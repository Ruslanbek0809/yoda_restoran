import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/utils/utils.dart';

void cartAddressAddEditBottomSheet(BuildContext context) {
  showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Constants.BORDER_RADIUS_20),
      ),
    ),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.7,
      builder: (context, scrollController) =>
          CartAddressAddEditBottomSheetWidget(
        scrollController,
      ),
    ),
  );
}

class CartAddressAddEditBottomSheetWidget extends StatefulWidget {
  final ScrollController scrollController;
  CartAddressAddEditBottomSheetWidget(this.scrollController);

  @override
  _CartAddressAddEditBottomSheetWidgetState createState() =>
      _CartAddressAddEditBottomSheetWidgetState();
}

class _CartAddressAddEditBottomSheetWidgetState
    extends State<CartAddressAddEditBottomSheetWidget>
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
    return Container(
      height: 0.7.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constants.BORDER_RADIUS_20)),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.BORDER_RADIUS_20),
              ),
              color: Colors.transparent,
            ),
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --------------- BOTTOM SHEET DRAGGER -------------- //
                  SizedBox(
                    height: 17.5.w,
                    width: 40.w,
                    child: SvgPicture.asset(
                      'assets/bottom_sheet_dragger.svg',
                      color: AppTheme.WHITE,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Constants.BORDER_RADIUS_20),
                      ),
                      color: AppTheme.WHITE,
                    ),
                    padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 50.w),
                    child: Form(
                      key: _cartAddressformKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --------------- CITY -------------- //
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
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
                            padding: EdgeInsets.only(left: 5.w, top: 15.w),
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
                                    labelText: 'Jaý',
                                    labelStyle: TextStyle(
                                        fontSize: 14.sp,
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
                                    labelText: 'Otag',
                                    labelStyle: TextStyle(
                                        fontSize: 14.sp,
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
                                    labelText: 'Gat',
                                    labelStyle: TextStyle(
                                        fontSize: 14.sp,
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
                            padding: EdgeInsets.only(left: 5.w, top: 15.w),
                            child: Text(
                              'Bellik',
                              style: TextStyle(
                                  fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
                            ),
                          ),
                          SizedBox(height: 5.w),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 5,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: AppTheme().containerRadius,
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
                  ),
                ],
              ),
            ),
          ),
          //--------------- FILTER BUTTONS -------------- //
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.WHITE,
                border:
                    Border.all(color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
              ),
              padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppTheme.MAIN,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: AppTheme().buttonBorderRadius),
                  padding: EdgeInsets.symmetric(vertical: 17.w),
                ),
                child: Text(
                  'Tassykla',
                  style: TextStyle(
                    color: AppTheme.WHITE,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
