import 'dart:async';
import 'package:arfoon_note/integration/integration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arfoon_note/client/models/filter.dart';

class AwaitCubit<T> extends Cubit<AwaitState<T>> {
  AwaitCubit() : super(AwaitState(status: AwaitStatus.loading));
  Future<T> Function(Filter?)? initialGetData;
  Filter? initialFilter;

  void safeEmit(AwaitState<T> newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  load(Future<T> Function(Filter?) getData, Filter? filter,
      {bool inital = false}) async {
    if (isClosed) return;

    if (inital) {
      initialGetData = getData;
      initialFilter = filter;
    }

    try {
      safeEmit(state.copyWith(status: AwaitStatus.loading, filter: filter));
      var data = await getData(filter);
      safeEmit(state.copyWith(status: AwaitStatus.data, data: data));
    } catch (e) {
      safeEmit(state.copyWith(error: e, status: AwaitStatus.error));
    }
  }

  filter(Filter filter) {
    if (!isClosed && initialGetData != null) {
      load(initialGetData!, filter);
    }
  }

  refresh({Filter? filter}) {
    if (!isClosed && initialGetData != null) {
      load(initialGetData!, filter ?? state.filter ?? initialFilter);
    }
  }
}
