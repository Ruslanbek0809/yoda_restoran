import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../models/models.dart';
import '../../../../services/services.dart';
import '../../../../shared/shared.dart';
import '../../../../utils/utils.dart';

class CheckoutAddressViewModel extends ReactiveViewModel {
  final log = getLogger('CheckoutAddressViewModel');

  final _checkoutService = locator<CheckoutService>();
  final _bottomSheetService = locator<BottomSheetService>();

  List<Address>? get addresses => _checkoutService.addresses;

  Address? _tempSelectedAddress;
  Address? get tempSelectedAddress => _tempSelectedAddress != null
      ? _tempSelectedAddress!
      : _checkoutService.selectedAddress!;

  //*Temporarily SETS _tempSelectedAddress
  void updateTempSelectedAddress(Address selectedAddress) {
    log.v(
        'updateTempSelectedAddress selectedAddress: ${selectedAddress.street}');

    _tempSelectedAddress = selectedAddress;
    notifyListeners();
  }

  //*SAVES selectedAddress ( uses _checkoutService reactivity)
  void saveSelectedAddress() {
    log.v(
        'saveSelectedAddress() _tempSelectedAddress: ${_tempSelectedAddress!.street}');

    _checkoutService.saveSelectedAddress(_tempSelectedAddress!);
    notifyListeners();
  }

//*----------------------- ADD ADDRESS BOTTOM SHEET ----------------------------//

  //*CALLS AddAddressBottomSheet
  Future<void> showCustomAddAddressBottomSheet() async {
    log.i('');
    SheetResponse<bool>? _navResult;
    _navResult = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.addAddress,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
    );

    if (_navResult != null && _navResult.data == true) {
      log.i('_navResult: $_navResult');
      await runBusyFuture(_checkoutService.getAddresses());
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _city = LocaleKeys.ashgabat.tr();
  String? get city => _city;

  String? _street;
  String? get street => _street;

  int? _apartment;
  int? get apartment => _apartment;

  int? _house;
  int? get house => _house;

  int? _floor;
  int? get floor => _floor;

  String? _note;
  String? get note => _note;

  //*UPDATES _city
  String? updateCity(String? value) {
    log.v('updateCity value: $value');
    if (value!.isEmpty) return LocaleKeys.enterCity.tr();

    _city = value;
    notifyListeners();
    return null;
  }

  //*UPDATES _street
  String? updateStreet(String? value) {
    log.v('updateStreet value: $value');
    if (value!.isEmpty) {
      return LocaleKeys.enterStreet.tr();
    }

    _street = value;
    notifyListeners();

    return null;
  }

  //*UPDATES _house
  String? updateHouse(String? value) {
    log.v('updateHouse value: $value');
    if (value == null || value.isEmpty) return null;

    _house = int.parse(value);
    notifyListeners();

    return null;
  }

  //*UPDATES _apartment
  String? updateApartment(String? value) {
    log.v('updateApartment value: $value');
    if (value == null || value.isEmpty) return null;

    _apartment = int.parse(value);
    notifyListeners();

    return null;
  }

  //*UPDATES _floor
  String? updateFloor(String? value) {
    log.v('updateFloor value: $value');
    if (value == null || value.isEmpty) return null;

    _floor = int.parse(value);
    notifyListeners();

    return null;
  }

  //*UPDATES _street
  String? updateNote(String? value) {
    log.v('updateNote value: $value');
    if (value == null || value.isEmpty) return null;

    _note = value;
    notifyListeners();

    return null;
  }

  //*ADDS new address
  Future<void> onAddAddressPressed(
    Function()? onSuccessForView,
    Function()? onFailForView,
  ) async {
    log.v('onAddAddressPressed()');

    _isLoading = true;
    notifyListeners();

    await runBusyFuture(_checkoutService.addAddress(
      _city,
      _street,
      _house,
      _apartment,
      _floor,
      _note,
      () {
        _isLoading = false;
        onSuccessForView!();
      },
      () {
        _isLoading = false;
        notifyListeners();
        onFailForView!();
      },
    ));
  }

  FlashController? _flashController;

  /// CREATED custom flash bar instead of one global flash bar because multiple stack flash bar issue
  Future<void> showCustomFlashBar({
    required BuildContext context,
    String msg = LocaleKeys.errorOccured,
    Duration duration = const Duration(seconds: 2),
  }) async {
    if (_flashController?.isDisposed == false)
      await _flashController?.dismiss();
    _flashController = FlashController<dynamic>(
      context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          barrierDismissible: true,
          margin: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 0.05.sh,
          ),
          position: FlashPosition.bottom,
          behavior: FlashBehavior.floating,
          boxShadows: kElevationToShadow[0],
          borderRadius: AppTheme().radius16,
          backgroundColor: kcSecondaryDarkColor,
          child: FlashBar(
            icon: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 12.w),
              child: SvgPicture.asset(
                'assets/warning.svg',
                width: 20.w,
                height: 20.h,
              ),
            ),
            content: Text(msg, style: kts16ButtonText).tr(),
          ),
        );
      },
    );
    await _flashController?.show();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_checkoutService];
}
