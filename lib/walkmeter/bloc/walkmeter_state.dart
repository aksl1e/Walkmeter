part of 'walkmeter_bloc.dart';

enum Pedostatus { walking, stopped, unknown }

enum Status { counting, stopped, unknown }

final class WalkmeterState extends Equatable {
  const WalkmeterState({
    this.steps = 0,
    this.dayGoal = 4000,
    this.pedostatus = Pedostatus.unknown,
    this.stepLengthCM = 45,
    this.distanceKM = 0.0,
    this.walkDuration = const Duration(),
    this.isActive = true,
  });

  final int steps;
  final int dayGoal;
  final Pedostatus pedostatus;
  final int stepLengthCM;
  final double distanceKM;
  final Duration walkDuration;
  final bool isActive;

  WalkmeterState copyWith({
    int? steps,
    int? dayGoal,
    Pedostatus? pedostatus,
    int? stepLengthCM,
    double? distanceKM,
    Duration? walkDuration,
    bool? isActive,
  }) {
    return WalkmeterState(
      steps: steps ?? this.steps,
      dayGoal: dayGoal ?? this.dayGoal,
      pedostatus: pedostatus ?? this.pedostatus,
      stepLengthCM: stepLengthCM ?? this.stepLengthCM,
      distanceKM: distanceKM ?? this.distanceKM,
      walkDuration: walkDuration ?? this.walkDuration,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object> get props =>
      [steps, dayGoal, pedostatus, distanceKM, walkDuration, isActive];
}
