// Firebase Configuration
// This file contains endpoints and collection names for Firebase services

class FirebaseConfig {
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String coursesCollection = 'courses';
  static const String enrollmentsCollection = 'enrollments';
  static const String lessonsCollection = 'lessons';
  static const String quizzesCollection = 'quizzes';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String courseImagesPath = 'course_images';
  static const String lessonVideosPath = 'lesson_videos';

  // Default Values
  static const String defaultProfileImage =
      'https://ui-avatars.com/api/?background=random';
  static const String defaultCourseImage =
      'https://placehold.co/600x400/2979FF/FFFFFF.png?text=Course';
}
