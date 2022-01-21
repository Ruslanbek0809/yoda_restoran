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
          appBar: AppBar(
              backgroundColor: AppTheme.WHITE,
              elevation: 1,
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
                style: ktsDefault22DarkText,
              ).tr()),
          body: model.isBusy
              ? LoadingWidget()
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (model.addresses!.isNotEmpty)
                          Column(
                            children: model.addresses!
                                .map(
                                  (address) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address.street! +
                                              (address.house != null
                                                  ? ', ${address.house}'
                                                  : ''),
                                          style: kts18Text,
                                        ),
                                        SizedBox(height: 10.h),
                                        Divider(color: kcDividerColor)
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        Material(
                          color: AppTheme.WHITE,
                          child: InkWell(
                            onTap: model.navToAddEditAddressView,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.w, 5.h, 0.5.sw, 5.h),
                              child: Text(
                                LocaleKeys.addNewAddress,
                                style: kts18Text,
                              ).tr(),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Divider(color: kcDividerColor),
                        if (model.addresses!.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 0.2.sh),
                            child: EmptyWidget(
                              text: LocaleKeys.noAddressesYet,
                              svg: 'assets/empty_addresses.svg',
                            ),
                          )
                      ],
                    ),
                  ),
                ),
        ),
      ),
      viewModelBuilder: () => AddressesViewModel(),
    );
  }
}
