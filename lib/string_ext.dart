library dart_ext.string;

String capitalize(String s) {
  if (s != null && s.isNotEmpty) {
    if (s.length == 1) {
      return s[0].toUpperCase();
    }
    return s[0].toUpperCase() + s.substring(1);
  }
  return s;
}