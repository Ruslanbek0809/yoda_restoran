import '../ui/drawer/addresses/addresses_view_model.dart';
import 'models.dart';

class AddressDialogData {
  AddressDialogData({
    this.addressesViewModel,
    this.address,
  });
  final AddressesViewModel? addressesViewModel;
  final Address? address;
}
