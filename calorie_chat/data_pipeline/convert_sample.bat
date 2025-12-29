@echo off
echo Converting sample USDA food data to JSON...
python convert_usda_to_json.py sample_usda_foods.csv ../assets/data/mypyramid_food.json
echo.
echo Done! The JSON file is ready in assets/data/
pause
