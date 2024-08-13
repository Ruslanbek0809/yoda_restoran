import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../generated/locale_keys.g.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

class ToggleButtonViewModel extends ReactiveViewModel {
  final log = getLogger('ToggleButtonViewModel');

  final _toggleButtonService = locator<ToggleButtonService>();

  bool get isDelivery => _toggleButtonService.isDelivery;

  //*UPDATES isDelivery to FALSE (USES _toggleButtonService)
  void updateToggleToDelivery() =>
      _toggleButtonService.updateToggleToDelivery();

  /// UPDATES isDelivery to TRUE (USES _toggleButtonService)
  void updateToggleToSelfPickUp() =>
      _toggleButtonService.updateToggleToSelfPickUp();

  /// SWITCHES isDelivery (USES _toggleButtonService)
  void switchToggleButton() => _toggleButtonService.switchToggleButton();

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
  List<ListenableServiceMixin> get listenableServices => [_toggleButtonService];
}
