import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'modal.dart';

typedef AsyncCallbackContext = Future<void> Function(BuildContext context);

/// A plugin for device preview that allows to capture a screenshots from the
/// device (with its frame included)
///
/// An instance should be provided the the [plugins] constructor property of
/// a [DevicePreview].
class ScreenShotModesPlugin extends StatelessWidget {
  const ScreenShotModesPlugin(
      {required this.processor, required this.modes, this.onEnd});

  /// A screenshot that processes a screenshot and returns the result as a display message.
  ///you must use to save image or uploaded to internet ...
  final ScreenshotProcessor processor;

  /// list of type ItemScreenMode represents all mode page will be taken
  /// function to navigate to next screen
  /// label helps with naming the image in processor
  /// modes , used if you have nested like device frame , dark light mode before page
  final List<ItemScreenMode> modes;
  final void Function(BuildContext)? onEnd;

  @override
  Widget build(
    BuildContext context,
  ) {
    return _Screenshot(
      processor: processor,
      modes: modes,
      onEnd: onEnd,
    );
  }
}

/// Process a given [screenshot] and returns a displayed message.
///
/// See also :
///   * [DevicePreview] uses it to process all the screenshots taken by the user.
typedef ScreenshotProcessor = Future<String> Function(
  DeviceScreenshotWithLabel screenshot,
);

class _Screenshot extends StatefulWidget {
  const _Screenshot({
    Key? key,
    required this.processor,
    required this.modes,
    this.onEnd,
  }) : super(key: key);
  final List<ItemScreenMode> modes;
  final ScreenshotProcessor processor;
  final void Function(BuildContext)? onEnd;

  @override
  _ScreenshotState createState() => _ScreenshotState();
}

class _ScreenshotState extends State<_Screenshot> {
  bool isLoading = false;
  List<Object> link = [];
  dynamic error;

  void pressTake() {
    setState(() {
      link.clear();
      isLoading = true;
    });

    _takeScreen(widget.modes, []).then((_) {
      setState(() {
        isLoading = false;
      });
      widget.onEnd?.call(context);
    });
  }

  Future<void> _takeScreen(
      List<ItemScreenMode> modes, List<Object> label) async {
    for (final mode in modes) {
      await mode.function?.call(context);
      if (mode.modes != null) {
        await _takeScreen(
            mode.modes!, [...label, if (mode.label != null) mode.label!]);
      } else {
        await Future.delayed(Duration(milliseconds: 400));
        await _take([...label, if (mode.label != null) mode.label!]);
        await Future.delayed(Duration(milliseconds: 40));
      }
    }
  }

  Future<void> _take(List<Object> label) async {
    try {
      final screenshot = await DevicePreview.screenshot(context);

      final link =
          await widget.processor(DeviceScreenshotWithLabel(label, screenshot));
      setState(() {
        this.link.add(link);
      });
    } catch (e) {
      setState(() {
        error = e;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPanelSection(title: 'Screenshot Mode', children: [
      ListTile(
        title: OutlinedButton(
          onPressed: pressTake,
          child: Text(isLoading ? "Re Take" : "Take"),
        ),
        trailing: isLoading
            ? SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator())
            : null,
      ),
      if (!isLoading && link.isNotEmpty)
        ListTile(
          title: OutlinedButton(
            onPressed: () {
              setState(() {
                link.clear();
              });
            },
            child: Text("Clear"),
          ),
          trailing: null,
        ),
      if (error != null)
        ListTile(
          title: Text(
            'Error while processing screenshot : $error',
          ),
          textColor: Colors.red,
        ),
      if (link.isNotEmpty)
        ListTile(
            title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: link.map(
            (e) {
              return Text(e.toString());
            },
          ).toList(),
        )),
    ]);
  }
}
