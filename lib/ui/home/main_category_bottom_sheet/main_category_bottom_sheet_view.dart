import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/ui/home/main_category/main_category_view_model.dart';

import 'main_category_bottom_sheet.dart';

class MainCategoryBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const MainCategoryBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainCategoryViewModel>.nonReactive(
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        maxChildSize: 0.95,
        builder: (context, scrollController) =>
            MainCategoryBottomSheet(scrollController: scrollController),
      ),
      viewModelBuilder: () => MainCategoryViewModel(),
    );
  }
}
