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
  late final AwaitCubit<T> awaitCubit;

  @override
  void initState() {
    super.initState();

    awaitCubit = widget.cubit ?? AwaitCubit<T>();

    final currentState = widget.cubit!.state;
    if (currentState.data == null || currentState.status == AwaitStatus.error) {
      _loadData();
    }
  }

  void _loadData() {
    awaitCubit.load(
      widget.getData,
      widget.initalFilter,
      inital: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: awaitCubit,
      child: BlocBuilder<AwaitCubit<T>, AwaitState<T>>(
        builder: (context, state) {
          return widget.builder(context, state);
        },
      ),
    );
  }
}
