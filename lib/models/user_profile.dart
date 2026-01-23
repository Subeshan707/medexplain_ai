import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String uid;
  final String email;
  final String role; // 'patient' or 'clinician'
  final String name;
  final String? photoUrl;
  
  // Clinician specific
  final String? clinicName;
  final String? specialty;
  final String? clinicAddress;
  
  // Patient specific
  final int? age;
  final String? gender;
  
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
    this.photoUrl,
    this.clinicName,
    this.specialty,
    this.clinicAddress,
    this.age,
    this.gender,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
  
  static DateTime? _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return null;
  }

  static dynamic _timestampToJson(DateTime? date) => 
      date != null ? Timestamp.fromDate(date) : FieldValue.serverTimestamp();
}
