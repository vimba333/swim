import 'package:swim/features/survay/domain/entities/swimmer_type.dart';

class SwimmerLevel {
  static const double minSeconds = 45;
  static const double maxSeconds = 240;

  final double? seconds; // null = пропущено / не заполнено

  const SwimmerLevel({
    this.seconds,
  });

  bool get isSkipped => seconds == null;

  SwimmerType? get swimmerType {
    final s = seconds;
    if (s == null) return null;
    if (s <= 70) return SwimmerType.elite;
    if (s <= 90) return SwimmerType.advanced;
    if (s <= 120) return SwimmerType.intermediate;
    return SwimmerType.beginner;
  }
}