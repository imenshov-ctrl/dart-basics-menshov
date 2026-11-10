import 'student.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final int credits;
  final String instructor;
  final List<String> prerequisites;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.credits,
    required this.instructor,
    List<String>? prerequisites,
  }) : prerequisites = prerequisites ?? [];

  bool hasPrerequisites() => prerequisites.isNotEmpty;

  /// Студент може записатись, якщо склав усі prerequisites.
  bool canStudentEnroll(Student student) {
    final passed = student.getPassedCourses();
    return prerequisites.every(passed.contains);
  }

  @override
  String toString() => 'Course($id: $name, $credits credits, $instructor)';
}
