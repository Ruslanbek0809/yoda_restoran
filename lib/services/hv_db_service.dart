import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/hive_models/hive_models.dart';
import '../models/hive_models/hive_story.dart';
import '../models/models.dart';
import 'services.dart';
import '../utils/utils.dart';

//* 1 For Reactive Views
class HiveDbService with ListenableServiceMixin {
  final log = getLogger('HiveDbService');

  HiveDbService() {
    //* 3
    listenToReactiveValues([_cartMeals, _hiveRatings, _hiveCreditCards]);
  }

  final _bottomCartService = locator<BottomCartService>();

  static late Box<HiveRestaurant> cartResBox;
  static late Box<HiveMeal>
      cartMealsBox; // Also we don't need other 2 meal and res related boxes here
  static late Box<HiveRating> hiveRatingBox;
  static late Box<HiveCreditCard> hiveCreditCardsBox;
  static late Box<HiveStory> storiesBox;

  HiveRestaurant? cartRes;

  //* 2
  ReactiveValue<List<HiveMeal>> _cartMeals = ReactiveValue<List<HiveMeal>>([]);
  List<HiveMeal> get cartMeals => _cartMeals.value;

  ReactiveValue<List<HiveRating>> _hiveRatings =
      ReactiveValue<List<HiveRating>>([]);
  List<HiveRating> get hiveRatings => _hiveRatings.value;

  //* HIVE CREDIT CARDS
  final _hiveCreditCards = ReactiveValue<List<HiveCreditCard>>([]);
  List<HiveCreditCard> get hiveCreditCards => _hiveCreditCards.value;

  //* INITIALIZE in StartUpViewModel
  Future initHiveBoxes() async {
    log.v('====== HiveDbService STARTED opening boxes ======');

    await Hive.openBox<HiveUser>(Constants.userBox);
    await Hive.openBox<int>(
        Constants.favoritesBox); //* Without custom hive object
    await Hive.openBox<HiveStory>(Constants.storiesBox);
    await Hive.openBox<HiveRestaurant>(Constants.cartResBox);
    await Hive.openBox<HiveResPaymentType>(Constants.resPaymentTypeBox);
    await Hive.openBox<HiveMeal>(Constants.cartMealsBox);
    await Hive.openBox<HiveVolCus>(Constants.volCartBox);
    await Hive.openBox<HiveRating>(Constants.hiveRatingBox);
    await Hive.openBox<HiveCreditCard>(Constants.creditCardsBox);

    log.v('====== HiveDbService ENDED opening boxes ======');
  }

  //* GETS CART restaurant from cartResBox
  void getCartRes() {
    cartResBox = Hive.box<HiveRestaurant>(Constants.cartResBox);

    cartRes = cartResBox.get('cartRes',
        defaultValue: HiveRestaurant(id: -1, name: 'Default'));
    log.v('cartRes ${cartRes!.id}');
  }

  Future<void> cleanStoriesBasedOnDeadlines() async {
    storiesBox = Hive.box<HiveStory>(Constants.storiesBox);
    final currentTime = DateTime.now();

    for (var storyKey in storiesBox.keys) {
      final hiveStory = storiesBox.get(storyKey);
      if (hiveStory != null) {
        if (hiveStory.deadline!.isBefore(currentTime)) {
          await storiesBox.delete(storyKey);
          log.v('hive story with key: ${hiveStory.id} deleted');
        }
      }
    }
  }

  //* GETS all CART meals from cartMealsBox
  void getCartMeals() {
    cartMealsBox = Hive.box<HiveMeal>(Constants.cartMealsBox);
    _cartMeals.value = cartMealsBox.values.toList();
    if (_cartMeals.value.isNotEmpty)
      _bottomCartService.showBottomCart(); //* INITIALIZES BottomCart.

    log.v('_cartMeals.value length: ${_cartMeals.value.length}');
  }

  //* GETS all hive ratings from hiveRatingBox
  void getHiveRatings() {
    hiveRatingBox = Hive.box<HiveRating>(Constants.hiveRatingBox);
    _hiveRatings.value = hiveRatingBox.values.toList();

    log.v('_hiveRatings.value length: ${_hiveRatings.value.length}');
  }

  //* GETS hive credit cards from hiveCreditCardsBox
  void getHiveCreditCards() {
    hiveCreditCardsBox = Hive.box<HiveCreditCard>(Constants.creditCardsBox);
    _hiveCreditCards.value = hiveCreditCardsBox.values.toList();

    log.v('_hiveCreditCards.value length: ${_hiveCreditCards.value.length}');
  }

//* ------------------ RESTAURANT PART ---------------------//

  //* UPDATES a restaurant in CART
  Future<void> updateResInCart(Restaurant? restaurant) async {
    log.i(
      'updateResInCart() resId: ${restaurant!.id}, restaurant.paymentTypes: ${restaurant.paymentTypes}',
    );

    try {
      List<HiveResPaymentType> _hiveResPaymentTypes = [];

      //* Adds all payment types of a restaurant to _hiveResPaymentTypes and ASSIGNS it to hive res
      for (PaymentType paymentType in restaurant.paymentTypes!)
        _hiveResPaymentTypes.add(
          HiveResPaymentType(
            id: paymentType.id,
            nameTk: paymentType.nameTk,
            nameRu: paymentType.nameRu,
          ),
        );

      log.i(
          '_hiveResPaymentTypes length BEFORE updateResInCart: ${_hiveResPaymentTypes.length}');

      final HiveRestaurant _restaurant = HiveRestaurant(
        id: restaurant.id,
        image: restaurant.image,
        name: restaurant.name,
        description: restaurant.description,
        rated: restaurant.rated,
        rating: restaurant.rating,
        notification: restaurant.notification,
        workingHours: restaurant.workingHours,
        prepareTime: restaurant.prepareTime,
        phoneNumber: restaurant.phoneNumber,
        address: restaurant.address,
        deliveryPrice: restaurant.deliveryPrice,
        city: restaurant.city,
        distance: restaurant.distance,
        selfPickUp: restaurant.selfPickUp,
        delivery: restaurant.delivery,
        resPaymentTypes: _hiveResPaymentTypes,
        disabled: restaurant.disabled,
      );

      await cartResBox.put('cartRes', _restaurant);
      cartRes = cartResBox.get('cartRes',
          defaultValue: HiveRestaurant(id: -1, name: 'Default'));

      log.v('cartResId ${cartRes!.id}');
    } catch (e) {
      log.v('Couldn\'t UPDATE a restaurant in CART: $e');
    }
  }

//* ------------------ MEAL PART ---------------------//

  //* GETS total quantity of cartMeals for meal with mealId
  int getMealQuantity(int? mealId) {
    var _quantity = 0;
    for (var _cartMeal in _cartMeals.value)
      if (_cartMeal.id == mealId) _quantity += _cartMeal.quantity!;

    // log.v(' _quantity: $_quantity');
    return _quantity;
  }

  //* ADDS a meal to CART
  Future<void> addMealToCart(Meal? meal, {int? quantity = 1}) async {
    log.v('mealId: ${meal!.id}, quantity: $quantity');

    try {
      final HiveMeal _cartMeal = HiveMeal(
        id: meal.id,
        image: meal.image,
        imageCard: meal.imageCard,
        name: meal.name,
        price: meal.price,
        discount: meal.discount?.toInt(),
        discountedPrice: meal.discountedPrice,
        quantity: quantity,
        customs: [],
        volumes: [],
      );
      await cartMealsBox.add(_cartMeal);
      _cartMeals.value.add(_cartMeal);
      log.v('_cartMeals.value length: ${_cartMeals.value.length}');
    } catch (e) {
      log.v('Couldn\'t ADD a meal to CART: $e');
    }
  }

  //* UPDATES a meal in CART
  Future<void> updateMealInCart({int? mealId, int? quantity}) async {
    log.v('mealId: $mealId, quantity: $quantity');

    //* CHECKS whether meal with this id exists and GETS pos if it exists. If NOT, returns -1
    int pos = _cartMeals.value.indexWhere((_meal) => _meal.id == mealId);
    if (pos == -1) return;

    if (quantity! >= 1) {
      _cartMeals.value[pos].quantity = quantity;
      cartMealsBox.putAt(pos, _cartMeals.value[pos]);
      log.v(
          '_cartMeals.value[pos].quantity: ${_cartMeals.value[pos].quantity}');
    } else {
      cartMealsBox.deleteAt(pos);
      _cartMeals.value.removeAt(pos);

      log.v('REMOVED _cartMeals.value.length: ${_cartMeals.value.length}');

      if (_cartMeals.value.isEmpty)
        _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    }
  }

  //* SUBTRACTS quantity of a meal or REMOVES a meal from CART
  Future<void> subtractOrRemoveMealInCart(int? mealId) async {
    log.v('mealId: $mealId');

    //* GETS lastMeal from these meals
    HiveMeal? _lastMeal =
        _cartMeals.value.lastWhere((_meal) => _meal.id == mealId);
    int pos = _cartMeals.value.indexOf(_lastMeal);

    //* UPDATING
    if (_lastMeal.quantity! > 1) {
      log.v('_lastMeal with ABOVE 1');

      // _lastMeal.quantity = _lastMeal.quantity! - 1;
      // cartMealsBox.putAt(pos, _lastMeal);
      // cartMealsBox.putAt(pos, _cartMeals.value[pos]);
      _cartMeals.value[pos].quantity = _cartMeals.value[pos].quantity! - 1;
      cartMealsBox.putAt(pos, _cartMeals.value[pos]);
      log.v('_lastMeal.quantity AFTER action: ${_lastMeal.quantity}');
    }

    //* REMOVING
    else {
      log.v(
          '_lastMeal with BELOW 1 with _cartMeals.value.length: ${_cartMeals.value.length}');
      cartMealsBox.deleteAt(pos);
      _cartMeals.value.removeAt(pos);

      log.v('AFTER action _cartMeals.value.length: ${_cartMeals.value.length}');

      if (_cartMeals.value.isEmpty)
        _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    }
  }

  Future<void> clearCart() async {
    log.v('BEFORE CLEAR _cartMeals.value length: ${_cartMeals.value.length}');
    await cartMealsBox.clear();
    await cartResBox.clear();
    _cartMeals.value.clear();
    await cartResBox.put('cartRes', HiveRestaurant(id: -1, name: 'Default'));
    cartRes = cartResBox.get('cartRes',
        defaultValue: HiveRestaurant(id: -1, name: 'Default'));

    _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    log.v(
        'AFTER CLEAR _cartMeals.value length: ${_cartMeals.value.length} and cartResId: ${cartRes!.id}');
  }

  Future<void> setResDefault() async {
    await cartResBox.clear();
    await cartResBox.put('cartRes', HiveRestaurant(id: -1, name: 'Default'));
    cartRes = cartResBox.get('cartRes',
        defaultValue: HiveRestaurant(id: -1, name: 'Default'));
    log.v('cartResId: ${cartRes!.id}');
  }

//* ------------------ MEAL BOTTOM SHEET PART ---------------------//

  //* ADDS a meal to CART from BOTTOM SHEET
  Future<void> addUpdateMealInCartFromBottomSheet(
      Meal? meal, List<Volume> selectedVols, List<Customizable> selectedCustoms,
      {int? quantityDraft = 1}) async {
    log.v('mealId: ${meal!.id}, quantityDraft: $quantityDraft');

    bool isNew = true;

    List<HiveMeal>? similarMeals = [];
    HiveMeal? similarUpdateMeal;

    //* STEP 1. Filter only to similar meals from cartMeals
    for (HiveMeal cartMeal in _cartMeals.value)
      if (meal.id == cartMeal.id) similarMeals.add(cartMeal);

    //* STEP 2. MAKE isNew to TRUE if similarMeals isEmpty
    if (similarMeals.isEmpty) isNew = true;

    log.v(
        'BEFORE SIMILARS selectedVols and selectedCustoms: ${selectedVols.length} and ${selectedCustoms.length}');

    //* STEP 3. GO THROUGH each similarMeal for vols and customs iteration to decide whether ADD or UPDATE the meal
    for (HiveMeal similarMeal in similarMeals) {
      //* STEP 3.1. CREATE and DEFINE initial value for condition
      bool shouldAdd = false;

      List<Volume> _filteredSelectedVols = [];
      selectedVols.forEach(
        (vol) {
          if (vol.id != -1) _filteredSelectedVols.add(vol);
        },
      );
      log.v('filteredVols length: ${_filteredSelectedVols.length}');

      //* STEP 3.2. CHECK length. If not same then UPDATE shouldAdd to TRUE
      if (selectedVols.length != similarMeal.volumes!.length ||
          selectedCustoms.length != similarMeal.customs!.length) {
        shouldAdd = true;
        log.v('INSIDE NOT SAME LENGTH SIMILAR. That why shouldAdd: $shouldAdd');
      }

      log.i(
          'shouldAdd AFTER LENGTH Comparison ---------------------------- $shouldAdd');

      //* STEP 3.2. CHECK selectedVols and UPDATE isAdd var by condition ( ID COMPARISON )
      for (Volume vol in _filteredSelectedVols) {
        shouldAdd = !similarMeal.volumes!.any((_vol) => _vol.id == vol.id);
        if (shouldAdd) break;
      }

      log.i('shouldAdd AFTER VOLUME ---------------------------- $shouldAdd');

      //* STEP 3.3. CHECK selectedCustoms and UPDATE isUnique var by condition ( ID COMPARISON )
      //* The reason commenting contains func is that same data in hive doesn't equal to each other. That's why we shifted to id comparison Workaround
      if (!shouldAdd)
        for (Customizable cus in selectedCustoms) {
          log.v('cus.id in each selectedCustoms: ${cus.id}');
          shouldAdd = !similarMeal.customs!.any((_cus) => _cus.id == cus.id);
          if (shouldAdd) break;
        }

      log.i(
          'shouldAdd AFTER CUSTOMIZES ---------------------------- $shouldAdd');

      //* STEP 3.4. if shouldAdd FALSE in the end then ASSIGN its value to isNew and UPDATE similarUpdateMeal
      if (!shouldAdd) {
        isNew = shouldAdd;
        similarUpdateMeal = similarMeal;
        log.v('INSIDE UPDATEEE SIMILARS shouldAdd at the END: $shouldAdd');
        break;
      }

      log.v('INSIDE SIMILARS shouldAdd at the END: $shouldAdd');
    }

    //* STEP 4. ADD or UPDATE a meal in CART
    //* ADD PART
    if (isNew) {
      log.v('ADDS with isNew: $isNew');
      List<HiveVolCus> _cartMealVolumes = [];
      List<HiveVolCus> _cartMealCustoms = [];

      //* STEP 4.1. ADD all selectedVols to _cartMeal.volumes
      for (Volume vol in selectedVols)
        _cartMealVolumes.add(HiveVolCus(
          id: vol.id,
          name: vol.volumeName,
          price: meal.discount != null || meal.discount! > 0
              ? (vol.price! / 100) * (100 - meal.discount!)
              : vol
                  .price!, // If discount is TRUE, then add vol's discount price
        ));

      //* STEP 4.2. ADD all selectedCustoms to _cartMeal.customs
      for (Customizable cus in selectedCustoms)
        _cartMealCustoms.add(HiveVolCus(
          id: cus.id,
          name: cus.customizableName,
          price: meal.discount != null || meal.discount! > 0
              ? (cus.price! / 100) * (100 - meal.discount!)
              : cus
                  .price!, // If discount is TRUE, then add cus's discount price
        ));

      log.v(
          '_cartMealVolumes LEN: ${_cartMealVolumes.length} and _cartMealCustoms LEN: ${_cartMealCustoms.length}');

      try {
        final HiveMeal _cartMeal = HiveMeal(
          id: meal.id,
          image: meal.image,
          imageCard: meal.imageCard,
          name: meal.name,
          price: meal.price,
          discount: meal.discount?.toInt(),
          discountedPrice: meal.discountedPrice,
          quantity: quantityDraft,
          volumes: _cartMealVolumes,
          customs: _cartMealCustoms,
        );
        await cartMealsBox.add(_cartMeal);
        _cartMeals.value.add(_cartMeal);
        log.v('_cartMeals.value length: ${_cartMeals.value.length}');
      } catch (e) {
        log.v('Couldn\'t ADD a meal to CART from BOTTOM SHEET: $e');
      }
    }

    //* UPDATE PART
    else {
      log.v('UPDATES with isNew: $isNew');
      int pos = _cartMeals.value.indexOf(similarUpdateMeal!);
      log.v('pos of similarUpdateMeal: $pos');
      if (pos == -1) return;

      _cartMeals.value[pos].quantity =
          _cartMeals.value[pos].quantity! + quantityDraft!;

      cartMealsBox.putAt(pos, _cartMeals.value[pos]);
      log.v(
          'similarUpdateMeal.quantity: ${similarUpdateMeal.quantity} and ${_cartMeals.value[pos].quantity}');
    }
  }

//* ----------------------- CART VIEW PART --------------------------//

  //* GETS quantity of this hiveMeal from cartMeals
  int getCartMealQuantity(HiveMeal hiveMeal) {
    int pos = _cartMeals.value.indexOf(hiveMeal);
    if (pos == -1) return 0;
    log.v(
        '_cartMeals.value[pos].quantity!: ${_cartMeals.value[pos].quantity!}');

    return _cartMeals.value[pos].quantity!;
  }

  //* UPDATES cart meal in cartMeals
  Future<void> updateCartMealInCart({HiveMeal? hiveMeal, int? quantity}) async {
    log.i('hiveMeal.id: ${hiveMeal!.id}, quantity: $quantity');

    int pos = _cartMeals.value.indexOf(hiveMeal);
    if (pos == -1) return;

    if (quantity! >= 1) {
      _cartMeals.value[pos].quantity = quantity;
      cartMealsBox.putAt(pos, _cartMeals.value[pos]);
      log.v(
          '_cartMeals.value[pos].quantity: ${_cartMeals.value[pos].quantity}');
    } else {
      cartMealsBox.deleteAt(pos);
      _cartMeals.value.removeAt(pos);
      log.v('REMOVED _cartMeals.value.length: ${_cartMeals.value.length}');

      if (_cartMeals.value.isEmpty)
        _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    }
  }

  Future<void> updateCartMeals(List<Meal> updatedMeals) async {
    log.v('updateCartMeals() updatedMeals => ${updatedMeals.length}');
    final cartMealsBox = Hive.box<HiveMeal>(Constants.cartMealsBox);
    final Map<int, Meal> updatedMealsMap = {
      for (var meal in updatedMeals) meal.id ?? -1: meal
    };

    final cartMealsBoxKeys = cartMealsBox.keys.toList();
    for (var cartMealsBoxKey in cartMealsBoxKeys) {
      final currentHiveMeal = cartMealsBox.get(cartMealsBoxKey);
      final updatedMeal = updatedMealsMap[currentHiveMeal?.id ?? -1];
      if (updatedMeal != null) {
        final HiveMeal updatedHiveMeal = HiveMeal(
          id: currentHiveMeal?.id,
          image: updatedMeal.image,
          imageCard: updatedMeal.imageCard,
          name: updatedMeal.name,
          price: updatedMeal.price,
          discount: updatedMeal.discount?.toInt(),
          discountedPrice: updatedMeal.discountedPrice,
          quantity: currentHiveMeal?.quantity ?? 1,
          customs: currentHiveMeal?.customs,
          volumes: currentHiveMeal?.volumes,
        );
        await cartMealsBox.put(cartMealsBoxKey, updatedHiveMeal);
      }
    }
    _cartMeals.value = cartMealsBox.values.toList();
  }

//* ----------------------- HIVE RATING --------------------------//

  //* DELETES a hive rating
  Future<void> deleteHiveRatingFromHiveRatings(int? orderId) async {
    log.v('orderId: $orderId');

    //* CHECHKS whether order with this id exists in hiveRatingBox
    int _indexHiveRatingNotification = _hiveRatings.value
        .indexWhere((_hiveRating) => _hiveRating.id == orderId.toString());

    //* IF this hiveRating EXISTS
    if (_indexHiveRatingNotification != -1) {
      log.v(
          'BEFORE delete action for _hiveRatings.value.length: ${_hiveRatings.value.length}');
      hiveRatingBox.deleteAt(_indexHiveRatingNotification);
      _hiveRatings.value.removeAt(_indexHiveRatingNotification);
    }

    log.v(
        'AFTER delete action for _hiveRatings.value.length: ${_hiveRatings.value.length}');
  }

//* ---------------------------------------//
//* ------------------ CREDIT CARD ---------------------//
//* ---------------------------------------//

  //* ADDS a creadit card
  Future<void> addCreditCard(CreditCard creditCard, BankCard bankCard) async {
    log.v('creditCard.cardNumber: ${creditCard.cardNumber}');
    log.v('creditCard.expiryDate: ${creditCard.expiryDate}');
    log.v('creditCard.cardHolderName: ${creditCard.cardHolderName}');

    try {
      final HiveCreditCard _creditCard = HiveCreditCard(
        cardNumber: creditCard.cardNumber,
        expiryDate: creditCard.expiryDate,
        cardHolderName: creditCard.cardHolderName,
        bankId: bankCard.bankId,
        bankName: bankCard.bankName,
      );
      await hiveCreditCardsBox.add(_creditCard);
      _hiveCreditCards.value = hiveCreditCardsBox.values.toList();
      log.v('_hiveCreditCards.value length: ${_hiveCreditCards.value.length}');
    } catch (e) {
      log.v('Couldn\'t ADD a credict card to hiveCreditCardsBox: $e');
    }
  }

  //* DELETES a hive rating from _hiveCreditCards
  Future<void> deleteHiveCreditCard(HiveCreditCard hiveCreditCard) async {
    log.v('hiveCreditCard: $hiveCreditCard');

    int pos = _hiveCreditCards.value.indexOf(hiveCreditCard);

    log.v(
        'DELETING hiveCreditCard when _hiveCreditCards.value.length: ${_hiveCreditCards.value.length}');
    hiveCreditCardsBox.deleteAt(pos);
    _hiveCreditCards.value = hiveCreditCardsBox.values.toList();

    log.v(
        'AFTER delete action for _hiveCreditCards.value.length: ${_hiveCreditCards.value.length}');
  }
}
