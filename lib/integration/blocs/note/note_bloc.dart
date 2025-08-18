import 'dart:async';

import 'package:arfoon_note/client/models/note.dart';
import 'package:arfoon_note/server/note_server.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> _onLoadNotes(LoadNotesEvent event, Emitter<NotesState> emit) async {
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

  Future<void> _onDeleteNote(DeleteNoteEvent event, Emitter<NotesState> emit)async {
    try{
      await api.notes.deleteNote(event.id);
      final notes = await api.notes.list();
      emit(NotesLoaded(notes));
    }catch(e){
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdatedNoteEvent event, Emitter<NotesState> emit) async {
     try {
      await api.notes.updateNote(event.note);
      final notes = await api.notes.list();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}