// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  uid: json['uid'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  name: json['name'] as String,
  photoUrl: json['photoUrl'] as String?,
  clinicName: json['clinicName'] as String?,
  specialty: json['specialty'] as String?,
  clinicAddress: json['clinicAddress'] as String?,
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  createdAt: UserProfile._timestampFromJson(json['createdAt']),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'role': instance.role,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'clinicName': instance.clinicName,
      'specialty': instance.specialty,
      'clinicAddress': instance.clinicAddress,
      'age': instance.age,
      'gender': instance.gender,
      'createdAt': UserProfile._timestampToJson(instance.createdAt),
    };
