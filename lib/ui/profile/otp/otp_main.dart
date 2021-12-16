import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'otp_view_model.dart';

class OtpMain extends HookViewModelWidget<OtpViewModel> {
  final TextEditingController otpController;
  OtpMain({required this.otpController, Key? key})
      : super(key: key, reactive: true);

  final formKey = GlobalKey<FormState>();
  @override
  Widget buildViewModelWidget(BuildContext context, OtpViewModel model) {

    
    // ignore: close_sinks
    StreamController<ErrorAnimationType>? errorController;

    /// Timer vars
    late Timer timer;
    late int totalTimeInSeconds;
    late bool _hideResendButton;
    final int time = 59;
    late AnimationController _timeController;

    @override
    void initState() {
      errorController = StreamController<ErrorAnimationType>();
      totalTimeInSeconds = time;
      super.initState();
      _timeController =
          AnimationController(vsync: this, duration: Duration(seconds: time))
            ..addStatusListener((status) {
              if (status == AnimationStatus.dismissed) {
                setState(() {
                  _hideResendButton = !_hideResendButton;
                });
              }
            });
      _timeController.reverse(
          from: _timeController.value == 0.0 ? 1.0 : _timeController.value);
      _startCountdown();
    }

    Future _startCountdown() async {
      setState(() {
        _hideResendButton = true;
        totalTimeInSeconds = time;
      });
      _timeController.reverse(
          from: _timeController.value == 0.0 ? 1.0 : _timeController.value);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 1.sh / 2.5,
              child: SvgPicture.asset(
                'assets/yoda_restoran.svg',
                color: AppTheme.MAIN_DARK,
                width: 0.75.sw,
              ),
            ),
            Text(
              'Tassyklamak',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: AppTheme.MAIN_DARK,
              ),
            ),
            SizedBox(height: 25.w),
            Text(
              'Telefon belgiňize gelen gizli kody giriziň',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.DRAWER_ICON,
              ),
            ),
            SizedBox(height: 30.w),
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 30.w),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: AppTheme.MAIN,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 6) {
                      return "Kody doly giriziň";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: AppTheme().radius10,
                    fieldHeight: 50.w,
                    fieldWidth: 40.w,
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
                  cursorColor: AppTheme.FONT_COLOR,
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: otpController,
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
                  dialogConfig: DialogConfig(
                    affirmativeText: 'Doldur',
                    negativeText: 'Ýok',
                    dialogTitle: 'Kody doldur',
                    dialogContent: 'Bu kody doldurmak isleýärsiňizmi?',
                  ),
                  errorTextSpace: 25.w,
                  // obscureText: false,
                  // obscuringCharacter: '*',
                  // obscuringWidget: FlutterLogo(
                  //   size: 24,
                  // ),
                  // blinkWhenObscuring: true,
                ),
              ),
            ),
            verticalSpaceMedium,
            //------------------ LOGIN BUTTON ---------------------//
            SizedBox(
              width: 0.88.sw,
              child: CustomTextChildButton(
                  child:
                      // Text(
                      //   'Dowam et',
                      //   style: ktsButtonText,
                      // ),
                      // ButtonLoading(),
                      AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: model.isBusy
                        ? ButtonLoading()
                        : Text(
                            'Tassyklamak',
                            style: ktsButtonText,
                          ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  borderRadius: kbr10,
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    formKey.currentState!.save();

                    String currentOtp = otpController.text;
                    if (currentOtp.length != 6 || currentOtp != model.otp) {
                      errorController!.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() => );
                    } else {
                      setState(
                        () {
                          hasError = false;
                          snackBar("OTP Verified!!", context);
                        },
                      );
                    }
                    model.saveData();
                  }),
            ),
            SizedBox(height: 15.w),
            _hideResendButton
                ? Offstage(
                    offstage: !_hideResendButton,
                    child: OtpTimerWidget(_timeController),
                  )
                : CustomTextButton(
                    text: 'Kody gaýtadan ugrat',
                    color: AppTheme.MAIN,
                    onPressed: () {},
                  )
          ],
        ),
      ),
    );
  }
}
