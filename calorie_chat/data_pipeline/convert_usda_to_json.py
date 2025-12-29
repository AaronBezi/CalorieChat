#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
USDA MyPyramid Data Converter
Converts Excel/CSV data to JSON format for CalorieChat app

Usage:
    python convert_usda_to_json.py input.xlsx output.json
    python convert_usda_to_json.py input.csv output.json
"""

import sys
import json
import csv
from pathlib import Path

# Fix Windows console encoding
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def normalize_text(text):
    """Normalize text by trimming and removing extra whitespace"""
    if not text:
        return ""
    return " ".join(str(text).strip().split())

def convert_csv_to_json(csv_path, json_path):
    """Convert CSV to JSON format"""
    foods = []
    seen_ids = set()

    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)

        for row in reader:
            # Extract fields (adjust column names based on your CSV)
            food_id = normalize_text(row.get('id') or row.get('ID') or row.get('Food_ID', ''))
            description = normalize_text(row.get('description') or row.get('Description') or row.get('Food_Name', ''))
            portion = normalize_text(row.get('portion') or row.get('Portion') or row.get('Serving_Size', ''))

            # Parse calories
            calories_str = row.get('calories') or row.get('Calories') or row.get('Energy_kcal', '0')
            try:
                calories = int(float(str(calories_str).strip()))
            except (ValueError, AttributeError):
                calories = 0

            # Skip invalid or duplicate entries
            if not food_id or not description or food_id in seen_ids:
                continue

            seen_ids.add(food_id)

            foods.append({
                'id': food_id,
                'description': description,
                'portion': portion,
                'calories': calories
            })

    # Write JSON
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(foods, f, indent=2, ensure_ascii=False)

    print(f"✅ Converted {len(foods)} food items")
    print(f"📁 Output: {json_path}")

def convert_excel_to_json(excel_path, json_path):
    """Convert Excel to JSON format"""
    try:
        import pandas as pd
    except ImportError:
        print("❌ Error: pandas not installed. Install with: pip install pandas openpyxl")
        sys.exit(1)

    # Read Excel file
    df = pd.read_excel(excel_path)

    # Try to identify columns
    id_col = None
    desc_col = None
    portion_col = None
    cal_col = None

    for col in df.columns:
        col_lower = col.lower()
        if not id_col and ('id' in col_lower or 'ndb' in col_lower):
            id_col = col
        if not desc_col and ('desc' in col_lower or 'name' in col_lower or 'food' in col_lower):
            desc_col = col
        if not portion_col and ('portion' in col_lower or 'serving' in col_lower or 'size' in col_lower):
            portion_col = col
        if not cal_col and ('calorie' in col_lower or 'energy' in col_lower or 'kcal' in col_lower):
            cal_col = col

    if not all([id_col, desc_col, cal_col]):
        print("❌ Error: Could not identify required columns")
        print(f"Available columns: {list(df.columns)}")
        sys.exit(1)

    print(f"Using columns:")
    print(f"  ID: {id_col}")
    print(f"  Description: {desc_col}")
    print(f"  Portion: {portion_col or 'Not found'}")
    print(f"  Calories: {cal_col}")

    foods = []
    seen_ids = set()

    for _, row in df.iterrows():
        food_id = normalize_text(row[id_col])
        description = normalize_text(row[desc_col])
        portion = normalize_text(row[portion_col]) if portion_col else "1 serving"

        try:
            calories = int(float(row[cal_col]))
        except (ValueError, TypeError):
            calories = 0

        # Skip invalid or duplicate entries
        if not food_id or not description or food_id in seen_ids:
            continue

        seen_ids.add(food_id)

        foods.append({
            'id': food_id,
            'description': description,
            'portion': portion,
            'calories': calories
        })

    # Write JSON
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(foods, f, indent=2, ensure_ascii=False)

    print(f"✅ Converted {len(foods)} food items")
    print(f"📁 Output: {json_path}")

def main():
    if len(sys.argv) != 3:
        print("Usage: python convert_usda_to_json.py <input_file> <output_file>")
        print("  input_file: Excel (.xlsx) or CSV (.csv) file")
        print("  output_file: JSON output file")
        sys.exit(1)

    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])

    if not input_path.exists():
        print(f"❌ Error: Input file not found: {input_path}")
        sys.exit(1)

    # Create output directory if needed
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Convert based on file type
    suffix = input_path.suffix.lower()

    if suffix == '.csv':
        convert_csv_to_json(input_path, output_path)
    elif suffix in ['.xlsx', '.xls']:
        convert_excel_to_json(input_path, output_path)
    else:
        print(f"❌ Error: Unsupported file type: {suffix}")
        print("Supported types: .csv, .xlsx, .xls")
        sys.exit(1)

if __name__ == '__main__':
    main()
