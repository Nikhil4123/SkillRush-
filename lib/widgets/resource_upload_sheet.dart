import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/resource.dart';
import '../data/sample_data.dart';

class ResourceUploadBottomSheet extends StatefulWidget {
  final ScrollController scrollController;

  const ResourceUploadBottomSheet({super.key, required this.scrollController});

  @override
  State<ResourceUploadBottomSheet> createState() =>
      _ResourceUploadBottomSheetState();
}

class _ResourceUploadBottomSheetState extends State<ResourceUploadBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _resourceUrlController = TextEditingController();
  Course? _selectedCourse;
  bool _isUploading = false;
  bool _isLocalFile = false;
  String? _resourceType = 'PDF';

  final List<String> _resourceTypes = [
    'PDF',
    'Document',
    'Spreadsheet',
    'Presentation',
    'Image',
    'Code',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _resourceUrlController.dispose();
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
              'Upload Course Resources',
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

            // Resource type
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Resource Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: _resourceType,
              items:
                  _resourceTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _resourceType = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a resource type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Resource Title',
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
                    label: const Text('Upload File'),
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

            // Resource URL or upload
            if (!_isLocalFile)
              TextFormField(
                controller: _resourceUrlController,
                decoration: InputDecoration(
                  labelText: 'Resource URL',
                  hintText: 'https://example.com/resource.pdf',
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
                        'Tap to select file',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
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
                          _uploadResource();
                        }
                      },
              child:
                  _isUploading
                      ? const CircularProgressIndicator()
                      : const Text(
                        'Upload Resource',
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

  void _uploadResource() async {
    if (_selectedCourse == null) return;

    setState(() {
      _isUploading = true;
    });

    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, we would upload the resource to storage
    // and then update the Firestore document

    // Create a resource object
    final resource = Resource(
      id: 'resource${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: _descriptionController.text,
      url:
          _isLocalFile
              ? 'https://example.com/sample_resource.pdf' // Placeholder for uploaded file
              : _resourceUrlController.text,
      courseId: _selectedCourse!.id,
      resourceType: _resourceType ?? 'Other',
      uploadDate: DateTime.now(),
    );

    // In a real app, this would be saved to Firestore
    // await firestore.collection('resources').add(resource.toMap());

    setState(() {
      _isUploading = false;
    });

    // Close the bottom sheet
    if (mounted) {
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_titleController.text} uploaded successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
