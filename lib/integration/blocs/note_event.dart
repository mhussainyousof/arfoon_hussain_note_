part of 'note_bloc.dart';

@immutable
abstract class NotesEvent  extends  Equatable{
  @override
  List<Object?> get props => [];
}


class LoadNotes extends NotesEvent {
   LoadNotes();
}


class AddNoteEvent extends NotesEvent {
  final Note note;
   AddNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}





