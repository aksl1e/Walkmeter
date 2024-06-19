part of 'walkmeter_bloc.dart';

sealed class WalkmeterEvent extends Equatable {
  const WalkmeterEvent();

  @override
  List<Object> get props => [];
}

final class WalkmeterStepsChanged extends WalkmeterEvent {
  const WalkmeterStepsChanged(this.steps);

  final int steps;

  @override
  List<Object> get props => [steps];
}

final class WalkmeterStatusChanged extends WalkmeterEvent {
  const WalkmeterStatusChanged(this.status);

  final String status;

  @override
  List<Object> get props => [status];
}

final class WalkmeterDurationChanged extends WalkmeterEvent {}

final class WalkmeterStopped extends WalkmeterEvent {}

final class WalkmeterStarted extends WalkmeterEvent {}
