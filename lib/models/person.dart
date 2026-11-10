/// Базовий абстрактний клас для всіх людей в університеті.
abstract class Person {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    var years = now.year - birthDate.year;
    final hadBirthday = now.month > birthDate.month ||
        (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hadBirthday) years--;
    return years;
  }

  /// Абстрактний getter - кожен підклас визначає свою роль.
  String get role;
}
