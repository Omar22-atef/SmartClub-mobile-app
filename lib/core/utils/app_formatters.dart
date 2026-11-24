/// Text formatting helpers (dates, times, money) shared across features.
class AppFormatters {
  AppFormatters._();

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// e.g. `Nov 24, 2026`
  static String date(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  /// e.g. `Tuesday, Nov 24, 2026`
  static String longDate(DateTime d) => '${_weekdays[d.weekday - 1]}, ${date(d)}';

  /// e.g. `04:58 PM`
  static String time(DateTime d) {
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour < 12 ? 'AM' : 'PM';
    return '${hour12.toString().padLeft(2, '0')}:$minute $period';
  }

  /// e.g. `Nov 24, 2026 • 04:58 PM`
  static String dateTime(DateTime d) => '${date(d)} • ${time(d)}';

  /// e.g. `$129` or `$12.50`
  static String currency(double value) {
    final isWhole = value == value.roundToDouble();
    return '\$${value.toStringAsFixed(isWhole ? 0 : 2)}';
  }

  /// e.g. `Just now`, `5m ago`, `3h ago`, `Yesterday`, `4 days ago`.
  static String relative(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inHours < 48) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return date(d);
  }
}
