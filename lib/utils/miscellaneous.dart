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

  static String mdy(String date) {
    if (date.isEmpty) {
      return "";
    } else {
      List<String> formats = [
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-dd HH:mm',
        'yyyy-MM-dd',
        'dd-MM-yyyy HH:mm:ss',
        'dd-MM-yyyy HH:mm',
        'dd-MM-yyyy',
        'MM/dd/yyyy HH:mm:ss',
        'MM/dd/yyyy HH:mm',
        'MM/dd/yyyy',
        'dd/MM/yyyy HH:mm:ss',
        'dd/MM/yyyy HH:mm',
        'dd/MM/yyyy',
        'MMM dd, yyyy',
        'MMMM dd, yyyy',
        'EEE, dd MMM yyyy HH:mm:ss',
        'EEE MMM dd HH:mm:ss yyyy',
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd HH:mm:ss",
        "MM/dd/yyyy HH:mm:ss",
        "MM/dd/yyyy hh:mm a",
        "dd/MM/yyyy HH:mm:ss",
        "dd/MM/yyyy hh:mm a",
        "dd-MM-yyyy HH:mm:ss",
        "dd-MM-yyyy hh:mm a",
        "yyyy/MM/dd HH:mm:ss",
        "yyyy/MM/dd hh:mm a",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss",
      ];

      for (String format in formats) {
        try {
          DateTime parsedDate = DateFormat(format).parseStrict(date);
          return DateFormat("MM-dd-yyyy").format(parsedDate);
        } catch (e) {
          // Ignore and try next format
        }
      }

      DateTime dateTime = DateTime.parse(date);
      return DateFormat('MM-dd-yyyy').format(dateTime);
    }
  }

  static String yyyy(String date) {
    if (date.isEmpty) {
      return "";
    } else {
      // Possible formats API might return
      List<String> formats = [
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-dd HH:mm',
        'yyyy-MM-dd',
        'dd-MM-yyyy HH:mm:ss',
        'dd-MM-yyyy HH:mm',
        'dd-MM-yyyy',
        'MM/dd/yyyy HH:mm:ss',
        'MM/dd/yyyy HH:mm',
        'MM/dd/yyyy',
        'dd/MM/yyyy HH:mm:ss',
        'dd/MM/yyyy HH:mm',
        'dd/MM/yyyy',
        'MMM dd, yyyy',
        'MMMM dd, yyyy',
        'EEE, dd MMM yyyy HH:mm:ss',
        'EEE MMM dd HH:mm:ss yyyy',
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd HH:mm:ss",
        "MM/dd/yyyy HH:mm:ss",
        "MM/dd/yyyy hh:mm a",
        "dd/MM/yyyy HH:mm:ss",
        "dd/MM/yyyy hh:mm a",
        "dd-MM-yyyy HH:mm:ss",
        "dd-MM-yyyy hh:mm a",
        "yyyy/MM/dd HH:mm:ss",
        "yyyy/MM/dd hh:mm a",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss",
      ];

      for (String format in formats) {
        try {
          DateTime parsedDate = DateFormat(format).parseStrict(date);
          return DateFormat("yyyy").format(parsedDate);
        } catch (e) {
          // Ignore and try next format
        }
      }

      DateTime dateTime = DateTime.parse(date);
      return DateFormat('yyyy').format(dateTime);
    }
  }

  static String ymd(String date) {
    if (date.isEmpty) {
      return "";
    } else {
      // Possible formats API might return
      List<String> formats = [
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-dd HH:mm',
        'yyyy-MM-dd',
        'dd-MM-yyyy HH:mm:ss',
        'dd-MM-yyyy HH:mm',
        'dd-MM-yyyy',
        'MM/dd/yyyy HH:mm:ss',
        'MM/dd/yyyy HH:mm',
        'MM/dd/yyyy',
        'dd/MM/yyyy HH:mm:ss',
        'dd/MM/yyyy HH:mm',
        'dd/MM/yyyy',
        'MMM dd, yyyy',
        'MMMM dd, yyyy',
        'EEE, dd MMM yyyy HH:mm:ss',
        'EEE MMM dd HH:mm:ss yyyy',
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd HH:mm:ss",
        "MM/dd/yyyy HH:mm:ss",
        "MM/dd/yyyy hh:mm a",
        "dd/MM/yyyy HH:mm:ss",
        "dd/MM/yyyy hh:mm a",
        "dd-MM-yyyy HH:mm:ss",
        "dd-MM-yyyy hh:mm a",
        "yyyy/MM/dd HH:mm:ss",
        "yyyy/MM/dd hh:mm a",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss",
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
      return DateFormat('MMMM d, yyyy').format(parsedDate).toUpperCase();
    } catch (e) {
      return "--";
    }
  }
}
