extension MaxLength on List<String> {
  int get maxLength {
    int max = 0;
    for (final item in this) {
      if (item.length > max) max = item.length;
    }
    return max;
  }
}

extension ListContains on String {
  bool containsAny(List<String> items) {
    for (final item in items) {
      if (indexOf(item) != -1) return true;
    }
    return false;
  }

  bool containsAll(List<String> items) {
    for (final item in items) {
      if (indexOf(item) == -1) return false;
    }
    return true;
  }
}

extension CaseHelper on List<String> {
  List<String> toLowerCase() => List.generate(
        length,
        (index) => this[index].toLowerCase(),
      );

  List<String> toUpperCase() => List.generate(
        length,
        (index) => this[index].toUpperCase(),
      );

  void makeLowerCase() {
    for (int i = 0; i < length; i++) {
      this[i] = this[i].toLowerCase();
    }
  }

  void makeUpperCase() {
    for (int i = 0; i < length; i++) {
      this[i] = this[i].toUpperCase();
    }
  }
}
