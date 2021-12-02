import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

class AddressAddEditScreen extends StatefulWidget {
  @override
  _AddressAddEditScreenState createState() => _AddressAddEditScreenState();
}

class _AddressAddEditScreenState extends State<AddressAddEditScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final GlobalKey<FormState> _cartAddressformKey = GlobalKey<FormState>();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _streetFocus = FocusNode();
  final FocusNode _apartmentFocus = FocusNode();
  final FocusNode _houseFocus = FocusNode();
  final FocusNode _floorFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _cityController.dispose();
    _streetController.dispose();
    _apartmentController.dispose();
    _houseController.dispose();
    _floorController.dispose();
    _notesController.dispose();
    _cityFocus.dispose();
    _streetFocus.dispose();
    _apartmentFocus.dispose();
    _houseFocus.dispose();
    _floorFocus.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  Future _onConfirmButtonPressed() async {
    setState(() {
      _isLoading = true;
    });
    if (_cartAddressformKey.currentState!.validate()) {
      printLog('_contactformKey validated');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppTheme.WHITE,
        elevation: 1,
        leadingWidth: 35.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppTheme.FONT_COLOR,
              size: 25.w,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Salgy',
          style: TextStyle(
            color: AppTheme.MAIN_DARK,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _cartAddressformKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --------------- CITY -------------- //
                      Padding(
                        padding: EdgeInsets.only(top: 10.w),
                        child: Text(
                          'Şäher',
                          style: TextStyle(
                              fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
                        ),
                      ),
                      TextFormField(
                        controller: _cityController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.FONT_COLOR, width: 0.5),
                          ),
                          hintText: 'Aşgabat',
                          hintStyle: TextStyle(
                              fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                        ),
                        focusNode: _cityFocus,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Şäheri giriziň';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.w),
                      // --------------- STREET -------------- //
                      Padding(
                        padding: EdgeInsets.only(top: 15.w),
                        child: Text(
                          'Köçe',
                          style: TextStyle(
                              fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
                        ),
                      ),
                      TextFormField(
                        controller: _streetController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.FONT_COLOR, width: 0.5),
                          ),
                          hintText: 'A.Nowaýy 23, 64',
                          hintStyle: TextStyle(
                              fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                        ),
                        focusNode: _streetFocus,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Köçäni giriziň';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.w),
                      // --------------- APARTMENT/HOUSE/FLOOR -------------- //
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: _apartmentController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.DRAWER_DIVIDER,
                                      width: 0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.FONT_COLOR, width: 0.5),
                                ),
                                labelText: 'Jaý',
                                labelStyle: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppTheme.DRAWER_ICON),
                              ),
                              focusNode: _apartmentFocus,
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: TextFormField(
                              controller: _houseController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.DRAWER_DIVIDER,
                                      width: 0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.FONT_COLOR, width: 0.5),
                                ),
                                labelText: 'Otag',
                                labelStyle: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppTheme.DRAWER_ICON),
                              ),
                              focusNode: _houseFocus,
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: TextFormField(
                              controller: _floorController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.DRAWER_DIVIDER,
                                      width: 0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.FONT_COLOR, width: 0.5),
                                ),
                                labelText: 'Gat',
                                labelStyle: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppTheme.DRAWER_ICON),
                              ),
                              focusNode: _floorFocus,
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                          Flexible(child: SizedBox())
                        ],
                      ),
                      // --------------- NOTE -------------- //
                      Padding(
                        padding: EdgeInsets.only(top: 20.w),
                        child: Text(
                          'Bellik',
                          style: TextStyle(
                              fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
                        ),
                      ),
                      SizedBox(height: 7.w),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 6,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: AppTheme().radius10,
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppTheme.MAIN_LIGHT,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //--------------- FILTER BUTTONS -------------- //
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppTheme.WHITE,
              padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 50.w),
              child: Column(
                children: [
                  TextButton(
                    child: Text(
                      'Salgyny aýyr',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppTheme.FONT_COLOR,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(height: 15.w),
                  SizedBox(
                    width: 1.sw,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.MAIN,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: AppTheme().radius10),
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                      ),
                      child: Text(
                        'Salgyny goş',
                        style: TextStyle(
                          color: AppTheme.WHITE,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
