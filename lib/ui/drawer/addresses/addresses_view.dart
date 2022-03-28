import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
          // backgroundColor: kcSecondaryLightColor,
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
                onPressed: model.navToAddressAddView,
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
                      padding: EdgeInsets.only(left: 10.w, top: 5.h),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: model.addresses!.length,
                        itemBuilder: (context, pos) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: GestureDetector(
                              onTap: () => model
                                  .navToAddressEditView(model.addresses![pos]),
                              child: Slidable(
                                // Specify a key if the Slidable is dismissible.
                                key: ValueKey(model.addresses![pos].id),

                                // The start action pane is the one at the left or the top side.
                                startActionPane: ActionPane(
                                  dragDismissible: false,
                                  extentRatio: 0.25,
                                  // A motion is a widget used to control how the pane animates.
                                  motion: const ScrollMotion(),

                                  // // A pane can dismiss the Slidable.
                                  // dismissible: DismissiblePane(onDismissed: () {}),

                                  // All actions are defined in the children parameter.
                                  children: [
                                    // A SlidableAction can have an icon and/or a label.
                                    SlidableAction(
                                      onPressed: (BuildContext context) =>
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) =>
                                                  model.showAddressRemoveDialog(
                                                      model,
                                                      model.addresses![pos])),

                                      // async =>
                                      //     await model.showAddressRemoveDialog(
                                      //         model, model.addresses![pos]),
                                      backgroundColor: kcRedColor,
                                      foregroundColor: kcWhiteColor,
                                      icon: Icons.delete_outline_rounded,
                                    ),
                                  ],
                                ),

                                // The child of the Slidable is what the user sees when the
                                // component is not dragged.
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    6.w,
                                    pos == 0 ? 10.h : 15.h,
                                    16.w,
                                    15.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          model.addresses![pos].street! +
                                              (model.addresses![pos].house !=
                                                      null
                                                  ? ', ${model.addresses![pos].house}'
                                                  : ''),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kts18Text,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: kcSecondaryDarkColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(left: 6.w),
                            color: kcDividerColor,
                            height: 0.5.h,
                          );
                        },
                      ),
                    ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: 16.w, vertical: 10.h),
          //   child: ListView.builder(
          //     physics: BouncingScrollPhysics(),
          //     itemCount: model.addresses!.length,
          //     itemBuilder: (context, pos) {
          //       return Container(
          //         decoration: BoxDecoration(
          //           color: kcWhiteColor,
          //           borderRadius: AppTheme().radius10,
          //         ),
          //         margin: EdgeInsets.symmetric(vertical: 5.h),
          //         padding:
          //             EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Padding(
          //               padding: EdgeInsets.only(bottom: 12.h),
          //               child: Text(
          //                 model.addresses![pos].street! +
          //                     (model.addresses![pos].house != null
          //                         ? ', ${model.addresses![pos].house}'
          //                         : ''),
          //                 overflow: TextOverflow.ellipsis,
          //                 maxLines: 3,
          //                 style: ktsDefault16Text,
          //               ),
          //             ),
          //             Row(
          //               mainAxisAlignment:
          //                   MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Expanded(
          //                   child: CustomIconTextButton(
          //                     icon: Icon(
          //                       Icons.edit_outlined,
          //                       color: kcSecondaryDarkColor,
          //                     ),
          //                     text: Text(
          //                       'Üýtget',
          //                       style: kts16DarkText,
          //                     ),
          //                     backgroundColor: kcSecondaryLightColor,
          //                     onPressed: () {},
          //                   ),
          //                 ),
          //                 SizedBox(width: 10.w),
          //                 Expanded(
          //                   child: CustomIconTextButton(
          //                     icon: Icon(
          //                       Icons.delete_outline_rounded,
          //                       color: kcSecondaryDarkColor,
          //                     ),
          //                     text: Text(
          //                       'Poz',
          //                       style: kts16DarkText,
          //                     ),
          //                     backgroundColor: kcSecondaryLightColor,
          //                     onPressed: () async =>
          //                         await model.showAddressRemoveDialog(
          //                             model, model.addresses![pos]),
          //                   ),
          //                 ),
          //                 SizedBox(width: 10.w),
          //                 Expanded(
          //                   child: CustomIconTextButton(
          //                     icon: Icon(
          //                       Icons.check_circle_outline_rounded,
          //                       color: kcSecondaryDarkColor,
          //                     ),
          //                     text: Text(
          //                       'Saýla',
          //                       style: kts16DarkText,
          //                     ),
          //                     backgroundColor: kcSecondaryLightColor,
          //                     onPressed: () {},
          //                   ),
          //                 ),
          //               ],
          //             )
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ),
      ),
      viewModelBuilder: () => AddressesViewModel(),
    );
  }
}
