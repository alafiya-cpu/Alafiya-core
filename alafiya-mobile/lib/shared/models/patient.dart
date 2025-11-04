/// Patient Model
/// Represents a patient in the healthcare system
class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String? phone;
  final String? email;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? medicalHistory;
  final String? allergies;
  final String? medications;
  final String bloodType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    this.phone,
    this.email,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.medicalHistory,
    this.allergies,
    this.medications,
    required this.bloodType,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  /// Create Patient from JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      medicalHistory: json['medical_history'] as String?,
      allergies: json['allergies'] as String?,
      medications: json['medications'] as String?,
      bloodType: json['blood_type'] as String,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert Patient to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'email': email,
      'address': address,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'medical_history': medicalHistory,
      'allergies': allergies,
      'medications': medications,
      'blood_type': bloodType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a copy of Patient with updated fields
  Patient copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    String? phone,
    String? email,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? medicalHistory,
    String? allergies,
    String? medications,
    String? bloodType,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Patient(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      bloodType: bloodType ?? this.bloodType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Full name of the patient
  String get fullName => '$firstName $lastName';

  /// Calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    
    if (now.month < dateOfBirth.month || 
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    
    return age;
  }

  /// Check if patient is active
  bool get isActive => status == 'active';

  /// Check if patient is discharged
  bool get isDischarged => status == 'discharged';

  /// Check if patient is admitted
  bool get isAdmitted => status == 'admitted';

  /// Get formatted display name
  String get displayName => fullName;

  /// Check if has allergies
  bool get hasAllergies => (allergies?.trim().isNotEmpty ?? false);

  /// Check if has medical history
  bool get hasMedicalHistory => (medicalHistory?.trim().isNotEmpty ?? false);

  /// Check if has current medications
  bool get hasMedications => (medications?.trim().isNotEmpty ?? false);

  /// Check if has emergency contact
  bool get hasEmergencyContact => 
      (emergencyContactName?.trim().isNotEmpty ?? false) ||
      (emergencyContactPhone?.trim().isNotEmpty ?? false);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Patient && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Patient(id: $id, name: $displayName, status: $status)';
  }
}