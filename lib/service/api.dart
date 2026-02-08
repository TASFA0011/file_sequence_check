import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:file_sequence_check/models/auth_data.dart';
import 'package:file_sequence_check/models/invoice_model.dart';
import 'package:file_sequence_check/models/user_model.dart';
import 'package:file_sequence_check/utils/get_media_type.dart';
import 'package:file_sequence_check/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:my_utils/my_utils.dart';

class Api {
  // ignore: non_constant_identifier_names
  // static String URL_BASE = 'http://127.0.0.1:5009';
  // ignore: non_constant_identifier_names
  static String URL_BASE = 'http://80.208.226.85:5009';

  static bool ok(int code) => code >= 200 && code < 300;

  static Future<void> ping(String host) async {
    final response = await http.get(Uri.parse('$host/api/ping'));

    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, response.body);
    }

    var data = json.decode(response.body);
    if (data['key'] != '3o1E5+ymOS1ZAPzI5RsBOw==') {
      throw Exception('wrong data');
    }
  }

  /* ************************************************************************************ */
  /* ************************************************************************************ */
  /* **************************************** USER ************************************** */
  /* ************************************************************************************ */
  /* ************************************************************************************ */

  static Future<AuthData> authenticate(String username, String password,
      {http.Client? client}) async {
    final get = client?.get ?? http.get;
    final response = await get(Uri.parse('$URL_BASE/api/v1/authenticate'),
        headers: {
          'Authorization': Utils.buildBasicAuthorization(username, password)
        });
    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, response.body);
    }

    return AuthData.fromJson(json.decode(response.body));
  }

  static Future<dynamic> modifyPassword(String oldPassword, String newPassword,
      {http.Client? client}) async {
    final post = client?.post ?? http.post;
    String body =
        json.encode({"oldPassword": oldPassword, "newPassword": newPassword});

    final response = await post(
        Uri.parse('$URL_BASE/api/v1/users-change-password'),
        headers: Utils.getRequestHeader(jsonContentType: true),
        body: body);

    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, response.body);
    }
    return json.decode(response.body);
  }

  static Future<UserModel> getUser(String id, {http.Client? client}) async {
    final get = client?.get ?? http.get;
    final response = await get(Uri.parse('$URL_BASE/api/v1/users/$id'),
        headers: Utils.getRequestHeader());
    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, response.body);
    }
    return UserModel.fromJson(json.decode(response.body));
  }

  static Future<Uint8List> register(Map<String, dynamic> data,
      {http.Client? client}) async {
    String type = '';
    switch (data['db']) {
      case 'CCN':
        type = 'ccn';
        break;
      case 'GGSN':
        type = 'ggsn';
        break;
      case 'AIR':
        type = 'air';
      case 'MSC':
        type = 'msc';
        break;

      default:
    }

    var uri = Uri.parse('$URL_BASE/api/v1/$type');
    final request = http.MultipartRequest('POST', uri);

    if (data['files'].isNotEmpty) {
      for (var image in data['files']) {
        request.files.add(await http.MultipartFile.fromPath('files', image.url,
            contentType: getMediaType(image.url)));
      }
    }

    var response = await request.send();
    // final body = response.stream;
    final body = await response.stream.toBytes();

    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, body.toString());
    }

    return body;
  }

  /* ************************************************************************************ */
  /* ************************************************************************************ */
  /* **************************************** INVOICE *********************************** */
  /* ************************************************************************************ */
  /* ************************************************************************************ */
  
  static Future<String?> checkFacturationAdress({http.Client? client}) async {
    final get = client?.get ?? http.get;
    final response = await get(Uri.parse('$URL_BASE/api/v1/invoice/check'),
        headers: Utils.getRequestHeader());
    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, response.body);
    }
    log(name: 'test', json.decode(response.body).toString());
    return json.decode(response.body)['_id'];
  }

  static Future<Uint8List> uploadAdress(Map<String, dynamic> data,
      {http.Client? client}) async {

    var uri = Uri.parse('$URL_BASE/api/v1/upload/address');
    final request = http.MultipartRequest('POST', uri);

    var file = data['file'];


    request.files.add(await http.MultipartFile.fromPath('file', file.url!,
            contentType: getMediaType(file.url!)));

    var response = await request.send();
    final body = await response.stream.toBytes();

    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, body.toString());
    }
    // log(name: 'name', body.toString());

    return body;
  }

  static Future<List<InvoiceModel>> getFactures(Map<String, dynamic> query,
      {http.Client? client}) async {
    final get = client?.get ?? http.get;
    final response = await get(
        Uri.parse('$URL_BASE/api/v1/factures?${Utils.getQueryParams(query)}'),
        headers: Utils.getRequestHeader());
    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, response.body);
    }
    final data = json.decode(response.body);
    return List.generate(
        data.length, (index) => InvoiceModel.fromJson(data[index]));
  }

  static Future<InvoiceModel> getFacture(String id,
      {http.Client? client}) async {
    final get = client?.get ?? http.get;
    final response = await get(
        Uri.parse('$URL_BASE/api/v1/facture/$id'),
        headers: Utils.getRequestHeader());
    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, response.body);
    }
    final data = json.decode(response.body);
    return InvoiceModel.fromJson(data);
  }


  static Future<Uint8List> registerCall(Map<String, dynamic> data,
      {http.Client? client}) async {
    String type = '';
      switch (data['db']) {
        case 'voix':
          type = 'call';
          break;
        case 'sms':
          type = 'sms';
          break;
        default:
      }

      var file = data['file'];

    var uri = Uri.parse('$URL_BASE/api/v1/factures/$type');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.url!,
      contentType: getMediaType(file.url!)));

    var response = await request.send();
    final body = await response.stream.toBytes();

    if (!ok(response.statusCode)) {
      throw HttpError.parse(response.statusCode, body.toString());
    }

    return body;
  }

}
