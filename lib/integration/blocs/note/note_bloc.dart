import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arfoon_note/client/models/filter.dart';
import 'package:arfoon_note/client/models/note.dart';
import 'package:arfoon_note/server/note_server.dart';

part 'note_event.dart';
part 'note_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteServer api;

  NotesBloc(this.api) : super(NotesInitial()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<UpdatedNoteEvent>(_onUpdateNote);
  }

  Future<void> _onLoadNotes(
      LoadNotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await api.notes.list();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await api.notes.insert(event.note);
      final notes = await api.notes.list();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(
      DeleteNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await api.notes.deleteNote(event.id);
      final notes = await api.notes.list();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onUpdateNote(
      UpdatedNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await api.notes.updateNote(event.note);
      final notes = await api.notes.list();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}

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

  refresh() {
    load(initalGetData!, initalFilter);
  }
  
}

enum AwaitStatus {
  loading,
  data,
  error,
}

class AwaitState<T> {
  final AwaitStatus? status;
  final T? data;
  final Object? error;
  final Filter? filter;
  const AwaitState({
    this.status,
    this.data,
    this.error,
    this.filter,
  });

  AwaitState<T> copyWith({
    AwaitStatus? status,
    T? data,
    Object? error,
    Filter? filter,
  }) {
    return AwaitState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
      filter: filter ?? this.filter,
    );
  }
}

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
