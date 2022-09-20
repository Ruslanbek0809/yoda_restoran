import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'my_credit_cards_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class MyCreditCardsView extends StatelessWidget {
  const MyCreditCardsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreditCardsViewModel>.reactive(
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
                LocaleKeys.my_credit_cards,
                style: kts22DarkText,
              ).tr(),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.add_rounded,
                    color: kcSecondaryDarkColor,
                    size: 25.w,
                  ),
                  onPressed: model.navToMyCreditCardAddView,
                ),
              ],
            ),
            body: EmptyWidget(
              text: LocaleKeys.noCreditCardsYet,
              svg: 'assets/credit_card_empty.svg',
            )
            // model.isBusy
            //     ? LoadingWidget()
            //     : model.addresses!.isEmpty
            //         ? EmptyWidget(
            //             text: LocaleKeys.noAddressesYet,
            //             svg: 'assets/empty_addresses.svg',
            //           )
            //         : Padding(
            //             padding: EdgeInsets.only(left: 10.w, top: 5.h),
            //             child: ListView.separated(
            //               physics: BouncingScrollPhysics(),
            //               itemCount: model.addresses!.length,
            //               itemBuilder: (context, pos) {
            //                 return GestureDetector(
            //                   onTap: () => model.navToAddressEditView(
            //                       model.addresses![pos], model),
            //                   child: Slidable(
            //                     // Specify a key if the Slidable is dismissible.
            //                     key: ValueKey(model.addresses![pos].id),

            //                     // // The start action pane is the one at the left or the top side.
            //                     // startActionPane: ActionPane(
            //                     //   dragDismissible: false,
            //                     //   extentRatio: 0.25,
            //                     //   // A motion is a widget used to control how the pane animates.
            //                     //   motion: const ScrollMotion(),

            //                     //   // // A pane can dismiss the Slidable.
            //                     //   // dismissible: DismissiblePane(onDismissed: () {}),

            //                     //   // All actions are defined in the children parameter.
            //                     //   children: [
            //                     //     // A SlidableAction can have an icon and/or a label.
            //                     //     SlidableAction(
            //                     //       onPressed: (BuildContext context) async =>
            //                     //           await model.showAddressRemoveDialog(
            //                     //               model, model.addresses![pos]),
            //                     //       backgroundColor: kcRedColor,
            //                     //       foregroundColor: kcWhiteColor,
            //                     //       icon: Icons.delete_outline_rounded,
            //                     //     ),
            //                     //   ],
            //                     // ),

            //                     endActionPane: ActionPane(
            //                       dragDismissible: false,
            //                       extentRatio: 0.25,
            //                       // A motion is a widget used to control how the pane animates.
            //                       motion: const ScrollMotion(),

            //                       // // A pane can dismiss the Slidable.
            //                       // dismissible: DismissiblePane(onDismissed: () {}),

            //                       // All actions are defined in the children parameter.
            //                       children: [
            //                         // A CustomSlidableAction can have an icon and/or a label.
            //                         CustomSlidableAction(
            //                           onPressed: (BuildContext context) async =>
            //                               await model.showAddressRemoveDialog(
            //                                   model, model.addresses![pos]),
            //                           backgroundColor: kcRedColor,
            //                           child: SvgPicture.asset(
            //                             'assets/trash.svg',
            //                             color: kcWhiteColor,
            //                             width: 24.sp,
            //                           ),
            //                         ),
            //                       ],
            //                     ),

            //                     // The child of the Slidable is what the user sees when the
            //                     // component is not dragged.
            //                     child: Padding(
            //                       padding: EdgeInsets.fromLTRB(
            //                         6.w,
            //                         pos == 0 ? 10.h : 15.h,
            //                         16.w,
            //                         15.h,
            //                       ),
            //                       child: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Flexible(
            //                             child: Text(
            //                               model.addresses![pos].street! +
            //                                   (model.addresses![pos].house != null
            //                                       ? ', ${model.addresses![pos].house}'
            //                                       : ''),
            //                               maxLines: 1,
            //                               overflow: TextOverflow.ellipsis,
            //                               style: kts18Text,
            //                             ),
            //                           ),
            //                           SizedBox(width: 5.w),
            //                           Icon(
            //                             Icons.arrow_forward_ios_rounded,
            //                             color: kcSecondaryDarkColor,
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               },
            //               separatorBuilder: (context, index) {
            //                 return Container(
            //                   margin: EdgeInsets.only(left: 6.w),
            //                   color: kcDividerColor,
            //                   height: 0.5.h,
            //                 );
            //               },
            //             ),
            //           ),
            ),
      ),
      viewModelBuilder: () => CreditCardsViewModel(),
    );
  }
}
