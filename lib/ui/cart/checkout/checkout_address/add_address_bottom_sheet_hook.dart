import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/cart/checkout/checkout_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

class AddAddressBottomSheetHook extends HookViewModelWidget<CheckoutViewModel> {
  const AddAddressBottomSheetHook({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget buildViewModelWidget(BuildContext context, CheckoutViewModel model) {
    final _cityController = useTextEditingController();
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
          padding: EdgeInsets.only(left: 5.w),
          child: Text('Şäher', style: ktsDefault14HelperText),
        ),
        TextFormField(
          controller: _cityController,
          initialValue: 'Aşgabat',
          onTap: null,
          style: ktsDefault18Text,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            hintText: 'Aşgabat',
            hintStyle: ktsDefault18HelperText,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Şäheri giriziň';
            }
            return null;
          },
        ),
        // --------------- STREET -------------- //
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 25.h),
          child: Text('Köçe', style: ktsDefault14HelperText),
        ),
        TextFormField(
          controller: _streetController,
          style: ktsDefault18Text,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
            ),
            hintText: 'A.Nowaýy 23, 64',
            hintStyle: ktsDefault18HelperText,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Köçäni giriziň';
            }
            return null;
          },
        ),
        SizedBox(height: 15.h),
        // --------------- APARTMENT/HOUSE/FLOOR -------------- //
        Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: _apartmentController,
                style: ktsDefault18Text,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: 'Jaý',
                  labelStyle: ktsDefault14HelperText,
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: TextFormField(
                controller: _houseController,
                style: ktsDefault18Text,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: 'Otag',
                  labelStyle: ktsDefault14HelperText,
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: TextFormField(
                controller: _floorController,
                style: ktsDefault18Text,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                  ),
                  labelText: 'Gat',
                  labelStyle: ktsDefault14HelperText,
                ),
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
          padding: EdgeInsets.only(left: 5.w, top: 15.h),
          child: Text(
            'Bellik',
            style: ktsDefault14HelperText,
          ),
        ),
        SizedBox(height: 5.h),
        TextFormField(
          controller: _notesController,
          maxLines: 5,
          style: ktsDefault18Text,
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
