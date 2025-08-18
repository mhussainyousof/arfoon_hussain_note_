part of 'note_bloc.dart';

@immutable
abstract class NotesEvent  extends  Equatable{
  @override
  List<Object?> get props => [];
}


class LoadNotesEvent extends NotesEvent {
   LoadNotesEvent();
}

class AddNoteEvent extends NotesEvent {
  final Note note;
   AddNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}
class UpdatedNoteEvent extends NotesEvent {
  final Note note;
   UpdatedNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}


class DeleteNoteEvent extends NotesEvent{
  final int id;
  DeleteNoteEvent( this.id);
} 





