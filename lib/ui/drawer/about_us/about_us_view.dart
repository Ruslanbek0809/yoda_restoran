import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'about_us_view_model.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AboutUsViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navToHomeByRemovingAll(); // Workaround
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kcWhiteColor,
            elevation: 0.5,
            leadingWidth: 35.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: kcFontColor,
                  size: 25.w,
                ),
                onPressed: model.navToHomeByRemovingAll,
              ),
            ),
            centerTitle: true,
            title: Text(
              model.isAboutUsTermSelected
                  ? LocaleKeys.about_us_terms_of_use
                  : LocaleKeys.about_us,
              style: kts22DarkText,
            ).tr(),
          ),
          body: model.isBusy
              ? LoadingWidget()
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (model.isAboutUsTermSelected &&
                            model.additionals.isNotEmpty)
                          Html(
                            data: model.additionals[0].info,
                            style: {
                              "body": Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                              ), // GENERAL BODY
                              "p": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ), // NORMAL
                              "pre": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ), // FORMATTED
                              "h1": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ),
                              "h2": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ),
                              "h3": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ),
                              "h4": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ),
                            },
                            onLinkTap: (url, _, __) async {
                              final Uri launchUri = Uri(
                                scheme: 'https',
                                path: url,
                              );
                              await launchUrl(launchUri);
                            },
                            onCssParseError: (css, messages) {
                              print("css that errored: $css");
                              print("error messages:");
                              messages.forEach((element) {
                                print(element);
                              });
                              return null;
                            },
                          ),
                        if (!model.isAboutUsTermSelected &&
                            model.additionals.isNotEmpty)
                          Html(
                            data: model.additionals[1].info,
                            style: {
                              "body": Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                              ), // GENERAL BODY
                              "p": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ), // NORMAL
                              "pre": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ), // FORMATTED
                              "h1": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ),
                              "h2": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ),
                              "h3": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ),
                              "h4": Style(
                                margin: Margins(
                                  left: Margin(16.w),
                                  right: Margin(16.w),
                                  bottom: Margin(10.h),
                                ),
                                padding: HtmlPaddings.zero,
                              ),
                            },
                            onLinkTap: (url, _, __) async {
                              final Uri launchUri = Uri(
                                scheme: 'https',
                                path: url,
                              );
                              await launchUrl(launchUri);
                            },
                            onCssParseError: (css, messages) {
                              print("css that errored: $css");
                              print("error messages:");
                              messages.forEach((element) {
                                print(element);
                              });
                              return null;
                            },
                          ),
                        if (!model.isAboutUsTermSelected)
                          Padding(
                            padding: EdgeInsets.only(left: 24.w, top: 24.h),
                            child: Divider(color: kcDividerColor),
                          ),
                        if (!model.isAboutUsTermSelected)
                          InkWell(
                            onTap: () => model.updateIsAboutUsTermSelected(),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 24.w,
                                top: 10.h,
                                bottom: 10.h,
                                right: 16.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.about_us_terms_of_use,
                                    style: kts16IconBoldText,
                                  ).tr(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 20.sp,
                                    color: kcIconColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!model.isAboutUsTermSelected)
                          Padding(
                            padding: EdgeInsets.only(left: 24.w),
                            child: Divider(color: kcDividerColor),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      viewModelBuilder: () => AboutUsViewModel(),
    );
  }
}
