import 'package:flutter/foundation.dart';
import '../../data/models/food_item.dart';
import '../../data/repository/food_repository.dart';

class SearchController extends ChangeNotifier {
  final FoodRepository _foodRepository = FoodRepository();

  List<FoodItem> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentQuery = '';
  int _totalCount = 0;
  int _currentOffset = 0;
  static const int _pageSize = 25;

  List<FoodItem> get results => _results;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;
  int get totalCount => _totalCount;
  bool get hasMore => _results.length < _totalCount;
  bool get hasResults => _results.isNotEmpty;

  Future<void> initialize() async {
    await _foodRepository.initialize();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _errorMessage = 'Please enter a search term';
      _results = [];
      _totalCount = 0;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    _currentQuery = query;
    _currentOffset = 0;
    notifyListeners();

    try {
      final results = await _foodRepository.searchFoods(
        query,
        limit: _pageSize,
        offset: 0,
      );

      final count = await _foodRepository.countSearchResults(query);

      _results = results;
      _totalCount = count;

      if (results.isEmpty) {
        _errorMessage = 'No matches found';
      }
    } catch (e) {
      _errorMessage = 'Error searching: $e';
      _results = [];
      _totalCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || !hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentOffset += _pageSize;
      final moreResults = await _foodRepository.searchFoods(
        _currentQuery,
        limit: _pageSize,
        offset: _currentOffset,
      );

      _results.addAll(moreResults);
    } catch (e) {
      _errorMessage = 'Error loading more: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _results = [];
    _errorMessage = '';
    _currentQuery = '';
    _totalCount = 0;
    _currentOffset = 0;
    notifyListeners();
  }
}
