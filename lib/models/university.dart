import 'course.dart';
import 'person.dart';
import 'student.dart';

class Professor extends Person {
  final String department;
  final List<String> taughtCourses;
  final double salary;

  Professor({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    required this.department,
    required this.salary,
    List<String>? taughtCourses,
  }) : taughtCourses = taughtCourses ?? [];

  @override
  String get role => 'Professor';

  void assignCourse(String courseId) {
    if (!taughtCourses.contains(courseId)) taughtCourses.add(courseId);
  }

  bool teaches(String courseId) => taughtCourses.contains(courseId);

  @override
  String toString() => 'Professor($id, $fullName, $department)';
}

class University {
  final String name;
  final List<Student> students;
  final List<Professor> professors;
  final List<Course> courses;

  University({
    required this.name,
    List<Student>? students,
    List<Professor>? professors,
    List<Course>? courses,
  })  : students = students ?? [],
        professors = professors ?? [],
        courses = courses ?? [];

  // ---- CRUD ----
  void addStudent(Student student) {
    if (findStudentById(student.id) != null) {
      throw StateError('Student with id ${student.id} already exists');
    }
    students.add(student);
  }

  void removeStudent(String studentId) =>
      students.removeWhere((s) => s.id == studentId);

  Student? findStudentById(String id) {
    for (final s in students) {
      if (s.id == id) return s;
    }
    return null;
  }

  void addProfessor(Professor professor) => professors.add(professor);

  void addCourse(Course course) => courses.add(course);

  Course? findCourseById(String id) {
    for (final c in courses) {
      if (c.id == id) return c;
    }
    return null;
  }

  // ---- Queries ----
  List<Student> getStudentsByCourse(String courseId) =>
      students.where((s) => s.enrolledCourses.contains(courseId)).toList();

  /// Курси, на які студент ще не записаний і виконав prerequisites.
  List<Course> getAvailableCoursesForStudent(String studentId) {
    final student = findStudentById(studentId);
    if (student == null) return [];
    return courses
        .where((c) =>
            !student.enrolledCourses.contains(c.id) &&
            c.canStudentEnroll(student))
        .toList();
  }

  Map<String, dynamic> generateStatistics() {
    final withGrades = students.where((s) => s.grades.isNotEmpty).toList();
    final avgGpa = withGrades.isEmpty
        ? 0.0
        : withGrades.fold<double>(0, (sum, s) => sum + s.gpa) /
            withGrades.length;
    final best = withGrades.isEmpty
        ? null
        : (withGrades.toList()..sort((a, b) => b.gpa.compareTo(a.gpa))).first;
    return {
      'university': name,
      'studentCount': students.length,
      'professorCount': professors.length,
      'courseCount': courses.length,
      'averageGpa': double.parse(avgGpa.toStringAsFixed(2)),
      'topStudent': best?.fullName,
      'enrollmentsPerCourse': {
        for (final c in courses) c.id: getStudentsByCourse(c.id).length,
      },
    };
  }
}
