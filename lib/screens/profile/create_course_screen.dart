import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../models/user.dart';
import '../../data/sample_users.dart';
import '../../data/sample_data.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Programming';
  bool _isFree = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  final List<String> _categories = [
    'Programming',
    'Mathematics',
    'Science',
    'Language',
    'Arts',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _createCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      try {
        // In a real app, this would be an API call to create a course
        await Future.delayed(const Duration(seconds: 1)); // Simulate API delay

        // Create a new course object
        final newCourse = Course(
          id: 'course${sampleCourses.length + 1}',
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl:
              'https://placehold.co/600x400/3498db/FFFFFF.png?text=${_titleController.text.substring(0, 1)}',
          category: _selectedCategory,
          duration: 0, // Will be updated as lessons are added
          lessonsCount: 0, // Will be updated as lessons are added
          rating: 0.0, // No ratings yet
          creatorId: currentUser.id,
          price: _isFree ? 0.0 : double.tryParse(_priceController.text) ?? 0.0,
          isFree: _isFree,
          lessons: [], // No lessons yet
        );

        // Add to sample courses
        sampleCourses.add(newCourse);

        // Update creator's createdCourseIds
        final creatorIndex = sampleUsers.indexWhere(
          (user) => user.id == currentUser.id,
        );
        if (creatorIndex != -1) {
          final creator = sampleUsers[creatorIndex];
          final updatedCreator = User(
            id: creator.id,
            name: creator.name,
            email: creator.email,
            imageUrl: creator.imageUrl,
            role: creator.role,
            bio: creator.bio,
            enrolledCourseIds: creator.enrolledCourseIds,
            createdCourseIds: [...creator.createdCourseIds, newCourse.id],
            joinDate: creator.joinDate,
          );

          sampleUsers[creatorIndex] = updatedCreator;

          // Update current user if needed
          if (currentUser.id == creator.id) {
            currentUser = updatedCreator;
          }
        }

        // Navigate back with success
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString();
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course cover image placeholder
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 64,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Upload Course Cover',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Recommended size: 1200 x 800 px',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Error message
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),

              // Course title
              const Text(
                'Course Title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter a descriptive title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Course description
              const Text(
                'Course Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'What will students learn in this course?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Course category
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Pricing
              const Text(
                'Pricing',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('This is a free course'),
                value: _isFree,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool value) {
                  setState(() {
                    _isFree = value;
                  });
                },
              ),
              if (!_isFree) ...[
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price (USD)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    try {
                      final price = double.parse(value);
                      if (price < 0) {
                        return 'Price cannot be negative';
                      }
                    } catch (e) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Recommended price range: \$19.99 - \$199.99',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],

              const SizedBox(height: 32),

              // Create course button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _createCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'Create Course',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'After creating the course, you can add lessons and content.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
