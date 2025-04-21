import '../models/course.dart';

final List<Map<String, String>> categories = [
  {'name': 'Programming', 'icon': 'code', 'color': '#3498db'},
  {'name': 'Mathematics', 'icon': 'calculate', 'color': '#e74c3c'},
  {'name': 'Science', 'icon': 'science', 'color': '#2ecc71'},
  {'name': 'Language', 'icon': 'translate', 'color': '#9b59b6'},
  {'name': 'Arts', 'icon': 'palette', 'color': '#f39c12'},
];

final List<Course> sampleCourses = [
  Course(
    id: '1',
    title: 'Flutter for Beginners',
    description:
        'Learn Flutter from the ground up. This course covers everything you need to know to get started with Flutter development.',
    imageUrl: 'https://placehold.co/600x400/3498db/FFFFFF.png?text=Flutter',
    category: 'Programming',
    duration: 420, // 7 hours
    lessonsCount: 12,
    rating: 4.8,
    creatorId: 'c1', // Professor Smith
    price: 49.99,
    isFree: false,
    lessons: [
      Lesson(
        id: '1-1',
        title: 'Introduction to Flutter',
        description: 'Learn what Flutter is and how it works',
        duration: 20,
        videoUrl: 'https://example.com/flutter-intro',
        isPreview: true, // Preview lesson is free
        quiz: [
          QuizQuestion(
            question: 'What programming language does Flutter use?',
            options: ['Java', 'Kotlin', 'Swift', 'Dart'],
            correctAnswerIndex: 3,
          ),
          QuizQuestion(
            question: 'Which company developed Flutter?',
            options: ['Apple', 'Google', 'Microsoft', 'Facebook'],
            correctAnswerIndex: 1,
          ),
        ],
      ),
      Lesson(
        id: '1-2',
        title: 'Setting up your Flutter Environment',
        description: 'Install and configure Flutter on your machine',
        duration: 30,
        videoUrl: 'https://example.com/flutter-setup',
      ),
      Lesson(
        id: '1-3',
        title: 'Creating Your First Flutter App',
        description: 'Build a simple app with Flutter',
        duration: 45,
        videoUrl: 'https://example.com/first-flutter-app',
      ),
    ],
  ),
  Course(
    id: '2',
    title: 'Basic Algebra',
    description:
        'Master the fundamentals of algebra including equations, functions, and graphs.',
    imageUrl: 'https://placehold.co/600x400/e74c3c/FFFFFF.png?text=Algebra',
    category: 'Mathematics',
    duration: 300, // 5 hours
    lessonsCount: 10,
    rating: 4.5,
    creatorId: 'c2', // Dr. Rebecca Johnson
    price: 29.99,
    isFree: false,
    lessons: [
      Lesson(
        id: '2-1',
        title: 'Introduction to Algebra',
        description: 'Basic concepts and notations in algebra',
        duration: 25,
        videoUrl: 'https://example.com/algebra-intro',
        isPreview: true,
      ),
      Lesson(
        id: '2-2',
        title: 'Solving Linear Equations',
        description: 'Learn how to solve equations with one variable',
        duration: 35,
        videoUrl: 'https://example.com/linear-equations',
        quiz: [
          QuizQuestion(
            question: 'Solve for x: 3x + 5 = 20',
            options: ['x = 5', 'x = 15', 'x = 3', 'x = 7.5'],
            correctAnswerIndex: 0,
          ),
        ],
      ),
    ],
  ),
  Course(
    id: '3',
    title: 'Introduction to Physics',
    description:
        'Discover the fundamental principles of physics and how they explain the world around us.',
    imageUrl: 'https://placehold.co/600x400/2ecc71/FFFFFF.png?text=Physics',
    category: 'Science',
    duration: 360, // 6 hours
    lessonsCount: 8,
    rating: 4.7,
    creatorId: 'c3', // Dr. Michael Chen
    price: 39.99,
    isFree: false,
    lessons: [
      Lesson(
        id: '3-1',
        title: 'Newton\'s Laws of Motion',
        description:
            'Understanding the three laws that form the foundation of classical mechanics',
        duration: 40,
        videoUrl: 'https://example.com/newtons-laws',
        isPreview: true,
      ),
    ],
  ),
  Course(
    id: '4',
    title: 'Spanish for Beginners',
    description:
        'Start your journey to Spanish fluency with this comprehensive beginner course.',
    imageUrl: 'https://placehold.co/600x400/9b59b6/FFFFFF.png?text=Spanish',
    category: 'Language',
    duration: 480, // 8 hours
    lessonsCount: 15,
    rating: 4.6,
    creatorId: 'c2', // Dr. Rebecca Johnson
    price: 34.99,
    isFree: false,
    lessons: [
      Lesson(
        id: '4-1',
        title: 'Basic Greetings and Introductions',
        description:
            'Learn how to introduce yourself and greet others in Spanish',
        duration: 30,
        videoUrl: 'https://example.com/spanish-intro',
        isPreview: true,
      ),
    ],
  ),
  Course(
    id: '5',
    title: 'Drawing Fundamentals',
    description:
        'Learn the core principles of drawing and artistic expression.',
    imageUrl: 'https://placehold.co/600x400/f39c12/FFFFFF.png?text=Drawing',
    category: 'Arts',
    duration: 390, // 6.5 hours
    lessonsCount: 9,
    rating: 4.9,
    creatorId: 'c1', // Professor Smith
    price: 0.0,
    isFree: true, // Free course
    lessons: [
      Lesson(
        id: '5-1',
        title: 'Understanding Perspective',
        description:
            'Master the principles of linear perspective for realistic drawings',
        duration: 45,
        videoUrl: 'https://example.com/perspective-drawing',
      ),
    ],
  ),
];
