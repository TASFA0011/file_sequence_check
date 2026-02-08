import 'dart:collection';

import 'package:file_sequence_check/models/check_model.dart';
import 'package:form_validator/form_validator.dart';
import 'package:z_file/z_file.dart';

FormValidatorBloc registerBloc(CheckModel? data) {
  return FormValidatorBloc(
      data: FormValidatorData(
          fields: HashMap.from({
    'files': ValidatorField<List<Zfile>?>(data?.files != null
        ? List.generate(
            data!.files.length, (index) => Zfile.fromFile(data.files[index]))
        : null),
    'db': ValidatorField<String>(data?.db ?? '',
        requiredMessage: 'Veuillez selection un noeud'),
  })));
}
