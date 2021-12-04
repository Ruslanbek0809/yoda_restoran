import '../../../common/constants.dart';
import '../../../common/utils.dart';
import '../../../providers/providers.dart';
import '../../../widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentSearchesWidget extends StatelessWidget {
  final Function? onTap;
  final bool isBrand;

  RecentSearchesWidget({this.onTap, this.isBrand = false});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final widthContent = (screenSize.width / 2) - 4;
    final currentLang = Provider.of<LangProvider>(context).currentLang;

    return Consumer<SearchProvider>(
      builder: (context, searchPvd, child) {
        return (searchPvd.keywords.isEmpty)
            ? renderEmpty(context, currentLang)
            : renderKeywords(searchPvd, widthContent, context, currentLang);
      },
    );
  }

  Widget renderEmpty(context, String currentLang) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10),
        ErrorEmptyWidgett(
          onTap: () {},
          isEmpty: true,
          show: false,
        ),
        SizedBox(height: 15.w),
        Text(
          i18n(currentLang,
              isBrand ? ki18nSearchForBrands : ki18nSearchForProducts)!,
          style: TextStyle(color: kGrey400, fontSize: 17.sp),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget renderKeywords(SearchProvider searchPvd, double widthContent,
      BuildContext context, String currentLang) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                i18n(currentLang, ki18nRecentSearches)!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (searchPvd.keywords.isNotEmpty)
                InkWell(
                  onTap: searchPvd.clearKeywords,
                  child: Text(
                    i18n(currentLang, ki18nClearCart)!,
                    style: const TextStyle(color: Colors.green, fontSize: 13),
                  ),
                )
            ],
          ),
        ),
        Card(
          elevation: 0,
          color: Theme.of(context).primaryColorLight,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: searchPvd.keywords
                .take(5)
                .map((e) => ListTile(
                      title: Text(e),
                      onTap: () {
                        onTap?.call(e);
                      },
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
