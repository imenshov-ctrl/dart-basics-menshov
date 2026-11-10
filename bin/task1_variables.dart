void main() {
  print('=== Dart Variables & Types Demo ===');
  demonstrateNumbers();
  demonstrateStrings();
  demonstrateBooleans();
  demonstrateCollections();
  demonstrateNullSafety();
}

void demonstrateNumbers() {
  print('\n--- Numbers ---');
  int a = 17;
  double b = 4.5;
  num c = 10; // num може бути int або double
  c = 2.5;

  print('a + b = ${a + b}');
  print('a ~/ 5 = ${a ~/ 5} (цілочисельне ділення), a % 5 = ${a % 5}');
  print('a / 5 = ${a / 5}');
  print('num c = $c');

  // Type conversion
  print('int -> double: ${a.toDouble()}');
  print('double -> int: ${b.toInt()} (truncate), round: ${b.round()}');
  print('String -> int: ${int.parse("42") + 1}');
  print('String -> double: ${double.parse("3.14") * 2}');
  print('tryParse("abc") = ${int.tryParse("abc")}');
  print('3.14159.toStringAsFixed(2) = ${3.14159.toStringAsFixed(2)}');
}

void demonstrateStrings() {
  print('\n--- Strings ---');
  const name = 'Dart';
  final version = 3;
  print('Interpolation: $name $version, length = ${name.length}');

  final multi = '''
Багаторядковий
рядок''';
  print(multi);
  print('Escape: tab[\t] newline[\\n] quote[\']');
  print(r'Raw string: \n не інтерпретується');

  const text = '  Hello, Dart World!  ';
  final trimmed = text.trim();
  print('trim: "$trimmed"');
  print('upper: ${trimmed.toUpperCase()}, lower: ${trimmed.toLowerCase()}');
  print('contains("Dart"): ${trimmed.contains("Dart")}');
  print('replaceAll: ${trimmed.replaceAll("World", "Mobile")}');
  print('split: ${trimmed.split(" ")}');
  print('substring(0, 5): ${trimmed.substring(0, 5)}');
  print('padLeft: "${"7".padLeft(3, "0")}"');

  final buffer = StringBuffer();
  for (var i = 1; i <= 3; i++) {
    buffer.write('$i ');
  }
  print('StringBuffer: ${buffer.toString().trim()}');
}

void demonstrateBooleans() {
  print('\n--- Booleans ---');
  const x = 7;
  const y = 10;
  final isSmall = x < 10;
  final isEven = x.isEven;
  print('x < 10: $isSmall, x.isEven: $isEven');
  print('&&: ${isSmall && isEven}, ||: ${isSmall || isEven}, !: ${!isEven}');
  print('x == y: ${x == y}, x != y: ${x != y}');

  final label = x > y ? 'x більше' : 'x не більше';
  print('Ternary: $label');
  final sign = x > 0 ? 'positive' : (x < 0 ? 'negative' : 'zero');
  print('Nested ternary: $sign');

  // switch expression (Dart 3)
  final size = switch (x) {
    < 5 => 'small',
    < 10 => 'medium',
    _ => 'large',
  };
  print('Switch expression: $size');
}

void demonstrateCollections() {
  print('\n--- Collections ---');
  final list = <int>[5, 3, 8, 1];
  list.add(10);
  list.sort();
  print('List: $list, first=${list.first}, last=${list.last}');
  print('List.map(x*2): ${list.map((e) => e * 2).toList()}');

  final set = <String>{'dart', 'flutter', 'dart'};
  set.add('git');
  print('Set (унікальні): $set, length=${set.length}');

  final map = <String, int>{'apple': 3, 'pear': 5};
  map['banana'] = 7;
  print('Map: $map, keys=${map.keys}, values=${map.values}');
  print('containsKey("pear"): ${map.containsKey("pear")}');
  map.remove('apple');
  map.forEach((k, v) => print('  $k -> $v'));

  // spread, collection if/for
  final extended = [0, ...list, if (list.length > 3) 99];
  print('Spread + collection-if: $extended');
}

String? maybeName(bool give) => give ? 'Olena' : null;

class Config {
  late final String path; // ініціалізується пізніше
  final String mode;
  Config({required this.mode});
  void init() => path = '/tmp/$mode';
}

void demonstrateNullSafety() {
  print('\n--- Null Safety ---');
  String? nullable = maybeName(false);
  print('nullable = $nullable');
  print('?. -> ${nullable?.length}');
  print('?? -> ${nullable ?? "default"}');
  nullable ??= 'assigned'; // присвоїти, якщо null
  print('??= -> $nullable');

  String? other = maybeName(true);
  if (other != null) {
    print('promotion: ${other.toUpperCase()}'); // без ! після перевірки
  }
  print('! operator: ${other!.length}');

  final cfg = Config(mode: 'dev');
  cfg.init();
  print('late variable: ${cfg.path}');
  print('required named parameter: mode=${cfg.mode}');
}
