import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/api_service.dart';

class HomeService {
  final log = getLogger('HomeService');
  final _api = locator<ApiService>();

  List<Sliderr>? _sliders;
  List<Sliderr>? get sliders => _sliders;

  List<MainCategory>? _mainCategories;
  List<MainCategory>? get mainCategories => _mainCategories;

  bool get hasSliders => _sliders != null && _sliders!.isNotEmpty;
  bool get hasmainCategories =>
      _mainCategories != null && _mainCategories!.isNotEmpty;

  Future<List<Sliderr>?> getSliders() async {
    _sliders = await _api.getSliders();
    log.i(_sliders!.length);
    return _sliders;
  }

  Future<List<MainCategory>?> getMainCategories() async {
    _mainCategories = await _api.getMainCategories();
    log.i(_mainCategories!.length);
    return _mainCategories;
  }
}
