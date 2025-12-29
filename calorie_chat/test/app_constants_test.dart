import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_chat/core/config/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('API configuration constants should be positive', () {
      expect(AppConstants.apiTimeoutSeconds, greaterThan(0));
      expect(AppConstants.maxMealTextLength, greaterThan(0));
      expect(AppConstants.minMealTextLength, greaterThan(0));
    });

    test('min meal text length should be less than max', () {
      expect(AppConstants.minMealTextLength, lessThan(AppConstants.maxMealTextLength));
    });

    test('search configuration constants should be positive', () {
      expect(AppConstants.searchResultsPerPage, greaterThan(0));
      expect(AppConstants.maxSearchResults, greaterThan(0));
      expect(AppConstants.alternativeMatchesLimit, greaterThan(0));
    });

    test('database configuration should have valid values', () {
      expect(AppConstants.databaseVersion, greaterThan(0));
      expect(AppConstants.databaseName, isNotEmpty);
    });

    test('UI configuration should have positive values', () {
      expect(AppConstants.defaultLoadingTimeoutSeconds, greaterThan(0));
      expect(AppConstants.maxRecentMealsDisplayed, greaterThan(0));
    });

    test('validation messages should not be empty', () {
      expect(AppConstants.mealTextTooShortError, isNotEmpty);
      expect(AppConstants.mealTextTooLongError, isNotEmpty);
      expect(AppConstants.mealTextEmptyError, isNotEmpty);
      expect(AppConstants.noMatchesError, isNotEmpty);
    });

    test('error messages should not be empty', () {
      expect(AppConstants.apiErrorGeneric, isNotEmpty);
      expect(AppConstants.networkErrorMessage, isNotEmpty);
      expect(AppConstants.databaseErrorMessage, isNotEmpty);
    });

    test('validation messages should reference correct constants', () {
      expect(AppConstants.mealTextTooShortError, contains(AppConstants.minMealTextLength.toString()));
      expect(AppConstants.mealTextTooLongError, contains(AppConstants.maxMealTextLength.toString()));
    });
  });
}
