import 'package:flutter/material.dart';
import '../../data/sample_users.dart';
import '../../data/sample_data.dart';
import '../../models/user.dart';
import '../../models/course.dart';
import '../auth/login_screen.dart';
import '../course_detail_screen.dart';
import 'creator_dashboard.dart';
import 'edit_profile_screen.dart';
import 'create_course_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = currentUser; // From sample_users.dart
  }

  void _logout() {
    logout(); // From sample_users.dart
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _refreshUser() {
    setState(() {
      user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Course> userCourses =
        user.isStudent
            ? sampleCourses
                .where((course) => user.enrolledCourseIds.contains(course.id))
                .toList()
            : sampleCourses
                .where((course) => user.createdCourseIds.contains(course.id))
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshUser();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile picture
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                        const SizedBox(height: 16),

                        // User name
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // User role badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                user.isCreator
                                    ? Colors.blue.shade100
                                    : Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user.isCreator ? 'Creator' : 'Student',
                            style: TextStyle(
                              color:
                                  user.isCreator
                                      ? Colors.blue.shade800
                                      : Colors.purple.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // User details
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text(user.email),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),

                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text('Joined ${_formatDate(user.joinDate)}'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),

                        const SizedBox(height: 8),

                        // Bio
                        if (user.bio.isNotEmpty) ...[
                          const Divider(),
                          const SizedBox(height: 8),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Bio',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.bio,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Edit profile button
                        OutlinedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditProfileScreen(user: user),
                              ),
                            );

                            if (result == true) {
                              _refreshUser();
                            }
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Creator dashboard button (for creators only)
                if (user.isCreator)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatorDashboardScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.dashboard),
                    label: const Text('Creator Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // User courses section
                Text(
                  user.isStudent ? 'My Enrolled Courses' : 'My Created Courses',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                if (userCourses.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          user.isStudent ? Icons.school : Icons.create,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.isStudent
                              ? 'You haven\'t enrolled in any courses yet.'
                              : 'You haven\'t created any courses yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (user.isStudent) {
                              // Navigate to explore courses
                              Navigator.of(
                                context,
                              ).pop(); // Go back to MainAppScreen
                              // This is a simple way to navigate to the "Explore" tab in MainAppScreen
                              // A better implementation would be to use a navigation service or state management
                            } else {
                              // Navigate to create course screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const CreateCourseScreen(),
                                ),
                              );
                            }
                          },
                          child: Text(
                            user.isStudent
                                ? 'Browse Courses'
                                : 'Create a Course',
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userCourses.length,
                    itemBuilder: (context, index) {
                      final course = userCourses[index];
                      return _buildCourseCard(course);
                    },
                  ),

                const SizedBox(height: 32),

                // Account settings section
                const Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.notifications,
                        title: 'Notification Settings',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _buildSettingsItem(
                        icon: Icons.payment,
                        title: 'Payment Methods',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _buildSettingsItem(
                        icon: Icons.security,
                        title: 'Privacy & Security',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _buildSettingsItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Danger zone
                const Text(
                  'Danger Zone',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text(
                    'Permanently delete your account and all associated data',
                  ),
                  onTap: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Delete Account?'),
                            content: const Text(
                              'This action cannot be undone. All your data will be permanently deleted.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete account logic would go here
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              course.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course title
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Course details
                Row(
                  children: [
                    Icon(
                      Icons.play_lesson,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course.lessonsCount} lessons',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      course.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress bar for students, status for creators
                if (user.isStudent)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress: 30%',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '3/${course.lessonsCount} lessons',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.3,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '128 students enrolled',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Published',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to course or course editing
                      if (user.isStudent) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CourseDetailScreen(course: course),
                          ),
                        );
                      } else {
                        // For creators, we'll just show the course details for now
                        // In a real app, we would navigate to a course editing screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CourseDetailScreen(course: course),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      user.isStudent ? 'Continue Learning' : 'Edit Course',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
