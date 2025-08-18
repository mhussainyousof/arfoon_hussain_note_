part of 'label_bloc.dart';

abstract class LabelsEvent extends Equatable {
  const LabelsEvent();

  @override
  List<Object?> get props => [];
}



class LoadLabelEvent extends LabelsEvent{}

class AddLabelEvent extends LabelsEvent{
  final Label label;
  const AddLabelEvent(this.label);

   @override
  List<Object?> get props => [label];
}

  class DeleteLabelEvent extends LabelsEvent {
  final int id;
  const DeleteLabelEvent(this.id);

  @override
  List<Object?> get props => [id];
}


class UpdateLabelEvent extends LabelsEvent {
  final Label label;
  const UpdateLabelEvent(this.label);

  @override
  List<Object?> get props => [label];
}




