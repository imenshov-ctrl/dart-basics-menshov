import 'person.dart';

class Student extends Person {
  final int year;
  final List<String> enrolledCourses;
  final Map<String, double> grades;
  final Set<String> skills;

  Student({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    this.year = 1,
    List<String>? enrolledCourses,
    Map<String, double>? grades,
    Set<String>? skills,
  })  : enrolledCourses = enrolledCourses ?? [],
        grades = grades ?? {},
        skills = skills ?? {};

  @override
  String get role => 'Student';

  /// Середній бал; 0, якщо оцінок ще немає.
  double get gpa {
    if (grades.isEmpty) return 0;
    final sum = grades.values.fold<double>(0, (a, b) => a + b);
    return sum / grades.length;
  }

  void enrollInCourse(String courseId) {
    if (!enrolledCourses.contains(courseId)) {
      enrolledCourses.add(courseId);
    }
  }

  void addGrade(String courseId, double grade) {
    if (grade < 0 || grade > 100) {
      throw ArgumentError.value(grade, 'grade', 'must be in range 0..100');
    }
    if (!enrolledCourses.contains(courseId)) {
      throw StateError('Student $id is not enrolled in $courseId');
    }
    grades[courseId] = grade;
  }

  /// Курси, де оцінка >= 60.
  List<String> getPassedCourses() => grades.entries
      .where((entry) => entry.value >= 60)
      .map((entry) => entry.key)
      .toList();

  @override
  String toString() =>
      'Student($id, $fullName, year $year, GPA ${gpa.toStringAsFixed(1)})';

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate.toIso8601String(),
        'year': year,
        'enrolledCourses': enrolledCourses,
        'grades': grades,
        'skills': skills.toList(),
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        birthDate: DateTime.parse(json['birthDate'] as String),
        year: (json['year'] as int?) ?? 1,
        enrolledCourses:
            List<String>.from(json['enrolledCourses'] as List? ?? const []),
        grades: (json['grades'] as Map? ?? const {})
            .map((k, v) => MapEntry(k as String, (v as num).toDouble())),
        skills: Set<String>.from(json['skills'] as List? ?? const []),
      );
}
