import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:yoda_res/library/flutter_datetime_picker.dart';
import 'package:yoda_res/library/src/i18n_model.dart';
import 'package:yoda_res/screens/home/home.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _profileScaffoldKey =
      GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  final GlobalKey<FormState> _profileformKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+993 ');
  var maskFormatter = MaskTextInputFormatter(
      mask: '+993 ## ## ## ##', filter: {'#': RegExp(r'[0-9]')});
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _birthdateFocus = FocusNode();
  final FocusNode _genderFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _birthdateFocus.dispose();
    _genderFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  _showDialog() {
    return () => showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2050),
        ).then(print);
  }

  void _onGenderPressed() async {
    printLog('_onGenderPressed');
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Erkek',
                ),
                onPressed: () {
                  _genderController.text = 'Erkek';
                  Navigator.of(context).pop();
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Aýal',
                ),
                onPressed: () {
                  _genderController.text = 'Aýal';
                  Navigator.of(context).pop();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: Text(
                'Ýap',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    } else {
      await showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return Container(
                height: 186,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Center(
                        child: Text(
                          'Erkek',
                        ),
                      ),
                      onTap: () {
                        _genderController.text = 'Erkek';
                        Navigator.of(context).pop();
                      },
                    ),
                    Divider(height: 8),
                    ListTile(
                      title: Center(
                        child: Text(
                          'Aýal',
                        ),
                      ),
                      onTap: () {
                        _genderController.text = 'Aýal';
                        Navigator.of(context).pop();
                      },
                    ),
                    Divider(height: 8),
                    ListTile(
                      title: Center(
                        child: Text(
                          'Ýap',
                          style: TextStyle(color: AppTheme.RED),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  Future _onRememberButtonPressed() async {
    setState(() {
      _isLoading = true;
    });
    if (_profileformKey.currentState!.validate()) {
      printLog('_profileformKey validated');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _profileScaffoldKey,
      backgroundColor: AppTheme.WHITE,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: AppTheme.WHITE,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => _profileScaffoldKey.currentState!.openDrawer(),
          child: Icon(
            Icons.arrow_back,
            color: AppTheme.FONT_COLOR,
            size: 25.w,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.WHITE,
          borderRadius: AppTheme().containerRadius,
        ),
        padding: EdgeInsets.only(top: 5.w, left: 25.w, right: 25.w),
        child: Form(
          key: _profileformKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Profil',
                  style: TextStyle(
                    color: AppTheme.MAIN_DARK,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.w),
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Ady',
                      labelStyle: TextStyle(
                        color: AppTheme.DRAWER_ICON,
                      ),
                    ),
                    focusNode: _nameFocus,
                    onFieldSubmitted: (notUsed) {
                      fieldFocusChange(context, _nameFocus, _birthdateFocus);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ady dolduryň';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.w),
                  child: TextFormField(
                    onTap: () async {
                      DateTime? date;
                      FocusScope.of(context).requestFocus(FocusNode());

                      date = await DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime.now(), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                      }, currentTime: DateTime.now(), locale: LocaleType.tk);
                      // await showDatePicker(
                      //   context: context,
                      //   cancelText: 'Ýatyrmak',
                      //   helpText: 'Doglan senäňizi giriziň',
                      //   confirmText: 'Tassyklamak',
                      //   fieldHintText: '01/01/2001',
                      //   fieldLabelText: 'Doglan senäňizi giriziň',
                      //   errorFormatText: 'Formaty dogry giriziň',
                      //   errorInvalidText: 'Ýalňyş format',
                      //   initialDate: DateTime.now(),
                      //   firstDate: DateTime(1900),
                      //   lastDate: DateTime.now(),
                      // );
                      _birthdateController.text = date!.toIso8601String();
                    },
                    controller: _birthdateController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Doglan senesi',
                      labelStyle: TextStyle(
                        color: AppTheme.DRAWER_ICON,
                      ),
                    ),
                    focusNode: _birthdateFocus,
                    onFieldSubmitted: (notUsed) {
                      fieldFocusChange(context, _birthdateFocus, _genderFocus);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Doglan senesini giriziň';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.w),
                  child: GestureDetector(
                    onTap: _onGenderPressed,
                    child: Container(
                      color: Colors.transparent,
                      //// the red square would receive click events when tapping the blue square.
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: _genderController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Jynsy',
                            labelStyle: TextStyle(
                              color: AppTheme.DRAWER_ICON,
                            ),
                          ),
                          focusNode: _genderFocus,
                          onFieldSubmitted: (notUsed) {
                            fieldFocusChange(
                                context, _genderFocus, _emailFocus);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Jynsy giriziň';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.w),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Elektron poçtasy',
                      labelStyle: TextStyle(
                        color: AppTheme.DRAWER_ICON,
                      ),
                    ),
                    focusNode: _emailFocus,
                    onFieldSubmitted: (notUsed) {
                      fieldFocusChange(context, _emailFocus, _phoneFocus);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Elektron poçtaňyzy giriziň';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.w),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Telefon belgiňiz',
                      labelStyle: TextStyle(
                        color: AppTheme.DRAWER_ICON,
                      ),
                    ),
                    focusNode: _phoneFocus,
                    onFieldSubmitted: (notUsed) {
                      _phoneFocus.unfocus();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Telefon belgiňizi giriziň';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 0.2.sw),
                CustomElevatedButton(
                  height: 1.sw / 9,
                  width: 1.sw,
                  color: AppTheme.MAIN,
                  borderRadius: 10.0,
                  text: 'Ýatda sakla',
                  isLoading: _isLoading,
                  onPressed: _onRememberButtonPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
