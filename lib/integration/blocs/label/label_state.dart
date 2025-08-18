
import 'package:equatable/equatable.dart';

import '../../../client/models/models.dart';

abstract class LabelsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LabelsInitial extends LabelsState {}

class LabelsLoading extends LabelsState {}

class LabelsLoaded extends LabelsState {
  final List<Label> labels;
  LabelsLoaded(this.labels);

  @override
  List<Object?> get props => [labels];
}

class LabelsError extends LabelsState {
  final String message;
  LabelsError(this.message);

  @override
  List<Object?> get props => [message];
}
