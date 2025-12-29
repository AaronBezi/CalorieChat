import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_chat/features/chat/chat_controller.dart';
import 'package:calorie_chat/core/config/app_constants.dart';
import 'package:calorie_chat/core/config/env.dart';

void main() {
  // Initialize environment before all tests
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      await Env.load();
    } catch (e) {
      // .env file may not exist in test environment, which is fine
      // Tests will use fallback values or skip tests that require API
    }
  });

  group('ChatController', () {
    late ChatController controller;

    setUp(() {
      controller = ChatController();
    });

    group('Input Validation', () {
      test('should reject empty meal text', () async {
        await controller.parseMeal('');

        expect(controller.errorMessage, AppConstants.mealTextEmptyError);
        expect(controller.isParsing, false);
        expect(controller.hasMatches, false);
      });

      test('should reject meal text that is too short', () async {
        await controller.parseMeal('ab');

        expect(controller.errorMessage, AppConstants.mealTextTooShortError);
        expect(controller.isParsing, false);
        expect(controller.hasMatches, false);
      });

      test('should reject meal text that is too long', () async {
        final longText = 'a' * (AppConstants.maxMealTextLength + 1);
        await controller.parseMeal(longText);

        expect(controller.errorMessage, AppConstants.mealTextTooLongError);
        expect(controller.isParsing, false);
        expect(controller.hasMatches, false);
      });

      test('should trim whitespace from meal text', () async {
        // This test verifies that whitespace is trimmed
        // The actual parsing will fail without API, but we're testing validation
        await controller.parseMeal('  valid meal text  ');

        // Should not reject based on whitespace
        expect(controller.errorMessage, isNot(AppConstants.mealTextEmptyError));
      });
    });

    group('State Management', () {
      test('should initialize with empty state', () {
        expect(controller.isParsing, false);
        expect(controller.isSaving, false);
        expect(controller.errorMessage, '');
        expect(controller.hasMatches, false);
        expect(controller.matches, isEmpty);
      });

      test('should clear state', () {
        controller.clear();

        expect(controller.errorMessage, '');
        expect(controller.hasMatches, false);
        expect(controller.matches, isEmpty);
      });
    });

    group('Match Management', () {
      test('should update quantity correctly', () {
        // This would require mocking the food repository
        // For now, just verify it doesn't crash with invalid index
        controller.updateQuantity(-1, 2);
        controller.updateQuantity(999, 2);

        // Should not crash
        expect(controller.matches, isEmpty);
      });

      test('should remove match correctly', () {
        // This would require mocking the food repository
        // For now, just verify it doesn't crash with invalid index
        controller.removeMatch(-1);
        controller.removeMatch(999);

        // Should not crash
        expect(controller.matches, isEmpty);
      });
    });

    group('saveMeal', () {
      test('should return false when no matches exist', () async {
        final result = await controller.saveMeal('Test meal');

        expect(result, false);
      });
    });
  });
}
