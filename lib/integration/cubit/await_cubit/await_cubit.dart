import 'dart:async';
import 'package:arfoon_note/integration/integration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arfoon_note/client/models/filter.dart';

class AwaitCubit<T> extends Cubit<AwaitState<T>> {
  AwaitCubit() : super(AwaitState(data: null));
  Future<T> Function(Filter?)? initalGetData;
  Filter? initalFilter;


  load(Future<T> Function(Filter?) getData, Filter? filter,
      {bool inital = false}) async {

    if (inital) {
      initalGetData = getData;
      initalFilter = filter;
    }

    try {
      emit(state.copyWith(status: AwaitStatus.loading, filter: filter));
      var data = await getData(filter);
      emit(state.copyWith(status: AwaitStatus.data, data: data));
    } catch (e) {
      emit(state.copyWith(error: e, status: AwaitStatus.error));
    }

  }

  filter(Filter filter) {
      load(initalGetData!, filter);
  }

  refresh({Filter? filter}) {
      load(initalGetData!, filter ?? state.filter ?? initalFilter);
    
  }
}
