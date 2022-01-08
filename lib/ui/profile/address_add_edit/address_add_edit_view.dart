import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/profile/address_add_edit/add_edit_address_hook.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'address_add_edit_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressAddEditView extends StatelessWidget {
  final GlobalKey<FormState> _addEditAddressformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressAddEditViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navBack(); // Workaround
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MyAppbar(
            child: AppBar(
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
                  onPressed: model.navBack,
                ),
              ),
              centerTitle: true,
              title: Text('Salgy', style: ktsDefault22BoldText),
            ),
          ),
          body: Stack(
            children: [
              //--------------- ADD/EDIT FORM HOOK -------------- //
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _addEditAddressformKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: AddEditAddressHook(),
                    ),
                  ],
                ),
              ),
              //--------------- ADDRESS BUTTONS -------------- //
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppTheme.WHITE,
                  padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 50.h),
                  child: Column(
                    children: [
                      TextButton(
                        child: Text(
                          'Salgyny aýyr',
                          style: ktsDefault18Text,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        width: 1.sw,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppTheme.MAIN,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppTheme().radius10),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: model.isBusy
                              ? ButtonLoading()
                              : Text(
                                  'Salgyny goş',
                                  style: ktsButton18Text,
                                ),
                          onPressed: () async {
                            FocusScope.of(context)
                                .unfocus(); // UNFOCUSES all textfield b4 data fetch
                            if (!_addEditAddressformKey.currentState!
                                .validate()) return;
                            _addEditAddressformKey.currentState!.save();
                            await model.onAddAddressPressed();
                            model.navBack();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => AddressAddEditViewModel(),
    );
  }
}
