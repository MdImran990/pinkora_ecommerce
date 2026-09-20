import 'package:intl/intl.dart';

/// 2100 -> "৳ 2,100"
String formatTaka(num value) {
  return '৳ ${NumberFormat('#,##0').format(value)}';
}

/// "20 Sep 2026, 04:35 PM"
String formatDateTime(DateTime date) {
  return DateFormat('dd MMM yyyy, hh:mm a').format(date);
}

/// "20 Sep 2026"
String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
}

/// "Just now", "5 min ago", "3 hr ago", "2 days ago", otherwise a date.
String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} hr ago';
  if (diff.inDays < 7) return '${diff.inDays} days ago';

  return formatDate(date);
}
