class Utilities {
  static final Map<String, int> _counters = Map();

  static String generateFileName(String extension) {
    String date = DateTime.now().toString().substring(0, 10);

    int counter = (_counters[extension] ?? 0) + 1;
    _counters[extension] = counter;
    return 'ytd$date|$counter.$extension';
  }
}
