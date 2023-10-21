import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../models/hive_models/hive_story.dart';
import '../../../../shared/shared.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import 'moments_all_bottom_cart.dart';
import 'moments_all_view_model.dart';

class MomentsAllView extends StatelessWidget {
  const MomentsAllView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MomentsAllViewModel>.reactive(
      viewModelBuilder: () => MomentsAllViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kcWhiteColor,
            elevation: 0.5,
            leading: CustomBackButtonWidget(),
            centerTitle: true,
            title: Text(
              LocaleKeys.moments,
              style: kts22DarkText,
            ).tr(),
          ),
          body: model.isBusy
              ? LoadingWidget()
              : model.hasError
                  ? ViewErrorWidget(
                      modelCallBack: () async => await model.initialise(),
                    )
                  : Stack(
                      children: [
                        Column(
                          children: [
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
                                  childAspectRatio: 0.76,
                                ),
                                itemCount: model.allMoments.length,
                                itemBuilder: (context, pos) => GestureDetector(
                                  onTap: () async {
                                    await model
                                        .addRestaurantStoriesToStoriesBox(
                                      model.allMoments[pos].stories != null &&
                                              model.allMoments[pos].stories!
                                                  .isNotEmpty
                                          ? model.allMoments[pos].stories!
                                          : [],
                                    );
                                    await model.navToMomentStoryView(
                                      model.allMoments[pos],
                                    );
                                  },
                                  child: ValueListenableBuilder<Box<HiveStory>>(
                                      valueListenable: Hive.box<HiveStory>(
                                              Constants.storiesBox)
                                          .listenable(),
                                      builder: (context, hiveStoriesBox, _) {
                                        var storyColor =
                                            kcDividerSecondaryColor;
                                        if (model.allMoments[pos].stories !=
                                                null &&
                                            model.allMoments[pos].stories!
                                                .isNotEmpty) {
                                          bool
                                              ishiveStoriesBoxContainsAllRestaurantStoriesIds =
                                              model.allMoments[pos].stories!
                                                  .every((story) =>
                                                      hiveStoriesBox
                                                          .containsKey(
                                                              story.id));
                                          if (!ishiveStoriesBoxContainsAllRestaurantStoriesIds) {
                                            storyColor = kcGreenColor;
                                          }
                                        }

                                        return Column(
                                          children: [
                                            //*----------------- CIRCLE AVATAR RESTAURANT IMAGE ---------------------//
                                            CachedNetworkImage(
                                              imageUrl: model.allMoments[pos]
                                                      .square_image ??
                                                  'assets/ph_product.png',
                                              fit: BoxFit.cover,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      CircleAvatar(
                                                backgroundColor: storyColor,
                                                radius: 54,
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage:
                                                      imageProvider,
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                backgroundColor: storyColor,
                                                radius: 54,
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: AssetImage(
                                                    'assets/ph_product.png',
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                backgroundColor: storyColor,
                                                radius: 54,
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
                                              padding:
                                                  EdgeInsets.only(top: 8.r),
                                              child: Text(
                                                'Restaurant Restaurant Restaurant',
                                                // model.allMoments[pos].name ??
                                                //     '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: kts14Text,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ),
                            if (!model.hasError && model.cartRes!.id != -1)
                              SizedBox(
                                  height: 0.11
                                      .sh), //* COMPENSATES MomentsAllBottomCart when cart is NOT EMPTY
                          ],
                        ),

                        //*----------------- BOTTOM CART (if cart is NOT EMPTY) ---------------------//
                        if (!model.hasError && model.cartRes!.id != -1)
                          MomentsAllBottomCart()
                      ],
                    ),
        );
      },
    );
  }
}
