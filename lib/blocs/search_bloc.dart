import 'dart:collection';

import 'package:file_sequence_check/models/seach_model.dart';
import 'package:form_validator/form_validator.dart';


FormValidatorBloc getSearchBloc(SearchModel? data) {
  return FormValidatorBloc(
      data: FormValidatorData(
          fields: HashMap.from({
    "date": ValidatorField<String?>(
        data?.date ?? "",
        // requiredMessage: 'Veuillez renseigner une date',
    ),
    "type": ValidatorField<String>(
        data?.type ?? '',
        // requiredMessage: 'Veuillez renseigner une date',
      )
  })));
}
