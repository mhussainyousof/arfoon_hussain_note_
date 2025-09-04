import 'package:isar/isar.dart';
import 'package:arfoon_note/client/client.dart';

class Notes {
  final Isar isar;
  const Notes({required this.isar});

  Future<Note> insert(Note note) async {
    var res = await isar.writeTxn(() async {
      return await isar.notes.put(note);
    });
    return note.copyWith(id: res);
  }

  Future<List<Note>> list([Filter? filter]) async {
     List<Note> notes;

    if ((filter?.search ?? '').isNotEmpty) {
      var s = filter!.search!;
      notes =  await isar.notes.filter().group((q)=> q
      .titleContains(s, caseSensitive: false)
      .or()
      .detailsContains(s, caseSensitive: false)
      ).findAll();
    }

     else if(filter?.label != null){
      notes =  await isar.notes.filter().labelIdsElementEqualTo (filter!.label!.id!).findAll();
    }
    
    else if (filter?.pagination != null) {
      notes =  await isar.notes
          .where()
          .offset(filter!.pagination!.offset)
          .limit(filter.pagination!.limit)
          .findAll();
    }else {
      notes = await isar.notes.where().findAll();
    }

    notes.sort((a,b){
      if(a.isPinned != b.isPinned){
        return a.isPinned ? -1 : 1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return notes;
  }

  Future<Note?> get(int id) async {
    return await isar.notes.get(id);
  }

  Future<Note?> updateNote(Note note) async {
    var res = await isar.writeTxn(() async {
      return await isar.notes.put(note);
    });
    return note.copyWith(id: res);
  }

  Future<bool> deleteNote(int id) async {
    return await isar.writeTxn(() async {
      return await isar.notes.delete(id);
    });
  }
}
