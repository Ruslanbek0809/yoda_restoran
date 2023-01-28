import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/widgets.dart';
import 'home_search_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeSearchHook extends HookViewModelWidget<HomeSearchViewModel> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget buildViewModelWidget(BuildContext context, HomeSearchViewModel model) {
    model.log.v('buildViewModelWidget CALLED');
    final _searchController = useTextEditingController(text: model.searchText);
    if ((model.searchText ?? '').isEmpty) _searchController.clear();

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      child: Scaffold(
        backgroundColor: kcWhiteColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: kcWhiteColor,
          elevation: 0.5,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: kcFontColor,
              size: 20.w,
            ),
            onPressed: model.navBack,
          ),
          //* =========== HomeSearchHook =========== //
          title: Container(
            decoration: BoxDecoration(
              color: kcWhiteColor,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            margin: EdgeInsets.symmetric(vertical: 5.h),
            child: TextField(
                controller: _searchController,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: kcSecondaryDarkColor,
                ),
                decoration: InputDecoration(
                  fillColor: kcWhiteColor,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: LocaleKeys.search.tr(),
                  hintStyle: kts14HelperText,
                ),
                autofocus: true,
                onChanged: (value) =>
                    _debouncer.run(() => model.startMainSearch(value)),
                onSubmitted: (value) =>
                    _debouncer.run(() => model.startMainSearch(value))),
          ),
          actions: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: (model.searchText ?? '').isEmpty
                  // model.searchController!.text.isEmpty
                  ? IconButton(
                      tooltip: 'Search',
                      // tooltip: i18n(currentLang, ki18nSearch),
                      icon: Icon(
                        Icons.search_rounded,
                        size: 22.w,
                        color: kcDividerColor,
                      ),
                      onPressed: () {},
                    )
                  : IconButton(
                      tooltip: 'Clear',
                      // tooltip: i18n(currentLang, ki18nClearCart),
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 22.w,
                        color: kcDividerColor,
                      ),
                      onPressed: () {
                        FocusScope.of(context)
                            .unfocus(); // UNFOCUSES all textfield b4 clear
                        model.clearSearch();
                      },
                    ),
            ),
          ],
        ),
        //*----------------- ListView builder ---------------------//
        body: model.isBusy
            ? LoadingWidget()
            : model.searchRestaurants.isEmpty || model.hasError
                ? Column(
                    mainAxisAlignment: model.searchMainCats!.isNotEmpty
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      if ((model.searchMainCats ?? []).isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          child: Wrap(
                            runSpacing: 8.0,
                            spacing: 10.0,
                            children:
                                model.searchMainCats!.map((_searchMainCat) {
                              return InkWell(
                                onTap: () {
                                  //* UPDATES current _searchController.text
                                  //* FIX link: https://stackoverflow.com/questions/51127241/how-do-you-change-the-value-inside-of-a-textfield-flutter
                                  _searchController.value =
                                      _searchController.value.copyWith(
                                    text: _searchMainCat.name ?? '',
                                    selection: TextSelection.collapsed(
                                      offset: _searchMainCat.name!.length,
                                    ),
                                  );
                                  model.startMainSearch(
                                      _searchMainCat.name ?? '');
                                },
                                borderRadius: kbr10,
                                child: Container(
                                  margin: EdgeInsets.only(top: 2.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    borderRadius: kbr10,
                                    color: kcSecondaryLightColor,
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      _searchMainCat.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: kts14Text,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      EmptyWidget(
                        text: '',
                        // text: LocaleKeys.nothingFound,
                        svg: 'assets/empty_search.svg',
                      ),

                      //*To make Empty in center
                      if ((model.searchMainCats ?? []).isNotEmpty) SizedBox(),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: 10.h),
                    itemCount: model.searchRestaurants.length,
                    itemBuilder: (ctx, pos) {
                      var _searchRestaurant = model.searchRestaurants[pos];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //*----------------- RESTAURANT PART ---------------------//
                            GestureDetector(
                              onTap: () => model.navToResDetailsView(Restaurant(
                                id: _searchRestaurant!.id,
                                image: _searchRestaurant.image,
                                name: _searchRestaurant.name,
                                address: _searchRestaurant.address,
                                rated: _searchRestaurant.rated,
                                rating: _searchRestaurant.rating,
                                workingHours: _searchRestaurant.workingHours,
                                deliveryPrice: _searchRestaurant.deliveryPrice,
                                description: _searchRestaurant.description,
                                phoneNumber: _searchRestaurant.phoneNumber,
                                prepareTime: _searchRestaurant.prepareTime,
                                city: _searchRestaurant.city,
                                distance: _searchRestaurant.distance,
                                selfPickUp: _searchRestaurant.selfPickUp,
                                delivery: _searchRestaurant.delivery,
                                paymentTypes: _searchRestaurant.paymentTypes,
                              )),
                              child: Row(
                                children: [
                                  //*----------------- IMAGE ---------------------//
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: YodaImage(
                                        image: _searchRestaurant?.image ??
                                            'assets/ph_restaurant.png',
                                        phImage: 'assets/ph_restaurant.png',
                                        height: 35.h,
                                        width: 35.h,
                                        borderRadius:
                                            Constants.BORDER_RADIUS_10,
                                      ),
                                    ),
                                  ),
                                  //*----------------- NAME and ADDRESS ---------------------//
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _searchRestaurant?.name ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w600,
                                            color: kcSecondaryDarkColor,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          _searchRestaurant?.address ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: kts14HelperText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //*----------------- RESTAURANT MEALS ---------------------//
                            if (_searchRestaurant?.meals != null)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                    top: 15.h, left: 24.w + 35.h),
                                itemCount: _searchRestaurant!.meals!
                                    .take(3)
                                    .toList()
                                    .length,
                                itemBuilder: (context, pos) {
                                  var _meal = _searchRestaurant.meals![pos];
                                  return GestureDetector(
                                    onTap: () =>
                                        model.navToResDetailsView(Restaurant(
                                      id: _searchRestaurant.id,
                                      image: _searchRestaurant.image,
                                      name: _searchRestaurant.name,
                                      address: _searchRestaurant.address,
                                      rated: _searchRestaurant.rated,
                                      rating: _searchRestaurant.rating,
                                      workingHours:
                                          _searchRestaurant.workingHours,
                                      deliveryPrice:
                                          _searchRestaurant.deliveryPrice,
                                      description:
                                          _searchRestaurant.description,
                                      phoneNumber:
                                          _searchRestaurant.phoneNumber,
                                      prepareTime:
                                          _searchRestaurant.prepareTime,
                                      city: _searchRestaurant.city,
                                      distance: _searchRestaurant.distance,
                                      selfPickUp: _searchRestaurant.selfPickUp,
                                      delivery: _searchRestaurant.delivery,
                                      paymentTypes:
                                          _searchRestaurant.paymentTypes,
                                    )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _meal.name ?? '',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: kcFontColor,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 16.w, left: 3.w),
                                          child: Text(
                                            _meal.discount != null ||
                                                    _meal.discount! > 0
                                                ? '${formatNum(_meal.discountedPrice!)} TMT'
                                                : '${formatNum(_meal.price!)} TMT',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kts16Text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                    child: Divider(
                                      thickness: 0.5,
                                      color: kcDividerSecondaryColor,
                                    ),
                                  );
                                },
                              ),
                            //*----------------- MEAL MORE ---------------------//
                            if (_searchRestaurant?.meals != null &&
                                (_searchRestaurant?.meals ?? []).length > 3)
                              GestureDetector(
                                onTap: () =>
                                    model.navToResDetailsView(Restaurant(
                                  id: _searchRestaurant?.id,
                                  image: _searchRestaurant?.image,
                                  name: _searchRestaurant?.name,
                                  address: _searchRestaurant?.address,
                                  rated: _searchRestaurant?.rated,
                                  rating: _searchRestaurant?.rating,
                                  workingHours: _searchRestaurant?.workingHours,
                                  deliveryPrice:
                                      _searchRestaurant?.deliveryPrice,
                                  description: _searchRestaurant?.description,
                                  phoneNumber: _searchRestaurant?.phoneNumber,
                                  prepareTime: _searchRestaurant?.prepareTime,
                                  city: _searchRestaurant?.city,
                                  distance: _searchRestaurant?.distance,
                                  selfPickUp: _searchRestaurant?.selfPickUp,
                                  delivery: _searchRestaurant?.delivery,
                                  paymentTypes: _searchRestaurant?.paymentTypes,
                                )),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 24.w + 35.h,
                                    top: 15.h,
                                    bottom: 5.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        LocaleKeys.more,
                                        style: ktsDefault18HelperText,
                                      ).tr(),
                                      Text(
                                        ((_searchRestaurant?.meals ?? [])
                                                    .length -
                                                3)
                                            .toString(),
                                        style: ktsDefault18HelperText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
