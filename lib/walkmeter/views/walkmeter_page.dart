import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walkmeter/walkmeter/bloc/walkmeter_bloc.dart';
import 'package:walkmeter/walkmeter/views/views.dart';

class WalkmeterPage extends StatelessWidget {
  const WalkmeterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Walkmeter',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: BlocProvider<WalkmeterBloc>(
          create: (BuildContext context) => WalkmeterBloc(),
          child: const WalkmeterView(),
        ));
  }
}
