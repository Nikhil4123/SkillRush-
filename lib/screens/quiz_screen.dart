import 'package:flutter/material.dart';
import '../models/course.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> quiz;
  final String lessonTitle;

  const QuizScreen({super.key, required this.quiz, required this.lessonTitle});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  List<int?> _selectedAnswers = [];
  bool _quizCompleted = false;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(widget.quiz.length, null);
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _completeQuiz() {
    int correctCount = 0;
    for (int i = 0; i < widget.quiz.length; i++) {
      if (_selectedAnswers[i] == widget.quiz[i].correctAnswerIndex) {
        correctCount++;
      }
    }

    setState(() {
      _quizCompleted = true;
      _correctAnswers = correctCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.lessonTitle}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _quizCompleted ? _buildResultScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = widget.quiz[_currentQuestionIndex];
    final int? selectedAnswer = _selectedAnswers[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.quiz.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Question ${_currentQuestionIndex + 1} of ${widget.quiz.length}',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text(
            currentQuestion.question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion.options.length,
              itemBuilder: (context, index) {
                final isSelected = selectedAnswer == index;
                return GestureDetector(
                  onTap: () => _selectAnswer(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1)
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300,
                          ),
                          child: Center(
                            child:
                                isSelected
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                    : Text(
                                      String.fromCharCode(
                                        65 + index,
                                      ), // A, B, C, D...
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            currentQuestion.options[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currentQuestionIndex > 0
                  ? ElevatedButton(
                    onPressed: _previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Previous'),
                  )
                  : const SizedBox(width: 100),
              ElevatedButton(
                onPressed:
                    selectedAnswer != null
                        ? _nextQuestion
                        : null, // Disable if no answer selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentQuestionIndex == widget.quiz.length - 1
                      ? 'Finish Quiz'
                      : 'Next',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_correctAnswers / widget.quiz.length) * 100;
    Color resultColor;
    String resultMessage;

    if (percentage >= 80) {
      resultColor = Colors.green;
      resultMessage = 'Excellent! You did great.';
    } else if (percentage >= 60) {
      resultColor = Colors.amber;
      resultMessage = 'Good job! Keep practicing.';
    } else {
      resultColor = Colors.red;
      resultMessage = 'You might need to review this lesson again.';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          const Text(
            'Quiz Completed!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            resultMessage,
            style: TextStyle(
              fontSize: 18,
              color: resultColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Score:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Correct Answers:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$_correctAnswers / ${widget.quiz.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Review answers
                setState(() {
                  _quizCompleted = false;
                  _currentQuestionIndex = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Review Answers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Go back to lesson
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Back to Lesson',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
