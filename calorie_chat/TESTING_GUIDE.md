# CalorieChat Testing Guide

## Running the App

```bash
flutter run
```

Or use your IDE's run button (F5 in VS Code).

## Testing the Search Feature

### Basic Search Tests

1. **Empty search warning**
   - Leave search field empty
   - Click "Search"
   - Should show: "Please enter a search term"

2. **Basic keyword search**
   - Enter: `apple`
   - Click "Search"
   - Should show multiple apple varieties

3. **No matches found**
   - Enter: `xyz123notfound`
   - Click "Search"
   - Should show: "No matches found"

4. **Clear button**
   - Perform any search
   - Click "Clear"
   - Results should disappear

### Wildcard Search Tests

5. **Wildcard at end**
   - Enter: `milk*`
   - Should show all items starting with "milk"

6. **Wildcard at start**
   - Enter: `*bread`
   - Should show all items ending with "bread"

7. **Wildcard in middle**
   - Enter: `*chick*`
   - Should show all items containing "chick"

### Pagination Tests

8. **Load more functionality**
   - Search for: `*`  (wildcard to match all)
   - Should show "Showing 25 of 104 results"
   - Scroll to bottom
   - Click "Load more" or auto-load by scrolling
   - Should show more results

9. **Results count**
   - Any search should show total count
   - Example: "Showing 5 of 10 results"

### UI/UX Tests

10. **Search on Enter key**
    - Type in search field
    - Press Enter
    - Should trigger search

11. **Navigation**
    - Bottom navigation should have 3 tabs:
      - Search (active)
      - Chat (placeholder)
      - Insights (placeholder)
    - Clicking each should switch screens

## Expected Results Display

Each food item card should show:
- Icon on the left
- **Food name** (bold)
- Portion size (subtitle)
- **Calorie count** (large, right side)
- "cal" label (small, gray)

## Sample Test Queries

| Query | Expected Results |
|-------|-----------------|
| `butter` | Butter varieties |
| `milk` | Milk products |
| `*cooked` | All cooked items |
| `raw*` | Raw food items |
| `*egg*` | All egg products |
| `chicken` | Chicken items |
| `*` | All 104 items (paginated) |

## Database Verification

On first launch, the app should:
1. Show "Loading CalorieChat..." screen
2. Load JSON from assets
3. Import 104 items into SQLite
4. Show the Search screen

Subsequent launches should be instant (data already in DB).

## Common Issues

**"No food data found"**
- Make sure `assets/data/mypyramid_food.json` exists
- Check pubspec.yaml has assets configured

**Slow search**
- First search loads data into DB (one-time)
- Subsequent searches should be fast

**App won't run**
- Run: `flutter pub get`
- Run: `flutter pub run build_runner build --delete-conflicting-outputs`
- Check that .env file exists

## Next Features to Test

- **Chat** (Step 4): AI-powered meal parsing
- **Insights** (Step 5): Calorie history and trends
