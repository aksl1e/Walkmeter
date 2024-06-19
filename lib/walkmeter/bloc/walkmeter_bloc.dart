import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pedometer/pedometer.dart';

part 'walkmeter_event.dart';
part 'walkmeter_state.dart';

class WalkmeterBloc extends Bloc<WalkmeterEvent, WalkmeterState> {
  WalkmeterBloc() : super(const WalkmeterState()) {
    _initialize();
  }

  Stream<Map<String, dynamic>?> pedometerServiceStepsStream =
      FlutterBackgroundService().on('updateSteps');
  Stream<Map<String, dynamic>?> pedometerServiceStatusStream =
      FlutterBackgroundService().on('updateStatus');
  Stream<Map<String, dynamic>?> pedometerServiceTimerBoolStream =
      FlutterBackgroundService().on('updateDuration');

  void _initialize() {
    _addEventListeners();
    _initPedometerStream();
  }

  void _addEventListeners() {
    on<WalkmeterStepsChanged>(_onStepsChanged);
    on<WalkmeterStatusChanged>(_onStatusChanged);
    on<WalkmeterDurationChanged>(_onDurationChanged);
    on<WalkmeterStopped>(_onStopped);
    on<WalkmeterStarted>(_onStarted);
  }

  void _initPedometerStream() {
    pedometerServiceStepsStream.listen((dataMap) {
      add(WalkmeterStepsChanged(int.parse(dataMap?['steps'])));
      print('Bloc Status: ${dataMap?['steps']}');
    });

    pedometerServiceStatusStream.listen((dataMap) {
      add(WalkmeterStatusChanged(dataMap?['status']));
      print('Bloc Status: ${dataMap?['status']}');
    });

    pedometerServiceTimerBoolStream.listen((dataMap) {
      add(WalkmeterDurationChanged());
    });
  }

  FutureOr<void> _onStepsChanged(
      WalkmeterStepsChanged event, Emitter<WalkmeterState> emit) {
    if (state.isActive) {
      int stepsChange = event.steps - state.steps;
      emit(state.copyWith(
        steps: state.steps + stepsChange,
      ));
      emit(state.copyWith(
        distanceKM: (state.steps * state.stepLengthMeters) / 1000,
      ));
    }
  }

  FutureOr<void> _onStatusChanged(
      WalkmeterStatusChanged event, Emitter<WalkmeterState> emit) {
    if (state.isActive) {
      emit(state.copyWith(
        status: Status.values.byName(event.status),
      ));
    }
  }

  FutureOr<void> _onDurationChanged(
      WalkmeterDurationChanged event, Emitter<WalkmeterState> emit) {
    if (state.isActive && state.status.name == 'walking') {
      emit(state.copyWith(
        walkDuration: state.walkDuration + const Duration(seconds: 1),
      ));
    }
  }

  FutureOr<void> _onStopped(
      WalkmeterStopped event, Emitter<WalkmeterState> emit) {}

  FutureOr<void> _onStarted(
      WalkmeterStarted event, Emitter<WalkmeterState> emit) {}
}
