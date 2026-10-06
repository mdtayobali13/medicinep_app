import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final String message;
  final String date;

  NotificationModel({
    required this.id,
    required this.message,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      message: json['data']?.toString() ?? json['message']?.toString() ?? json['title']?.toString() ?? '',
      date: json['date']?.toString() != null ? json['date'].toString() : _formatDate(json['created_at']?.toString() ?? ''),
    );
  }

  static String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd-MM-yyyy hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
