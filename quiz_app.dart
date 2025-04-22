import 'dart:io';

void main() {
  QuizApp app = QuizApp();
  app.start();
}

class Question {
  String text;
  List<String> options;
  int correctAnswerIndex;

  Question(this.text, this.options, this.correctAnswerIndex);

  bool checkAnswer(int userAnswer) {
    return userAnswer == correctAnswerIndex;
  }

  void display() {
    stdout.writeln("\n$text");
    for (int i = 0; i < options.length; i++) {
      stdout.writeln("${i + 1}. ${options[i]}");
    }
    stdout.write("Enter your answer (1-${options.length}): ");
  }
}

class Quiz {
  List<Question> questions;
  int currentQuestionIndex = 0;
  int score = 0;

  Quiz(this.questions);

  bool hasNextQuestion() {
    return currentQuestionIndex < questions.length;
  }

  Question getCurrentQuestion() {
    return questions[currentQuestionIndex];
  }

  void answerCurrentQuestion(int answer) {
    Question question = getCurrentQuestion();

    int adjustedAnswer = answer - 1;

    if (question.checkAnswer(adjustedAnswer)) {
      score++;
      stdout.writeln("\n Correct!");
    } else {
      stdout.writeln(
        "\n Incorrect! The correct answer was: ${question.options[question.correctAnswerIndex]}",
      );
    }

    currentQuestionIndex++;
  }

  int getScore() {
    return score;
  }

  int getTotalQuestions() {
    return questions.length;
  }
}

class QuizApp {
  late Quiz quiz;

  QuizApp() {
    // Initialize the quiz with predefined questions
    quiz = Quiz([
      Question("What is Dart's primary purpose?", [
        "Mobile development only",
        "Web development only",
        "Client-optimized programming for apps on multiple platforms",
        "Server-side programming only",
      ], 2),
      Question("Which company developed Dart?", [
        "Apple",
        "Google",
        "Microsoft",
        "Facebook",
      ], 1),
      Question(
        "What is the Dart keyword to declare a variable whose value will never change after initialization?",
        ["const", "final", "static", "immutable"],
        1,
      ),
      Question("Which of these is NOT a valid Dart type?", [
        "String",
        "num",
        "var",
        "character",
      ], 3),
      Question("In Dart, what does the '??' operator do?", [
        "Null-aware assignment",
        "Type checking",
        "String concatenation",
        "Boolean negation",
      ], 0),
    ]);
  }

  void displayWelcomeMessage() {
    stdout.writeln("\n==================================");
    stdout.writeln("  WELCOME TO THE DART QUIZ APP");
    stdout.writeln("==================================");
    stdout.writeln("\nTest your knowledge of Dart programming!");
    stdout.writeln(
      "Answer the following ${quiz.getTotalQuestions()} multiple-choice questions.",
    );
    stdout.writeln("Press Enter to start the quiz...");

    try {
      stdin.readLineSync();
    } catch (e) {}
  }

  void displayFinalScore() {
    double percentage = (quiz.getScore() / quiz.getTotalQuestions()) * 100;

    stdout.writeln("\n==================================");
    stdout.writeln("           QUIZ COMPLETE");
    stdout.writeln("==================================");
    stdout.writeln(
      "\nYour final score: ${quiz.getScore()}/${quiz.getTotalQuestions()}",
    );
    stdout.writeln("Percentage: ${percentage.toStringAsFixed(1)}%");

    if (percentage >= 80) {
      stdout.writeln("\nExcellent! You're a Dart expert!");
    } else if (percentage >= 60) {
      stdout.writeln("\nGood job! You know Dart quite well!");
    } else {
      stdout.writeln("\nKeep practicing! You'll get better at Dart!");
    }
  }

  String? safeReadLine() {
    try {
      return stdin.readLineSync();
    } catch (e) {
      return "";
    }
  }

  int getValidInput(int max) {
    while (true) {
      String? input = safeReadLine();

      if (input == null || input.isEmpty) {
        stdout.writeln("Input not detected, using default answer: 1");
        return 1;
      }

      try {
        int choice = int.parse(input);
        if (choice >= 1 && choice <= max) {
          return choice;
        } else {
          stdout.write("Please enter a number between 1 and $max: ");
        }
      } catch (e) {
        stdout.write(
          "Invalid input. Please enter a number between 1 and $max: ",
        );
      }
    }
  }

  void start() {
    displayWelcomeMessage();

    while (quiz.hasNextQuestion()) {
      Question currentQuestion = quiz.getCurrentQuestion();
      currentQuestion.display();

      int userAnswer = getValidInput(currentQuestion.options.length);
      quiz.answerCurrentQuestion(userAnswer);

      if (quiz.hasNextQuestion()) {
        stdout.writeln("\nPress Enter for the next question...");
        try {
          stdin.readLineSync();
        } catch (e) {}
      }
    }

    displayFinalScore();
  }
}
