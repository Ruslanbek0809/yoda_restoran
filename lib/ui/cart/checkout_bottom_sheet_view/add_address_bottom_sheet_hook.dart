import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/ui/cart/checkout_bottom_sheet_view/checkout_view_model.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAddressBottomSheetHook extends HookViewModelWidget<CheckoutViewModel> {
  const AddAddressBottomSheetHook({
    Key? key,
  }) : super(
          key: key,
        );

  // final TextEditingController _cityController = TextEditingController();
  // final TextEditingController _streetController = TextEditingController();
  // final TextEditingController _apartmentController = TextEditingController();
  // final TextEditingController _houseController = TextEditingController();
  // final TextEditingController _floorController = TextEditingController();
  // final TextEditingController _notesController = TextEditingController();
  // final FocusNode _cityFocus = FocusNode();
  // final FocusNode _streetFocus = FocusNode();
  // final FocusNode _apartmentFocus = FocusNode();
  // final FocusNode _houseFocus = FocusNode();
  // final FocusNode _floorFocus = FocusNode();
  // final FocusNode _notesFocus = FocusNode();

  @override
  Widget buildViewModelWidget(BuildContext context, CheckoutViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------- CITY -------------- //
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Text(
            'Şäher',
            style: TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
          ),
        ),
        TextFormField(
          controller: _cityController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            hintText: 'Aşgabat',
            hintStyle: TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
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
            style: TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
          ),
        ),
        TextFormField(
          controller: _streetController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            hintText: 'A.Nowaýy 23, 64',
            hintStyle: TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
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
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: 'Jaý',
                  labelStyle:
                      TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
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
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: 'Otag',
                  labelStyle:
                      TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
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
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: 'Gat',
                  labelStyle:
                      TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
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
            style: TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
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
    );
  }
}
