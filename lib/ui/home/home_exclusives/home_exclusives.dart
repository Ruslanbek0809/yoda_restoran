import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';

class HomeExclusives extends StatelessWidget {
  final List<ExclusiveSingle> exlusiveSingles;
  const HomeExclusives({Key? key, required this.exlusiveSingles})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: exlusiveSingles.mapIndexed((_exclusiveSingle, pos) {
          return Padding(
            padding: EdgeInsets.fromLTRB(pos == 0 ? 16.w : 4.w, 5.h,
                pos == exlusiveSingles.length - 1 ? 16.w : 4.w, 0.h),
            child: GestureDetector(
              onTap: () {},
              child: YodaImage(
                image: _exclusiveSingle.image!,
                fit: BoxFit.cover,
                width: 95.w,
                height: 95.w,
                borderRadius: Constants.BORDER_RADIUS_20,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
