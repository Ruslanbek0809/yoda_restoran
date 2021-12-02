import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/widgets/widgets.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;

  final _phoneController = TextEditingController(text: '+993 ');
  final _phoneNode = FocusNode();
  var maskFormatter = MaskTextInputFormatter(
      mask: '+993 ## ## ## ##', filter: {'#': RegExp(r'[0-9]')});

  FormValidation _validate = FormValidation.valid;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _phoneController.dispose();
    _phoneNode.dispose();
    super.dispose();
  }

  void _onContinueButtonPressed() async {
    String phone = "+993${maskFormatter.getUnmaskedText()}";
    // String realPhone = maskFormatter.getUnmaskedText();
    if (phone.length < 12) {
      setState(() {
        _validate = FormValidation.phoneInvalid;
      });
      return;
    }

    _validate = FormValidation.valid;
    await _playAnimation();
    await _stopAnimation();
  }

  Future _playAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {
      printLog('[_playAnimation] error');
    }
  }

  Future _stopAnimation() async {
    try {
      await _buttonController.reverse();
    } on TickerCanceled {
      printLog('[_stopAnimation] error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Ulgama girmek',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: AppTheme.MAIN_DARK,
              ),
            ),
            SizedBox(height: 25.w),
            Text(
              'Telefon belgiňizi giriziň',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.DRAWER_ICON,
              ),
            ),
            SizedBox(height: 40.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: TextField(
                controller: _phoneController,
                inputFormatters: [maskFormatter],
                keyboardType: TextInputType.phone,
                style: TextStyle(color: AppTheme.FONT_COLOR),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.FILL_BORDER_COLOR,
                      width: 0.3,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: AppTheme.FONT_COLOR,
                  ),
                  fillColor: AppTheme.FILL_COLOR,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.FILL_BORDER_COLOR,
                      width: 0.3,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.FILL_BORDER_COLOR,
                      width: 0.3,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.RED,
                      width: 0.3,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.RED,
                      width: 0.3,
                    ),
                  ),
                  errorText: (_validate == FormValidation.phoneInvalid)
                      ? 'Nomeri doly giriziň'
                      : null,
                ),
                textInputAction: TextInputAction.done,
                focusNode: _phoneNode,
                onSubmitted: (value) {
                  _phoneNode.unfocus();
                },
              ),
            ),
            SizedBox(height: 30.w),
            StaggerAnimationButtonWidget(
              titleButton: 'Dowam',
              buttonController: _buttonController.view as AnimationController,
              onTap: _onContinueButtonPressed,
            ),
            SizedBox(height: 25.w),
            Text(
              'Siziň telefon belgiňize gizlin SMS kody geler.',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.DRAWER_ICON,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
