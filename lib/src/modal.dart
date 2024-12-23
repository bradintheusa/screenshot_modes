import 'package:device_preview_plus/device_preview_plus.dart';

import 'core.dart';

class DeviceScreenshotWithLabel {
  final List<Object> label;
  final DeviceScreenshot deviceScreenshot;
  const DeviceScreenshotWithLabel(this.label, this.deviceScreenshot);
}

class ItemScreenMode {
  const ItemScreenMode({this.function, this.modes, this.label});

  /// function to navigate to next screen
  final AsyncCallbackContext? function;

  /// modes , used if you have nested like device frame , dark light mode before page
  final List<ItemScreenMode>? modes;

  /// label helps with naming the image in processor
  final Object? label;
}
