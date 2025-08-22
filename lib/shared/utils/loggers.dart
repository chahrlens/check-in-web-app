import 'package:flutter/foundation.dart';
import 'package:qr_check_in/shared/constants/config.dart';

void debugLog(Object? object) {
  if (kDebugMode || Config.isDebug) {
    // ignore: avoid_print
    print(object);
  }
}
