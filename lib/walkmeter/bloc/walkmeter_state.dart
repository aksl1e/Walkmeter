part of 'walkmeter_bloc.dart';

enum Pedostatus { walking, stopped, unknown }

enum Status { counting, stopped, unknown }

final class WalkmeterState extends Equatable {
  const WalkmeterState({
    this.steps = 0,
    this.dayGoal = 0,
    this.pedostatus = Pedostatus.unknown,
    this.status = Status.unknown,
    this.stepLengthMeters = 0,
    this.distanceKM = 0.0,
    this.walkDuration = const Duration(),
    this.isActive = true,
  });

  final int steps;
  final int dayGoal;
  final Pedostatus pedostatus;
  final Status status;
  final int stepLengthMeters;
  final double distanceKM;
  final Duration walkDuration;
  final bool isActive;

  WalkmeterState copyWith({
    int? steps,
    int? dayGoal,
    Pedostatus? pedostatus,
    Status? status,
    int? stepLengthMeters,
    double? distanceKM,
    Duration? walkDuration,
    bool? isActive,
  }) {
    return WalkmeterState(
      steps: steps ?? this.steps,
      dayGoal: dayGoal ?? this.dayGoal,
      pedostatus: pedostatus ?? this.pedostatus,
      status: status ?? this.status,
      stepLengthMeters: stepLengthMeters ?? this.stepLengthMeters,
      distanceKM: distanceKM ?? this.distanceKM,
      walkDuration: walkDuration ?? this.walkDuration,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object> get props =>
      [steps, dayGoal, pedostatus, status, distanceKM, walkDuration, isActive];
}
