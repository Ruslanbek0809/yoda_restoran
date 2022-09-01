import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'otp_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class OtpMain extends HookViewModelWidget<OtpViewModel> {
  OtpMain({Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, OtpViewModel model) {
    final otpController = useTextEditingController();

    /// Here I used 2nd approach of creating textEditingController without StatefullWidget

    // ignore: close_sinks
    final errorController = useStreamController<
        ErrorAnimationType>(); // To shake when error happens

    final timeController = useAnimationController(
      duration: Duration(seconds: model.durationTime),
    );

    /// To dispose a status listener attached to timeController
    useEffect(() {
      void _listenerStatus(AnimationStatus status) {
        // This listener was used to update isResend
        if (status == AnimationStatus.dismissed) {
          model.updateResendButton();
        }
      }

      timeController..addStatusListener(_listenerStatus);
      return () => timeController.removeStatusListener(_listenerStatus);
    }, [timeController]);

    /// Here it starts countdown in reverse if model.hideResendButton is true
    if (model.hideResendButton)
      timeController.reverse(
          from: timeController.value == 0.0 ? 1.0 : timeController.value);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //------------------ YodaRes LOGO ---------------------//
            SizedBox(
              height: 1.sh / 2.5,
              child: SvgPicture.asset(
                'assets/title_yoda_restoran.svg',
                width: 0.6.sw,
              ),
            ),
            Text(LocaleKeys.title_confirm, style: kts22DarkText).tr(),
            verticalSpaceTiny,
            verticalSpaceMedium,
            Text(
              LocaleKeys.enter_otp_code,
              style: kts14HelperText,
            ).tr(),
            verticalSpaceMedium,
            //------------------ PinCodeTextField ---------------------//
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
              child: PinCodeTextField(
                appContext: context,
                controller: otpController,
                pastedTextStyle: TextStyle(
                  color: kcPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: AppTheme().radius10,
                  fieldHeight: 48.h,
                  fieldWidth: 45.w,
                  fieldOuterPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  activeFillColor: AppTheme.FILL_COLOR,
                  disabledColor: AppTheme.FILL_BORDER_COLOR,
                  inactiveFillColor: AppTheme.FILL_COLOR,
                  inactiveColor: AppTheme.FILL_BORDER_COLOR,
                  selectedFillColor: AppTheme.FILL_COLOR,
                  selectedColor: AppTheme.FILL_BORDER_COLOR,
                  activeColor: AppTheme.FILL_BORDER_COLOR,
                  borderWidth: 0.0,
                  errorBorderColor: AppTheme.RED,
                ),
                cursorColor: kcFontColor,
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                errorAnimationController: errorController,
                errorTextSpace: 25.w,
                keyboardType: TextInputType.number,
                boxShadows: [
                  AppTheme().fillShadow,
                ],
                onCompleted: (v) {
                  print("Completed");
                },
                onTap: () {
                  print("Pressed");
                },
                onChanged: (value) {
                  print(value);
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                enablePinAutofill: false,
              ),
            ),
            verticalSpaceSmall,
            //------------------ Verify BUTTON ---------------------//
            SizedBox(
              width: 0.8.sw,
              child: CustomTextChildButton(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: model.isBusy
                        ? ButtonLoading()
                        : Text(LocaleKeys.confirm, style: ktsButton18Text).tr(),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  borderRadius: kbr10,
                  onPressed: () async {
                    String currentOtp = otpController.text;
                    if (currentOtp.length != 6) {
                      errorController.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      showErrorFlashBar(
                        context: context,
                        msg: LocaleKeys.enter_otp_code_error.tr(),
                        margin: EdgeInsets.only(
                          left: 0.1.sw,
                          right: 0.1.sw,
                          bottom: 0.05.sh,
                        ),
                      );
                      return;
                    }

                    if (currentOtp != model.successOtp) {
                      errorController.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      showErrorFlashBar(
                        context: context,
                        msg: LocaleKeys.incorrect_code.tr(),
                        margin: EdgeInsets.only(
                          left: 0.1.sw,
                          right: 0.1.sw,
                          bottom: 0.05.sh,
                        ),
                      );
                      return;
                    }

                    FocusScope.of(context)
                        .unfocus(); // UNFOCUSES all textfield b4 data fetch
                    await model.saveOtpData(
                      onFailForView: () => showErrorFlashBar(
                        context: context,
                        margin: EdgeInsets.only(
                          left: 0.1.sw,
                          right: 0.1.sw,
                          bottom: 0.05.sh,
                        ),
                      ),
                    );
                  }),
            ),
            verticalSpaceMedium,
            //------------------ RESEND BUTTON and TIMER ---------------------//
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: model.hideResendButton
                  ? Offstage(
                      offstage: !model.hideResendButton,
                      child: OtpTimerWidget(timeController))
                  : CustomTextChildButton(
                      onPressed: () async {
                        await model.updateResendButtonWithCode(
                          onFailForView: () => showErrorFlashBar(
                            context: context,
                            margin: EdgeInsets.only(
                              left: 0.1.sw,
                              right: 0.1.sw,
                              bottom: 0.05.sh,
                            ),
                          ),
                        );
                      },
                      color: kcWhiteColor,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.refresh_rounded,
                            color: kcPrimaryColor,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            LocaleKeys.resend_code,
                            style: kts16PrimaryBoldText,
                          ).tr(),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
