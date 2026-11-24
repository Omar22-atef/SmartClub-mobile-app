/// Date helpers shared across features.
///
/// Named `AppDateUtils` to avoid clashing with Flutter's built-in `DateUtils`.
class AppDateUtils {
  AppDateUtils._();

  /// Strips the time part of [date].
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Today's date at midnight (local time).
  static DateTime today() => dateOnly(DateTime.now());

  /// Adds calendar months to [date].
  ///
  /// If the target month is shorter, the day is clamped to the last day of
  /// that month (e.g. Jan 31 + 1 month = Feb 28/29).
  static DateTime addMonths(DateTime date, int months) {
    final totalMonths = date.year * 12 + (date.month - 1) + months;
    final year = totalMonths ~/ 12;
    final month = totalMonths % 12 + 1;
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final day = date.day > lastDayOfMonth ? lastDayOfMonth : date.day;
    return DateTime(year, month, day);
  }

  /// Whole calendar days from [from] to [to] (negative if [to] is earlier).
  ///
  /// Uses UTC internally so daylight-saving changes never cause off-by-one
  /// errors.
  static int daysBetween(DateTime from, DateTime to) {
    final start = DateTime.utc(from.year, from.month, from.day);
    final end = DateTime.utc(to.year, to.month, to.day);
    return end.difference(start).inDays;
  }
}
