import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/library/flutter_datetime_picker.dart';
import 'package:yoda_res/library/src/datetime_picker_theme.dart';
import 'package:yoda_res/library/src/i18n_model.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/cart/checkout/checkout_note_hook.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'checkout_promocode_hook.dart';
import 'checkout_view_model.dart';

class CheckoutBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const CheckoutBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      onModelReady: (model) => model.getOnModelReady(),
      viewModelBuilder: () => CheckoutViewModel(),
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constants.BORDER_RADIUS_20),
                ),
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(

                    /// To resize screen when OnKeyboard opened
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
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 0.w, 20.h),
                      child: Column(
                        children: [
// --------------- PHONE PART -------------- //
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/phone.svg',
                                color: AppTheme.MAIN_DARK,
                                width: 25.w,
                              ),
                              SizedBox(width: 15.w),
                              Text(
                                '+993 61883349',
                                style: ktsDefault18BoldText,
                              ),
                            ],
                          ),
                          Divider(
                            color: AppTheme.DRAWER_DIVIDER,
                            indent: 0.111.sw,
                          ),
// --------------- ADDRESS -------------- //
                          Material(
                            color: AppTheme.WHITE,
                            child: InkWell(
                              onTap: model.showCustomAddAddressBottomSheet,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/house.svg',
                                          color: AppTheme.MAIN_DARK,
                                          width: 25.w,
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          'A.Nowaýy 23, 64',
                                          style: ktsDefault16Text,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20.w),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: AppTheme.FONT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: AppTheme.DRAWER_DIVIDER,
                            indent: 0.111.sw,
                          ),
// --------------- DELIVERY DATE TIME -------------- //
                          Material(
                            color: AppTheme.WHITE,
                            child: InkWell(
                              onTap: () async {
                                model.deliverDateTime =
                                    await DatePicker.showDateTimePicker(
                                          context,
                                          showTitleActions: true,
                                          minTime: model.now,
                                          maxTime: model.maxDateTime,
                                          onChanged: (date) {
                                            model.log.i('Senä change $date');
                                          },
                                          onConfirm: (date) {
                                            model.log.i('Senä confirm $date');
                                          },
                                          currentTime: model.deliverDateTime,
                                          locale: LocaleType.tk,
                                          theme: DatePickerTheme(
                                            doneStyle: ktsDefault20BoldText,
                                            backgroundColor:
                                                AppTheme.MAIN_LIGHT,
                                          ),
                                        ) ??
                                        model.deliverDateTime;
                                model.deliverDateFormatted = DateFormat('HH:mm')
                                    .format(model.deliverDateTime!);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/clock.svg',
                                          color: AppTheme.MAIN_DARK,
                                          width: 25.w,
                                        ),
                                        SizedBox(width: 15.w),
                                        Row(
                                          children: [
                                            Text(
                                              'Eltmeli wagty: ',
                                              style: ktsDefault16Text,
                                            ),
                                            Text(
                                              model.deliverDateTime == model.now
                                                  ? 'Şu wagt'
                                                  : model.deliverDateTime!
                                                              .isAfter(
                                                                  model.now) &&
                                                          model.deliverDateTime!
                                                              .isBefore(model
                                                                  .tomorrow!)
                                                      ? 'Şu gün ${model.deliverDateFormatted}'
                                                      : model.deliverDateTime!
                                                              .isAfter(model
                                                                  .tomorrow!)
                                                          ? 'Ertir ${model.deliverDateFormatted}'
                                                          : '',
                                              style: ktsDefault16Text,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20.w),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: AppTheme.FONT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: AppTheme.DRAWER_DIVIDER,
                            indent: 0.111.sw,
                          ),
// --------------- PARMENT TYPE -------------- //
                          Material(
                            color: AppTheme.WHITE,
                            child: InkWell(
                              onTap: model.showCustomPaymentTypeBottomSheet,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/wallet.svg',
                                          color: AppTheme.MAIN_DARK,
                                          width: 25.w,
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          'Töleg görnüşi: ${model.selectedPaymentType!.name}',
                                          style: ktsDefault16Text,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20.w),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: AppTheme.FONT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: AppTheme.DRAWER_DIVIDER,
                            indent: 0.111.sw,
                          ),
                          SizedBox(height: 10.h),
                          //------------------ PROMOCODE ---------------------//
                          CheckoutPromocodeHook(),
                          // --------------- NOTE -------------- //
                          CheckoutNoteHook(),
                        ],
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
                  border: Border.all(
                      color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
                ),
                padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 25.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${model.getTotalCartSum} TMT',
                      style: ktsDefault20BoldText,
                    ),
                    CustomTextChildButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 17.w,
                        horizontal: 0.2.sw,
                      ),
                      child: Text(
                        'Sargyt et',
                        style: ktsButton18Text,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .popAndPushNamed(RouteList.orderSuccess);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
