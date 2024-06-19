import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walkmeter/walkmeter/bloc/walkmeter_bloc.dart';

class WalkmeterView extends StatelessWidget {
  const WalkmeterView({super.key});

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 200.0,
            width: 200.0,
            child: CircularProgressIndicator(
              value: context.watch<WalkmeterBloc>().state.steps /
                  context.watch<WalkmeterBloc>().state.dayGoal,
              semanticsValue:
                  context.watch<WalkmeterBloc>().state.steps.toString(),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                        'Distance: ${context.watch<WalkmeterBloc>().state.distanceKM.toStringAsFixed(2)} KM'),
                    Text(
                        'Time: ${format(context.watch<WalkmeterBloc>().state.walkDuration)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                        'Goal: ${context.watch<WalkmeterBloc>().state.dayGoal.toString()}'),
                    Text(
                        'Steps: ${context.watch<WalkmeterBloc>().state.steps.toString()}'),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Change DayGoal'),
                DropdownMenu<int>(
                  width: 120,
                  initialSelection:
                      context.watch<WalkmeterBloc>().state.dayGoal,
                  dropdownMenuEntries: [
                    for (var i = 4000; i <= 7000; i += 500) i
                  ].map<DropdownMenuEntry<int>>((int number) {
                    return DropdownMenuEntry(
                        value: number, label: number.toString());
                  }).toList(),
                  onSelected: (int? selectedNumber) {
                    context
                        .read<WalkmeterBloc>()
                        .add(WalkmeterDayGoalChanged(selectedNumber!));
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Change Step(CM)'),
                DropdownMenu<int>(
                  width: 110,
                  initialSelection:
                      context.watch<WalkmeterBloc>().state.stepLengthCM,
                  dropdownMenuEntries: [for (var i = 45; i <= 70; i++) i]
                      .map<DropdownMenuEntry<int>>((int number) {
                    return DropdownMenuEntry(
                        value: number, label: number.toString());
                  }).toList(),
                  onSelected: (int? selectedNumber) {
                    context
                        .read<WalkmeterBloc>()
                        .add(WalkmeterStepLengthMetersChanged(selectedNumber!));
                  },
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () =>
                  context.read<WalkmeterBloc>().add(WalkmeterActiveChanged()),
              icon: context.watch<WalkmeterBloc>().state.isActive
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow))
        ],
      ),
    );
  }
}
