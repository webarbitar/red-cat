extension StringExtension on String {
  String capitalize() {
    if (isNotEmpty) {
      return trim().split(" ").map((str) => "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}").join(" ");
    }
    return "";
  }
}
