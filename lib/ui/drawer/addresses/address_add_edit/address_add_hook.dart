import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';
import 'address_add_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressAddHook extends HookViewModelWidget<AddressAddViewModel> {
  const AddressAddHook({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, AddressAddViewModel model) {
    final _cityController =
        useTextEditingController(text: LocaleKeys.ashgabat.tr());
    final _streetController = useTextEditingController();
    final _apartmentController = useTextEditingController();
    final _houseController = useTextEditingController();
    final _floorController = useTextEditingController();
    final _notesController = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------- CITY -------------- //
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(LocaleKeys.city, style: kts14HelperText).tr(),
        ),
        TextFormField(
          controller: _cityController,
          style: kts18Text,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            hintText: LocaleKeys.ashgabat.tr(),
            hintStyle: ktsDefault18HelperText,
          ),
          validator: model.updateCity,
        ),
        // --------------- STREET -------------- //
        SizedBox(height: 15.h),
        TextFormField(
          controller: _streetController,
          style: kts18Text,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            labelText: LocaleKeys.streetEx.tr(),
            labelStyle: ktsDefault18HelperText,
          ),
          validator: model.updateStreet,
        ),
        SizedBox(height: 15.h),
        // --------------- APARTMENT/HOUSE/FLOOR -------------- //
        Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: _houseController,
                style: kts18Text,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: LocaleKeys.apartment.tr(),
                  labelStyle: kts14HelperText,
                ),
                validator: model.updateHouse,
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: TextFormField(
                controller: _apartmentController,
                style: kts18Text,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: LocaleKeys.house.tr(),
                  labelStyle: kts14HelperText,
                ),
                validator: model.updateApartment,
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: TextFormField(
                controller: _floorController,
                style: kts18Text,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: LocaleKeys.floor.tr(),
                  labelStyle: kts14HelperText,
                ),
                validator: model.updateFloor,
              ),
            ),
            Flexible(child: SizedBox())
          ],
        ),
        // --------------- NOTE -------------- //
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Text(
            LocaleKeys.note,
            style: kts14HelperText,
          ).tr(),
        ),
        SizedBox(height: 5.h),
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
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            filled: true,
            fillColor: AppTheme.MAIN_LIGHT,
          ),
          validator: model.updateNote,
        ),
      ],
    );
  }
}
