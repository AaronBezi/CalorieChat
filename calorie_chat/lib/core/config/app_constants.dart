/// Application-wide constants
class AppConstants {
  // API Configuration
  static const int apiTimeoutSeconds = 30;
  static const int maxMealTextLength = 500;
  static const int minMealTextLength = 3;

  // Search Configuration
  static const int searchResultsPerPage = 25;
  static const int maxSearchResults = 100;
  static const int alternativeMatchesLimit = 5;

  // Database Configuration
  static const int databaseVersion = 1;
  static const String databaseName = 'calorie_chat.db';

  // UI Configuration
  static const int defaultLoadingTimeoutSeconds = 10;
  static const int maxRecentMealsDisplayed = 20;

  // Validation Messages
  static const String mealTextTooShortError =
      'Please enter at least $minMealTextLength characters';
  static const String mealTextTooLongError =
      'Meal description is too long (max $maxMealTextLength characters)';
  static const String mealTextEmptyError =
      'Please enter a meal description';
  static const String noMatchesError =
      'No food items matched. Try describing your meal differently.';

  // Error Messages
  static const String apiErrorGeneric =
      'Unable to process meal. Please try again.';
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String databaseErrorMessage =
      'Error accessing local data. Please restart the app.';
}
