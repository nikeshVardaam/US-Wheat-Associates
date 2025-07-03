class Miscellaneous {
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
