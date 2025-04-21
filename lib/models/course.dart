import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final int duration; // in minutes
  final int lessonsCount;
  final double rating;
  final List<Lesson> lessons;
  final String creatorId; // ID of the creator
  final double price; // Price in USD
  final bool isFree; // Whether the course is free
  final int enrollmentCount; // Number of enrolled students

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.duration,
    required this.lessonsCount,
    required this.rating,
    required this.lessons,
    required this.creatorId,
    this.price = 0.0,
    this.isFree = false,
    this.enrollmentCount = 0,
  });

  // Create a Course from Firestore data
  factory Course.fromFirestore(String id, Map<String, dynamic> data) {
    List<Lesson> lessonsList = [];
    if (data['lessons'] != null) {
      lessonsList =
          (data['lessons'] as List).map((lessonData) {
            return Lesson.fromMap(lessonData as Map<String, dynamic>);
          }).toList();
    }

    return Course(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Uncategorized',
      duration: data['duration'] ?? 0,
      lessonsCount: data['lessonsCount'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      lessons: lessonsList,
      creatorId: data['creatorId'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      isFree: data['isFree'] ?? false,
      enrollmentCount: data['enrollmentCount'] ?? 0,
    );
  }

  // Convert Course to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'duration': duration,
      'lessonsCount': lessonsCount,
      'rating': rating,
      'lessons': lessons.map((lesson) => lesson.toMap()).toList(),
      'creatorId': creatorId,
      'price': price,
      'isFree': isFree,
      'enrollmentCount': enrollmentCount,
    };
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final int duration; // in minutes
  final String videoUrl;
  final List<QuizQuestion>? quiz;
  final bool isPreview; // Whether the lesson is available as a preview

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.videoUrl,
    this.quiz,
    this.isPreview = false,
  });

  // Create a Lesson from a Map
  factory Lesson.fromMap(Map<String, dynamic> data) {
    List<QuizQuestion>? quizList;

    if (data['quiz'] != null) {
      quizList =
          (data['quiz'] as List).map((quizData) {
            return QuizQuestion.fromMap(quizData as Map<String, dynamic>);
          }).toList();
    }

    return Lesson(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: data['duration'] ?? 0,
      videoUrl: data['videoUrl'] ?? '',
      quiz: quizList,
      isPreview: data['isPreview'] ?? false,
    );
  }

  // Convert Lesson to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'videoUrl': videoUrl,
      'quiz': quiz?.map((q) => q.toMap()).toList(),
      'isPreview': isPreview,
    };
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  // Create a QuizQuestion from a Map
  factory QuizQuestion.fromMap(Map<String, dynamic> data) {
    return QuizQuestion(
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
    );
  }

  // Convert QuizQuestion to a Map
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
