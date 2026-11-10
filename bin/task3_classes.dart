import 'dart:convert';

import 'package:dart_basics_menshov/models/course.dart';
import 'package:dart_basics_menshov/models/person.dart';
import 'package:dart_basics_menshov/models/student.dart';
import 'package:dart_basics_menshov/models/university.dart';

void main() {
  print('=== University Management System Demo ===');
  runUniversityDemo();
}

void runUniversityDemo() {
  // 1. Університет
  final uni = University(name: 'Lviv Polytechnic');

  // 2. Студенти та професори
  final olena = Student(
    id: 'S001',
    firstName: 'Olena',
    lastName: 'Kovalenko',
    birthDate: DateTime(2004, 3, 15),
    year: 2,
  );
  final andrii = Student(
    id: 'S002',
    firstName: 'Andrii',
    lastName: 'Shevchenko',
    birthDate: DateTime(2003, 11, 2),
    year: 3,
  );
  uni.addStudent(olena);
  uni.addStudent(andrii);

  final prof = Professor(
    id: 'P001',
    firstName: 'Petro',
    lastName: 'Ivanenko',
    birthDate: DateTime(1975, 6, 1),
    department: 'Computer Science',
    salary: 40000,
  );
  uni.addProfessor(prof);

  // 3. Курси
  final cs101 = Course(
    id: 'CS101',
    name: 'Intro to Programming',
    description: 'Basics of programming',
    credits: 5,
    instructor: prof.fullName,
  );
  final mob301 = Course(
    id: 'MOB301',
    name: 'Mobile Development',
    description: 'Dart and Flutter',
    credits: 6,
    instructor: prof.fullName,
    prerequisites: ['CS101'],
  );
  uni.addCourse(cs101);
  uni.addCourse(mob301);
  prof.assignCourse('CS101');
  prof.assignCourse('MOB301');

  // 4. Запис на курси
  print('\nДоступні курси для Olena до запису: '
      '${uni.getAvailableCoursesForStudent('S001').map((c) => c.id).toList()}');
  olena.enrollInCourse('CS101');
  andrii.enrollInCourse('CS101');
  print('Чи може Olena записатись на MOB301? ${mob301.canStudentEnroll(olena)}');

  // 5. Оцінки
  olena.addGrade('CS101', 91);
  andrii.addGrade('CS101', 55);
  print('Olena може на MOB301 після оцінки 91? ${mob301.canStudentEnroll(olena)}');
  print('Andrii може на MOB301 після оцінки 55? ${mob301.canStudentEnroll(andrii)}');
  olena.enrollInCourse('MOB301');
  olena.addGrade('MOB301', 88);

  // Обробка помилки
  try {
    andrii.addGrade('MOB301', 70);
  } on StateError catch (e) {
    print('Очікувана помилка: ${e.message}');
  }

  // 6. Статистика
  print('\n--- Статистика ---');
  uni.generateStatistics().forEach((k, v) => print('$k: $v'));

  // Поліморфізм
  print('\n--- Polymorphism ---');
  final people = <Person>[olena, andrii, prof];
  for (final p in people) {
    print('${p.role}: ${p.fullName}, age ${p.age}');
  }

  // CRUD
  print('\n--- CRUD ---');
  print('find S002: ${uni.findStudentById('S002')}');
  uni.removeStudent('S002');
  print('after remove S002: ${uni.findStudentById('S002')}');

  // JSON
  final json = jsonEncode(olena.toJson());
  print('\nJSON: $json');
  final restored = Student.fromJson(jsonDecode(json) as Map<String, dynamic>);
  print('Restored: $restored');
}
