import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/course.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User related methods
  Future<User> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception('User not found');
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return User.fromFirestore(uid, data);
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Course related methods
  Future<List<Course>> getCourses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('courses').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Course.fromFirestore(doc.id, data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get courses: $e');
    }
  }

  Future<Course> getCourseById(String courseId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('courses').doc(courseId).get();

      if (!doc.exists) {
        throw Exception('Course not found');
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Course.fromFirestore(courseId, data);
    } catch (e) {
      throw Exception('Failed to get course: $e');
    }
  }

  Future<List<Course>> getUserCourses(String uid, bool isCreator) async {
    try {
      QuerySnapshot snapshot;
      if (isCreator) {
        snapshot =
            await _firestore
                .collection('courses')
                .where('creatorId', isEqualTo: uid)
                .get();
      } else {
        // Get user data to find enrolled courses
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(uid).get();
        if (!userDoc.exists) {
          throw Exception('User not found');
        }

        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<String> enrolledCourseIds = List<String>.from(
          userData['enrolledCourseIds'] ?? [],
        );

        if (enrolledCourseIds.isEmpty) {
          return [];
        }

        snapshot =
            await _firestore
                .collection('courses')
                .where(FieldPath.documentId, whereIn: enrolledCourseIds)
                .get();
      }

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Course.fromFirestore(doc.id, data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get user courses: $e');
    }
  }

  Future<String> createCourse(Map<String, dynamic> courseData) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('courses')
          .add(courseData);

      // Add course ID to creator's list
      await _firestore.collection('users').doc(courseData['creatorId']).update({
        'createdCourseIds': FieldValue.arrayUnion([docRef.id]),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  Future<void> updateCourse(String courseId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('courses').doc(courseId).update(data);
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  Future<void> enrollInCourse(String uid, String courseId) async {
    try {
      // Add course to user's enrolled courses
      await _firestore.collection('users').doc(uid).update({
        'enrolledCourseIds': FieldValue.arrayUnion([courseId]),
      });

      // Increment course enrollment count
      await _firestore.collection('courses').doc(courseId).update({
        'enrollmentCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }
}
