import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';
import 'search.dart';

class HeaderSearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
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
                builder: (context) => SearchScreen(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Gözleg',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.FONT_GREY_COLOR,
                ),
              ),
              Icon(
                CupertinoIcons.search,
                size: 22.w,
                color: AppTheme.FONT_COLOR,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
