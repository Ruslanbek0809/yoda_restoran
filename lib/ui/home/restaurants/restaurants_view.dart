import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../main_category/main_cats_view.dart';
import 'restaurants_bottom_cart.dart';
import 'restaurants_view_model.dart';

class RestaurantsView extends StatelessWidget {
  const RestaurantsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestauranstViewModel>.reactive(
      viewModelBuilder: () => RestauranstViewModel(),
      builder: (context, model, child) {
        //* SHOWS custom ERROR snackbar when there is FILTER ERROR
        if (model.fetchingFilterError && model.cartRes!.id != -1)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            model.disableActiveFilterErrorFromView();
            await model.showCustomFlashBar(
              context: context,
              isCartEmpty: false,
            );
          });
        //* SHOWS custom ERROR snackbar when there is FILTER ERROR
        else if (model.fetchingFilterError)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            model.disableActiveFilterErrorFromView();
            await model.showCustomFlashBar(context: context);
          });

        return Scaffold(
          appBar: AppBar(
            backgroundColor: kcWhiteColor,
            elevation: 0.5,
            leading: CustomBackButtonWidget(),
            centerTitle: true,
            title: Text(
              LocaleKeys.restaurants,
              style: kts22DarkText,
            ).tr(),
          ),
          body: model.isBusy || model.fetchingFilter
              ? LoadingWidget()
              : model.hasError
                  ? ViewErrorWidget(
                      modelCallBack: () async => await model.initialise(),
                    )
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              //*----------------- MAIN CATEGORIES ---------------------//
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.r),
                                child: MainCatsView(),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.r, vertical: 6.r),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),

                              //*----------------- FILTER/MAINCAT is APPLIED ---------------------//
                              if (model.isFilterApplied)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 4.r,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocaleKeys.foundRestaurants,
                                        overflow: TextOverflow.ellipsis,
                                        style: kts18BoldText,
                                      ).tr(args: [
                                        model.selectedMainCatRestaurants.length
                                            .toString()
                                      ]),
                                      SizedBox(width: 5.r),
                                      CustomTextChildButton(
                                          child: Text(
                                            LocaleKeys.clear,
                                            style: kts16Text,
                                          ).tr(),
                                          color: kcSecondaryLightColor,
                                          borderRadius: AppTheme().radius20,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 6.r,
                                            horizontal: 20.r,
                                          ),
                                          onPressed: () async {
                                            await model
                                                .clearSelectedMainCatRess();
                                            await model.initialise();
                                          }),
                                    ],
                                  ),
                                ),
                              //*----------------- RESTAURANTS GRID ---------------------//
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.r,
                                  horizontal: 10.r,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10.r,
                                  crossAxisSpacing: 6.r,
                                  childAspectRatio: 0.77,
                                ),
                                itemCount: model.isFilterApplied
                                    ? model.selectedMainCatRestaurants.length
                                    : model.allPaginatedRestaurants.length,
                                itemBuilder: (context, pos) => GestureDetector(
                                  onTap: () => model.navToResDetailsView(
                                    model.isFilterApplied
                                        ? model.selectedMainCatRestaurants[pos]
                                        : model.allPaginatedRestaurants[pos],
                                  ),
                                  child: Column(
                                    children: [
                                      //*----------------- CIRCLE AVATAR RESTAURANT IMAGE ---------------------//
                                      CachedNetworkImage(
                                        imageUrl: model.isFilterApplied
                                            ? model
                                                    .selectedMainCatRestaurants[
                                                        pos]
                                                    .square_image ??
                                                'assets/ph_product.png'
                                            : model.allPaginatedRestaurants[pos]
                                                    .square_image ??
                                                'assets/ph_product.png',
                                        fit: BoxFit.cover,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          backgroundColor:
                                              kcDividerSecondaryColor,
                                          radius: 50.5,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: imageProvider,
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          backgroundColor:
                                              kcDividerSecondaryColor,
                                          radius: 50.5,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                              'assets/ph_product.png',
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          backgroundColor:
                                              kcDividerSecondaryColor,
                                          radius: 50.5,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                              'assets/ph_product.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      //*----------------- RESTAURANT NAME ---------------------//
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.r),
                                        child: Text(
                                          model.isFilterApplied
                                              ? model
                                                      .selectedMainCatRestaurants[
                                                          pos]
                                                      .name ??
                                                  ''
                                              : model
                                                      .allPaginatedRestaurants[
                                                          pos]
                                                      .name ??
                                                  '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: kts14Text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!model.hasError && model.cartRes!.id != -1)
                                SizedBox(
                                    height: 0.11
                                        .sh), //* COMPENSATES HomeBottomCart when cart is NOT EMPTY
                            ],
                          ),
                        ),

                        //*----------------- BOTTOM CART (if cart is NOT EMPTY) ---------------------//
                        if (!model.hasError && model.cartRes!.id != -1)
                          RestaurantsBottomCart()
                      ],
                    ),
        );
      },
    );
  }
}
