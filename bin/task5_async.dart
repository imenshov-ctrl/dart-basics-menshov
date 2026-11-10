import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_basics_menshov/models/student.dart';
import 'package:dart_basics_menshov/utils/data_processor.dart';

const outputDir = 'data/output';

void main() async {
  print('=== Dart Async Programming Demo ===');
  await demonstrateFutures();
  await demonstrateStreams();
  await demonstrateFileOperations();
}

// Симуляція API запиту
Future<String> fetchStudentData(String studentId) async {
  await Future.delayed(const Duration(seconds: 1));
  if (studentId.isEmpty) throw ArgumentError('studentId is empty');
  return 'Data for student $studentId';
}

Future<List<Student>> loadStudentsFromFile(String filename) async {
  final content = await File(filename).readAsString();
  final list = jsonDecode(content) as List<dynamic>;
  return list
      .map((e) => Student.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<void> saveStudentsToFile(List<Student> students, String filename) async {
  final file = File(filename);
  await file.parent.create(recursive: true);
  const encoder = JsonEncoder.withIndent('  ');
  await file.writeAsString(encoder.convert(students.map((s) => s.toJson()).toList()));
}

Stream<Student> studentStream() async* {
  final csv = await File('data/students.csv').readAsString();
  for (final s in DataProcessor.parseStudentsCsv(csv)) {
    await Future.delayed(const Duration(milliseconds: 200));
    yield s;
  }
}

Future<void> demonstrateFutures() async {
  print('\n--- Futures ---');

  // Послідовно vs паралельно
  final ids = ['S001', 'S002', 'S003'];

  var sw = Stopwatch()..start();
  for (final id in ids) {
    await fetchStudentData(id);
  }
  sw.stop();
  print('Послідовно: ${sw.elapsedMilliseconds} мс');

  sw = Stopwatch()..start();
  final results = await Future.wait(ids.map(fetchStudentData));
  sw.stop();
  print('Future.wait: ${sw.elapsedMilliseconds} мс -> $results');

  // Error handling
  try {
    await fetchStudentData('');
  } on ArgumentError catch (e) {
    print('Перехоплено помилку: ${e.message}');
  } finally {
    print('finally виконується завжди');
  }

  // Timeout
  try {
    await fetchStudentData('S001').timeout(const Duration(milliseconds: 300));
  } on TimeoutException {
    print('Timeout: запит тривав довше 300 мс');
  }
}

Future<void> demonstrateStreams() async {
  print('\n--- Streams ---');

  final names = studentStream().map((s) => s.fullName);
  await for (final name in names.take(3)) {
    print('await for -> $name');
  }

  final completer = Completer<void>();
  final honors = studentStream()
      .where((s) => s.gpa >= 85)
      .map((s) => '${s.fullName} (${s.gpa.toStringAsFixed(1)})');
  honors.listen(
    (line) => print('listen -> відмінник: $line'),
    onDone: () {
      print('stream завершено');
      completer.complete();
    },
  );
  await completer.future;

  final count = await studentStream().length;
  print('Всього студентів у stream: $count');
}

Future<void> demonstrateFileOperations() async {
  print('\n--- File operations ---');
  final csv = await File('data/students.csv').readAsString();
  final students = DataProcessor.parseStudentsCsv(csv);

  const path = '$outputDir/students.json';
  await saveStudentsToFile(students, path);
  print('Записано ${students.length} студентів у $path');

  try {
    final loaded = await loadStudentsFromFile(path);
    final top = DataProcessor.sortStudentsByGPA(loaded).first;
    print('Прочитано ${loaded.length}; найкращий: ${top['name']} (${top['gpa']})');

    // Асинхронна обробка і запис результату
    await File('$outputDir/summary.txt').writeAsString(
        'Students: ${loaded.length}\n'
        'Best: ${top['name']}\n'
        'Skills: ${DataProcessor.getUniqueSkills(loaded).join(", ")}\n');
    print('Підсумок записано у $outputDir/summary.txt');
  } on FileSystemException catch (e) {
    print('Помилка файлу: ${e.message}');
  }

  try {
    await loadStudentsFromFile('data/missing.json');
  } on FileSystemException {
    print('Файл не знайдено - помилка оброблена коректно');
  }
}
