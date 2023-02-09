import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../main_category/main_cats_view.dart';
import 'restaurants_view_model.dart';

class RestaurantsView extends StatelessWidget {
  const RestaurantsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestauranstViewModel>.reactive(
      viewModelBuilder: () => RestauranstViewModel(),
      builder: (context, model, child) {
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
          body: model.isBusy
              ? LoadingWidget()
              : model.hasError
                  ? ViewErrorWidget(
                      modelCallBack: () async => await model.initialise(),
                    )
                  : Column(
                      children: [
                        //*----------------- MAIN CATEGORIES ---------------------//
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.r),
                          child: MainCatsView(),
                        ),
                        //*----------------- RESTAURANTS GRID ---------------------//
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.r,
                              horizontal: 10.r,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10.r,
                              crossAxisSpacing: 6.r,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: 10,
                            itemBuilder: (context, pos) => Column(
                              children: [
                                //*----------------- IMAGE with DISCOUNT(if needed) ---------------------//
                                YodaImage(
                                  image: 'assets/mock_restaurant.png',
                                  // image: meal.imageCard ?? 'assets/ph_product.png',
                                ),
                                //*----------------- IMAGE with DISCOUNT(if needed) ---------------------//
                                Padding(
                                  padding: EdgeInsets.only(top: 8.r),
                                  child: Text(
                                    'Overbrinks Oguzkent',
                                    // meal.name ?? '',
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
                      ],
                    ),
        );
      },
    );
  }
}
