import 'package:intl/intl.dart';

class Miscellaneous {
  static const String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static String getInitials(String fullName) {
    List names = fullName.split(' ');

    if (names.length > 2) {
      names.removeAt(1);
      String initials = names.map((name) => name.isNotEmpty ? name[0] : '').join('');
      return initials.toUpperCase();
    } else {
      String initials = names.map((name) => name.isNotEmpty ? name[0] : '').join('');
      return initials.toUpperCase();
    }
  }

  static String dateConverterToYYYYMMDD(String date) {
    if (date.isEmpty) {
      return "";
    } else {
      // Possible formats API might return
      List<String> formats = [
        "MM/dd/yyyy",
        "dd/MM/yyyy",
        "yyyy-MM-dd",
        "dd-MM-yyyy",
        "MM-dd-yyyy",
        "yyyy/MM/dd",
      ];

      for (String format in formats) {
        try {
          DateTime parsedDate = DateFormat(format).parseStrict(date);
          return DateFormat("yyyy-MM-dd").format(parsedDate);
        } catch (e) {
          // Ignore and try next format
        }
      }

      DateTime dateTime = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }

  static String formatPrDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "--";
    try {
      final parsedDate = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy').format(parsedDate).toUpperCase(); // e.g. July 18, 2025
    } catch (e) {
      return "--";
    }
  }
  static String formatDateCustom(
      String? dateStr, {
        String format = 'yyyyMMdd', // default format
        bool toUpperCase = true,    // convert to uppercase if needed
      }) {
    if (dateStr == null || dateStr.isEmpty) return "--";

    try {
      final parsedDate = DateTime.parse(dateStr);
      String formatted = DateFormat(format).format(parsedDate);
      return toUpperCase ? formatted.toUpperCase() : formatted;
    } catch (e) {
      return "--";
    }
  }
  static String getYear(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "--";

    try {
      final parsedDate = dateStr.length == 4 ? DateTime.parse("$dateStr-01-01") : DateTime.parse(dateStr);
      return DateFormat("yyyy").format(parsedDate).toUpperCase();
    } catch (e) {
      return "--";
    }
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
