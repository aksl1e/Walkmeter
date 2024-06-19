import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walkmeter/walkmeter/bloc/walkmeter_bloc.dart';

class WalkmeterView extends StatelessWidget {
  const WalkmeterView({super.key});

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
            ),
          ),
        ],
      ),
    );
  }
}
