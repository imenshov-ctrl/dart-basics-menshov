import 'package:dart_basics_menshov/utils/calculator.dart';
import 'package:dart_basics_menshov/utils/data_processor.dart';

void main() {
  print('=== Dart Functions Demo ===');
  testBasicFunctions();
  testAdvancedFunctions();
  testFunctionalProgramming();
  testCalculator();
  testTextAnalyzer();
}

// 1. Звичайні функції
int calculateSum(int a, int b) => a + b;

double calculateAverage(List<double> numbers) {
  if (numbers.isEmpty) return 0;
  return numbers.reduce((a, b) => a + b) / numbers.length;
}

// 2. Optional та named parameters
String formatName(
  String firstName,
  String lastName, {
  String? middleName,
  bool uppercase = false,
}) {
  final parts = [firstName, if (middleName != null) middleName, lastName];
  final result = parts.join(' ');
  return uppercase ? result.toUpperCase() : result;
}

// positional optional
String greet(String name, [String greeting = 'Привіт']) => '$greeting, $name!';

// 4. Recursive functions
int fibonacci(int n) {
  if (n < 0) throw ArgumentError('n must be >= 0');
  if (n < 2) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

int factorial(int n) {
  if (n < 0) throw ArgumentError('n must be >= 0');
  return n <= 1 ? 1 : n * factorial(n - 1);
}

void testBasicFunctions() {
  print('\n--- Basic functions ---');
  print('calculateSum(3, 4) = ${calculateSum(3, 4)}');
  print('calculateAverage = ${calculateAverage([4.0, 5.5, 9.0])}');
  print('fibonacci(10) = ${fibonacci(10)}');
  print('factorial(5) = ${factorial(5)}');
}

void testAdvancedFunctions() {
  print('\n--- Optional & named parameters ---');
  print(formatName('Ivan', 'Petrenko'));
  print(formatName('Ivan', 'Petrenko', middleName: 'Ivanovych'));
  print(formatName('Ivan', 'Petrenko', uppercase: true));
  print(greet('Олена'));
  print(greet('Олена', 'Добрий день'));
}

// Функція приймає іншу функцію
List<int> applyToAll(List<int> items, int Function(int) transform) =>
    items.map(transform).toList();

// Повертає closure
Function counter() {
  var count = 0;
  return () => ++count;
}

int Function(int) multiplier(int factor) => (int x) => x * factor;

void testFunctionalProgramming() {
  print('\n--- Functional programming ---');
  final numbers = [1, 2, 3, 4, 5, 6];

  print('map (x*x): ${numbers.map((n) => n * n).toList()}');
  print('where (even): ${numbers.where((n) => n.isEven).toList()}');
  print('fold (sum): ${numbers.fold<int>(0, (acc, n) => acc + n)}');
  print('reduce (max): ${numbers.reduce((a, b) => a > b ? a : b)}');
  print('any > 5: ${numbers.any((n) => n > 5)}, every > 0: '
      '${numbers.every((n) => n > 0)}');

  print('applyToAll (x+10): ${applyToAll(numbers, (x) => x + 10)}');

  // Closures та scope
  final next = counter();
  next();
  next();
  print('closure counter (3rd call): ${next()}');

  final triple = multiplier(3);
  print('multiplier(3)(7) = ${triple(7)}');
}

void testCalculator() {
  print('\n--- Calculator ---');
  final calc = Calculator();
  const operations = [
    ['+', 12.0, 8.0],
    ['-', 12.0, 8.0],
    ['*', 12.0, 8.0],
    ['/', 12.0, 8.0],
    ['^', 2.0, 10.0],
    ['/', 5.0, 0.0],
  ];
  for (final op in operations) {
    final symbol = op[0] as String;
    final a = op[1] as double;
    final b = op[2] as double;
    try {
      print('$a $symbol $b = ${calc.apply(symbol, a, b)}');
    } on ArgumentError catch (e) {
      print('$a $symbol $b -> помилка: ${e.message}');
    }
  }
  print('sqrt(144) = ${calc.sqrt(144)}');
  print('15% від 200 = ${calc.percentOf(15, 200)}');
}

void testTextAnalyzer() {
  print('\n--- Text analyzer ---');
  const text = 'Dart is great. Dart is fast!\nFlutter uses Dart.';
  final stats = DataProcessor.analyzeText(text);
  stats.forEach((k, v) => print('$k: $v'));
  final counts = DataProcessor.countWords(text);
  final top = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  print('Top words: ${top.take(3).map((e) => "${e.key}=${e.value}").join(", ")}');
}
