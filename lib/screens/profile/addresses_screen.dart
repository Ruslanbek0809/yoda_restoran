import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

class AddressesScreen extends StatefulWidget {
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen>
    with SingleTickerProviderStateMixin {
  int selectedAddressID = -1;
  List<Address> addresses = [
    Address(1, 'A.Nowaýy, 164'),
    Address(2, 'N.Andalyp 32'),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacementNamed(context, RouteList.home);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.WHITE,
          elevation: 1,
          leadingWidth: 35.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppTheme.FONT_COLOR,
                size: 25,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Salgylar',
            style: TextStyle(
              color: AppTheme.MAIN_DARK,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: addresses
                          .map(
                            (address) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address.name,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                  SizedBox(height: 10.w),
                                  Divider(color: AppTheme.DRAWER_DIVIDER)
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Material(
                    color: AppTheme.WHITE,
                    child: InkWell(
                      onTap: () async => await Navigator.pushNamed(
                          context, RouteList.addressAddEdit),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        child: Text(
                          'Täze salgy goş...',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppTheme.FONT_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Divider(color: AppTheme.DRAWER_DIVIDER)
                ],
              ),
            ),
            //--------------- FILTER BUTTONS -------------- //
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppTheme.WHITE,
                padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 50.w),
                child: Column(
                  children: [
                    TextButton(
                      child: Text(
                        'Salgyny aýyr',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppTheme.FONT_COLOR,
                        ),
                      ),
                      onPressed: () async =>
                          await Navigator.pushReplacementNamed(
                              context, RouteList.home),
                    ),
                    SizedBox(height: 15.w),
                    SizedBox(
                      width: 1.sw,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.MAIN,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: AppTheme().containerRadius),
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                        ),
                        child: Text(
                          'Salgyny goş',
                          style: TextStyle(
                            color: AppTheme.WHITE,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => Navigator.of(context)
                            .popAndPushNamed(RouteList.home),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
