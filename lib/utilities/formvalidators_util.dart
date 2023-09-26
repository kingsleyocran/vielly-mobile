class Validators {
  static validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }

  static validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }

    if (!value.contains(new RegExp(r'[A-Z]')) &&
        !value.contains(new RegExp(r'[a-z]'))) {
      return "Password does not contain an alphabet";
    }

    if (!value.contains(new RegExp(r'[0-9]'))) {
      return "Password must contain at least one digit";
    }

    // if (!value.contains(new RegExp(r'[a-z]'))) {
    //   return "Password does not contain a lowercase character";
    // }

    // if(!value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return "Password must contain a special character";
    // }

    return null;
  }

  static validateEmpty(String value) {
    if (value.isEmpty) {
      return "Enter a valid value";
    }

    return null;
  }

  static validateLengthGreaterThan(String value, int length) {
    if (value.length > length) {
      return "Should not be longer than $length characters";
    }

    return null;
  }

  static validateLengthLessThan(String value, int length) {
    if (value.length < length) {
      return "Should be $length characters or longer";
    }

    return null;
  }

  static validateIntPhoneNumber(String value) {
    final v = validateEmpty(value);

    if (v == null) {
      Pattern pattern = r'(^(?:[+][0-9][3])?[0-9]{10,12}$)';
      RegExp regExp = RegExp(pattern.toString());
      if (!regExp.hasMatch(value))
        return "Enter a valid phone number";
      else
        return null;
    }
    return v;
  }

  static bool validateGhanaPostGPS(String value) {
    Pattern pattern = r'^([A-Z]{2})-([0-9]{3}|[0-9]{4})-([0-9]{4})$';
    RegExp regExp = RegExp(pattern.toString());

    if (!regExp.hasMatch(value)) {
      return false;
    }

    return true;
  }

  static bool validateTIN(String value) {
    Pattern pattern = r'^([A-Z]{1})([0-9]{10})$';
    RegExp regExp = RegExp(pattern.toString());

    if (!regExp.hasMatch(value)) {
      return false;
    }

    return true;
  }

  static validateIsNumeric(String? s) {
    if (s == null || double.parse(s) == null) {
      return "Enter a valid numeric value";
    }

    return null;
  }

  static validateName(String s) {
    if (s.length < 2) {
      return 'Your name should be more than one character long';
    }

    Pattern pattern = r'^[a-z A-Z,.\-]+$';
    RegExp regExp = RegExp(pattern.toString());

    if (!regExp.hasMatch(s)) {
      return 'Enter a valid name';
    }

    return null;
  }

  static validateURL(String? s) {
    if (s == null) {
      return null;
    }

    Pattern pattern =
        r"(https://|http://)?([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    bool match = new RegExp(pattern.toString(), caseSensitive: false).hasMatch(s);
    if (!match) {
      return "Enter a valid URL";
    }

    return null;
  }
}
