import 'package:dart_basics_menshov/models/student.dart';
import 'package:dart_basics_menshov/utils/calculator.dart';
import 'package:dart_basics_menshov/utils/data_processor.dart';
import 'package:test/test.dart';

Student st(String id, int year, List<String> courses, Map<String, double> grades,
        [Set<String> skills = const {}]) =>
    Student(
      id: id,
      firstName: 'N',
      lastName: id,
      birthDate: DateTime(2004, 1, 1),
      year: year,
      enrolledCourses: courses,
      grades: grades,
      skills: {...skills},
    );

void main() {
  group('Calculator', () {
    final calc = Calculator();
    test('basic operations', () {
      expect(calc.add(2, 3), 5);
      expect(calc.subtract(2, 3), -1);
      expect(calc.multiply(2, 3), 6);
      expect(calc.divide(6, 3), 2);
      expect(calc.power(2, 10), 1024);
    });
    test('division by zero throws', () {
      expect(() => calc.divide(1, 0), throwsArgumentError);
    });
    test('unknown operator throws', () {
      expect(() => calc.apply('%', 1, 2), throwsArgumentError);
    });
  });

  group('DataProcessor', () {
    test('filterEvenNumbers', () {
      expect(DataProcessor.filterEvenNumbers([1, 2, 3, 4]), [2, 4]);
    });

    test('countWords is case-insensitive', () {
      final counts = DataProcessor.countWords('Dart dart, DART! flutter');
      expect(counts['dart'], 3);
      expect(counts['flutter'], 1);
    });

    test('sortStudentsByGPA descending', () {
      final a = st('A', 1, ['C'], {'C': 50});
      final b = st('B', 1, ['C'], {'C': 90});
      final sorted = DataProcessor.sortStudentsByGPA([a, b]);
      expect(sorted.first['id'], 'B');
    });

    test('findCommonCourses is an intersection', () {
      final a = st('A', 1, ['C1', 'C2'], {});
      final b = st('B', 1, ['C2', 'C3'], {});
      expect(DataProcessor.findCommonCourses([a, b]), {'C2'});
      expect(DataProcessor.findCommonCourses([]), isEmpty);
    });

    test('getUniqueSkills', () {
      final a = st('A', 1, [], {}, {'dart', 'git'});
      final b = st('B', 1, [], {}, {'git'});
      expect(DataProcessor.getUniqueSkills([a, b]), {'dart', 'git'});
    });

    test('groupStudentsByYear', () {
      final groups = DataProcessor.groupStudentsByYear(
          [st('A', 1, [], {}), st('B', 2, [], {}), st('C', 1, [], {})]);
      expect(groups['Year 1']!.length, 2);
      expect(groups['Year 2']!.length, 1);
    });

    test('calculateAverageGradesByCourse', () {
      final avg = DataProcessor.calculateAverageGradesByCourse([
        st('A', 1, ['C'], {'C': 80}),
        st('B', 1, ['C'], {'C': 60}),
      ]);
      expect(avg['C'], 70.0);
    });

    test('parseStudentsCsv', () {
      const csv = 'header\n'
          'S1,Ann,Lee,2004-03-15,2,C1;C2,C1:90;C2:70,dart;git\n'
          'S2,Bob,Ray,2005-01-01,1,C1,,git\n';
      final students = DataProcessor.parseStudentsCsv(csv);
      expect(students.length, 2);
      expect(students[0].grades['C1'], 90);
      expect(students[0].skills, {'dart', 'git'});
      expect(students[1].grades, isEmpty);
    });
  });
}
