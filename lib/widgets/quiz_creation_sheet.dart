import 'package:flutter/material.dart';
import '../models/course.dart';
import '../data/sample_data.dart';

class QuizCreationBottomSheet extends StatefulWidget {
  final ScrollController scrollController;

  const QuizCreationBottomSheet({super.key, required this.scrollController});

  @override
  State<QuizCreationBottomSheet> createState() =>
      _QuizCreationBottomSheetState();
}

class _QuizCreationBottomSheetState extends State<QuizCreationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  Course? _selectedCourse;
  Lesson? _selectedLesson;
  bool _isSubmitting = false;
  final List<QuizQuestionForm> _questions = [];

  @override
  void initState() {
    super.initState();
    _addNewQuestion();
  }

  void _addNewQuestion() {
    setState(() {
      _questions.add(QuizQuestionForm());
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length > 1) {
      setState(() {
        _questions.removeAt(index);
      });
    }
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
              'Create Quiz',
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
                  _selectedLesson = null;
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

            // Lesson selector
            if (_selectedCourse != null)
              DropdownButtonFormField<Lesson>(
                decoration: InputDecoration(
                  labelText: 'Select Lesson',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedLesson,
                items:
                    _selectedCourse!.lessons
                        .map(
                          (lesson) => DropdownMenuItem(
                            value: lesson,
                            child: Text(lesson.title),
                          ),
                        )
                        .toList(),
                onChanged: (lesson) {
                  setState(() {
                    _selectedLesson = lesson;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a lesson';
                  }
                  return null;
                },
              ),
            if (_selectedCourse != null && _selectedCourse!.lessons.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: const Text(
                  'This course has no lessons yet. Please add at least one lesson before creating a quiz.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),

            // Questions
            if (_selectedCourse != null &&
                _selectedCourse!.lessons.isNotEmpty) ...[
              const Text(
                'Quiz Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ...List.generate(_questions.length, (index) {
                return QuestionCard(
                  index: index,
                  questionForm: _questions[index],
                  onRemove: () => _removeQuestion(index),
                  canRemove: _questions.length > 1,
                );
              }),

              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _addNewQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Add Question'),
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
                    _isSubmitting
                        ? null
                        : () {
                          if (_formKey.currentState!.validate()) {
                            _createQuiz();
                          }
                        },
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text(
                          'Create Quiz',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _createQuiz() async {
    if (_selectedCourse == null || _selectedLesson == null) return;

    // Validate all questions
    bool allValid = true;
    for (var question in _questions) {
      if (!question.isValid()) {
        allValid = false;
        break;
      }
    }

    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all questions and options'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Convert form questions to model
    final quizQuestions =
        _questions.map((q) {
          return QuizQuestion(
            question: q.questionController.text,
            options: [
              q.option1Controller.text,
              q.option2Controller.text,
              if (q.option3Controller.text.isNotEmpty) q.option3Controller.text,
              if (q.option4Controller.text.isNotEmpty) q.option4Controller.text,
            ],
            correctAnswerIndex: q.correctAnswerIndex,
          );
        }).toList();

    // Find the course and lesson indexes
    final courseIndex = sampleCourses.indexWhere(
      (course) => course.id == _selectedCourse!.id,
    );

    if (courseIndex != -1) {
      final course = sampleCourses[courseIndex];
      final lessonIndex = course.lessons.indexWhere(
        (lesson) => lesson.id == _selectedLesson!.id,
      );

      if (lessonIndex != -1) {
        // Update the lesson with the quiz
        final lesson = course.lessons[lessonIndex];
        final updatedLesson = Lesson(
          id: lesson.id,
          title: lesson.title,
          description: lesson.description,
          duration: lesson.duration,
          videoUrl: lesson.videoUrl,
          isPreview: lesson.isPreview,
          quiz: quizQuestions,
        );

        // Create updated lessons list
        final updatedLessons = [...course.lessons];
        updatedLessons[lessonIndex] = updatedLesson;

        // Create updated course
        final updatedCourse = Course(
          id: course.id,
          title: course.title,
          description: course.description,
          imageUrl: course.imageUrl,
          category: course.category,
          duration: course.duration,
          lessonsCount: course.lessonsCount,
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
    }

    setState(() {
      _isSubmitting = false;
    });

    // Close the bottom sheet
    if (mounted) {
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz created successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class QuizQuestionForm {
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  int correctAnswerIndex = 0;

  bool isValid() {
    return questionController.text.isNotEmpty &&
        option1Controller.text.isNotEmpty &&
        option2Controller.text.isNotEmpty;
  }

  void dispose() {
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
  }
}

class QuestionCard extends StatefulWidget {
  final int index;
  final QuizQuestionForm questionForm;
  final VoidCallback onRemove;
  final bool canRemove;

  const QuestionCard({
    super.key,
    required this.index,
    required this.questionForm,
    required this.onRemove,
    required this.canRemove,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${widget.index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (widget.canRemove)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: widget.onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.questionForm.questionController,
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Options:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Option 1
            _buildOptionField(
              controller: widget.questionForm.option1Controller,
              index: 0,
              isCorrect: widget.questionForm.correctAnswerIndex == 0,
              onTap: () {
                setState(() {
                  widget.questionForm.correctAnswerIndex = 0;
                });
              },
            ),
            const SizedBox(height: 8),

            // Option 2
            _buildOptionField(
              controller: widget.questionForm.option2Controller,
              index: 1,
              isCorrect: widget.questionForm.correctAnswerIndex == 1,
              onTap: () {
                setState(() {
                  widget.questionForm.correctAnswerIndex = 1;
                });
              },
            ),
            const SizedBox(height: 8),

            // Option 3
            _buildOptionField(
              controller: widget.questionForm.option3Controller,
              index: 2,
              isCorrect: widget.questionForm.correctAnswerIndex == 2,
              onTap: () {
                setState(() {
                  widget.questionForm.correctAnswerIndex = 2;
                });
              },
              optional: true,
            ),
            const SizedBox(height: 8),

            // Option 4
            _buildOptionField(
              controller: widget.questionForm.option4Controller,
              index: 3,
              isCorrect: widget.questionForm.correctAnswerIndex == 3,
              onTap: () {
                setState(() {
                  widget.questionForm.correctAnswerIndex = 3;
                });
              },
              optional: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionField({
    required TextEditingController controller,
    required int index,
    required bool isCorrect,
    required VoidCallback onTap,
    bool optional = false,
  }) {
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: widget.questionForm.correctAnswerIndex,
          onChanged: (value) {
            if (value != null) {
              onTap();
            }
          },
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText:
                  optional
                      ? 'Option ${index + 1} (Optional)'
                      : 'Option ${index + 1}',
              hintText: 'Enter an option',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: isCorrect,
              fillColor: isCorrect ? Colors.green.shade50 : null,
            ),
            validator: (value) {
              if (!optional && (value == null || value.isEmpty)) {
                return 'Please enter an option';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
