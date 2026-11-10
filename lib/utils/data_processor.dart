import '../models/student.dart';
import '../models/university.dart';

class DataProcessor {
  // ---------- Lists ----------
  static List<int> filterEvenNumbers(List<int> numbers) =>
      numbers.where((n) => n.isEven).toList();

  /// Рахує слова без урахування регістру та розділових знаків.
  static Map<String, int> countWords(String text) {
    final result = <String, int>{};
    final words = RegExp(r"[\p{L}\p{N}']+", unicode: true)
        .allMatches(text.toLowerCase())
        .map((m) => m.group(0)!);
    for (final w in words) {
      result[w] = (result[w] ?? 0) + 1;
    }
    return result;
  }

  static Map<String, int> analyzeText(String text) {
    final counts = countWords(text);
    return {
      'characters': text.length,
      'charactersNoSpaces': text.replaceAll(RegExp(r'\s'), '').length,
      'words': counts.values.fold(0, (a, b) => a + b),
      'uniqueWords': counts.length,
      'lines': text.isEmpty ? 0 : text.split('\n').length,
    };
  }

  static List<Map<String, dynamic>> sortStudentsByGPA(List<Student> students) {
    final sorted = [...students]..sort((a, b) => b.gpa.compareTo(a.gpa));
    return sorted
        .map((s) => {
              'id': s.id,
              'name': s.fullName,
              'gpa': double.parse(s.gpa.toStringAsFixed(2)),
            })
        .toList();
  }

  // ---------- Sets ----------
  static Set<String> getUniqueSkills(List<Student> students) =>
      students.expand((s) => s.skills).toSet();

  /// Курси, на які записані ВСІ студенти зі списку (перетин множин).
  static Set<String> findCommonCourses(List<Student> students) {
    if (students.isEmpty) return {};
    return students
        .map((s) => s.enrolledCourses.toSet())
        .reduce((a, b) => a.intersection(b));
  }

  // ---------- Maps ----------
  static Map<String, List<Student>> groupStudentsByYear(
      List<Student> students) {
    final groups = <String, List<Student>>{};
    for (final s in students) {
      groups.putIfAbsent('Year ${s.year}', () => []).add(s);
    }
    return groups;
  }

  static Map<String, double> calculateAverageGradesByCourse(
      List<Student> students) {
    final sums = <String, double>{};
    final counts = <String, int>{};
    for (final s in students) {
      s.grades.forEach((course, grade) {
        sums[course] = (sums[course] ?? 0) + grade;
        counts[course] = (counts[course] ?? 0) + 1;
      });
    }
    return {
      for (final course in sums.keys)
        course: double.parse(
            (sums[course]! / counts[course]!).toStringAsFixed(2)),
    };
  }

  // ---------- Advanced ----------
  static List<Map<String, dynamic>> generateReport(University university) {
    return university.courses.map((course) {
      final enrolled = university.getStudentsByCourse(course.id);
      final grades = enrolled
          .where((s) => s.grades.containsKey(course.id))
          .map((s) => s.grades[course.id]!)
          .toList();
      final avg =
          grades.isEmpty ? 0.0 : grades.reduce((a, b) => a + b) / grades.length;
      final passRate = grades.isEmpty
          ? 0.0
          : grades.where((g) => g >= 60).length / grades.length * 100;
      return {
        'course': course.name,
        'instructor': course.instructor,
        'enrolled': enrolled.length,
        'graded': grades.length,
        'averageGrade': double.parse(avg.toStringAsFixed(2)),
        'passRate': double.parse(passRate.toStringAsFixed(1)),
      };
    }).toList();
  }

  // ---------- CSV ----------
  /// Формат рядка:
  /// id,firstName,lastName,birthDate,year,courses(;),grades(course:grade;),skills(;)
  static List<Student> parseStudentsCsv(String csv) {
    final lines = csv
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .skip(1); // header
    List<String> list(String v) =>
        v.isEmpty ? [] : v.split(';').map((e) => e.trim()).toList();
    return lines.map((line) {
      final c = line.split(',');
      final grades = <String, double>{};
      for (final pair in list(c[6])) {
        final kv = pair.split(':');
        grades[kv[0]] = double.parse(kv[1]);
      }
      return Student(
        id: c[0],
        firstName: c[1],
        lastName: c[2],
        birthDate: DateTime.parse(c[3]),
        year: int.parse(c[4]),
        enrolledCourses: list(c[5]),
        grades: grades,
        skills: list(c[7]).toSet(),
      );
    }).toList();
  }
}
