import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../shared/shared.dart';
import '../../../widgets/widgets.dart';
import '../../../../utils/util_functions.dart';
import 'res_bottom_cart_total_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../generated/locale_keys.g.dart';

class ResBottomCartTotalView extends StatelessWidget {
  const ResBottomCartTotalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResBottomCartTotalViewModel>.reactive(
      builder: (context, model, child) => model.isUpdateQuantity
          ? ButtonLoading()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.order, style: ktsButtonWhite18Text).tr(),
                Text(
                  '${formatNum(model.getTotalCartSum)} TMT',
                  style: ktsButtonWhite18Text,
                ),
              ],
            ),
      viewModelBuilder: () => ResBottomCartTotalViewModel(),
    );
  }
}
