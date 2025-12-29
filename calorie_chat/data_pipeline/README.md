# CalorieChat Data Pipeline

This directory contains tools to convert USDA MyPyramid food data from Excel/CSV format to JSON for use in the CalorieChat app.

## Quick Start (Sample Data)

To get started with sample data (100+ common foods):

**Windows:**
```bash
convert_sample.bat
```

**Mac/Linux:**
```bash
chmod +x convert_sample.sh
./convert_sample.sh
```

This will create `assets/data/mypyramid_food.json` with sample food data.

## Converting Your Own USDA Data

### Prerequisites

- Python 3.7+
- For Excel files: `pip install pandas openpyxl`

### Usage

```bash
python convert_usda_to_json.py <input_file> <output_file>
```

**Examples:**

```bash
# From CSV
python convert_usda_to_json.py MyPyramidData.csv ../assets/data/mypyramid_food.json

# From Excel
python convert_usda_to_json.py MyPyramidData.xlsx ../assets/data/mypyramid_food.json
```

### Input File Format

The script auto-detects column names. Your CSV/Excel should have columns like:

- **ID/Food_ID/NDB**: Unique food identifier
- **Description/Food_Name**: Food description
- **Portion/Serving_Size**: Portion size (optional, defaults to "1 serving")
- **Calories/Energy_kcal**: Calorie count

**Example CSV:**
```csv
id,description,portion,calories
01001,Butter salted,1 tbsp,102
01077,Milk whole 3.25% milkfat,1 cup,149
09003,Apple raw with skin,1 medium,95
```

### Output Format

The script produces JSON in this format:

```json
[
  {
    "id": "01001",
    "description": "Butter salted",
    "portion": "1 tbsp",
    "calories": 102
  },
  {
    "id": "01077",
    "description": "Milk whole 3.25% milkfat",
    "portion": "1 cup",
    "calories": 149
  }
]
```

## Features

- ✅ Removes duplicate entries (by ID)
- ✅ Normalizes text (trims whitespace)
- ✅ Auto-detects column names
- ✅ Handles both CSV and Excel formats
- ✅ Validates data integrity

## Where to Get USDA Data

You can download official USDA nutrition data from:

1. **USDA FoodData Central**: https://fdc.nal.usda.gov/
2. **MyPyramid Food Raw Data**: Search for "USDA MyPyramid Food Raw Data" or use FoodData Central

Download as CSV or Excel, then use this script to convert it.

## Troubleshooting

**"pandas not installed"**
```bash
pip install pandas openpyxl
```

**"Could not identify required columns"**

The script will show available columns. Edit your CSV/Excel to use standard column names or modify the script's column detection logic.

**"No such file or directory"**

Make sure you're running the script from the `data_pipeline` directory.

## Sample Data Info

The included `sample_usda_foods.csv` contains 100+ common foods across categories:
- Dairy products
- Fruits
- Vegetables
- Nuts & seeds
- Seafood
- Legumes
- Grains & bread
- Meat & poultry
- Prepared foods

This is perfect for testing and demo purposes!
