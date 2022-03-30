import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../../models/models.dart';
import '../../../../utils/utils.dart';
import '../addresses.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressEditView extends StatelessWidget {
  final Address address;
  final AddressesViewModel addressesViewModel;
  AddressEditView(
      {required this.address, required this.addressesViewModel, Key? key})
      : super(key: key);

  final GlobalKey<FormState> _addEditAddressformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressEditViewModel>.reactive(
      onModelReady: (model) => model.setInitialAddress(),
      viewModelBuilder: () => AddressEditViewModel(
        address: address,
        addressesViewModel: addressesViewModel,
      ),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: kcWhiteColor,
          elevation: 0.5,
          leadingWidth: 35.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: kcFontColor,
                size: 25.w,
              ),
              onPressed: model.navBackWithFalse,
            ),
          ),
          centerTitle: true,
          title: Text(LocaleKeys.address, style: kts22DarkText).tr(),
          actions: [
            IconButton(
              onPressed: () async => await model.showAddressRemoveDialog(
                addressesViewModel,
                address,
              ),
              icon: SvgPicture.asset(
                'assets/trash.svg',
                color: kcSecondaryDarkColor,
                width: 25.w,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              children: [
                Form(
                  key: _addEditAddressformKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: AddressEditHook(),
                ),

                /// ADDRESS ADD BUTTON
                Container(
                  color: kcWhiteColor,
                  padding: EdgeInsets.fromLTRB(30.w, 75.h, 30.w, 50.h),
                  child: SizedBox(
                    width: 1.sw,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kcPrimaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: AppTheme().radius10),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: model.isBusy
                          ? ButtonLoading()
                          : Text(
                              LocaleKeys.save,
                              style: ktsButton18Text,
                            ).tr(),
                      onPressed: () async {
                        FocusScope.of(context)
                            .unfocus(); // UNFOCUSES all textfield b4 data fetch
                        if (!_addEditAddressformKey.currentState!.validate())
                          return;
                        _addEditAddressformKey.currentState!.save();
                        await model.onEditAddressPressed(
                          () => model.navBack(),
                          () => model.navBack(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
