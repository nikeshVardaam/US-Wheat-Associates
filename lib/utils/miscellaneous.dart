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
}
