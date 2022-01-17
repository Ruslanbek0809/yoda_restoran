import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';

import 'contact_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  bool _isLoading = false;
  final GlobalKey<FormState> _contactformKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final _phoneController = TextEditingController(text: '+993 ');
  var maskFormatter = MaskTextInputFormatter(
      mask: '+993 ## ## ## ##', filter: {'#': RegExp(r'[0-9]')});
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _infoFocus = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _phoneController.dispose();
    _infoController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _infoFocus.dispose();
    super.dispose();
  }

  Future _onContactPressed() async {
    setState(() {
      _isLoading = true;
    });
    if (_contactformKey.currentState!.validate()) {
      printLog('_contactformKey validated');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          await Navigator.pushReplacementNamed(context, RouteList.home);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.WHITE,
            elevation: 0,
            leading: GestureDetector(
              onTap: () async =>
                  await Navigator.pushReplacementNamed(context, RouteList.home),
              child: Icon(
                Icons.arrow_back,
                color: AppTheme.FONT_COLOR,
                size: 25.w,
              ),
            ),
            title: Text(
              LocaleKeys.contact_us,
              style: TextStyle(
                color: AppTheme.MAIN_DARK,
              ),
            ).tr(),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _contactformKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50.w),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                            color: AppTheme.CONTACT_COLOR, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppTheme.CONTACT_COLOR, width: 0.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      hintText: LocaleKeys.name.tr(),
                      hintStyle: TextStyle(
                          fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                      filled: true,
                      fillColor: AppTheme.MAIN_LIGHT,
                    ),
                    focusNode: _nameFocus,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.your_name.tr();
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                      border: UnderlineInputBorder(
                        // borderRadius: AppTheme().containerRadius,
                        borderSide: BorderSide(
                            color: AppTheme.CONTACT_COLOR, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppTheme.CONTACT_COLOR, width: 0.5),
                      ),
                      hintText: LocaleKeys.phone.tr(),
                      hintStyle: TextStyle(
                          fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                      filled: true,
                      fillColor: AppTheme.MAIN_LIGHT,
                    ),
                    focusNode: _phoneFocus,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.phone.tr();
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _infoController,
                    maxLines: 10,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        // borderRadius: AppTheme().containerRadius,
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: LocaleKeys.text.tr(),
                      hintStyle: TextStyle(
                          fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                      filled: true,
                      fillColor: AppTheme.MAIN_LIGHT,
                    ),
                    focusNode: _infoFocus,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.enter_text.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: 1.sw,
                    child: CustomTextButton(
                      text: LocaleKeys.send.tr(),
                      padding: EdgeInsets.symmetric(
                          vertical: 13.w, horizontal: 16.w),
                      textStyle: TextStyle(
                        color: AppTheme.WHITE,
                        fontSize: 18.sp,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      onPressed: _onContactPressed,
                    ),
                  ),
                  SizedBox(height: 0.35.sw),
                  Text(
                    LocaleKeys.our_phone,
                    style: TextStyle(
                      color: AppTheme.CONTACT_COLOR,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ).tr(),
                  SizedBox(height: 2.h),
                  Text(
                    LocaleKeys.our_address,
                    style: TextStyle(
                      color: AppTheme.CONTACT_COLOR,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ).tr(),
                  SizedBox(height: 2.h),
                  // Text(
                  //   'Instagram: @yoda.restoran',
                  //   style: TextStyle(
                  //     color: AppTheme.CONTACT_COLOR,
                  //     fontSize: 16.sp,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ).tr(),
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ContactViewModel(),
    );
  }
}
