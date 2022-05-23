import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../../library/flutter_datetime_picker.dart';
import '../../../library/src/datetime_picker_theme.dart';
import '../../../library/src/i18n_model.dart';
import '../../../shared/shared.dart';
import 'checkout_address/checkout_select_address_bottom_sheet.dart';
import 'checkout_note_hook.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'checkout_payment_type_bottom_sheet.dart';
import 'checkout_promocode_hook.dart';
import 'checkout_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutBottomSheetView extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  const CheckoutBottomSheetView({
    Key? key,
    required this.scrollController,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      onModelReady: (model) => model.getOnModelReady(),
      viewModelBuilder: () => CheckoutViewModel(),
      builder: (context, model, child) => Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.BORDER_RADIUS_20)),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(

                  /// To resize screen when OnKeyboard opened
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Constants.BORDER_RADIUS_20)),
                      color: AppTheme.WHITE,
                    ),
                    padding: EdgeInsets.fromLTRB(20.w, 22.h, 0.0, 20.h),
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
                              model.currentUser!.mobile != null
                                  ? model.currentUser!.mobile!
                                  : '+993 65555555',
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
                            onTap: model.isDelivery
                                ? () async => await showFlexibleBottomSheet(
                                      minHeight: 0,
                                      initHeight: 0.31,
                                      maxHeight: 0.975,
                                      duration: Duration(milliseconds: 250),
                                      context: context,
                                      builder:
                                          (context, scrollController, offset) {
                                        return CustomBarBottomSheet(
                                          child:
                                              CheckoutSelectAddressBottomSheetView(
                                            scrollController: scrollController,
                                            offset: offset,
                                          ),
                                        );
                                      },
                                      anchors: [0, 0.31, 0.975],
                                    )
                                // model.showCustomSelectAddressBottomSheet
                                : null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: model.isDelivery
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/house.svg',
                                                color: AppTheme.MAIN_DARK,
                                                width: 25.w,
                                              ),
                                              SizedBox(width: 15.w),
                                              model.selectedAddress!.id == -1
                                                  ? Text(
                                                      LocaleKeys
                                                          .selectAddressPls,
                                                      style: kts16HelperText,
                                                    ).tr()
                                                  : Flexible(
                                                      child: Text(
                                                        model.selectedAddress!
                                                                .street! +
                                                            (model.selectedAddress!
                                                                        .house !=
                                                                    null
                                                                ? ', ${model.selectedAddress!.house}'
                                                                : ''),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: kts16Text,
                                                      ),
                                                    ),
                                            ],
                                          ),
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
                                    )
                                  : Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/map_pin_bold.svg',
                                          color: AppTheme.MAIN_DARK,
                                          width: 25.w,
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          model.cartRes!.name!,
                                          style: kts16Text,
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
                              DateTime? _tempDateTime =
                                  await DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: model.now.add(Duration(hours: 1)),
                                maxTime: model.maxDateTime,
                                currentTime: model.deliveryDateTime
                                        ?.add(Duration(minutes: 1)) ??
                                    model.now.add(Duration(
                                        hours:
                                            1)), // Here model.deliveryDateTime?.add(Duration(minutes: 1) ADDING a min is a Workaround
                                // currentTime: model.deliveryDateTime,
                                onChanged: (date) {
                                  // model.log.v('Senä change $date');
                                },
                                onConfirm: (date) {
                                  // model.log.v('Senä confirm $date');
                                },
                                locale: context.locale ==
                                        context.supportedLocales[0]
                                    ? LocaleType.tk
                                    : LocaleType.ru,
                                theme: DatePickerTheme(
                                  doneStyle: ktsDefault20BoldText,
                                  backgroundColor: kcWhiteColor,
                                ),
                              );
                              // ??
                              // model.deliveryDateTime;

                              model.log.v('_tempDateTime: $_tempDateTime');
                              model.log.v('model.now: ${model.now}');

                              /// If _tempDateTime is SELECTED go inside this condition
                              if (_tempDateTime != null) {
                                /// Below we have condition whether selected _tempDateTime inside workingHours
                                var resWorkingHoursSplitted =
                                    model.cartRes!.workingHours!.split('-');
                                var resStartWorkingHoursSplitted =
                                    resWorkingHoursSplitted[0].split(':');
                                var resEndWorkingHoursSplitted =
                                    resWorkingHoursSplitted[1].split(':');
                                var startHour =
                                    int.parse(resStartWorkingHoursSplitted[0]);
                                var startMinute =
                                    int.parse(resStartWorkingHoursSplitted[1]);
                                var endHour =
                                    int.parse(resEndWorkingHoursSplitted[0]);
                                var endMinute =
                                    int.parse(resEndWorkingHoursSplitted[1]);

                                model.log.v(
                                    '_tempDateTime and model.deliveryDateTime: $_tempDateTime and ${model.deliveryDateTime}');

                                /// =========== CHECKS HOURS PART =========== ///
                                if (_tempDateTime.hour < startHour ||
                                    _tempDateTime.hour > endHour) {
                                  model.log.v(
                                      'HOUR Inconvenience _tempDateTime.hour:${_tempDateTime.hour}, startHour:$startHour, endHour:$endHour');

                                  await showDateRangeErrorFlashBar(
                                    context: context,
                                    msg: Text(
                                            LocaleKeys
                                                .requiredWorkingHoursForRes,
                                            style: kts16ButtonText)
                                        .tr(args: [
                                      model.cartRes!.workingHours!
                                    ]),
                                    margin: EdgeInsets.only(
                                      left: 16.w,
                                      right: 16.w,
                                      bottom: 0.13.sh,
                                    ),
                                  );
                                }

                                /// ========== CHECKS MINUTES PART =========== ///
                                else {
                                  model.log.v(
                                      'PASSED HOUR Inconvenience _tempDateTime.hour:${_tempDateTime.hour}, startHour:$startHour, endHour:$endHour');

                                  var tempHourMin = (_tempDateTime.hour * 60) +
                                      _tempDateTime.minute;
                                  var startTempHourMin =
                                      (startHour * 60) + startMinute;
                                  var endTempHourMin =
                                      (endHour * 60) + endMinute;
                                  model.log.v(
                                      'tempHourMin: $tempHourMin,startTempHourMin: $startTempHourMin, endTempHourMin: $endTempHourMin');

                                  if (tempHourMin < startTempHourMin ||
                                      tempHourMin > endTempHourMin) {
                                    model.log.v(
                                        'MINUTE EQUAL Inconvenience _tempDateTime.minute:${_tempDateTime.minute}, startMinute:$startMinute, endMinute:$endMinute');
                                    await showDateRangeErrorFlashBar(
                                      context: context,
                                      msg: Text(
                                              LocaleKeys
                                                  .requiredWorkingHoursForRes,
                                              style: kts16ButtonText)
                                          .tr(args: [
                                        model.cartRes!.workingHours!
                                      ]),
                                      margin: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                        bottom: 0.13.sh,
                                      ),
                                    );
                                  } else {
                                    model.log.v(
                                        'PASSED MINUTE EQUAL _tempDateTime.minute:${_tempDateTime.minute}, startMinute:$startMinute, endMinute:$endMinute');
                                    model.updateDateTimeForDelivery(
                                        _tempDateTime);
                                  }
                                }
                              }
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
                                          model.isDelivery
                                              ? Text(
                                                  LocaleKeys.deliveryTime,
                                                  style: ktsDefault16BoldText,
                                                ).tr()
                                              : Text(
                                                  LocaleKeys.preparationTime,
                                                  style: ktsDefault16BoldText,
                                                ).tr(),
                                          model.deliveryDateTime == null
                                              ? Text(
                                                  LocaleKeys.now,
                                                  style: kts16Text,
                                                ).tr()
                                              : model.deliveryDateTime!
                                                          .isAfter(model.now) &&
                                                      model.deliveryDateTime!
                                                          .isBefore(
                                                              model.tomorrow!)
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          LocaleKeys.today,
                                                          style: kts16Text,
                                                        ).tr(),
                                                        Text(
                                                          ' ${model.deliveryDateFormatted}',
                                                          style: kts16Text,
                                                        ).tr(),
                                                      ],
                                                    )
                                                  : model.deliveryDateTime!
                                                          .isAfter(
                                                              model.tomorrow!)
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              LocaleKeys
                                                                  .tomorrow,
                                                              style: kts16Text,
                                                            ).tr(),
                                                            Text(
                                                              ' ${model.deliveryDateFormatted}',
                                                              style: kts16Text,
                                                            ).tr(),
                                                          ],
                                                        )
                                                      : Text(
                                                          ' ${model.deliveryDateFormatted}',
                                                          style: kts16Text,
                                                        ).tr(),
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
                            onTap: () async => await showFlexibleBottomSheet(
                              minHeight: 0,
                              initHeight: 0.3,
                              maxHeight: 0.3,
                              duration: Duration(milliseconds: 250),
                              context: context,
                              builder: (context, scrollController, offset) {
                                return CustomBarBottomSheet(
                                  child: CheckoutPaymentTypeBottomSheetView(
                                    scrollController: scrollController,
                                    offset: offset,
                                  ),
                                );
                              },
                              anchors: [0, 0.3],
                            ),
                            // onTap: model.showCustomPaymentTypeBottomSheet,
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
                                      Row(
                                        children: [
                                          Text(
                                            LocaleKeys.paymentType,
                                            style: ktsDefault16BoldText,
                                          ).tr(),
                                          Text(
                                            context.locale ==
                                                    context.supportedLocales[0]
                                                ? model.selectedPaymentType!
                                                    .nameTk!
                                                : model.selectedPaymentType!
                                                    .nameRu!,
                                            style: kts16Text,
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
          //--------------- CHECKOUT BUTTON -------------- //
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
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 15.h + 0.02.sw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  model.promocode != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: Text(
                                '${formatNum(model.getTotalCartSum)} TMT -${formatNum(model.getPromocodePrice)} TMT',
                                style: kts12PromocodeText,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: Text(
                                '${formatNum(model.getTotalCartSumWithPromocode)} TMT',
                                style: ktsDefault22BoldText,
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Text(
                            '${formatNum(model.getTotalCartSum)} TMT',
                            style: ktsDefault22BoldText,
                          ),
                        ),
                  Expanded(
                    child: CustomTextChildButton(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: model.isBusy
                          ? ButtonLoading()
                          : Text(
                              LocaleKeys.orderNow,
                              style: ktsButton18Text,
                            ).tr(),
                      // onPressed: model.navToOrdersByRemovingAll,
                      onPressed: model.isBusy
                          ? () {}
                          : () async {
                              if (model.selectedAddress!.id == -1 &&
                                  model.isDelivery)
                                await showErrorFlashBar(
                                  context: context,
                                  msg: LocaleKeys.selectAddressPls,
                                  margin: EdgeInsets.only(
                                    left: 16.w,
                                    right: 16.w,
                                    bottom: 0.13.sh,
                                  ),
                                );
                              else
                                await model.createOrder(
                                  onFailForView: () async =>
                                      await showErrorFlashBar(
                                    context: context,
                                    margin: EdgeInsets.only(
                                      left: 16.w,
                                      right: 16.w,
                                      bottom: 0.13.sh,
                                    ),
                                  ),
                                );
                            },
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
