import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

import 'search.dart';

class HeaderSearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 15.w, right: 5.w),
        margin: EdgeInsets.only(right: 10.w),
        // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        // margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        // height: 40.h,

        decoration: BoxDecoration(
          borderRadius: AppTheme().radius20,
          color: Theme.of(context).cardColor,
          boxShadow: [AppTheme().searchShadow],
        ),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.1),
        //       blurRadius: 3.0,
        //     ),
        //   ],
        //   borderRadius: BorderRadius.circular(15.0),
        //   border: Border.all(
        //     width: 1.0,
        //     color: Colors.black.withOpacity(0.05),
        //   ),
        // ),
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
              Text('Gözleg'),
              const Icon(
                Icons.search,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
