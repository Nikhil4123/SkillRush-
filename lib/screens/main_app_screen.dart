import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile/profile_screen.dart';
import 'course_list_screen.dart';
import '../data/sample_data.dart';
import '../data/sample_users.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  // Create a list of screens to display
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      CourseListScreen(category: 'All Courses', courses: sampleCourses),
      _buildMyCoursesScreen(),
      const ProfileScreen(),
    ];
  }

  // Helper to build "My Courses" screen based on user role
  Widget _buildMyCoursesScreen() {
    final user = currentUser;
    final List<String> relevantCourseIds;

    if (user.isStudent) {
      relevantCourseIds = user.enrolledCourseIds;
    } else {
      relevantCourseIds = user.createdCourseIds;
    }

    final myCourses =
        sampleCourses
            .where((course) => relevantCourseIds.contains(course.id))
            .toList();

    return CourseListScreen(
      category: user.isStudent ? 'My Enrolled Courses' : 'My Created Courses',
      courses: myCourses,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
