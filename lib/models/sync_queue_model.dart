import 'dart:convert';

/// ============================================================
/// SYNC QUEUE MODEL — Represents pending offline actions
/// ============================================================

class SyncQueueModel {
  final String id;
  final String action;     // e.g., 'ADD_RECORD', 'ADD_AI_REPORT'
  final Map<String, dynamic> payload; // Data to be synced
  final DateTime createdAt;
  final int retryCount;

  const SyncQueueModel({
    required this.id,
    required this.action,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  factory SyncQueueModel.fromMap(Map<String, dynamic> map) {
    return SyncQueueModel(
      id: map['id'],
      action: map['action'],
      payload: json.decode(map['payload']),
      createdAt: DateTime.parse(map['createdAt']),
      retryCount: map['retryCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'payload': json.encode(payload),
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
    };
  }
}
