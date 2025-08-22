import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';

class UserCheckIn {
  int id;
  String name;
  String email;
  UserCheckIn({required this.id, required this.name, required this.email});
}

class CheckInController extends GetxController {
  final userName = TextEditingController();
  final quantityAvailable = TextEditingController();
  final quantity = TextEditingController();

  UserCheckIn? selectedElement;
}
