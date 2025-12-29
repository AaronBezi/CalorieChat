# CalorieChat Setup Instructions

## Step 1: Install Dependencies

Run the following command in your terminal from the project root:

```bash
flutter pub get
```

## Step 2: Generate Code for Freezed Models

After installing dependencies, run the code generator:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate the following files:
- `food_item.freezed.dart` and `food_item.g.dart`
- `meal_parse.freezed.dart` and `meal_parse.g.dart`
- `logged_meal.freezed.dart` and `logged_meal.g.dart`

## Step 3: Prepare USDA Food Data

You need to add the USDA MyPyramid food data JSON file:

1. Create/process your USDA data into JSON format
2. Place it at: `assets/data/mypyramid_food.json`

Expected JSON format:
```json
[
  {
    "id": "12345",
    "description": "Oatmeal, cooked",
    "portion": "1 cup",
    "calories": 158
  },
  ...
]
```

## Step 4: Verify .env File

Make sure your `.env` file is in the project root with your Gemini API key:

```
GEMINI_API_KEY=your_key_here
GEMINI_API_BASE_URL=https://generativelanguage.googleapis.com/v1beta
```

## Step 5: Run the App

```bash
flutter run
```

## Project Structure Created

```
lib/
├── core/
│   ├── config/
│   │   └── env.dart                    # Environment configuration
│   ├── network/
│   │   └── api_client.dart             # Gemini API client
│   └── utils/
│       └── text_normalize.dart         # Text utilities
├── data/
│   ├── models/
│   │   ├── food_item.dart              # Food item model
│   │   ├── meal_parse.dart             # Meal parsing models
│   │   └── logged_meal.dart            # Logged meal models
│   ├── local/
│   │   ├── db.dart                     # SQLite database setup
│   │   ├── food_dao.dart               # Food data access
│   │   └── log_dao.dart                # Meal log data access
│   └── repository/
│       ├── food_repository.dart        # Food business logic
│       └── log_repository.dart         # Meal log business logic
└── features/
    ├── search/                         # (To be implemented)
    ├── chat/                           # (To be implemented)
    └── insights/                       # (To be implemented)
```

## Next Steps

The architecture is complete. Next we'll implement:
1. Data pipeline (Excel → CSV → JSON)
2. Search screen
3. Chat screen with Gemini integration
4. Insights/History screen
