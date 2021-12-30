import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/library/flutter_datetime_picker.dart';
import 'package:yoda_res/library/src/datetime_picker_theme.dart';
import 'package:yoda_res/library/src/i18n_model.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'checkout_view_model.dart';

class CheckoutBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const CheckoutBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      onModelReady: (model) => model.getOnModelReady(),
      viewModelBuilder: () => CheckoutViewModel(),
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.6,
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
                      padding: EdgeInsets.fromLTRB(20.w, 18.h, 0.w, 20.h),
                      child: Column(
                        children: [
// --------------- PHONE PART -------------- //
                          Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: SvgPicture.asset(
                                      'assets/phone.svg',
                                      color: AppTheme.MAIN_DARK,
                                      width: 25.w,
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Text(
                                    '+993 61883349',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: AppTheme.FONT_COLOR,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: AppTheme.DRAWER_DIVIDER,
                                indent: 0.111.sw,
                              )
                            ],
                          ),
// --------------- HOUSE PART -------------- //
                          Material(
                            color: AppTheme.WHITE,
                            child: InkWell(
                              onTap: () {
                                /// TODO: AddressBottomSheet
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.w),
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
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppTheme.FONT_COLOR,
                                          ),
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
// --------------- DELIVERY TIME -------------- //
                          Material(
                            color: AppTheme.WHITE,
                            child: InkWell(
                              onTap: () async {
                                _deliverDateTime =
                                    await DatePicker.showDateTimePicker(
                                          context,
                                          showTitleActions: true,
                                          minTime: now,
                                          maxTime: maxDateTime,
                                          onChanged: (date) {
                                            print('Senä change $date');
                                          },
                                          onConfirm: (date) {
                                            print('Senä confirm $date');
                                          },
                                          currentTime: _deliverDateTime,
                                          locale: LocaleType.tk,
                                          theme: DatePickerTheme(
                                            doneStyle: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.FONT_COLOR,
                                            ),
                                            backgroundColor:
                                                AppTheme.MAIN_LIGHT,
                                          ),
                                        ) ??
                                        _deliverDateTime;
                                _deliverDateFormatted = DateFormat('HH:mm')
                                    .format(_deliverDateTime!);
                                // setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.w),
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
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: AppTheme.FONT_COLOR,
                                              ),
                                            ),
                                            Text(
                                              _deliverDateTime == now
                                                  ? 'Şu wagt'
                                                  : _deliverDateTime!
                                                              .isAfter(now) &&
                                                          _deliverDateTime!
                                                              .isBefore(
                                                                  tomorrow!)
                                                      ? 'Şu gün $_deliverDateFormatted'
                                                      : _deliverDateTime!
                                                              .isAfter(
                                                                  tomorrow!)
                                                          ? 'Ertir $_deliverDateFormatted'
                                                          : '',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: AppTheme.FONT_COLOR,
                                              ),
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
                          SizedBox(height: 10.w),
// --------------- NOTE -------------- //
                          Padding(
                            padding: EdgeInsets.only(
                                left: 40.w, right: 15.w, bottom: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Text(
                                    'Bellik',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppTheme.DRAWER_ICON,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.w),
                                TextField(
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
                                ),
                              ],
                            ),
                          ),
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
                      '175 TMT',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.FONT_COLOR,
                      ),
                    ),
                    CustomTextButton(
                      text: 'Sargyt et',
                      padding: EdgeInsets.symmetric(
                          vertical: 17.w, horizontal: 0.2.sw),
                      textStyle: TextStyle(
                        color: AppTheme.WHITE,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.normal,
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
