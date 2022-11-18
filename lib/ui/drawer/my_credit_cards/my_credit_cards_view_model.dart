import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/hive_models/hive_models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class CreditCardsViewModel extends ReactiveViewModel {
//   final log = getLogger('CreditCardsViewModel');

//   final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();
//   final _dialogService = locator<DialogService>();

//   List<HiveCreditCard> get hiveCreditCards => _hiveDbService.hiveCreditCards;

// //------------------------ CREDIT CARD DELETE DIALOG ----------------------------//

//   /// SHOWS CREDIT CARD DELETE Dialog
//   Future showCreditCardDeleteDialog(HiveCreditCard hiveCreditCard) async {
//     log.i('showCreditCardDeleteDialog()');
//     DialogResponse<dynamic>? respData = await _dialogService.showCustomDialog(
//       variant: DialogType.creditCardDelete,
//       title: LocaleKeys.wanna_delete_credit_card,
//       mainButtonTitle: LocaleKeys.no,
//       secondaryButtonTitle: LocaleKeys.delete,
//       showIconInMainButton: false,
//       barrierDismissible: true,
//     );
//     if (respData != null && respData.data == true)
//       await _hiveDbService.deleteHiveCreditCard(hiveCreditCard);
//   }

// //------------------------ NAVIGATIONS ----------------------------//

//   /// NAVIGATES to MyCreditCardAddView
//   Future<void> navToMyCreditCardAddView({
//     required Function() onNewCreditCardAdded,
//   }) async {
//     dynamic _navResult;
//     _navResult =
//         await _navService.navigateTo(Routes.myCreditCardAddView) ?? false;
//     if (_navResult) await onNewCreditCardAdded(); // Workaround
//   }

//   /// NAVIGATES to Home by removing all previous routes
//   Future<void> navToHomeByRemovingAll() async =>
//       await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
