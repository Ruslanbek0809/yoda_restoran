import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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
  final formKey = GlobalKey<FormState>();
  late AnimationController _buttonController;
  final _phoneController = TextEditingController(text: '+993 ');
  var maskFormatter = MaskTextInputFormatter(
      mask: '+993 ## ## ## ##', filter: {'#': RegExp(r'[0-9]')});
  final _phoneNode = FocusNode();

  bool isLoading = false;

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
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fill all fields')));
    } else {
      if (formKey.currentState!.validate()) {
        print('Continue validated');
      }
      await _playAnimation();
    }
  }

  Future _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _buttonController.forward();
    } on TickerCanceled {
      printLog('[_playAnimation] error');
    }
  }

  Future _stopAnimation() async {
    try {
      await _buttonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      printLog('[_stopAnimation] error');
    }
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
                autovalidateMode: AutovalidateMode.disabled,
                child: TextFormField(
                  controller: _phoneController,
                  inputFormatters: [maskFormatter],
                  style: const TextStyle(color: AppTheme.BLACK),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: AppTheme().mainBorderRadius,
                      borderSide: BorderSide.none,
                    ),
                    fillColor: AppTheme.FILL_COLOR,
                    filled: true,
                    prefixIcon: Icon(Icons.phone),
                  ),
                  textInputAction: TextInputAction.done,
                  focusNode: _phoneNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Doly nomeri giriziň';
                    }
                    return null;
                  },
                  onFieldSubmitted: (notUsed) {
                    _phoneNode.unfocus();
                  },
                ),
              ),
              SizedBox(height: 15.w),
              StaggerAnimationWidget(
                titleButton: 'Dowam',
                buttonController: _buttonController.view as AnimationController,
                onTap: _onContinueButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
