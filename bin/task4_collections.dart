import 'dart:io';

import 'package:dart_basics_menshov/models/course.dart';
import 'package:dart_basics_menshov/models/student.dart';
import 'package:dart_basics_menshov/models/university.dart';
import 'package:dart_basics_menshov/utils/data_processor.dart';

late List<Student> students;

void main() {
  print('=== Dart Collections & Data Processing Demo ===');
  final csv = File('data/students.csv').readAsStringSync();
  students = DataProcessor.parseStudentsCsv(csv);
  print('Завантажено студентів з CSV: ${students.length}');

  demonstrateLists();
  demonstrateSets();
  demonstrateMaps();
  demonstrateAdvancedOperations();
}

void demonstrateLists() {
  print('\n--- Lists ---');
  final nums = [7, 2, 9, 4, 12, 5, 8];
  print('even: ${DataProcessor.filterEvenNumbers(nums)}');
  print('sorted: ${([...nums]..sort())}');
  print('map x*x: ${nums.map((n) => n * n).toList()}');
  print('where > 5: ${nums.where((n) => n > 5).toList()}');
  print('fold sum: ${nums.fold<int>(0, (a, b) => a + b)}');
  print('reduce min: ${nums.reduce((a, b) => a < b ? a : b)}');

  print('\nРейтинг за GPA:');
  for (final row in DataProcessor.sortStudentsByGPA(students)) {
    print('  ${row['name']}: ${row['gpa']}');
  }
}

void demonstrateSets() {
  print('\n--- Sets ---');
  final a = {'dart', 'flutter', 'git'};
  final b = {'git', 'python', 'dart'};
  print('union: ${a.union(b)}');
  print('intersection: ${a.intersection(b)}');
  print('difference a-b: ${a.difference(b)}');

  print('Унікальні навички: ${DataProcessor.getUniqueSkills(students)}');
  print('Спільні курси всіх студентів: '
      '${DataProcessor.findCommonCourses(students)}');
}

void demonstrateMaps() {
  print('\n--- Maps ---');
  final byYear = DataProcessor.groupStudentsByYear(students);
  byYear.forEach((year, list) {
    print('$year: ${list.map((s) => s.lastName).join(", ")}');
  });

  final avg = DataProcessor.calculateAverageGradesByCourse(students);
  print('Середні оцінки по курсах: $avg');

  // трансформація: курс -> "pass"/"fail" за середнім балом
  final status = avg.map((c, g) => MapEntry(c, g >= 60 ? 'pass' : 'fail'));
  print('Статус курсів: $status');
}

void demonstrateAdvancedOperations() {
  print('\n--- Advanced ---');
  final uni = University(name: 'Demo University', students: students);
  uni.addCourse(Course(
      id: 'CS101',
      name: 'Intro to Programming',
      description: '',
      credits: 5,
      instructor: 'Ivanenko'));
  uni.addCourse(Course(
      id: 'MATH101',
      name: 'Calculus',
      description: '',
      credits: 5,
      instructor: 'Hnatyuk'));
  uni.addCourse(Course(
      id: 'CS201',
      name: 'Data Structures',
      description: '',
      credits: 5,
      instructor: 'Ivanenko',
      prerequisites: ['CS101']));
  uni.addCourse(Course(
      id: 'MOB301',
      name: 'Mobile Development',
      description: '',
      credits: 6,
      instructor: 'Ivanenko',
      prerequisites: ['CS101', 'CS201']));

  final report = DataProcessor.generateReport(uni);
  print('Звіт по курсах:');
  for (final row in report) {
    print('  $row');
  }

  // Вкладені колекції + кастомне сортування: спершу за курсом, потім за GPA
  final sorted = [...students]..sort((a, b) {
      final byYear = b.year.compareTo(a.year);
      return byYear != 0 ? byYear : b.gpa.compareTo(a.gpa);
    });
  print('Сортування (рік ↓, GPA ↓): ${sorted.map((s) => s.lastName).toList()}');

  // Збереження результатів
  Directory('data/output').createSync(recursive: true);
  final buffer = StringBuffer('course,enrolled,graded,averageGrade,passRate\n');
  for (final r in report) {
    buffer.writeln('${r['course']},${r['enrolled']},${r['graded']},'
        '${r['averageGrade']},${r['passRate']}');
  }
  File('data/output/course_report.csv').writeAsStringSync(buffer.toString());
  print('Звіт збережено: data/output/course_report.csv');
}
