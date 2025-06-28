class ScheduledTermIdentifier {
  final int year; // YYYY
  final int period; // X where X is from 0 to 2
  final String id; // 'YYYYX' where X is from 0 to 2
  final String name; // 'YYYY-X'

  ScheduledTermIdentifier._({
    required this.year,
    required this.period,
    required this.id,
    required this.name,
  });

  factory ScheduledTermIdentifier.buildFromId(String id) {
    if (id.length != 5) {
      throw ArgumentError(
        'El ID del semestre debe tener exactamente 5 caracteres, pero se recibió "$id".',
      );
    }
    final year = int.tryParse(id.substring(0, 4));
    if (year == null) {
      throw ArgumentError(
        'El ID del semestre debe comenzar con un año válido de 4 dígitos, pero se recibió "$id".',
      );
    }
    final period = int.tryParse(id.substring(4));
    if (period == null || period < 0 || period > 2) {
      throw ArgumentError(
        'El período del semestre debe ser un número entre 0 y 2, pero se recibió "$period" ("$id").',
      );
    }
    final name = '$year-$period';
    return ScheduledTermIdentifier._(
      id: id,
      name: name,
      year: year,
      period: period,
    );
  }

  factory ScheduledTermIdentifier.buildFromName(String name) {
    final parts = name.split('-');
    if (parts.length != 2) {
      throw ArgumentError(
        'El nombre del semestre debe estar en el formato "YYYY-X", pero se recibió "$name".',
      );
    }
    final year = int.tryParse(parts[0]);
    if (year == null) {
      throw ArgumentError(
        'El año en el nombre del semestre debe ser un número válido de 4 dígitos, pero se recibió "$name".',
      );
    }
    final period = int.tryParse(parts[1]);
    if (period == null || period < 0 || period > 2) {
      throw ArgumentError(
        'El período en el nombre debe ser un número entre 0 y 2, pero se recibió "$period" ("$name").',
      );
    }
    final id = '$year$period';
    return ScheduledTermIdentifier._(
      id: id,
      name: name,
      year: year,
      period: period,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScheduledTermIdentifier && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  bool operator <(ScheduledTermIdentifier other) => id.compareTo(other.id) < 0;
  bool operator <=(ScheduledTermIdentifier other) =>
      id.compareTo(other.id) <= 0;
  bool operator >(ScheduledTermIdentifier other) => id.compareTo(other.id) > 0;
  bool operator >=(ScheduledTermIdentifier other) =>
      id.compareTo(other.id) >= 0;
}
