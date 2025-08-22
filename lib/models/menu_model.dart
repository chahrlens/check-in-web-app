import 'package:flutter/material.dart';

class MenuItemModel {
  final String label;
  final String route;
  final IconData icon;
  final bool show;

  MenuItemModel({required this.label, required this.route, required this.icon, this.show = true});
}

class MenuGroupModel {
  final String label;
  final List<MenuItemModel> children;

  MenuGroupModel({required this.label, required this.children});
}