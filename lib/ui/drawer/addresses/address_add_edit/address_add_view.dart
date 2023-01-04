import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/shared.dart';
import '../../../widgets/widgets.dart';
import '../../../../utils/utils.dart';
import 'address_add_hook.dart';
import 'address_add_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressAddView extends StatelessWidget {
  AddressAddView({Key? key}) : super(key: key);

  final GlobalKey<FormState> _addEditAddressformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressAddViewModel>.reactive(
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
                Icons.arrow_back_rounded,
                color: kcFontColor,
                size: 25.w,
              ),
              onPressed: model.navBackWithFalse,
            ),
          ),
          centerTitle: true,
          title: Text(LocaleKeys.address, style: kts22DarkText).tr(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              children: [
                Form(
                  key: _addEditAddressformKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: AddressAddHook(),
                ),

                //*ADDRESS ADD BUTTON
                Container(
                  color: kcWhiteColor,
                  padding: EdgeInsets.fromLTRB(30.w, 75.h, 30.w, 50.h),
                  child: SizedBox(
                    width: 1.sw,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kcPrimaryColor,
                        primary: kcSecondaryLightColor, // ripple effect color
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: AppTheme().radius10),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: model.isBusy
                          ? ButtonLoading()
                          : Text(
                              LocaleKeys.addNewAddressButton,
                              style: ktsButtonWhite18Text,
                            ).tr(),
                      onPressed: () async {
                        FocusScope.of(context)
                            .unfocus(); // UNFOCUSES all textfield b4 data fetch
                        if (!_addEditAddressformKey.currentState!.validate())
                          return;
                        _addEditAddressformKey.currentState!.save();
                        await model.onAddAddressPressed(
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
      viewModelBuilder: () => AddressAddViewModel(),
    );
  }
}
