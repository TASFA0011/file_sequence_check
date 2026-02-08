import 'dart:async';
import 'package:flutter/material.dart';

class LoadingDialogController {
  Completer<void>? _completer;
  VoidCallback? _closeCallback;

  set _setCallback(VoidCallback closeCallback) {
    _closeCallback = closeCallback;
    /// Si completer est different de null dans ce cas la methode `close`
    /// a deja ete appele avant que le widget ne soit prete
    if (_completer != null) {
      _closeCallback!();
      _completer!.complete();
    }
  }

  Future<void> close() {
    bool isFirstTime = _completer == null;
    _completer ??= Completer();
    if (isFirstTime && _closeCallback != null) {
      /// Le composant est deja charge!
      _closeCallback!();
      _completer!.complete();
    }
    // Si competer est different de null dans ce case la methode `close` a deja ete appele
    return _completer!.future;
  }

  // bool get isClosed => _completer == null || _completer!.isCompleted;

}

LoadingDialogController showLoadingDialog({
  required BuildContext context
}) {
  final controller = LoadingDialogController();
  showDialog(
    context: context,
    builder: (_) => _LoadingDialog(controller: controller),
    barrierDismissible: false
  );
  return controller;
}

class _LoadingDialog extends StatefulWidget {
  final LoadingDialogController controller;
  const _LoadingDialog({ required this.controller });

  @override
  State<_LoadingDialog> createState() => __LoadingDialogState();
}

class __LoadingDialogState extends State<_LoadingDialog> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller._setCallback = Navigator.of(context).pop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
