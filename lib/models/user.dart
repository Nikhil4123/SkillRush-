import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, creator }

class User {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final UserRole role;
  final String bio;
  final List<String> enrolledCourseIds; // For students
  final List<String> createdCourseIds; // For creators
  final DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.role,
    required this.bio,
    this.enrolledCourseIds = const [],
    this.createdCourseIds = const [],
    required this.joinDate,
  });

  bool get isCreator => role == UserRole.creator;
  bool get isStudent => role == UserRole.student;

  // Create a User from Firestore data
  factory User.fromFirestore(String uid, Map<String, dynamic> data) {
    return User(
      id: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? 'https://ui-avatars.com/api/?name=User',
      role: data['isCreator'] == true ? UserRole.creator : UserRole.student,
      bio: data['bio'] ?? '',
      enrolledCourseIds: List<String>.from(data['enrolledCourseIds'] ?? []),
      createdCourseIds: List<String>.from(data['createdCourseIds'] ?? []),
      joinDate:
          data['joinDate'] != null
              ? (data['joinDate'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  // Convert User to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'isCreator': isCreator,
      'isStudent': isStudent,
      'bio': bio,
      'enrolledCourseIds': enrolledCourseIds,
      'createdCourseIds': createdCourseIds,
      'joinDate': joinDate,
    };
  }
}
