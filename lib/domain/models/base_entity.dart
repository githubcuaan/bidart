import 'package:flutter/foundation.dart';

abstract class BaseEntity<T> {
  T get id;
  T get name;
  T get description;
}

extension BaseEntityCommonMethods<T> on BaseEntity<T> {
  String get displayTitle => '$name (#$id)';
  bool matchesKeyword(String keyword) {
    final query = keyword.toLowerCase().trim();
    return name.toString().toLowerCase().contains(query) ||
           description.toString().toLowerCase().contains(query);
  }
  void printInfo() {
    debugPrint('[$runtimeType] ID: $id | Tên: $name | Miêu tả: $description');
  }
}