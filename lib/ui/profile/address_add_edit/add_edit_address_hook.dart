import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/ui/profile/address_add_edit/address_add_edit_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEditAddressHook extends HookViewModelWidget<AddressAddEditViewModel> {
  const AddEditAddressHook({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(
      BuildContext context, AddressAddEditViewModel model) {
    return //--------------- ADD/EDIT FORM HOOK -------------- //
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                    style:
                        TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
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
                      borderSide:
                          BorderSide(color: AppTheme.FONT_COLOR, width: 0.5),
                    ),
                    hintText: 'Aşgabat',
                    hintStyle:
                        TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
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
                    style:
                        TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
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
                      borderSide:
                          BorderSide(color: AppTheme.FONT_COLOR, width: 0.5),
                    ),
                    hintText: 'A.Nowaýy 23, 64',
                    hintStyle:
                        TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
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
                                color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.FONT_COLOR, width: 0.5),
                          ),
                          labelText: 'Jaý',
                          labelStyle: TextStyle(
                              fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
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
                                color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.FONT_COLOR, width: 0.5),
                          ),
                          labelText: 'Otag',
                          labelStyle: TextStyle(
                              fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
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
                                color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.FONT_COLOR, width: 0.5),
                          ),
                          labelText: 'Gat',
                          labelStyle: TextStyle(
                              fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
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
                    style:
                        TextStyle(fontSize: 14.sp, color: AppTheme.DRAWER_ICON),
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
    );
  }
}
