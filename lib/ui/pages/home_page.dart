import 'dart:io';
import 'dart:typed_data';

import 'package:file_sequence_check/blocs/register_bloc.dart';
import 'package:file_sequence_check/models/check_model.dart';
import 'package:file_sequence_check/service/api.dart';
import 'package:file_sequence_check/ui/components/custom_dropdown_menu.dart';
import 'package:file_sequence_check/ui/components/form_field_error_widget.dart';
import 'package:file_sequence_check/ui/components/generate_file.dart';
import 'package:file_sequence_check/ui/components/mutiple_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart';
import 'package:overlay_notifications/overlay_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final CheckModel? initialData;
  const HomePage({super.key, this.initialData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FormValidatorBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = registerBloc(widget.initialData);
  }

  void _onChange<T>(String key, T value) {
    _bloc.changeValue(key, value);
  }

  Future<Uint8List> convertByteStreamToUint8List(ByteStream byteStream) async {
    // Convertit ByteStream en Uint8List
    Uint8List data = await byteStream.toBytes();
    return data;
  }

  void _onSubmit() {
    if (_bloc.data.isLoading || !_bloc.validate()) {
      return;
    }
    _bloc.setLoadingStatus(true);

    Api.register(_bloc.getFormValues()).then((value) async {
      _bloc.setLoadingStatus(false);

      var path = await GenerateFile.saveFile(value, 'missing_file.xlsx');

      if (path == null || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Votre fichier a bien été enregistré'),
        action: SnackBarAction(
            label: 'Ouvrir le fichier',
            onPressed: () {
              launchUrl(Uri.file(path));
            }),
      ));
    }, onError: (err) {
      _bloc.setLoadingStatus(false);

      // FIXME handler error
      OverlayNotificationWidget notification;

      if (err is SocketException) {
        notification = const OverlayNotificationWidget.networkError();
      } else {
        notification = const OverlayNotificationWidget.wrongThing();
      }

      OverlayNotifications.instance
          .notify(context: context, notification: notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("File sequence check"),
        ),
        body: FormValidatorBuilder(
          bloc: _bloc,
          builder: (BuildContext context, FormValidatorData data) {
            return _contentWidget(data, size);
          },
        ));
  }

  Widget _contentWidget(FormValidatorData data, Size size) {
    final width = size.width;
    final fields = data.fields;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: width / 3,
              child: CustomDropdownMenu<String>(
                  // value: fields["typeTransit"]!.value,
                  onChanged: (value) => _onChange("db", value),
                  items: const ['MSC', 'CCN', 'GGSN', 'AIR'],
                  labelText: "Selectionner un noeud",
                  isDense: false,
                  filled: false,
                  border: const OutlineInputBorder(),
                  itemBuilder: (value) => Text(value)),
            ),
            if (fields["db"]!.errorMessage != null)
              FormFieldErrorWidget(fields["db"]!.errorMessage!),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: width / 3,
              child: MultipleImagePicker(
                initialFiles: fields["files"]!.value,
                onChanged: (v) {
                  _onChange('files', v);
                },
              ),
            ),
            if (fields["files"]!.errorMessage != null)
              FormFieldErrorWidget(fields["files"]!.errorMessage!),
            const SizedBox(
              height: 20.0,
            ),
            FilledButton.tonal(
                onPressed: data.isValid ? _onSubmit : null,
                style: ButtonStyle(
                    minimumSize:
                        WidgetStatePropertyAll(Size(width / 3, 52.0))),
                child: data.isLoading
                    ? const SizedBox(
                        // width: width / 3,
                        height: 32.0,
                        child: CircularProgressIndicator())
                    : const Text("Telecharger"))
          ],
        ),
      ),
    );
  }

}
