// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'virtual_pilgrimage_user.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_VirtualPilgrimageUser _$$_VirtualPilgrimageUserFromJson(
        Map<String, dynamic> json) =>
    _$_VirtualPilgrimageUser(
      id: json['id'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      gender: json['gender'] == null
          ? Gender.unknown
          : _GenderConverter.intToGender(json['gender'] as int),
      birthDay: FirestoreTimestampConverter.timestampToDateTime(
          json['birthDay'] as Timestamp),
      email: json['email'] as String? ?? '',
      userIconUrl: json['userIconUrl'] as String? ??
          'https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-dev.appspot.com/o/icon512.jpg?alt=media',
      userStatus: json['userStatus'] == null
          ? UserStatus.temporary
          : _UserStatusConverter.intToUserStatus(json['userStatus'] as int),
      createdAt: FirestoreTimestampConverter.timestampToDateTime(
          json['createdAt'] as Timestamp),
      updatedAt: FirestoreTimestampConverter.timestampToDateTime(
          json['updatedAt'] as Timestamp),
      health: json['health'] == null
          ? null
          : HealthInfo.fromJson(json['health'] as Map<String, dynamic>),
      pilgrimage:
          PilgrimageInfo.fromJson(json['pilgrimage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_VirtualPilgrimageUserToJson(
        _$_VirtualPilgrimageUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'gender': _GenderConverter.genderToInt(instance.gender),
      'birthDay':
          FirestoreTimestampConverter.dateTimeToTimestamp(instance.birthDay),
      'email': instance.email,
      'userIconUrl': instance.userIconUrl,
      'userStatus': _UserStatusConverter.userStatusToInt(instance.userStatus),
      'createdAt':
          FirestoreTimestampConverter.dateTimeToTimestamp(instance.createdAt),
      'updatedAt':
          FirestoreTimestampConverter.dateTimeToTimestamp(instance.updatedAt),
      'health': instance.health?.toJson(),
      'pilgrimage': instance.pilgrimage.toJson(),
    };
