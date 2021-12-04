import '../../../common/utils.dart';
import '../../../providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'search.dart';

class HeaderSearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentLang = Provider.of<LangProvider>(context).currentLang;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      width: 1.sw,
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3.0,
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 1.0,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(isBrandSearch: true),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(i18n(currentLang, ki18nSearchTitle)!),
            const Icon(Icons.search, size: 24),
          ],
        ),
      ),
    );
  }
}
