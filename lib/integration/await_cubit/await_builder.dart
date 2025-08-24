import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AwaitBuilder<T> extends StatefulWidget {
  const AwaitBuilder({
    super.key,
    required this.getData,
    required this.builder,
    this.initalFilter,
    this.cubit,
  });

  final AwaitCubit<T>? cubit;
  final Future<T> Function(Filter?) getData;
  final Widget Function(BuildContext context, AwaitState<T>) builder;
  final Filter? initalFilter;

  @override
  State<AwaitBuilder<T>> createState() => _AwaitBuilderState<T>();
}

class _AwaitBuilderState<T> extends State<AwaitBuilder<T>> {
  AwaitCubit<T> awaitCubit = AwaitCubit();

  @override
  void initState() {
    super.initState();
    if (widget.cubit != null) {
      awaitCubit = widget.cubit!;
    }

    awaitCubit.load(
      widget.getData,
      widget.initalFilter,
      inital: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => awaitCubit,
      child: BlocBuilder<AwaitCubit<T>, AwaitState<T>>(
        builder: (context, state) {
          return widget.builder(context, state);
        },
      ),
    );
  }
}
