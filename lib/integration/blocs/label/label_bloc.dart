import 'dart:async';
import 'package:arfoon_note/integration/blocs/label/label_state.dart';
import 'package:arfoon_note/server/note_server.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../client/models/models.dart';
part 'label_event.dart';



class LabelsBloc extends Bloc<LabelsEvent, LabelsState> {
  final NoteServer api;

  LabelsBloc(this.api) : super(LabelsInitial()) {
    on<AddLabelEvent>(_onAddLabel);
    on<DeleteLabelEvent>(_onDeleteLabel);
    on<UpdateLabelEvent>(_onUpdateLabel);
    on<LoadLabelEvent>(_onLoadLabels);
  }

  Future<void> _onLoadLabels(
      LoadLabelEvent event, Emitter<LabelsState> emit) async {
    emit(LabelsLoading());
    try {
      final labels = await api.labels.list();
      emit(LabelsLoaded(labels));
    } catch (e) {
      emit(LabelsError(e.toString()));
    }
  }

  Future<void> _onAddLabel(
      AddLabelEvent event, Emitter<LabelsState> emit) async {
    try {
      await api.labels.insert(event.label);
      final labels = await api.labels.list();
      emit(LabelsLoaded(labels));
    } catch (e) {
      emit(LabelsError(e.toString()));
    }
  }

  Future<void> _onDeleteLabel(
      DeleteLabelEvent event, Emitter<LabelsState> emit) async {
    try {
      await api.labels.deleteLabel(event.id);
      final labels = await api.labels.list();
      emit(LabelsLoaded(labels));
    } catch (e) {
      emit(LabelsError(e.toString()));
    }
  }

  Future<void> _onUpdateLabel(
      UpdateLabelEvent event, Emitter<LabelsState> emit) async {
    try {
      await api.labels.updateLabel(event.label);
      final labels = await api.labels.list();
      emit(LabelsLoaded(labels));
    } catch (e) {
      emit(LabelsError(e.toString()));
    }
  }
}
