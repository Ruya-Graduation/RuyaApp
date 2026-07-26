class Validators {
  static String? name(String? value, String requiredError) {
    if (value == null || value.trim().isEmpty) {
      return requiredError;
    }
    return null;
  }

  static String? email(String? value, String invalidError) {
    if (value == null || value.trim().isEmpty) {
      return invalidError;
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return invalidError;
    }
    return null;
  }

  static String? password(String? value, String minError) {
    if (value == null || value.trim().length < 8) {
      return minError;
    }
    return null;
  }
}
