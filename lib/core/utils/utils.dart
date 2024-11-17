
class Utils {
  static String extractPenultimateValue(String url) {
    final segments = url.split('/');
    if (segments.length > 2) {
      return segments[segments.length - 2];
    } else {
      throw Exception('URL no válida o con formato incorrecto');
    }
  }
}
extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}