import '../models/course.dart';

final List<Map<String, String>> categories = [
  {'name': 'Programming', 'icon': 'code', 'color': '#3498db'},
  {'name': 'Mathematics', 'icon': 'calculate', 'color': '#e74c3c'},
  {'name': 'Science', 'icon': 'science', 'color': '#2ecc71'},
  {'name': 'Language', 'icon': 'translate', 'color': '#9b59b6'},
  {'name': 'Arts', 'icon': 'palette', 'color': '#f39c12'},
];

// Sample courses for testing
final List<Course> sampleCourses = [
  Course(
    id: '1',
    title: 'Flutter Masterclass',
    description:
        'Learn Flutter from scratch and build beautiful cross-platform apps',
    imageUrl: 'https://placehold.co/600x400/3498db/FFFFFF.png?text=Flutter',
    category: 'Programming',
    duration: 1200, // 20 hours
    lessonsCount: 42,
    rating: 4.8,
    lessons: [
      Lesson(
        id: '1_1',
        title: 'Introduction to Flutter',
        description: 'Overview of Flutter and its features',
        duration: 15,
        videoUrl: 'https://example.com/video1.mp4',
        isPreview: true,
      ),
      Lesson(
        id: '1_2',
        title: 'Setting Up Your Development Environment',
        description: 'Installing Flutter SDK and configuring your IDE',
        duration: 25,
        videoUrl: 'https://example.com/video2.mp4',
      ),
    ],
    creatorId: 'c1',
    price: 49.99,
    isFree: false,
    enrollmentCount: 123,
  ),
  Course(
    id: '2',
    title: 'Advanced Mathematics',
    description: 'Master complex mathematical concepts with clear explanations',
    imageUrl: 'https://placehold.co/600x400/e74c3c/FFFFFF.png?text=Math',
    category: 'Mathematics',
    duration: 1080, // 18 hours
    lessonsCount: 36,
    rating: 4.5,
    lessons: [
      Lesson(
        id: '2_1',
        title: 'Introduction to Calculus',
        description: 'Basic concepts of differentiation and integration',
        duration: 20,
        videoUrl: 'https://example.com/video3.mp4',
        isPreview: true,
      ),
      Lesson(
        id: '2_2',
        title: 'Limits and Continuity',
        description: 'Understanding limits and continuous functions',
        duration: 30,
        videoUrl: 'https://example.com/video4.mp4',
      ),
    ],
    creatorId: 'c2',
    price: 39.99,
    isFree: false,
    enrollmentCount: 87,
  ),
  Course(
    id: '3',
    title: 'Introduction to Physics',
    description: 'Learn the fundamental principles of physics and mechanics',
    imageUrl: 'https://placehold.co/600x400/2ecc71/FFFFFF.png?text=Physics',
    category: 'Science',
    duration: 960, // 16 hours
    lessonsCount: 32,
    rating: 4.7,
    lessons: [
      Lesson(
        id: '3_1',
        title: 'Newton\'s Laws of Motion',
        description: 'Understanding the three fundamental laws of motion',
        duration: 25,
        videoUrl: 'https://example.com/video5.mp4',
        isPreview: true,
      ),
      Lesson(
        id: '3_2',
        title: 'Work, Energy, and Power',
        description: 'Understanding how force produces work and energy',
        duration: 30,
        videoUrl: 'https://example.com/video6.mp4',
      ),
    ],
    creatorId: 'c3',
    price: 29.99,
    isFree: false,
    enrollmentCount: 105,
  ),
  Course(
    id: '4',
    title: 'Web Development Basics',
    description:
        'Start your journey into web development with HTML, CSS, and JavaScript',
    imageUrl: 'https://placehold.co/600x400/9b59b6/FFFFFF.png?text=Web',
    category: 'Programming',
    duration: 840, // 14 hours
    lessonsCount: 28,
    rating: 4.6,
    lessons: [
      Lesson(
        id: '4_1',
        title: 'HTML Fundamentals',
        description: 'Learn the basics of HTML markup language',
        duration: 20,
        videoUrl: 'https://example.com/video7.mp4',
        isPreview: true,
      ),
      Lesson(
        id: '4_2',
        title: 'CSS Styling',
        description: 'Make your websites beautiful with CSS',
        duration: 25,
        videoUrl: 'https://example.com/video8.mp4',
      ),
    ],
    creatorId: 'c1',
    price: 0,
    isFree: true,
    enrollmentCount: 215,
  ),
  Course(
    id: '5',
    title: 'Digital Art for Beginners',
    description: 'Learn the basics of digital art and illustration',
    imageUrl: 'https://placehold.co/600x400/1abc9c/FFFFFF.png?text=Art',
    category: 'Arts',
    duration: 720, // 12 hours
    lessonsCount: 24,
    rating: 4.9,
    lessons: [
      Lesson(
        id: '5_1',
        title: 'Digital Drawing Basics',
        description: 'Learn to use digital drawing tools effectively',
        duration: 30,
        videoUrl: 'https://example.com/video9.mp4',
        isPreview: true,
      ),
      Lesson(
        id: '5_2',
        title: 'Color Theory',
        description: 'Understanding color combinations and palettes',
        duration: 25,
        videoUrl: 'https://example.com/video10.mp4',
      ),
    ],
    creatorId: 'c3',
    price: 19.99,
    isFree: false,
    enrollmentCount: 78,
  ),
];
