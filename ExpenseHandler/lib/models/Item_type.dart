import 'package:flutter/material.dart';
import 'package:ExpenseHandler/support/icon_helper.dart';

class ItemType {
  ItemType({
    @required this.id,
    @required this.name,
    @required this.codePoint,
  });
  final int id;
  final String name;
  final int codePoint;

  IconData get iconData => IconHelper.createIconData(codePoint);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'codePoint': codePoint,
      };

  factory ItemType.fromMap(Map<String, dynamic> map) => ItemType(
        id: map['id'],
        name: map['name'],
        codePoint: map['codePoint'],
      );
}