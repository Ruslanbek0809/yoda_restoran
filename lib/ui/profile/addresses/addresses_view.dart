import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../utils/utils.dart';

import 'addresses_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({Key? key}) : super(key: key);

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
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
              title: Text('Salgylar', style: ktsDefault22BoldText)),
          body: model.isBusy
              ? LoadingWidget()
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: model.addresses!
                              .map(
                                (address) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address.street! +
                                            (address.house != null
                                                ? ', ${address.house}'
                                                : ''),
                                        style: ktsDefault18Text,
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
                            onTap: () async => await Navigator.pushNamed(
                                context, RouteList.addressAddEdit),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Text(
                                'Täze salgy goş...',
                                style: ktsDefault18Text,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Divider(color: kcDividerColor)
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
