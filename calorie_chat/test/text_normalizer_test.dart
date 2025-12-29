import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_chat/core/utils/text_normalize.dart';

void main() {
  group('TextNormalizer', () {
    group('normalizeForSearch', () {
      test('should convert to lowercase', () {
        expect(TextNormalizer.normalizeForSearch('APPLE'), 'apple');
        expect(TextNormalizer.normalizeForSearch('BaNaNa'), 'banana');
      });

      test('should handle empty strings', () {
        expect(TextNormalizer.normalizeForSearch(''), '');
      });

      test('should handle strings with spaces', () {
        expect(TextNormalizer.normalizeForSearch('ice cream'), 'ice cream');
      });
    });

    group('matchesWildcard', () {
      test('should match exact strings', () {
        expect(TextNormalizer.matchesWildcard('apple', 'apple'), true);
        expect(TextNormalizer.matchesWildcard('banana', 'banana'), true);
      });

      test('should match case-insensitively', () {
        expect(TextNormalizer.matchesWildcard('APPLE', 'apple'), true);
        expect(TextNormalizer.matchesWildcard('apple', 'APPLE'), true);
      });

      test('should match prefix wildcard (*bread)', () {
        expect(TextNormalizer.matchesWildcard('whole wheat bread', '*bread'), true);
        expect(TextNormalizer.matchesWildcard('white bread', '*bread'), true);
        expect(TextNormalizer.matchesWildcard('bread crumbs', '*bread'), false);
      });

      test('should match suffix wildcard (bread*)', () {
        expect(TextNormalizer.matchesWildcard('bread crumbs', 'bread*'), true);
        expect(TextNormalizer.matchesWildcard('bread stick', 'bread*'), true);
        expect(TextNormalizer.matchesWildcard('whole wheat bread', 'bread*'), false);
      });

      test('should match contains wildcard (*bread*)', () {
        expect(TextNormalizer.matchesWildcard('whole wheat bread crumbs', '*bread*'), true);
        expect(TextNormalizer.matchesWildcard('bread', '*bread*'), true);
        expect(TextNormalizer.matchesWildcard('homemade bread sticks', '*bread*'), true);
        expect(TextNormalizer.matchesWildcard('rice', '*bread*'), false);
      });

      test('should match all items with single wildcard (*)', () {
        expect(TextNormalizer.matchesWildcard('anything', '*'), true);
        expect(TextNormalizer.matchesWildcard('', '*'), true);
        expect(TextNormalizer.matchesWildcard('123', '*'), true);
      });

      test('should not match when pattern has no wildcard and strings differ', () {
        expect(TextNormalizer.matchesWildcard('apple', 'banana'), false);
        expect(TextNormalizer.matchesWildcard('bread', 'rice'), false);
      });

      test('should handle strings with spaces', () {
        expect(TextNormalizer.matchesWildcard('ice cream', '*cream*'), true);
        expect(TextNormalizer.matchesWildcard('sour cream', 'sour*'), true);
      });

      test('should handle empty search string', () {
        expect(TextNormalizer.matchesWildcard('apple', ''), false);
      });
    });
  });
}
