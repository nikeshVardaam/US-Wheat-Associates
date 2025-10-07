import 'package:flutter/cupertino.dart';

class CalculatorProvider extends ChangeNotifier {
  bool _isUpdating = false;

  //distanceAndArea

//miles=kilometer
  TextEditingController milesController = TextEditingController();
  TextEditingController kilometerController = TextEditingController();

  static const double mileToKm = 1.60934; // 1 mile = 1.60934 km
  static const double kmToMile = 0.621371; // 1 km = 0.621371 mile

  // From Miles → Kilometers
  void convertFromMiles(String value) {
    if (value.isEmpty) {
      kilometerController.clear(); // agar user delete kare
    } else {
      double miles = double.tryParse(value) ?? 0;
      double km = miles * mileToKm;
      kilometerController.text = km.toStringAsFixed(4);
    }
    notifyListeners();
  }

  void convertFromKilometers(String value) {
    if (value.isEmpty) {
      milesController.clear(); // agar user delete kare
    } else {
      double km = double.tryParse(value) ?? 0;
      double miles = km * kmToMile;
      milesController.text = miles.toStringAsFixed(4);
    }
    notifyListeners();
  }

  void clearMilesKilometer() {
    milesController.clear();
    kilometerController.clear();
    notifyListeners();
  }

  // squareFeet=squareMeter
  TextEditingController sqFeetController = TextEditingController();
  TextEditingController sqMeterController = TextEditingController();

  static const double sqftToSqm = 0.092903; // 1 sqft = 0.092903 sqm
  static const double sqmToSqft = 10.7639; // 1 sqm = 10.7639 sqft

  // From Square Feet → Square Meter
  void convertFromSqFeet(String value) {
    if (value.isEmpty) {
      sqMeterController.clear(); // agar user delete kare
    } else {
      double sqft = double.tryParse(value) ?? 0;
      double sqm = sqft * sqftToSqm;
      sqMeterController.text = sqm.toStringAsFixed(4);
    }
    notifyListeners();
  }

// From Square Meter → Square Feet
  void convertFromSqMeter(String value) {
    if (value.isEmpty) {
      sqFeetController.clear(); // agar user delete kare
    } else {
      double sqm = double.tryParse(value) ?? 0;
      double sqft = sqm * sqmToSqft;
      sqFeetController.text = sqft.toStringAsFixed(4);
    }
    notifyListeners();
  }

// Clear All
  void clearSqFeetSqMeter() {
    sqFeetController.clear();
    sqMeterController.clear();
    notifyListeners();
  }

//meters=yards=feet
  TextEditingController meterController = TextEditingController();
  TextEditingController yardController = TextEditingController();
  TextEditingController feetController = TextEditingController();

  static const double meterToYard = 1.09361;
  static const double meterToFeet = 3.28084;

  // From Meter
  void convertFromMeter(String value) {
    if (value.isEmpty) {
      yardController.clear();
      feetController.clear();
    } else {
      double meter = double.tryParse(value) ?? 0;
      double yard = meter * meterToYard;
      double feet = meter * meterToFeet;
      yardController.text = yard.toStringAsFixed(4);
      feetController.text = feet.toStringAsFixed(4);
    }
    notifyListeners();
  }

  // From Yard
  void convertFromYard(String value) {
    if (value.isEmpty) {
      meterController.clear();
      feetController.clear();
    } else {
      double yard = double.tryParse(value) ?? 0;
      double meter = yard / meterToYard;
      double feet = meter * meterToFeet;
      meterController.text = meter.toStringAsFixed(4);
      feetController.text = feet.toStringAsFixed(4);
    }

    notifyListeners();
  }

  // From Feet
  void convertFromFeet(String value) {
    if (value.isEmpty) {
      meterController.clear();
      yardController.clear();
    } else {
      double feet = double.tryParse(value) ?? 0;
      double meter = feet / meterToFeet;
      double yard = meter * meterToYard;
      meterController.text = meter.toStringAsFixed(4);
      yardController.text = yard.toStringAsFixed(4);
    }
    notifyListeners();
  }

  // Clear All
  void clearMeterYardFeet() {
    meterController.clear();
    yardController.clear();
    feetController.clear();
    notifyListeners();
  }

//acres=hectares=mu
  TextEditingController acreController = TextEditingController();
  TextEditingController hectareController = TextEditingController();
  TextEditingController muController = TextEditingController();

  static const double acreToHectare = 0.404686;
  static const double acreToMu = 6.0702846336;

  // Conversion from Acre
  // From Acre → Hectare & Mu
  void convertFromAcre(String val) {
    if (val.isEmpty) {
      hectareController.clear();
      muController.clear();
    } else {
      double acre = double.tryParse(val) ?? 0;
      double hectare = acre * acreToHectare;
      double mu = acre * acreToMu;

      hectareController.text = hectare.toStringAsFixed(4);
      muController.text = mu.toStringAsFixed(2);
    }
    notifyListeners();
  }

// From Hectare → Acre & Mu
  void convertFromHectare(String val) {
    if (val.isEmpty) {
      acreController.clear();
      muController.clear();
    } else {
      double hectare = double.tryParse(val) ?? 0;
      double acre = hectare / acreToHectare;
      double mu = acre * acreToMu;

      acreController.text = acre.toStringAsFixed(4);
      muController.text = mu.toStringAsFixed(2);
    }
    notifyListeners();
  }

// From Mu → Acre & Hectare
  void convertFromMu(String val) {
    if (val.isEmpty) {
      acreController.clear();
      hectareController.clear();
    } else {
      double mu = double.tryParse(val) ?? 0;
      double acre = mu / acreToMu;
      double hectare = acre * acreToHectare;

      acreController.text = acre.toStringAsFixed(4);
      hectareController.text = hectare.toStringAsFixed(4);
    }
    notifyListeners();
  }

// Clear All
  void clearAcresHectaresMu() {
    acreController.clear();
    hectareController.clear();
    muController.clear();
    notifyListeners();
  }


  //weight
  //bushels=metric tons
  final TextEditingController bushelController = TextEditingController();
  final TextEditingController metricTonController = TextEditingController();

  void convertBushelToMT(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      metricTonController.clear();
    } else {
      double bushel = double.tryParse(value) ?? 0;
      double mt = bushel * 0.0272;
      metricTonController.text = mt.toStringAsFixed(4);
    }

    _isUpdating = false;
  }

// From Metric Ton → Bushel
  void convertMTToBushel(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      bushelController.clear();
    } else {
      double mt = double.tryParse(value) ?? 0;
      double bushel = mt / 0.0272;
      bushelController.text = bushel.toStringAsFixed(2);
    }

    _isUpdating = false;
  }

// Clear all fields
  void clearFields() {
    bushelController.clear();
    metricTonController.clear();
  }

  //shortTonsController = metrictitons

  final TextEditingController shortTonController = TextEditingController();
  final TextEditingController metric_TonController = TextEditingController();

  void convertShortToMetricTon(String val) {
    double shortTons = double.tryParse(val) ?? 0;
    double metricTons = shortTons * 0.90718474;
    metric_TonController.text = metricTons.toStringAsFixed(4);
    notifyListeners();
  }

  void clearShortMetricTons() {
    shortTonController.clear();
    metric_TonController.clear();
    notifyListeners();
  }

  // britishTons=metricTons
  final TextEditingController longTonController = TextEditingController();
  final TextEditingController longToMetricController = TextEditingController();

  void convertLongToMetricTon(String val) {
    double longTons = double.tryParse(val) ?? 0;
    double metricTons = longTons * 1.01604691;
    longToMetricController.text = metricTons.toStringAsFixed(4);
    notifyListeners();
  }

  void clearLongMetricTons() {
    longTonController.clear();
    longToMetricController.clear();
    notifyListeners();
  }

  // americanTons=pounds

  final TextEditingController shortTonToPoundController = TextEditingController();
  final TextEditingController poundResultController = TextEditingController();

  void convertShortTonToPound(String val) {
    double shortTons = double.tryParse(val) ?? 0;
    double pounds = shortTons * 2000;
    poundResultController.text = pounds.toStringAsFixed(2);
    notifyListeners();
  }

  void clearShortTonToPound() {
    shortTonToPoundController.clear();
    poundResultController.clear();
    notifyListeners();
  }

  // metricTons=kg=pounds

  final TextEditingController metricTonInputController = TextEditingController();
  final TextEditingController kgOutputController = TextEditingController();
  final TextEditingController poundOutputController = TextEditingController();

  /// Convert from Metric Ton input
  // From Metric Ton → KG & Pound
  void convertFromMetricTon(String val) {
    if (val.isEmpty) {
      kgOutputController.clear();
      poundOutputController.clear();
    } else {
      double mt = double.tryParse(val) ?? 0;
      double kg = mt * 1000;
      double pounds = kg * 2.20462262;

      kgOutputController.text = kg.toStringAsFixed(2);
      poundOutputController.text = pounds.toStringAsFixed(2);
    }
    notifyListeners();
  }

// From KG → Metric Ton & Pound
  void convertFromKg(String val) {
    if (val.isEmpty) {
      metricTonInputController.clear();
      poundOutputController.clear();
    } else {
      double kg = double.tryParse(val) ?? 0;
      double mt = kg / 1000;
      double pounds = kg * 2.20462262;

      metricTonInputController.text = mt.toStringAsFixed(4);
      poundOutputController.text = pounds.toStringAsFixed(2);
    }
    notifyListeners();
  }

// From Pound → Metric Ton & KG
  void convertFromPound(String val) {
    if (val.isEmpty) {
      metricTonInputController.clear();
      kgOutputController.clear();
    } else {
      double pounds = double.tryParse(val) ?? 0;
      double kg = pounds / 2.20462262;
      double mt = kg / 1000;

      metricTonInputController.text = mt.toStringAsFixed(4);
      kgOutputController.text = kg.toStringAsFixed(2);
    }
    notifyListeners();
  }

// Clear all fields
  void clearMetricTonKgPound() {
    metricTonInputController.clear();
    kgOutputController.clear();
    poundOutputController.clear();
    notifyListeners();
  }


  //metricTons=cwt
  final TextEditingController metricController = TextEditingController();
  final TextEditingController cwtInputController = TextEditingController();

  // From Metric Ton → CWT
  void convertMetricTonToCwt(String val) {
    if (val.isEmpty) {
      cwtInputController.clear();
    } else {
      double mt = double.tryParse(val) ?? 0;
      double cwt = (mt * 2204.62262) / 100;
      cwtInputController.text = cwt.toStringAsFixed(4);
    }
    notifyListeners();
  }

// From CWT → Metric Ton
  void convertCwtToMetricTon(String val) {
    if (val.isEmpty) {
      metricController.clear();
    } else {
      double cwt = double.tryParse(val) ?? 0;
      double mt = (cwt * 100) / 2204.62262;
      metricController.text = mt.toStringAsFixed(6);
    }
    notifyListeners();
  }

// Clear all fields
  void clearMetricTonCwt() {
    metricController.clear();
    cwtInputController.clear();
    notifyListeners();
  }

  // Test Weight controllers
  final TextEditingController commonLbController = TextEditingController();
  final TextEditingController commonKgController = TextEditingController();
  final TextEditingController durumLbController = TextEditingController();
  final TextEditingController durumKgController = TextEditingController();

  /// Common wheat: lb/bu → kg/hl
  void convertCommonLbToKg(String val) {
    if (val.isEmpty) {
      commonKgController.clear();
      return;
    }
    double lb = double.tryParse(val) ?? 0;
    double kg = (lb * 1.292) + 1.419;
    commonKgController.text = kg.toStringAsFixed(2);
    notifyListeners();
  }

  /// Common wheat: kg/hl → lb/bu
  void convertCommonKgToLb(String val) {
    if (val.isEmpty) {
      commonLbController.clear();
      return;
    }
    double kg = double.tryParse(val) ?? 0;
    double lb = (kg - 1.419) / 1.292;
    commonLbController.text = lb.toStringAsFixed(2);
    notifyListeners();
  }

  /// Durum wheat: lb/bu → kg/hl
  void convertDurumLbToKg(String val) {
    if (val.isEmpty) {
      durumKgController.clear();
      return;
    }
    double lb = double.tryParse(val) ?? 0;
    double kg = (lb * 1.292) + 0.630;
    durumKgController.text = kg.toStringAsFixed(2);
    notifyListeners();
  }

  /// Durum wheat: kg/hl → lb/bu
  void convertDurumKgToLb(String val) {
    if (val.isEmpty) {
      durumLbController.clear();
      return;
    }
    double kg = double.tryParse(val) ?? 0;
    double lb = (kg - 0.630) / 1.292;
    durumLbController.text = lb.toStringAsFixed(2);
    notifyListeners();
  }

  /// Clear all Test Weight fields
  void clearTestWeight() {
    commonLbController.clear();
    commonKgController.clear();
    durumLbController.clear();
    durumKgController.clear();
    notifyListeners();
  }


// yields
  TextEditingController buAcreController = TextEditingController();
  TextEditingController mtHectareController = TextEditingController();

  // From Bushel/Acre → Metric Ton/Hectare
  void convertBuAcreToMtHectare(String val) {
    if (val.isEmpty) {
      mtHectareController.clear();
    } else {
      double buAcre = double.tryParse(val) ?? 0;
      double mtHectare = buAcre * 0.0673; // conversion factor
      mtHectareController.text = mtHectare.toStringAsFixed(4);
    }
    notifyListeners();
  }

// From Metric Ton/Hectare → Bushel/Acre
  void convertMtHectareToBuAcre(String val) {
    if (val.isEmpty) {
      buAcreController.clear();
    } else {
      double mtHectare = double.tryParse(val) ?? 0;
      double buAcre = mtHectare / 0.0673; // reverse conversion
      buAcreController.text = buAcre.toStringAsFixed(4);
    }
    notifyListeners();
  }

// Clear all fields
  void clearBuAcreMtHectare() {
    buAcreController.clear();
    mtHectareController.clear();
    notifyListeners();
  }


//protein

  final TextEditingController mbController = TextEditingController(); // Moisture Basis
  final TextEditingController dbController = TextEditingController(); // Dry Basis

  double moistureFraction = 0.12; // 12% moisture

  /// MB → DB
  void convertMbToDb(String val) {
    if (val.isEmpty) {
      dbController.clear();
      return;
    }

    double mb = double.tryParse(val) ?? 0;
    double db = mb / (1 - moistureFraction); // Correct formula
    dbController.text = db.toStringAsFixed(2);
    notifyListeners();
  }

  /// DB → MB
  void convertDbToMb(String val) {
    if (val.isEmpty) {
      mbController.clear();
      return;
    }

    double db = double.tryParse(val) ?? 0;
    double mb = db * (1 - moistureFraction); // Correct formula
    mbController.text = mb.toStringAsFixed(2);
    notifyListeners();
  }

  /// Clear
  void clearProtein() {
    mbController.clear();
    dbController.clear();
    notifyListeners();
  }
// flour protein
  final TextEditingController flourMbController = TextEditingController(); // 14% mb
  final TextEditingController flourDbController = TextEditingController(); // dry basis

  /// 14% MB → Dry Basis
  void convertFlourMbToDb(String val) {
    if (val.isEmpty) {
      flourDbController.clear();
      return;
    }
    double mb = double.tryParse(val) ?? 0;
    double db = mb / 0.86; // 14% moisture
    flourDbController.text = db.toStringAsFixed(2);
    notifyListeners();
  }

  /// Dry Basis → 14% MB
  void convertFlourDbToMb(String val) {
    if (val.isEmpty) {
      flourMbController.clear();
      return;
    }
    double db = double.tryParse(val) ?? 0;
    double mb = db * 0.86;
    flourMbController.text = mb.toStringAsFixed(2);
    notifyListeners();
  }

  /// Clear Flour Protein fields
  void clearFlourProtein() {
    flourMbController.clear();
    flourDbController.clear();
    notifyListeners();
  }

  // fahrenheit=celsius

  final TextEditingController fahrenheitController = TextEditingController();
  final TextEditingController celsiusFromFahrenheitController = TextEditingController();

  void convertFromFahrenheit(String val) {
    if (val.isEmpty) {
      celsiusFromFahrenheitController.clear();
    } else {
      double f = double.tryParse(val) ?? 0;
      double c = (f - 32) * 5 / 9;
      celsiusFromFahrenheitController.text = c.toStringAsFixed(2);
    }
    notifyListeners();
  }

  // From Celsius → Fahrenheit
  void convertFromCelsius(String val) {
    if (val.isEmpty) {
      fahrenheitController.clear();
    } else {
      double c = double.tryParse(val) ?? 0;
      double f = (c * 9 / 5) + 32;
      fahrenheitController.text = f.toStringAsFixed(2);
    }
    notifyListeners();
  }

  // Clear Both
  void clearTemperatureFields() {
    fahrenheitController.clear();
    celsiusFromFahrenheitController.clear();
    notifyListeners();
  }
}
