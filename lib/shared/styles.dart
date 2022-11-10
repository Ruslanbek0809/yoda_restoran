import 'package:flutter/cupertino.dart';
import 'shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Text Styles
// To make it clear which weight we are using, we'll define the weight even for regular
// fonts

TextStyle kts10IconText = TextStyle(
  fontSize: 10.sp,
  fontWeight: FontWeight.w600,
  color: kcIconColor,
);

TextStyle kts10DialogText = TextStyle(
  fontSize: 10.sp,
  color: kcDialogColor,
);

TextStyle kts12DialogText = TextStyle(
  fontSize: 12.sp,
  color: kcDialogColor,
);

TextStyle kts12Text = TextStyle(
  fontSize: 12.sp,
  color: kcFontColor,
);

TextStyle kts12HelperText = TextStyle(
  fontSize: 12.sp,
  color: kcHelperColor,
);

TextStyle kts12PromocodeText = TextStyle(
  fontSize: 12.sp,
  color: kcPromocodeColor,
);

TextStyle kts12ContactText = TextStyle(
  fontSize: 12.sp,
  color: kcContactColor,
);

TextStyle kts14Text = TextStyle(
  fontSize: 14.sp,
  color: kcFontColor,
);

TextStyle kts14SemiBoldText = TextStyle(
  fontSize: 14.sp,
  color: kcFontColor,
  fontWeight: FontWeight.w500,
);

TextStyle kts14HelperText = TextStyle(
  fontSize: 14.sp,
  color: kcHelperColor,
);

TextStyle kts14IconText = TextStyle(
  fontSize: 14.sp,
  color: kcIconColor,
);

TextStyle kts14ContactText = TextStyle(
  fontSize: 14.sp,
  color: kcContactColor,
);

TextStyle ktsDefault14DialogText = TextStyle(
  fontSize: 14.sp,
  color: kcDialogColor,
);

TextStyle kts16ContactText = TextStyle(
  fontSize: 16.sp,
  color: kcContactColor,
);

TextStyle kts16ButtonText = TextStyle(
  color: kcWhiteColor,
  fontSize: 16.sp,
);

TextStyle kts16PrimaryBoldText = TextStyle(
  color: kcPrimaryColor,
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
);

TextStyle kts16Text = TextStyle(
  fontSize: 16.sp,
  color: kcFontColor,
);

TextStyle kts16PrimaryLightText = TextStyle(
  fontSize: 16.sp,
  color: kcPrimaryColor,
);

TextStyle kts16BoldText = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: kcFontColor,
);

TextStyle kts16WhiteBoldText = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: kcWhiteColor,
);

TextStyle kts16HelperText = TextStyle(
  fontSize: 16.sp,
  color: kcHelperColor,
);

TextStyle kts16DarkText = TextStyle(
  fontSize: 16.sp,
  color: kcSecondaryDarkColor,
);

TextStyle kts16DarkBoldText = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: kcSecondaryDarkColor,
);

TextStyle kts16OnlinePaymentBoldText = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: kcOnlinePaymentColor,
);

TextStyle kts16DialogText = TextStyle(
  fontSize: 16.sp,
  color: kcDialogColor,
);

TextStyle kts16DialogBoldText = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: kcDialogColor,
);

TextStyle kts16ContactBlueBoldText = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: kcBlueColor,
);

TextStyle kts16IconBoldText = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: kcIconColor,
);

TextStyle kts18Text = TextStyle(
  fontSize: 18.sp,
  color: kcFontColor,
);

TextStyle kts18BoldText = TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w600,
  color: kcFontColor,
);

TextStyle kts18ErrorEmptyText = TextStyle(
  fontSize: 18.sp,
  color: kcErrorEmptyColor,
);

TextStyle kts18NotificationText = TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w600,
  color: kcGreenColor,
);

TextStyle kts18DarkText = TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w600,
  color: kcSecondaryDarkColor,
);

TextStyle ktsDefault18HelperText = TextStyle(
  fontSize: 18.sp,
  color: kcHelperColor,
);

TextStyle ktsButtonWhite18Text = TextStyle(
  color: kcWhiteColor,
  fontSize: 18.sp,
);

TextStyle ktsButton18ContactText = TextStyle(
  color: kcContactColor,
  fontSize: 18.sp,
);

TextStyle kts24CreditCardNumberText = TextStyle(
  fontSize: 24.sp,
  fontWeight: FontWeight.w600,
  color: kcCreditCardNumberColor,
);

TextStyle kts20Text = TextStyle(
  fontSize: 20.sp,
  color: kcFontColor,
);

TextStyle kts20BoldText = TextStyle(
  fontSize: 20.sp,
  fontWeight: FontWeight.w600,
  color: kcFontColor,
);

TextStyle ktsButtonText = TextStyle(
  color: kcWhiteColor,
  fontSize: 20.sp,
);

TextStyle kts20DarkText = TextStyle(
  fontSize: 20.sp,
  fontWeight: FontWeight.w600,
  color: kcSecondaryDarkColor,
);

TextStyle kts22DarkText = TextStyle(
  fontSize: 22.sp,
  fontWeight: FontWeight.w600,
  color: kcSecondaryDarkColor,
);

TextStyle kts22Text = TextStyle(
  fontSize: 22.sp,
  fontWeight: FontWeight.w500,
  color: kcFontColor,
);

TextStyle ktsDefault22BoldText = TextStyle(
  fontSize: 22.sp,
  fontWeight: FontWeight.w600,
  color: kcFontColor,
);

TextStyle kts22PrimaryText = TextStyle(
  fontSize: 22.sp,
  color: kcPrimaryColor,
);

TextStyle kts22BoldWhiteText = TextStyle(
  fontSize: 22.sp,
  fontWeight: FontWeight.w600,
  color: kcWhiteColor,
);

TextStyle ktsDefault24DarkText = TextStyle(
  fontSize: 24.sp,
  fontWeight: FontWeight.w600,
  color: kcSecondaryDarkColor,
);

TextStyle kts28DarkBoldText = TextStyle(
  fontSize: 28.sp,
  fontWeight: FontWeight.bold,
  color: kcSecondaryDarkColor,
);

TextStyle kts30DarkText = TextStyle(
  fontSize: 30.sp,
  fontWeight: FontWeight.w600,
  color: kcSecondaryDarkColor,
);

TextStyle kts30DarkBoldText = TextStyle(
  fontSize: 30.sp,
  fontWeight: FontWeight.bold,
  color: kcSecondaryDarkColor,
);
