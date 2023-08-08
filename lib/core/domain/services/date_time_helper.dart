import 'package:intl/intl.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';

class DateTimeHelper {
  static const String dateFormat = "dd/MM/yyyy";
  static const String dateTimeFormat = "dd/MM/yyyy HH:mm:ss";
  static const String dateTimeFormatForField = "yyyy-MM-dd hh:mm:ss";
  static const String savingFormat = 'yyyy-MM-dd';

  static String formattedDateTime(
      {required String? str, String format = dateFormat}) {
    try {
      if (str == "" || str == null) return "";
      DateTime dateTime = DateTime.parse(str).toLocal();
      return DateFormat(format).format(dateTime);
    } catch (ex) {
      return LocalizationService.translate.cm_error;
    }
  }

  static DateTime? convertStringToDateTime({required dynamic str}) {
    try {
      str = str.toString();
      return DateTime.parse(str).toLocal();
    } catch (ex) {
      return null;
    }
  }

  static String getCurrentMillisecondTime() {
    DateTime now = DateTime.now().toLocal();
    return now.microsecondsSinceEpoch.toString();
  }

  static String getCurrentTimeAsString(
      {String format = dateFormat,
      int diffDay = 0,
      int diffMonth = 0,
      int diffYear = 0}) {
    DateTime now = DateTime.now().toLocal();
    var diffDate =
        DateTime(now.year + diffYear, now.month + diffMonth, now.day + diffDay)
            .toLocal();
    return DateFormat(format).format(diffDate);
  }

  static String convertDateTimeToString(
      {required DateTime? dateTime, String format = dateFormat}) {
    try {
      return DateFormat(format).format(dateTime!.toLocal());
    } catch (ex) {
      return "";
    }
  }
}
