class GlobalState {
  static List<String> _classNames = [];

  static List<String> getClassNames() => List.unmodifiable(_classNames);

  static void addClassName(String name) {
    _classNames.add(name);
  }
}
