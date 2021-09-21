import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/widgets/widgets.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  /// Timer vars
  late Timer timer;
  late int totalTimeInSeconds;
  late bool _hideResendButton;
  final int time = 59;
  late AnimationController _controller;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  Future _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // SnackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future _onOTPPressed() async {
    // setState(() {
    //   _isLoading = true;
    // });

    formKey.currentState!.validate();
    // conditions for validating
    if (currentText.length != 6 || currentText != "123456") {
      errorController!
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() => hasError = true);
    } else {
      setState(
        () {
          hasError = false;
          snackBar("OTP Verified!!");
        },
      );
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.WHITE,
      body: GestureDetector(
        onTap: () {},
        child: SingleChildScrollView(
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
                'Ulgama girmek',
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
              SizedBox(height: 20.w),
              Form(
                key: formKey,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.w, horizontal: 30.w),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
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
                      borderRadius: AppTheme().containerRadius,
                      fieldHeight: 50,
                      fieldWidth: 40,
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
                    controller: textEditingController,
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
                      setState(() {
                        currentText = value;
                      });
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
              SizedBox(height: 15.w),
              CustomElevatedButton(
                height: 0.12.sw,
                width: 0.8.sw,
                color: AppTheme.MAIN,
                borderRadius: 15.0,
                text: 'Tassyklamak',
                // isLoading: _isLoading,
                onPressed: _onOTPPressed,
              ),
              SizedBox(height: 20.w),
              _hideResendButton
                  ? Offstage(
                      offstage: !_hideResendButton,
                      child: OtpTimerWidget(_controller),
                    )
                  : CustomTextButton(
                      text: 'Kody gaýtadan ugrat',
                      color: AppTheme.MAIN,
                      onPressed: () {},
                    )
              // GestureDetector(
              //     child: Container(
              //       decoration: BoxDecoration(
              //           color: Colors.black,
              //           shape: BoxShape.rectangle,
              //           borderRadius: BorderRadius.circular(32)),
              //       alignment: Alignment.center,
              //       child: Text(
              //         "Kody gaýtadan ugrat",
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: AppTheme.WHITE),
              //       ),
              //     ),
              //     onTap: () {
              //       // Resend you OTP via API or anything
              //     },
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
