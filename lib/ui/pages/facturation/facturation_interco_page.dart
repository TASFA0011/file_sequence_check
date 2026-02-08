
import 'dart:collection';
import 'dart:io';
// import 'package:file_picker_utils/file_picker_utils.dart' as file_picker_utils;
import 'package:file_sequence_check/constants/navigation_service.dart';
import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/service/api.dart';
import 'package:file_sequence_check/ui/components/custom_dropdown_menu.dart';
import 'package:file_sequence_check/ui/components/form_field_error_widget.dart';
import 'package:file_sequence_check/ui/components/single_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:overlay_notifications/overlay_notifications.dart';
import 'package:z_file/z_file.dart';

class FacturationIntercoPage extends StatefulWidget {
  const FacturationIntercoPage({super.key});

  @override
  State<FacturationIntercoPage> createState() => _FacturationIntercoPageState();
}

class _FacturationIntercoPageState extends State<FacturationIntercoPage> {
  
  late final FormValidatorBloc _bloc;


  FormValidatorBloc registerBloc({File? file, String? db}) {
  return FormValidatorBloc(
      data: FormValidatorData(
          fields: HashMap.from({
    'file': ValidatorField<Zfile?>(
      file != null ? Zfile.fromFile(file): null,
      requiredMessage: "Veuillez charger un fichier excel"

    ),
    'db': ValidatorField<String>(db ?? '',
        requiredMessage: 'Veuillez selectionner un noeud'),

  }) )); 
}

  @override
  void initState() {
    super.initState();
    _bloc = registerBloc();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        fetchFacturationAdress();
    });
  

  }

  void fetchFacturationAdress() {

    //TODO
    Api.checkFacturationAdress().then((v){
      if (v == null) {
        NavigationService.nestedNavigatorKey.currentState
          ?.pushNamed(Routes.FACTURATION_ADRESS, arguments: true);
          return;
      }
    });
  }


  void _onChange<T>(String key, Zfile? value) {
    _bloc.changeValue(key, value);
  }

  
  void _onDbChange<T>(String key, T value) {
    _bloc.changeValue(key, value);
  }


  void _onSubmit() {
    if (_bloc.data.isLoading || !_bloc.validate()) {
      return;
    }
    _bloc.setLoadingStatus(true);

    Api.registerCall(_bloc.getFormValues()).then((value) async {
      _bloc.setLoadingStatus(false);

      // var path = await GenerateFile.saveFile(value, 'missing_file.xlsx');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Votre fichier a bien été charger'),
      ));

      NavigationService.navigate(Routes.FACTURATIONS);
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
        title: const Text("Facturation"),
      ),
      body: FormValidatorBuilder(
                bloc: _bloc,
                builder: (BuildContext context, FormValidatorData data) {
                  return _contentWidget(data, size);
                },
              )
    );
  }

  Widget _contentWidget(FormValidatorData data, Size size) {
    final width = size.width;
    final fields = data.fields;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: width / 3,
              child: CustomDropdownMenu<String>(
                  // value: fields["typeTransit"]!.value,
                  onChanged: (value) => _onDbChange("db", value),
                  items: const ['voix', 'sms',],
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
              child: SingleFilePicker(
                onChanged: (file) => _onChange("file", file)),
              // file_picker_utils.DocumentPicker(
              //   height: 200,
              //   image: const AssetImage("assets/excel_img.png"),
              //   filterSpecification : const {"Document" : "*.xlsx; *.xlsm, *.xlsb;"},
              //   onChanged: (file) => _onChange("file", file),
              //   // borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              // ),
            
            ),
            if (fields["file"]!.errorMessage != null)
              FormFieldErrorWidget(fields["file"]!.errorMessage!),
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