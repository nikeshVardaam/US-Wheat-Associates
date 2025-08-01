import 'package:flutter/cupertino.dart';

class CalculatorProvider extends ChangeNotifier {
  //distanceAndArea

//miles=kilometer
  TextEditingController milesController = TextEditingController();
  TextEditingController kilometerController = TextEditingController();

  void convertToKilometers(String value) {
    double miles = double.tryParse(value) ?? 0;
    double km = miles * 1.60934;
    kilometerController.text = km.toStringAsFixed(4);
  }

  void clearMilesKilometer() {
    milesController.clear();
    kilometerController.clear();
  }

  // squareFeet=squareMeter
  TextEditingController sqFeetController = TextEditingController();
  TextEditingController sqMeterController = TextEditingController();

  void convertToSqMeter(String value) {
    double sqft = double.tryParse(value) ?? 0;
    double sqm = sqft * 0.092903;
    sqMeterController.text = sqm.toStringAsFixed(4);
  }

  void clearSqFeetSqMeter() {
    sqFeetController.clear();
    sqMeterController.clear();
  }

//meters=yards=feet
  TextEditingController meterController = TextEditingController();
  TextEditingController yardController = TextEditingController();
  TextEditingController feetController = TextEditingController();

  void convertMeterToYardFeet(String value) {
    double meter = double.tryParse(value) ?? 0;
    double yard = meter * 1.09361;
    double feet = meter * 3.28084;

    yardController.text = yard.toStringAsFixed(4);
    feetController.text = feet.toStringAsFixed(4);
  }

  void clearMeterYardFeet() {
    meterController.clear();
    yardController.clear();
    feetController.clear();
  }

//acres=hectares=mu
  TextEditingController acreController = TextEditingController();
  TextEditingController hectareController = TextEditingController();
  TextEditingController muController = TextEditingController();

  void convertAcresToHectaresMu(String val) {
    double acres = double.tryParse(val) ?? 0;
    double hectares = acres * 0.404686;
    double mu = acres * 6.0702846336;

    hectareController.text = hectares.toStringAsFixed(4);
    muController.text = mu.toStringAsFixed(2);
    notifyListeners();
  }

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

  void convertToMT(String value) {
    double bushel = double.tryParse(value) ?? 0;
    double mt = bushel * 0.0272;
    metricTonController.text = mt.toStringAsFixed(4);
  }

  void clearFields() {
    bushelController.clear();
    meterController.clear();
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

  void convertMetricTonToKgAndPound(String val) {
    double metricTon = double.tryParse(val) ?? 0;
    double kg = metricTon * 1000;
    double pounds = kg * 2.20462262;

    kgOutputController.text = kg.toStringAsFixed(2);
    poundOutputController.text = pounds.toStringAsFixed(2);
    notifyListeners();
  }

  void clearMetricTonKgPound() {
    metricTonInputController.clear();
    kgOutputController.clear();
    poundOutputController.clear();
    notifyListeners();
  }

  // fahrenheit=celsius

  final TextEditingController fahrenheitController = TextEditingController();
  final TextEditingController celsiusFromFahrenheitController = TextEditingController();

  final TextEditingController celsiusController = TextEditingController();
  final TextEditingController fahrenheitFromCelsiusController = TextEditingController();

  void convertFahrenheitToCelsius(String val) {
    double f = double.tryParse(val) ?? 0;
    double c = (f - 32) * 5 / 9;
    celsiusFromFahrenheitController.text = c.toStringAsFixed(2);
    notifyListeners();
  }

  void convertCelsiusToFahrenheit(String val) {
    double c = double.tryParse(val) ?? 0;
    double f = (c * 9 / 5) + 32;
    fahrenheitFromCelsiusController.text = f.toStringAsFixed(2);
    notifyListeners();
  }

  void clearTemperatureFields() {
    fahrenheitController.clear();
    celsiusFromFahrenheitController.clear();
    celsiusController.clear();
    fahrenheitFromCelsiusController.clear();
    notifyListeners();
  }

}
