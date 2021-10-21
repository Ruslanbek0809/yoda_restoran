import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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
    return WillPopScope(
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
            'Biz bilen habarlaş',
            style: TextStyle(
              color: AppTheme.MAIN_DARK,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Form(
            key: _contactformKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 25.w),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: AppTheme().containerRadius,
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Ady',
                    hintStyle:
                        TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                    filled: true,
                    fillColor: AppTheme.MAIN_LIGHT,
                  ),
                  focusNode: _nameFocus,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ady dolduryň';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.w),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: AppTheme().containerRadius,
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Telefon belgiňiz',
                    hintStyle:
                        TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                    filled: true,
                    fillColor: AppTheme.MAIN_LIGHT,
                  ),
                  focusNode: _phoneFocus,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Telefon belgiňizi giriziň';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.w),
                TextFormField(
                  controller: _infoController,
                  maxLines: 10,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: AppTheme().containerRadius,
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Habarnama',
                    hintStyle:
                        TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                    filled: true,
                    fillColor: AppTheme.MAIN_LIGHT,
                  ),
                  focusNode: _infoFocus,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Habarnama hökman dolduryň';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 35.w),
                CustomTextButton(
                  text: 'Ugratmak',
                  padding:
                      EdgeInsets.symmetric(vertical: 14.w, horizontal: 0.34.sw),
                  textStyle: TextStyle(
                    color: AppTheme.WHITE,
                    fontSize: 18.sp,
                  ),
                  borderRadius: AppTheme().containerRadius,
                  onPressed: _onContactPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
