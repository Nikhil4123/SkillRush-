import 'package:flutter/material.dart';
import '../models/course.dart';
import '../data/sample_data.dart';

class VideoUploadBottomSheet extends StatefulWidget {
  final ScrollController scrollController;

  const VideoUploadBottomSheet({super.key, required this.scrollController});

  @override
  State<VideoUploadBottomSheet> createState() => _VideoUploadBottomSheetState();
}

class _VideoUploadBottomSheetState extends State<VideoUploadBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _videoUrlController = TextEditingController();
  Course? _selectedCourse;
  int _duration = 5; // In minutes
  bool _isPreview = false;
  bool _isUploading = false;
  bool _isLocalFile = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          controller: widget.scrollController,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const Text(
              'Add Video Content',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Course selector
            DropdownButtonFormField<Course>(
              decoration: InputDecoration(
                labelText: 'Select Course',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: _selectedCourse,
              items:
                  sampleCourses
                      .map(
                        (course) => DropdownMenuItem(
                          value: course,
                          child: Text(course.title),
                        ),
                      )
                      .toList(),
              onChanged: (course) {
                setState(() {
                  _selectedCourse = course;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a course';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Video Title',
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
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Duration
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Duration: $_duration minutes',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Slider(
                    value: _duration.toDouble(),
                    min: 1,
                    max: 120,
                    divisions: 119,
                    label: _duration.toString(),
                    onChanged: (value) {
                      setState(() {
                        _duration = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Upload options
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLocalFile = true;
                      });
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Video'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor:
                          _isLocalFile
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLocalFile = false;
                      });
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('External URL'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Video URL or upload
            if (!_isLocalFile)
              TextFormField(
                controller: _videoUrlController,
                decoration: InputDecoration(
                  labelText: 'Video URL',
                  hintText: 'https://example.com/video.mp4',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
              ),
            if (_isLocalFile)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 40,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to select video file',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Is preview
            SwitchListTile(
              title: const Text('Available as preview'),
              subtitle: const Text(
                'Allow non-enrolled students to watch this video',
              ),
              value: _isPreview,
              onChanged: (value) {
                setState(() {
                  _isPreview = value;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed:
                  _isUploading
                      ? null
                      : () {
                        if (_formKey.currentState!.validate()) {
                          _addVideoToLesson();
                        }
                      },
              child:
                  _isUploading
                      ? const CircularProgressIndicator()
                      : const Text(
                        'Add Video',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _addVideoToLesson() async {
    if (_selectedCourse == null) return;

    setState(() {
      _isUploading = true;
    });

    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, we would upload the video to storage
    // and then update the Firestore document

    final newLesson = Lesson(
      id: 'lesson${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: _descriptionController.text,
      duration: _duration,
      videoUrl:
          _isLocalFile
              ? 'https://example.com/sample_video.mp4' // Placeholder for uploaded file
              : _videoUrlController.text,
      isPreview: _isPreview,
    );

    // Find the course index
    final courseIndex = sampleCourses.indexWhere(
      (course) => course.id == _selectedCourse!.id,
    );

    if (courseIndex != -1) {
      // Update the course with the new lesson
      final course = sampleCourses[courseIndex];
      final updatedLessons = [...course.lessons, newLesson];

      // Create updated course
      final updatedCourse = Course(
        id: course.id,
        title: course.title,
        description: course.description,
        imageUrl: course.imageUrl,
        category: course.category,
        duration: course.duration + _duration,
        lessonsCount: course.lessonsCount + 1,
        rating: course.rating,
        lessons: updatedLessons,
        creatorId: course.creatorId,
        price: course.price,
        isFree: course.isFree,
        enrollmentCount: course.enrollmentCount,
      );

      // Update the course in the sample data
      sampleCourses[courseIndex] = updatedCourse;
    }

    setState(() {
      _isUploading = false;
    });

    // Close the bottom sheet
    if (mounted) {
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video added successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
