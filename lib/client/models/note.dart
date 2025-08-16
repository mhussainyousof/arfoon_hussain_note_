// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id? id = Isar.autoIncrement;
  String? title;
  String? details;
  int? colorId;
  List<int> labelIds;
  DateTime createdAt;
  DateTime? updatedAt;

  Note({
    this.id,
    this.title,
    this.details,
    this.colorId,
    required this.labelIds,
    required this.createdAt,
    this.updatedAt,
  });

  Note copyWith({
    Id? id,
    String? title,
    String? details,
    int? colorId,
    List<int>? labelIds,
    DateTime? createdAt,
  DateTime? updatedAt
    
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      colorId: colorId ?? this.colorId,
      labelIds: labelIds ?? this.labelIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt
    );
  }
}
