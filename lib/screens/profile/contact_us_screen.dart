import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            'Biz bilen habarlaşyň',
            style: TextStyle(
              color: AppTheme.MAIN_DARK,
            ),
          ),
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
                          color: AppTheme.CONTACT_DIVIDER, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.CONTACT_DIVIDER, width: 0.5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
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
                      return 'Ady giriziň';
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
                          color: AppTheme.CONTACT_DIVIDER, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.CONTACT_DIVIDER, width: 0.5),
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
                    hintText: 'Tekst',
                    hintStyle:
                        TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                    filled: true,
                    fillColor: AppTheme.MAIN_LIGHT,
                  ),
                  focusNode: _infoFocus,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Teksti hökman dolduryň';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  width: 1.sw,
                  child: CustomTextButton(
                    text: 'Ugrat',
                    padding:
                        EdgeInsets.symmetric(vertical: 13.w, horizontal: 16.w),
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
                  'Telefon: +99363 687171',
                  style: TextStyle(
                    color: AppTheme.CONTACT_DIVIDER,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.w),
                Text(
                  'Salgy: G.Kulyýew köç.29 (Rowana), 2-nji gat',
                  style: TextStyle(
                    color: AppTheme.CONTACT_DIVIDER,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.w),
                Text(
                  'Instagram: @yoda.restoran',
                  style: TextStyle(
                    color: AppTheme.CONTACT_DIVIDER,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
