// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get searchHint => 'Search in your app';

  @override
  String get expressModeLabel => 'Activate express experience';

  @override
  String get cartTitleExpress => 'Express Cart';

  @override
  String get cartTitleStandard => 'My Cart';

  @override
  String get emptyCartMessage => 'Your cart is empty';

  @override
  String get totalLabel => 'Total:';

  @override
  String get checkoutButton => 'CHECKOUT';

  @override
  String get addButton => 'Add';

  @override
  String get buyButton => 'Buy';

  @override
  String get unitsLabel => 'units';

  @override
  String get searchPlaceholder => 'What are you looking for?';
}
