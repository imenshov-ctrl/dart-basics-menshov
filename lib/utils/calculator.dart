import 'dart:math' as math;

class Calculator {
  double add(double a, double b) => a + b;
  double subtract(double a, double b) => a - b;
  double multiply(double a, double b) => a * b;

  double divide(double a, double b) {
    if (b == 0) throw ArgumentError('Division by zero');
    return a / b;
  }

  double power(double base, double exponent) =>
      math.pow(base, exponent).toDouble();

  double sqrt(double x) {
    if (x < 0) throw ArgumentError('Square root of negative number');
    return math.sqrt(x);
  }

  double percentOf(double percent, double value) => value * percent / 100;

  /// Виконує операцію за символом: + - * / ^
  double apply(String op, double a, double b) {
    switch (op) {
      case '+':
        return add(a, b);
      case '-':
        return subtract(a, b);
      case '*':
        return multiply(a, b);
      case '/':
        return divide(a, b);
      case '^':
        return power(a, b);
      default:
        throw ArgumentError('Unknown operator: $op');
    }
  }
}
