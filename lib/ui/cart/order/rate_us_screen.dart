import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/utils.dart';

class RateUsScreen extends StatefulWidget {
  @override
  _RateUsScreenState createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final GlobalKey<FormState> _rateFormKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _notesFocus = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _notesController.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  Future _onConfirmButtonPressed() async {
    setState(() {
      _isLoading = true;
    });
    if (_rateFormKey.currentState!.validate()) {
      printLog('_contactformKey validated');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _rateFormKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // --------------- YODA RES Title -------------- //
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: SvgPicture.asset(
                            'assets/rate_yoda_res.svg',
                            color: AppTheme.MAIN,
                            width: 0.35.sw,
                          ),
                        ),
                        // --------------- RES NAME -------------- //
                        Padding(
                          padding: EdgeInsets.only(top: 35.h, bottom: 10.h),
                          child: Text(
                            'Soltan Restoran',
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: AppTheme.MAIN_DARK,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // --------------- TEXT -------------- //
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Text(
                            'Sargyt edeniňiz üçin sag boluň!',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: AppTheme.FONT_COLOR,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // --------------- TEXT -------------- //
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          child: Text(
                            'Işimiziň hilini ýokarlandyrmak üçin tagamlarymyza we hyzmatymyza berjek bahaňyz biziň üçin wajyp.',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppTheme.FONT_COLOR,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // --------------- RATING -------------- //
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            glow: false,
                            unratedColor: AppTheme.GREEN_COLOR.withOpacity(0.4),
                            itemSize: 60,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star_rate_rounded,
                              color: AppTheme.GREEN_COLOR,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                        // --------------- COMMENT -------------- //
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: TextFormField(
                            controller: _notesController,
                            minLines: 8,
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: AppTheme().radius10,
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppTheme.MAIN_LIGHT,
                              hintText: 'Teswir',
                              hintStyle: TextStyle(
                                fontSize: 16.sp,
                                color: AppTheme.TEXTFIELD_HINT_COLOR,
                              ),
                            ),
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //--------------- SEND Button -------------- //
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppTheme.WHITE,
                padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 50.w),
                child: SizedBox(
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
                      'Ugrat',
                      style: TextStyle(
                        color: AppTheme.WHITE,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme().radius20,
                        ),
                        title: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/success_rate_star.svg',
                              color: AppTheme.MAIN,
                              width: 120.w,
                              height: 120.w,
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              'Soltan Restoran',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.MAIN,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                        content: Text(
                          'Pikiriňizi paýlaşanyňyz üçin sag boluň!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.GREEN_COLOR,
                          ),
                        ),
                      ),
                    ),
                    // Navigator.of(context).pop(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
