import 'package:arfoon_note/client/client.dart';

class Filter {
  final String? search;
  final Pagination? pagination;
  final Label? label;
  Filter({
    this.label,
    this.search,
    this.pagination,
  });
}
