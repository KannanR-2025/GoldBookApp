// Minimal settings models stub - but with all properties for settings screen compatibility
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanySettings {
  final String companyName;
  final String? companyCode;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pinCode;
  final String? gstin;
  final String? panNumber;
  final String? phone;
  final String? email;
  final String? website;

  const CompanySettings({
    required this.companyName,
    this.companyCode,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pinCode,
    this.gstin,
    this.panNumber,
    this.phone,
    this.email,
    this.website,
  });
}

class UserSettings {
  final String fullName;
  final String? username;
  final String? email;
  final String? role;

  const UserSettings({
    required this.fullName,
    this.username,
    this.email,
    this.role,
  });
}

class AppPreferences {
  final String dateFormat;
  final String? currencySymbol;
  final String? numberFormat;
  final int? decimalPlaces;
  final String? defaultUnit;
  final bool? darkMode;
  final bool? autoBackup;
  final int? backupFrequencyDays;

  const AppPreferences({
    this.dateFormat = 'dd/MM/yyyy',
    this.currencySymbol,
    this.numberFormat,
    this.decimalPlaces,
    this.defaultUnit,
    this.darkMode,
    this.autoBackup,
    this.backupFrequencyDays,
  });
}

class TaxSettings {
  final double gstRate;
  final bool? applyGstByDefault;
  final List<String>? gstCategories;

  const TaxSettings({
    this.gstRate = 18.0,
    this.applyGstByDefault,
    this.gstCategories,
  });
}

class ItemSettings {
  final List<String> metalTypes;
  final List<String>? metals;
  final List<String>? purities;
  final List<String>? itemCategories;

  const ItemSettings({
    this.metalTypes = const ['Gold', 'Silver'],
    this.metals,
    this.purities,
    this.itemCategories,
  });
}

// Simple providers using Provider (NOT NotifierProvider - to avoid dashboard issues)
final companySettingsProvider = Provider<CompanySettings>(
  (ref) => const CompanySettings(companyName: 'GoldBook'),
);

final userSettingsProvider = Provider<UserSettings>(
  (ref) => const UserSettings(fullName: 'User'),
);

final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => const AppPreferences(),
);

final taxSettingsProvider = Provider<TaxSettings>((ref) => const TaxSettings());

final itemSettingsProvider = Provider<ItemSettings>(
  (ref) => const ItemSettings(),
);
