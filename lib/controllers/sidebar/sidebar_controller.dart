import 'package:get/get.dart';

class SidebarController extends GetxController {
  var expandedGroup = RxnString();

  void setExpandedGroup(String? group) {
    expandedGroup.value = group;
  }
}