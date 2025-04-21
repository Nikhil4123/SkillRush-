import 'package:flutter/material.dart';
import '../../data/sample_users.dart';
import '../../data/sample_data.dart';
import '../../models/course.dart';
import 'create_course_screen.dart';

class CreatorDashboardScreen extends StatefulWidget {
  const CreatorDashboardScreen({super.key});

  @override
  State<CreatorDashboardScreen> createState() => _CreatorDashboardScreenState();
}

class _CreatorDashboardScreenState extends State<CreatorDashboardScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final creatorCourses =
        sampleCourses
            .where((course) => course.creatorId == currentUser.id)
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Creator Dashboard')),
      body: Column(
        children: [
          // Stats summary
          _buildStatsSummary(creatorCourses),

          // Tab selector
          _buildTabSelector(),

          // Tab content
          Expanded(
            child:
                _selectedTab == 0
                    ? _buildCoursesTab(creatorCourses)
                    : _buildAnalyticsTab(creatorCourses),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCourseScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Course'),
      ),
    );
  }

  Widget _buildStatsSummary(List<Course> courses) {
    // Calculate some demo stats
    final totalCourses = courses.length;
    final totalStudents = 248; // Mock data
    final totalRevenue = 1243.50; // Mock data

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${currentUser.name}!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard(
                icon: Icons.book,
                title: 'Courses',
                value: totalCourses.toString(),
                color: Colors.blue,
              ),
              _buildStatCard(
                icon: Icons.people,
                title: 'Students',
                value: totalStudents.toString(),
                color: Colors.purple,
              ),
              _buildStatCard(
                icon: Icons.attach_money,
                title: 'Revenue',
                value: '\$${totalRevenue.toStringAsFixed(2)}',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTabButton(title: 'My Courses', index: 0, icon: Icons.book),
          _buildTabButton(title: 'Analytics', index: 1, icon: Icons.analytics),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : null,
            borderRadius: BorderRadius.circular(25),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesTab(List<Course> courses) {
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No courses yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first course',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _buildCourseCard(course);
      },
    );
  }

  Widget _buildCourseCard(Course course) {
    final enrolledStudents = 42; // Mock data

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Course header with image
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(course.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // Course info
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              course.category,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              course.isFree
                                  ? Colors.green.withOpacity(0.8)
                                  : Colors.blue.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.isFree
                              ? 'Free'
                              : '\$${course.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Course details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCourseStatItem(
                      icon: Icons.people,
                      value: enrolledStudents.toString(),
                      label: 'Students',
                    ),
                    _buildCourseStatItem(
                      icon: Icons.star,
                      value: course.rating.toString(),
                      label: 'Rating',
                    ),
                    _buildCourseStatItem(
                      icon: Icons.book,
                      value: course.lessonsCount.toString(),
                      label: 'Lessons',
                    ),
                    _buildCourseStatItem(
                      icon: Icons.access_time,
                      value: '${course.duration ~/ 60}h',
                      label: 'Duration',
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Edit course logic
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // View course details logic
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('Preview'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab(List<Course> courses) {
    // This is just a placeholder for analytics
    // In a real app, this would include charts and detailed statistics

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue chart
          _buildAnalyticsCard(
            title: 'Revenue (Last 30 Days)',
            child: Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 64,
                      color: Colors.blue.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Total: \$1,243.50',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '12% increase from last month',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Students enrollment chart
          _buildAnalyticsCard(
            title: 'New Students (Last 30 Days)',
            child: Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people, size: 64, color: Colors.purple.shade300),
                    const SizedBox(height: 16),
                    const Text(
                      'Total: 86 new students',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '8% increase from last month',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Course performance
          _buildAnalyticsCard(
            title: 'Course Performance',
            child: Column(
              children: [
                for (final course in courses)
                  _buildCoursePerformanceItem(course),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildCoursePerformanceItem(Course course) {
    // Mock data
    final completionRate = (course.id.hashCode % 50 + 50) / 100.0;
    final studentSatisfaction = (course.id.hashCode % 20 + 80) / 100.0;

    return ListTile(
      title: Text(
        course.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildProgressBar(
            label: 'Completion Rate',
            value: completionRate,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _buildProgressBar(
            label: 'Student Satisfaction',
            value: studentSatisfaction,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
