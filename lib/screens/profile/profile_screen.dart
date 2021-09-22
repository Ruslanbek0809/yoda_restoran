import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.cancel, // TODO: Change this to other icon
            color: AppTheme.BLACK,
            size: 22.w,
          ),
        ),
        title: Text(
          'Biz bilen habarlaş',
          style: TextStyle(
            color: AppTheme.WHITE,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.WHITE,
          borderRadius: AppTheme().containerRadius,
        ),
        padding: EdgeInsets.only(top: 5.w, right: 15.w, left: 15.w),
        child: Form(
          key: _contactformKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hintText: 'Ady'),
                focusNode: _nameFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ady dolduryň';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hintText: 'Telefon belgiňiz'),
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
                maxLines: 8,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      gapPadding: 0.0,
                    ),
                    hintText: 'Habarnama'),
                focusNode: _infoFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Habarnama hökman dolduryň';
                  }
                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: CustomElevatedButton(
                  height: 1.sw / 10,
                  width: 1.sw,
                  color: AppTheme.MAIN,
                  borderRadius: 10.0,
                  text: 'Ugratmak',
                  isLoading: _isLoading,
                  onPressed: _onContactPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
