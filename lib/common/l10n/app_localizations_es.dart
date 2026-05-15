// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get searchHint => 'Busca en tu app';

  @override
  String get expressModeLabel => 'Activar la experiencia express';

  @override
  String get cartTitleExpress => 'Carrito Express';

  @override
  String get cartTitleStandard => 'Mi Carrito';

  @override
  String get emptyCartMessage => 'Tu carrito está vacío';

  @override
  String get totalLabel => 'Total:';

  @override
  String get checkoutButton => 'FINALIZAR COMPRA';

  @override
  String get addButton => 'Agregar';

  @override
  String get buyButton => 'Comprar';

  @override
  String get unitsLabel => 'und';

  @override
  String get searchPlaceholder => '¿Qué buscas?';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get searchHint => 'Busca en tu app';

  @override
  String get expressModeLabel => 'Activar la experiencia express';

  @override
  String get cartTitleExpress => 'Carrito Express';

  @override
  String get cartTitleStandard => 'Mi Carrito';

  @override
  String get emptyCartMessage => 'Tu carrito está vacío';

  @override
  String get totalLabel => 'Total:';

  @override
  String get checkoutButton => 'FINALIZAR COMPRA';

  @override
  String get addButton => 'Agregar';

  @override
  String get buyButton => 'Comprar';

  @override
  String get unitsLabel => 'und';

  @override
  String get searchPlaceholder => '¿Qué buscas?';
}
