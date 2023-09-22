import 'package:dio/dio.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

// 1 For Reactive View
class HomeService with ReactiveServiceMixin {
  final log = getLogger('HomeService');

  HomeService() {
    // 3
    listenToReactiveValues([_fetchingFilter, _fetchingFilterError]);
  }

  final _api = locator<ApiService>();

  List<SliderModel> _sliders = [];
  List<SliderModel> get sliders => _sliders;

  List<MainCategory> _mainCats = [];
  List<MainCategory> get mainCats => _mainCats;

  List<Restaurant> _moments = [];
  List<Restaurant> get moments => _moments;

  List<MainCategory> _searchMainCats = [];
  List<MainCategory> get searchMainCats => _searchMainCats;

  List<Restaurant> _randomRess = [];
  List<Restaurant> get randomRess => _randomRess;

  List<Promoted> _proms = [];
  List<Promoted> get proms => _proms;

  List<Exclusive> _exclusives = [];
  List<Exclusive> get exclusives => _exclusives;

  //*HOME RESS PAG
  bool _isPullUpEnabled = true;
  bool get isPullUpEnabled => _isPullUpEnabled;

  //*------ SELECTECTED MAIN CAT RESTAURANTS --------//
  List<Restaurant> _selectedMainCatRestaurants = [];
  List<Restaurant> get selectedMainCatRestaurants =>
      _selectedMainCatRestaurants;

  bool get hasSelectedMainCatRestaurants =>
      _selectedMainCatRestaurants.isNotEmpty;

  // 2
  ReactiveValue<bool> _fetchingFilter =
      ReactiveValue<bool>(false); // Custom busy for HomeView
  bool get fetchingFilter => _fetchingFilter.value;

  // CUSTOM ERROR for selectedMainCats fetch
  ReactiveValue<bool> _fetchingFilterError =
      ReactiveValue<bool>(false); // Custom busy for HomeView
  bool get fetchingFilterError => _fetchingFilterError.value;

  Future<void> getSliders() async {
    _sliders = await _api.getSliders();
    log.v('_sliders.length: ${_sliders.length}');
  }

  Future<void> getMainCategs() async {
    _mainCats = await _api.getMainCats();
    _mainCats.sort((prev, next) => prev.order!.compareTo(next.order!));
    log.v('_mainCats.length: ${_mainCats.length}');
  }

  Future<void> getSearchMainCategs() async {
    _searchMainCats = await _api.getSearchMainCats();
    _searchMainCats.sort((prev, next) => prev.order!.compareTo(next.order!));
    log.v('_searchMainCats.length: ${_searchMainCats.length}');
  }

  Future<void> getMoments() async {
    _moments = await _api.getMoments();
    log.v('_moments.length: ${_moments.length}');
  }

  // Future<List<Restaurant>?> getRandomRess() async {
  //   _randomRess = await _api.getRandomRess();
  //   log.v('_randomRess.length: ${_randomRess.length}');
  //   return _randomRess;
  // }

  //*HOME RESS PAG
  Future<void> getPaginatedRess({int page = 1}) async {
    List<Restaurant> _fetchedRandomRess = [];
    String? _pagNext;
    await _api.getPaginatedRess(
      page,
      (pagRess, pagNext) {
        if (pagRess != null && pagRess.isNotEmpty) _fetchedRandomRess = pagRess;
        if (pagNext != null) _pagNext = pagNext;
      },
    );
    log.v(
        '_fetchedRandomRess.length: ${_fetchedRandomRess.length}, _pagNext:$_pagNext');

    if (_pagNext == null) _isPullUpEnabled = false;

    if (page == 1)
      _randomRess = _fetchedRandomRess;
    else
      _randomRess = [..._randomRess, ..._fetchedRandomRess];

    log.v(
        '_randomRess.length: ${_randomRess.length}; _isPullUpEnabled:$_isPullUpEnabled');
  }

  //*HOME RESS PAG
  //*ENABLES SmartRefresher's pull up function
  void enablePullUp() => _isPullUpEnabled = true;

  Future<void> getProms() async {
    _proms = await _api.getProms();
    log.v('_proms.length: ${_proms.length}');
  }

  Future<void> getExclusives() async {
    _exclusives = await _api.getExclusives();
    log.v('_exclusives.length: ${_exclusives.length}');
  }

  Future<bool> getFilterResult(
    List<int> selectedMainCats,
    bool alphabet,
    bool rating,
    bool openRestaurants,
  ) async {
    _fetchingFilter.value = true;
    await Future.delayed(Duration(milliseconds: 500));
    dynamic result = await _api.getFilterResult(
      selectedMainCats,
      alphabet,
      rating,
      openRestaurants,
    );

    //*This line "result.runtimeType != DioError" is Workaround
    if (result.runtimeType != DioError) {
      _selectedMainCatRestaurants = result;
      _fetchingFilter.value = false;
      log.v(
          'result: $result and _selectedMainCatRestaurants.length: ${_selectedMainCatRestaurants.length}');
      return true;
    } else {
      _fetchingFilter.value = false;
      _fetchingFilterError.value =
          true; // When error occurs, it activates this error
      return false;
    }
  }

  void clearSelectedMainCatRess() {
    _selectedMainCatRestaurants.clear();
    log.v(
        '_selectedMainCatRestaurants.length: ${_selectedMainCatRestaurants.length}');
  }

  //*Workaround to disable active filter select error
  void disableActiveFilterError() {
    log.i('');

    _fetchingFilterError.value = false;
  }

  //*------------------ RESTAURANTS APIS ---------------------//

  List<Restaurant> _allPaginatedRestaurants = [];
  List<Restaurant> get allPaginatedRestaurants => _allPaginatedRestaurants;

  Future<void> getAllPaginatedRestaurants() async {
    _allPaginatedRestaurants = await _api.getAllPaginatedRestaurants();
    log.v(
        '_allPaginatedRestaurants.length: ${_allPaginatedRestaurants.length}');
  }
}
