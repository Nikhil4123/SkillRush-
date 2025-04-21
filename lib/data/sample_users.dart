import '../models/user.dart';

// Sample users for testing
final List<User> sampleUsers = [
  // Creators
  User(
    id: 'c1',
    name: 'Professor Smith',
    email: 'smith@example.com',
    imageUrl: 'https://placehold.co/400x400/3498db/FFFFFF.png?text=PS',
    role: UserRole.creator,
    bio:
        'Expert in programming and software development with 15+ years of experience. Teaching Flutter and mobile development for the past 5 years.',
    createdCourseIds: ['1'],
    joinDate: DateTime(2022, 1, 15),
  ),
  User(
    id: 'c2',
    name: 'Dr. Rebecca Johnson',
    email: 'rebecca@example.com',
    imageUrl: 'https://placehold.co/400x400/e74c3c/FFFFFF.png?text=RJ',
    role: UserRole.creator,
    bio:
        'Mathematics professor specialized in algebra and calculus. Passionate about making math accessible to everyone.',
    createdCourseIds: ['2'],
    joinDate: DateTime(2022, 3, 10),
  ),
  User(
    id: 'c3',
    name: 'Dr. Michael Chen',
    email: 'chen@example.com',
    imageUrl: 'https://placehold.co/400x400/2ecc71/FFFFFF.png?text=MC',
    role: UserRole.creator,
    bio:
        'Physics professor with a PhD in Theoretical Physics. Loves to explain complex concepts in simple terms.',
    createdCourseIds: ['3'],
    joinDate: DateTime(2022, 2, 20),
  ),

  // Students
  User(
    id: 's1',
    name: 'Alex Johnson',
    email: 'alex@example.com',
    imageUrl: 'https://placehold.co/400x400/9b59b6/FFFFFF.png?text=AJ',
    role: UserRole.student,
    bio:
        'Computer Science student passionate about mobile app development and AI.',
    enrolledCourseIds: ['1', '3'],
    joinDate: DateTime(2023, 5, 5),
  ),
  User(
    id: 's2',
    name: 'Emma Williams',
    email: 'emma@example.com',
    imageUrl: 'https://placehold.co/400x400/f39c12/FFFFFF.png?text=EW',
    role: UserRole.student,
    bio:
        'Engineering student with a focus on mathematics and physics. Loves to learn new technologies.',
    enrolledCourseIds: ['2', '3'],
    joinDate: DateTime(2023, 6, 15),
  ),
  User(
    id: 's3',
    name: 'David Brown',
    email: 'david@example.com',
    imageUrl: 'https://placehold.co/400x400/1abc9c/FFFFFF.png?text=DB',
    role: UserRole.student,
    bio:
        'Art and design student looking to improve drawing skills and learn new artistic techniques.',
    enrolledCourseIds: ['5'],
    joinDate: DateTime(2023, 4, 10),
  ),
];

// Current logged in user (for testing)
User currentUser = sampleUsers[3]; // Alex Johnson (student)

// Authentication functions (mock for now, will be replaced with Firebase)
bool isLoggedIn = false;

void login(String email, String password) {
  // Find user with matching email
  final user = sampleUsers.firstWhere(
    (user) => user.email == email,
    orElse: () => throw Exception('User not found'),
  );

  // In a real app, we would validate the password here
  // For now, any password works

  currentUser = user;
  isLoggedIn = true;
}

void logout() {
  isLoggedIn = false;
  // currentUser remains set but isLoggedIn flag is false
}

void register(String name, String email, String password, UserRole role) {
  // Check if email already exists
  final existingUser = sampleUsers.any((user) => user.email == email);
  if (existingUser) {
    throw Exception('User with this email already exists');
  }

  // Create new user
  final newUser = User(
    id: 'user${sampleUsers.length + 1}',
    name: name,
    email: email,
    imageUrl: 'https://placehold.co/400x400/34495e/FFFFFF.png?text=${name[0]}',
    role: role,
    bio: '',
    joinDate: DateTime.now(),
  );

  sampleUsers.add(newUser);
  currentUser = newUser;
  isLoggedIn = true;
}
