import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/profile/address_add_edit/add_edit_address_hook.dart';
import 'package:yoda_res/ui/widgets/my_app_bar.dart';
import '../../../utils/utils.dart';

import 'address_add_edit_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressAddEditView extends StatefulWidget {
  const AddressAddEditView({Key? key}) : super(key: key);

  @override
  State<AddressAddEditView> createState() => _AddressAddEditViewState();
}

class _AddressAddEditViewState extends State<AddressAddEditView>
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

  final GlobalKey<FormState> _addEditAddressformKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressAddEditViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navBack(); // Workaround
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MyAppbar(
            child: AppBar(
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
          ),
          body: Stack(
            children: [
              //--------------- ADD/EDIT FORM HOOK -------------- //
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _addEditAddressformKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: AddEditAddressHook(),
                    ),
                  ],
                ),
              ),
              //--------------- ADDRESS BUTTONS -------------- //
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
        ),
      ),
      viewModelBuilder: () => AddressAddEditViewModel(),
    );
  }
}
