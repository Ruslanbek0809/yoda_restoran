import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/api_service.dart';

class HomeService {
  final log = getLogger('HomeService');
  final _api = locator<ApiService>();

  List<SliderModel>? _sliders;
  List<SliderModel>? get sliders => _sliders;

  List<MainCategory>? _mainCats;
  List<MainCategory>? get mainCats => _mainCats;

  List<Restaurant>? _randomRess;
  List<Restaurant>? get randomRess => _randomRess;

  List<Promoted>? _proms;
  List<Promoted>? get proms => _proms;

  bool get hasSliders => _sliders != null && _sliders!.isNotEmpty;

  bool get hasMainCats => _mainCats != null && _mainCats!.isNotEmpty;

  bool get hasRandomRess => _randomRess != null && _randomRess!.isNotEmpty;

  bool get hasProms => _proms != null && _proms!.isNotEmpty;

  Future<List<SliderModel>?> getSliders() async {
    _sliders = await _api.getSliders();
    log.i(_sliders!.length);
    return _sliders;
  }

  Future<List<MainCategory>?> getMainCategs() async {
    _mainCats = await _api.getMainCats();
    _mainCats!.sort((prev, next) => prev.order!.compareTo(next.order!));
    log.i(_mainCats!.length);
    return _mainCats;
  }

  Future<List<Restaurant>?> getRandomRess() async {
    _randomRess = await _api.getRandomRess();
    log.i(_randomRess!.length);
    return _randomRess;
  }

  Future<List<Promoted>?> getProms() async {
    _proms = await _api.getProms();
    log.i(_proms!.length);
    return _proms;
  }
}
