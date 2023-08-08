class StringHelper {
  // static convertStringToSlug({required String str, bool unique = false}) {
  //   String uniqueStr = "";
  //
  //   if (unique) {
  //     uniqueStr = DateTimeHelper.getCurrentMillisecondTime();
  //   }
  //
  //   return slugify("$str $uniqueStr", delimiter: "_");
  // }

  static int? toInt(dynamic input) {
    try {
      if (input is int) {
        return input;
      } else {
        return int.tryParse(input);
      }
    } catch (ex) {
      return null;
    }
  }

  static double? toDouble({dynamic input, dynamic defaultValue}) {
    try {
      if (input is double) {
        return input;
      } else {
        return double.tryParse(input);
      }
    } catch (ex) {
      print("Exception $ex");
      return defaultValue;
    }
  }

  static String parseToString(dynamic input) {
    if (input == null) {
      return "";
    }
    return "$input";
  }

  static String prettify(double? d) {
    if (d == null) return '';
    return d.toStringAsFixed(1).replaceFirst(RegExp(r'\.?0*$'), '');
  }
}
