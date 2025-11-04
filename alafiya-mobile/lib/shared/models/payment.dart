/// Payment Model
/// Represents a payment transaction in the healthcare system
class Payment {
  final String id;
  final String patientId;
  final String treatmentId;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final String method;
  final String? transactionId;
  final String? referenceNumber;
  final DateTime? paymentDate;
  final DateTime dueDate;
  final String? description;
  final String? notes;
  final List<String> items;
  final double? taxAmount;
  final double? discountAmount;
  final double? totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const Payment({
    required this.id,
    required this.patientId,
    required this.treatmentId,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    this.status = 'pending',
    required this.method,
    this.transactionId,
    this.referenceNumber,
    this.paymentDate,
    required this.dueDate,
    this.description,
    this.notes,
    this.items = const [],
    this.taxAmount,
    this.discountAmount,
    this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  /// Create Payment from JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      treatmentId: json['treatment_id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      status: json['status'] as String? ?? 'pending',
      method: json['method'] as String,
      transactionId: json['transaction_id'] as String?,
      referenceNumber: json['reference_number'] as String?,
      paymentDate: json['payment_date'] != null 
          ? DateTime.parse(json['payment_date'] as String) 
          : null,
      dueDate: DateTime.parse(json['due_date'] as String),
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ?? [],
      taxAmount: json['tax_amount'] != null 
          ? (json['tax_amount'] as num).toDouble() 
          : null,
      discountAmount: json['discount_amount'] != null 
          ? (json['discount_amount'] as num).toDouble() 
          : null,
      totalAmount: json['total_amount'] != null 
          ? (json['total_amount'] as num).toDouble() 
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert Payment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'treatment_id': treatmentId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'status': status,
      'method': method,
      'transaction_id': transactionId,
      'reference_number': referenceNumber,
      'payment_date': paymentDate?.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'description': description,
      'notes': notes,
      'items': items,
      'tax_amount': taxAmount,
      'discount_amount': discountAmount,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a copy of Payment with updated fields
  Payment copyWith({
    String? id,
    String? patientId,
    String? treatmentId,
    String? type,
    double? amount,
    String? currency,
    String? status,
    String? method,
    String? transactionId,
    String? referenceNumber,
    DateTime? paymentDate,
    DateTime? dueDate,
    String? description,
    String? notes,
    List<String>? items,
    double? taxAmount,
    double? discountAmount,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Payment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      treatmentId: treatmentId ?? this.treatmentId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      method: method ?? this.method,
      transactionId: transactionId ?? this.transactionId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      paymentDate: paymentDate ?? this.paymentDate,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if payment is pending
  bool get isPending => status == 'pending';

  /// Check if payment is completed
  bool get isCompleted => status == 'completed';

  /// Check if payment failed
  bool get isFailed => status == 'failed';

  /// Check if payment is refunded
  bool get isRefunded => status == 'refunded';

  /// Check if payment is overdue
  bool get isOverdue {
    return dueDate.isBefore(DateTime.now()) && !isCompleted && !isRefunded;
  }

  /// Calculate the actual total amount including tax and discount
  double get calculatedTotal {
    double total = amount;
    if (taxAmount != null) total += taxAmount!;
    if (discountAmount != null) total -= discountAmount!;
    return total;
  }

  /// Check if payment is fully paid
  bool get isFullyPaid {
    return totalAmount != null && calculatedTotal <= amount;
  }

  /// Get remaining amount to be paid
  double get remainingAmount {
    if (isCompleted || isRefunded) return 0;
    return calculatedTotal;
  }

  /// Get status color for UI
  String get statusColor {
    switch (status) {
      case 'pending':
        return 'orange';
      case 'completed':
        return 'green';
      case 'failed':
        return 'red';
      case 'refunded':
        return 'blue';
      default:
        return 'gray';
    }
  }

  /// Check if it's a consultation fee
  bool get isConsultationFee => type == 'consultation';

  /// Check if it's a treatment fee
  bool get isTreatmentFee => type == 'treatment';

  /// Check if it's a medication fee
  bool get isMedicationFee => type == 'medication';

  /// Check if it's a procedure fee
  bool get isProcedureFee => type == 'procedure';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Payment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Payment(id: $id, amount: $amount, status: $status, type: $type)';
  }
}