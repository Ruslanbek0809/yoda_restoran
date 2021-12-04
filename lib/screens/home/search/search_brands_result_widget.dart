import 'package:belent_online/routes/belent_navigate.dart';

import '../../../common/constants.dart';
import '../../../providers/providers.dart';
import '../../../widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home.dart';

class SearchBrandsResultWidget extends StatefulWidget {
  final String searchName;

  const SearchBrandsResultWidget({required this.searchName});

  @override
  _SearchBrandsResultWidgetState createState() =>
      _SearchBrandsResultWidgetState();
}

class _SearchBrandsResultWidgetState extends State<SearchBrandsResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (_, model, __) {
        final _brands = model.brands;

        if (_brands == null) {
          return LoadingWidget();
        }

        if (_brands.isEmpty) {
          return ErrorEmptyWidgett(onTap: () {}, show: false, isEmpty: true);
        }
        return GridView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
              vertical: getDeviceType() == MyConstants.PHONE ? 15.w : 7.w,
              horizontal: getDeviceType() == MyConstants.PHONE ? 5.w : 3.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getDeviceType() == MyConstants.PHONE ? 2 : 4,
            mainAxisSpacing: 5.0, //spaceTopBottom
            crossAxisSpacing: 5.0, //spaceLeftRight
          ),
          itemCount: _brands.length,
          itemBuilder: (context, pos) {
            return BrandEachWidget(
              brandModel: _brands[pos],
              margin: getDeviceType() == MyConstants.PHONE ? 5.w : 2.w,
              radius: 14.0,
              onTap: () {
                // BrandProductListScreen
                BelentNavigate.push(MaterialPageRoute(
                  builder: (context) => BrandProductListScreen(
                    brandID: _brands[pos].id,
                    brandName: _brands[pos].name,
                  ),
                ));
              },
            );
          },
        );
      },
    );
  }
}
