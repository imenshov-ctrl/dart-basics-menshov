import 'package:dart_basics_menshov/models/course.dart';
import 'package:dart_basics_menshov/models/student.dart';
import 'package:dart_basics_menshov/models/university.dart';
import 'package:test/test.dart';

Student makeStudent(String id, {int year = 1}) => Student(
      id: id,
      firstName: 'Test',
      lastName: id,
      birthDate: DateTime(2004, 1, 1),
      year: year,
    );

void main() {
  group('Student', () {
    test('gpa is 0 without grades', () {
      expect(makeStudent('A').gpa, 0);
    });

    test('gpa is average of grades', () {
      final s = makeStudent('A')
        ..enrollInCourse('C1')
        ..enrollInCourse('C2')
        ..addGrade('C1', 80)
        ..addGrade('C2', 60);
      expect(s.gpa, 70);
    });

    test('addGrade validates range and enrollment', () {
      final s = makeStudent('A')..enrollInCourse('C1');
      expect(() => s.addGrade('C1', 101), throwsArgumentError);
      expect(() => s.addGrade('C9', 50), throwsStateError);
    });

    test('getPassedCourses uses threshold 60', () {
      final s = makeStudent('A')
        ..enrollInCourse('C1')
        ..enrollInCourse('C2')
        ..addGrade('C1', 60)
        ..addGrade('C2', 59);
      expect(s.getPassedCourses(), ['C1']);
    });

    test('json round trip', () {
      final s = makeStudent('A')
        ..enrollInCourse('C1')
        ..addGrade('C1', 75);
      final copy = Student.fromJson(s.toJson());
      expect(copy.id, s.id);
      expect(copy.grades, s.grades);
      expect(copy.enrolledCourses, s.enrolledCourses);
    });

    test('fullName and role', () {
      final s = makeStudent('A');
      expect(s.fullName, 'Test A');
      expect(s.role, 'Student');
    });
  });

  group('Course', () {
    final base = Course(
        id: 'C1', name: 'Base', description: '', credits: 3, instructor: 'X');
    final adv = Course(
        id: 'C2',
        name: 'Adv',
        description: '',
        credits: 3,
        instructor: 'X',
        prerequisites: ['C1']);

    test('hasPrerequisites', () {
      expect(base.hasPrerequisites(), isFalse);
      expect(adv.hasPrerequisites(), isTrue);
    });

    test('canStudentEnroll requires passed prerequisites', () {
      final s = makeStudent('A')..enrollInCourse('C1');
      expect(adv.canStudentEnroll(s), isFalse);
      s.addGrade('C1', 70);
      expect(adv.canStudentEnroll(s), isTrue);
    });
  });

  group('University', () {
    test('CRUD for students', () {
      final uni = University(name: 'U');
      uni.addStudent(makeStudent('A'));
      expect(uni.findStudentById('A'), isNotNull);
      expect(() => uni.addStudent(makeStudent('A')), throwsStateError);
      uni.removeStudent('A');
      expect(uni.findStudentById('A'), isNull);
    });

    test('statistics', () {
      final uni = University(name: 'U');
      final s = makeStudent('A')
        ..enrollInCourse('C1')
        ..addGrade('C1', 90);
      uni.addStudent(s);
      final stats = uni.generateStatistics();
      expect(stats['studentCount'], 1);
      expect(stats['averageGpa'], 90.0);
    });

    test('professor is a Person with role', () {
      final p = Professor(
          id: 'P',
          firstName: 'A',
          lastName: 'B',
          birthDate: DateTime(1980),
          department: 'CS',
          salary: 1);
      expect(p.role, 'Professor');
    });
  });
}
