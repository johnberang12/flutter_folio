// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//A type representing the currentUser.uid
typedef UserID = String;

class AppUser {
  final UserID uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
  });

  AppUser copyWith({
    UserID? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
    };
  }

  static AppUser? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return AppUser(
      uid: map['uid'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      photoUrl: map['photoUrl'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  static AppUser? fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUser(uid: $uid, name: $name, email: $email, phoneNumber: $phoneNumber, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        photoUrl.hashCode;
  }
}
