import '../../../client/models/models.dart';

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
