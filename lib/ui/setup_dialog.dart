import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void setupDialog() {
  var dialogService = locator<DialogService>();

  final builders = {
    DialogType.basic: (context, sheetRequest, completer) =>
        _BasicDialog(request: sheetRequest, completer: completer),
    DialogType.cart: (context, sheetRequest, completer) =>
        MealDialog(request: sheetRequest, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class MealDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const MealDialog({Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        request.title!,
        style: TextStyle(
          color: AppTheme.FONT_COLOR,
          fontSize: 16.sp,
        ),
      ),
      content: Text(
        request.description!,
        style: TextStyle(
          color: AppTheme.FONT_COLOR,
          fontSize: 16.sp,
        ),
      ),
      actions: <Widget>[
        CustomTextButton(
          text: request.secondaryButtonTitle!,
          color: Colors.transparent,
          textStyle: TextStyle(
            color: AppTheme.FONT_COLOR,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        CustomTextButton(
          text: request.mainButtonTitle!,
          color: Colors.transparent,
          textStyle: TextStyle(
            color: AppTheme.FONT_COLOR,
            fontSize: 17.sp,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}

class _BasicDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const _BasicDialog({Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              request.title!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              request.description!,
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => completer(DialogResponse()),
              child: Container(
                child: request.showIconInMainButton!
                    ? Icon(Icons.check_circle)
                    : Text(request.mainButtonTitle!),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
