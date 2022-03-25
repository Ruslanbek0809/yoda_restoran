import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../utils/utils.dart';

import 'addresses_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressesView extends StatelessWidget {
  const AddressesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressesViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navToHomeByRemovingAll(); // Workaround
          return false;
        },
        child: Scaffold(
          backgroundColor: kcSecondaryLightColor,
          appBar: AppBar(
            backgroundColor: kcWhiteColor,
            elevation: 0.5,
            leadingWidth: 35.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppTheme.FONT_COLOR,
                  size: 25.w,
                ),
                onPressed: model.navToHomeByRemovingAll,
              ),
            ),
            centerTitle: true,
            title: Text(
              LocaleKeys.addresses,
              style: kts22DarkText,
            ).tr(),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: kcSecondaryDarkColor,
                  size: 25.w,
                ),
                onPressed: model.navToAddEditAddressView,
              ),
            ],
          ),
          body: model.isBusy
              ? LoadingWidget()
              : model.addresses!.isEmpty
                  ? EmptyWidget(
                      text: LocaleKeys.noAddressesYet,
                      svg: 'assets/empty_addresses.svg',
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: model.addresses!.length,
                        itemBuilder: (context, pos) {
                          return Container(
                            decoration: BoxDecoration(
                              color: kcWhiteColor,
                              borderRadius: AppTheme().radius10,
                            ),
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            padding: EdgeInsets.fromLTRB(12.w, 10.h, 7.w, 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Text(
                                    model.addresses![pos].street! +
                                        (model.addresses![pos].house != null
                                            ? ', ${model.addresses![pos].house}'
                                            : ''),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: ktsDefault16Text,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomIconTextButton(
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: kcSecondaryDarkColor,
                                        ),
                                        text: Text(
                                          'Üýtget',
                                          style: kts16DarkText,
                                        ),
                                        backgroundColor: kcSecondaryLightColor,
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: CustomIconTextButton(
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          color: kcSecondaryDarkColor,
                                        ),
                                        text: Text(
                                          'Poz',
                                          style: kts16DarkText,
                                        ),
                                        backgroundColor: kcSecondaryLightColor,
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: CustomIconTextButton(
                                        icon: Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: kcSecondaryDarkColor,
                                        ),
                                        text: Text(
                                          'Saýla',
                                          style: kts16DarkText,
                                        ),
                                        backgroundColor: kcSecondaryLightColor,
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
      viewModelBuilder: () => AddressesViewModel(),
    );
  }
}
