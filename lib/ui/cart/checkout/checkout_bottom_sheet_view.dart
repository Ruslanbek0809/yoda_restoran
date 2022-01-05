import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../library/flutter_datetime_picker.dart';
import '../../../library/src/datetime_picker_theme.dart';
import '../../../library/src/i18n_model.dart';
import '../../../shared/shared.dart';
import 'checkout_note_hook.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
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
                                  ? model.showCustomSelectAddressBottomSheet
                                  : null,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: model.isDelivery
                                    ? Row(
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
                                                model.selectedAddress!.id == -1
                                                    ? 'Salgyňyzy giriziň'
                                                    : model.selectedAddress!
                                                            .street! +
                                                        (model.selectedAddress!
                                                                    .house !=
                                                                null
                                                            ? ', ${model.selectedAddress!.house}'
                                                            : ''),
                                                style:
                                                    model.selectedAddress!.id ==
                                                            -1
                                                        ? ktsDefault16HelperText
                                                        : ktsDefault16Text,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 20.w),
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
                                            style: ktsDefault16Text,
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
                                model.deliveryDateTime =
                                    await DatePicker.showDateTimePicker(
                                          context,
                                          showTitleActions: true,
                                          minTime: model.now,
                                          maxTime: model.maxDateTime,
                                          onChanged: (date) {
                                            model.log.v('Senä change $date');
                                          },
                                          onConfirm: (date) {
                                            model.log.v('Senä confirm $date');
                                          },
                                          currentTime: model.deliveryDateTime,
                                          locale: LocaleType.tk,
                                          theme: DatePickerTheme(
                                            doneStyle: ktsDefault20BoldText,
                                            backgroundColor:
                                                AppTheme.MAIN_LIGHT,
                                          ),
                                        ) ??
                                        model.deliveryDateTime;
                                model.updateDateTimeForDelivery(
                                    model.deliveryDateTime);
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
                                                    'Eltmeli wagty: ',
                                                    style: ktsDefault16Text,
                                                  )
                                                : Text(
                                                    'Taýýarlamaly wagty: ',
                                                    style: ktsDefault16Text,
                                                  ),
                                            Text(
                                              model.deliveryDateTime ==
                                                      model.now
                                                  ? 'Şu wagt'
                                                  : model.deliveryDateTime!
                                                              .isAfter(
                                                                  model.now) &&
                                                          model
                                                              .deliveryDateTime!
                                                              .isBefore(model
                                                                  .tomorrow!)
                                                      ? 'Şu gün ${model.deliveryDateFormatted}'
                                                      : model.deliveryDateTime!
                                                              .isAfter(model
                                                                  .tomorrow!)
                                                          ? 'Ertir ${model.deliveryDateFormatted}'
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
            //--------------- CHECKOUT BUTTON -------------- //
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
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 25.h),
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
                                  '${model.getTotalCartSum} TMT -${model.getPromocodePrice} TMT',
                                  style: ktsDefault12Text,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: Text(
                                  '${model.getTotalCartSumWithPromocode} TMT',
                                  style: ktsDefault22BoldText,
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: Text(
                              '${model.getTotalCartSum} TMT',
                              style: ktsDefault22BoldText,
                            ),
                          ),
                    Expanded(
                      child: CustomTextChildButton(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: model.isBusy
                            ? ButtonLoading()
                            : Text(
                                'Sargyt et',
                                style: ktsButton18Text,
                              ),
                        onPressed: model.navToOrdersByRemovingAll,
                        // onPressed: model.createOrder,
                      ),
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
