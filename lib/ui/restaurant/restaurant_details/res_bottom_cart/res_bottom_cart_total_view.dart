import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/utils/util_functions.dart';
import 'res_bottom_cart_total_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';

class ResBottomCartTotalView extends StatelessWidget {
  const ResBottomCartTotalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResBottomCartTotalViewModel>.reactive(
      builder: (context, model, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(LocaleKeys.order, style: ktsButton18Text).tr(),
          Text(
            '${formatNum(model.getTotalCartSum)} TMT',
            style: ktsButton18Text,
          ),
        ],
      ),
      viewModelBuilder: () => ResBottomCartTotalViewModel(),
    );
  }
}
