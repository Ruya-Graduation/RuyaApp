import 'package:equatable/equatable.dart';

class LocalBookingModel extends Equatable {
  final String referenceNumber;
  final String siteId;
  final String siteName;
  final DateTime visitDate;
  final String timeSlot;
  final int ticketCount;
  final double pricePerTicket;
  final String currency;
  final DateTime createdAt;
  final int? backendReservationId;
  final bool reminderEnabled;
  final DateTime? reminderDateTime;
  final int? notificationId;

  double get totalPrice => ticketCount * pricePerTicket;

  const LocalBookingModel({
    required this.referenceNumber,
    required this.siteId,
    required this.siteName,
    required this.visitDate,
    required this.timeSlot,
    required this.ticketCount,
    required this.pricePerTicket,
    required this.currency,
    required this.createdAt,
    this.backendReservationId,
    this.reminderEnabled = false,
    this.reminderDateTime,
    this.notificationId,
  });

  LocalBookingModel copyWith({
    String? referenceNumber,
    String? siteId,
    String? siteName,
    DateTime? visitDate,
    String? timeSlot,
    int? ticketCount,
    double? pricePerTicket,
    String? currency,
    DateTime? createdAt,
    int? backendReservationId,
    bool? reminderEnabled,
    DateTime? reminderDateTime,
    int? notificationId,
    bool clearReminderDateTime = false,
    bool clearNotificationId = false,
    bool clearBackendReservationId = false,
  }) {
    return LocalBookingModel(
      referenceNumber: referenceNumber ?? this.referenceNumber,
      siteId: siteId ?? this.siteId,
      siteName: siteName ?? this.siteName,
      visitDate: visitDate ?? this.visitDate,
      timeSlot: timeSlot ?? this.timeSlot,
      ticketCount: ticketCount ?? this.ticketCount,
      pricePerTicket: pricePerTicket ?? this.pricePerTicket,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      backendReservationId: clearBackendReservationId
          ? null
          : (backendReservationId ?? this.backendReservationId),
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderDateTime: clearReminderDateTime
          ? null
          : (reminderDateTime ?? this.reminderDateTime),
      notificationId: clearNotificationId
          ? null
          : (notificationId ?? this.notificationId),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referenceNumber': referenceNumber,
      'siteId': siteId,
      'siteName': siteName,
      'visitDate': visitDate.toIso8601String(),
      'timeSlot': timeSlot,
      'ticketCount': ticketCount,
      'pricePerTicket': pricePerTicket,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'backendReservationId': backendReservationId,
      'reminderEnabled': reminderEnabled,
      'reminderDateTime': reminderDateTime?.toIso8601String(),
      'notificationId': notificationId,
    };
  }

  factory LocalBookingModel.fromJson(Map<String, dynamic> json) {
    return LocalBookingModel(
      referenceNumber: json['referenceNumber'] as String,
      siteId: json['siteId'] as String,
      siteName: json['siteName'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      timeSlot: json['timeSlot'] as String? ?? '08:00 AM Entry',
      ticketCount: (json['ticketCount'] as num).toInt(),
      pricePerTicket: (json['pricePerTicket'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EGP',
      createdAt: DateTime.parse(json['createdAt'] as String),
      backendReservationId: json['backendReservationId'] as int?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
      reminderDateTime: json['reminderDateTime'] != null
          ? DateTime.parse(json['reminderDateTime'] as String)
          : null,
      notificationId: json['notificationId'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        referenceNumber,
        siteId,
        siteName,
        visitDate,
        timeSlot,
        ticketCount,
        pricePerTicket,
        currency,
        createdAt,
        backendReservationId,
        reminderEnabled,
        reminderDateTime,
        notificationId,
      ];
}
