/// Treatment Model
/// Represents a medical treatment or procedure
class Treatment {
  final String id;
  final String patientId;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime scheduledDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? assignedDoctor;
  final String? assignedNurse;
  final List<String> medications;
  final String? notes;
  final double? cost;
  final String? paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const Treatment({
    required this.id,
    required this.patientId,
    required this.title,
    required this.description,
    this.status = 'pending',
    this.priority = 'normal',
    required this.scheduledDate,
    this.startDate,
    this.endDate,
    this.assignedDoctor,
    this.assignedNurse,
    this.medications = const [],
    this.notes,
    this.cost,
    this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  /// Create Treatment from JSON
  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String? ?? 'pending',
      priority: json['priority'] as String? ?? 'normal',
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date'] as String) 
          : null,
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'] as String) 
          : null,
      assignedDoctor: json['assigned_doctor'] as String?,
      assignedNurse: json['assigned_nurse'] as String?,
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ?? [],
      notes: json['notes'] as String?,
      cost: json['cost'] != null ? (json['cost'] as num).toDouble() : null,
      paymentStatus: json['payment_status'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert Treatment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'scheduled_date': scheduledDate.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'assigned_doctor': assignedDoctor,
      'assigned_nurse': assignedNurse,
      'medications': medications,
      'notes': notes,
      'cost': cost,
      'payment_status': paymentStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a copy of Treatment with updated fields
  Treatment copyWith({
    String? id,
    String? patientId,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? scheduledDate,
    DateTime? startDate,
    DateTime? endDate,
    String? assignedDoctor,
    String? assignedNurse,
    List<String>? medications,
    String? notes,
    double? cost,
    String? paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Treatment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      assignedDoctor: assignedDoctor ?? this.assignedDoctor,
      assignedNurse: assignedNurse ?? this.assignedNurse,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      cost: cost ?? this.cost,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if treatment is pending
  bool get isPending => status == 'pending';

  /// Check if treatment is in progress
  bool get isInProgress => status == 'in_progress';

  /// Check if treatment is completed
  bool get isCompleted => status == 'completed';

  /// Check if treatment is cancelled
  bool get isCancelled => status == 'cancelled';

  /// Check if treatment is high priority
  bool get isHighPriority => priority == 'high';

  /// Check if treatment is low priority
  bool get isLowPriority => priority == 'low';

  /// Check if treatment has started
  bool get hasStarted => startDate != null;

  /// Check if treatment is finished
  bool get isFinished => endDate != null;

  /// Calculate treatment duration in days
  int? get durationDays {
    if (startDate == null || endDate == null) return null;
    return endDate!.difference(startDate!).inDays;
  }

  /// Check if treatment is overdue
  bool get isOverdue {
    return scheduledDate.isBefore(DateTime.now()) && !isCompleted && !isCancelled;
  }

  /// Get status color for UI
  String get statusColor {
    switch (status) {
      case 'pending':
        return 'orange';
      case 'in_progress':
        return 'blue';
      case 'completed':
        return 'green';
      case 'cancelled':
        return 'red';
      default:
        return 'gray';
    }
  }

  /// Get priority color for UI
  String get priorityColor {
    switch (priority) {
      case 'high':
        return 'red';
      case 'normal':
        return 'blue';
      case 'low':
        return 'gray';
      default:
        return 'blue';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Treatment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Treatment(id: $id, title: $title, status: $status, priority: $priority)';
  }
}