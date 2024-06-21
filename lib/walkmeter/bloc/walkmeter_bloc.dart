import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:duration/duration.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Stream<Map<String, dynamic>?> pedometerServiceTimerStream =
      FlutterBackgroundService().on('updateDuration');

  void _initialize() {
    _addEventListeners();
    _initPedometerStream();
    _initStateFromPrefs();
  }

  void _addEventListeners() {
    on<WalkmeterStepsChanged>(_onStepsChanged);
    on<WalkmeterStatusChanged>(_onStatusChanged);
    on<WalkmeterDurationChanged>(_onDurationChanged);
    on<WalkmeterDayGoalChanged>(_onDayGoalChanged);
    on<WalkmeterStepLengthMetersChanged>(_onStepLengthMetersChanged);
    on<WalkmeterActiveChanged>(_onActiveChanged);
    on<WalkmeterStateToPrefsSaved>(_onStateToPrefsSaved);
    on<WalkmeterStateFromPrefsRequested>(_onStateFromPrefsRequested);
    on<WalkmeterDisposed>(_onDisposed);
  }

  void _initPedometerStream() {
    pedometerServiceStepsStream.listen((dataMap) {
      add(WalkmeterStepsChanged(int.parse(dataMap?['steps'])));
    });

    pedometerServiceStatusStream.listen((dataMap) {
      add(WalkmeterStatusChanged(dataMap?['status']));
    });

    pedometerServiceTimerStream.listen((dataMap) {
      add(WalkmeterDurationChanged());
    });
  }

  void _initStateFromPrefs() {
    add(WalkmeterStateFromPrefsRequested());
  }

  FutureOr<void> _onStepsChanged(
      WalkmeterStepsChanged event, Emitter<WalkmeterState> emit) {
    if (state.isActive) {
      int newSteps = state.steps + 1;
      emit(state.copyWith(
        steps: newSteps,
      ));
      emit(state.copyWith(
        distanceKM: (state.steps * state.stepLengthCM) / 100 / 1000,
      ));
    }
  }

  FutureOr<void> _onStatusChanged(
      WalkmeterStatusChanged event, Emitter<WalkmeterState> emit) {
    if (state.isActive) {
      emit(state.copyWith(
        pedostatus: Pedostatus.values.byName(event.status),
      ));
    }
  }

  FutureOr<void> _onDurationChanged(
      WalkmeterDurationChanged event, Emitter<WalkmeterState> emit) {
    if (state.isActive && state.pedostatus == Pedostatus.walking) {
      Duration newDuration = state.walkDuration + const Duration(seconds: 1);
      emit(state.copyWith(
        walkDuration: newDuration,
      ));
    }
  }

  FutureOr<void> _onDayGoalChanged(
      WalkmeterDayGoalChanged event, Emitter<WalkmeterState> emit) {
    emit(state.copyWith(
      dayGoal: event.newDayGoal,
    ));
  }

  FutureOr<void> _onStepLengthMetersChanged(
      WalkmeterStepLengthMetersChanged event, Emitter<WalkmeterState> emit) {
    emit(state.copyWith(
      stepLengthCM: event.newStepLengthCM,
      distanceKM: (state.steps * event.newStepLengthCM) / 100 / 1000,
    ));
  }

  FutureOr<void> _onActiveChanged(
      WalkmeterActiveChanged event, Emitter<WalkmeterState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state.isActive) {
      emit(state.copyWith(
        isActive: false,
      ));

      add(WalkmeterStateToPrefsSaved());
    } else {
      int? prefsSteps = prefs.getInt('steps');
      int? prefsDayGoal = prefs.getInt('dayGoal');
      int? prefsStepLength = prefs.getInt('stepLength');
      String? prefsWalkDuration = prefs.getString('walkDuration');

      emit(state.copyWith(
        steps: prefsSteps,
        dayGoal: prefsDayGoal,
        stepLengthCM: prefsStepLength,
        walkDuration: parseTime(prefsWalkDuration!),
        isActive: true,
      ));
    }
  }

  FutureOr<void> _onStateToPrefsSaved(
      WalkmeterStateToPrefsSaved event, Emitter<WalkmeterState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', state.steps);
    await prefs.setInt('dayGoal', state.dayGoal);
    await prefs.setInt('stepLength', state.stepLengthCM);
    await prefs.setString('walkDuration', state.walkDuration.toString());
  }

  FutureOr<void> _onStateFromPrefsRequested(
      WalkmeterStateFromPrefsRequested event,
      Emitter<WalkmeterState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? prefsSteps = prefs.getInt('steps');
    int? prefsDayGoal = prefs.getInt('dayGoal');
    int? prefsStepLength = prefs.getInt('stepLength');
    String? prefsWalkDuration = prefs.getString('walkDuration');

    emit(state.copyWith(
      steps: prefsSteps,
      dayGoal: prefsDayGoal,
      distanceKM: (prefsSteps! * prefsStepLength!) / 100 / 1000,
      stepLengthCM: prefsStepLength,
      walkDuration: parseTime(prefsWalkDuration!),
    ));
  }

  FutureOr<void> _onDisposed(
      WalkmeterDisposed event, Emitter<WalkmeterState> emit) {
    FlutterBackgroundService().invoke('stopService');
    add(WalkmeterStateToPrefsSaved());
  }
}
