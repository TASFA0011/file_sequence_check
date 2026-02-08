import 'dart:convert';
import 'package:file_sequence_check/models/auth_data.dart';
import 'package:file_sequence_check/service/setup_locator.dart';

class Utils {
  /// `buildUrl('http://127.0.0.1:5000', '/hello', { 'sort': 'asc', 'sortBy': 'name,size' })`
  static Uri buildUrl(String url, String path, Map<String, dynamic>? query) {
    String q =
        query == null || query.isEmpty ? '' : '?${getQueryParams(query)}';
    return Uri.parse('$url$path$q');
  }

  static String getQueryParams(Map<String, dynamic> params) {
    List<String> parts = [];

    final values = params.entries.toList();
    final len = values.length;

    for (int i = 0; i < len; ++i) {
      final e = values[i];
      if (e.value == null) {
        continue;
      }

      final v = e.value;
      parts.add(
          '${e.key}=${Uri.encodeComponent(v is List ? v.join(',') : v.toString())}');
    }

    return parts.join('&');
  }

  static List<int>? toDate(String date) {
    List<String> parts = date.split('-');

    if (parts.length != 2) return null;

    List<int> n = [0, 0];

    for (int i = 0; i < 2; ++i) {
      int? value = int.tryParse(parts[i]);
      if (value == null) {
        return null;
      }
      n[i] = value;
    }

    return n;
  }

  static DateTime? parseIsoDate(String? date) {
    if (date == null) {
      return null;
    }
    return DateTime.tryParse(date);
  }


  static String formatDateTime(DateTime date,
      {String sep = '/', bool includeTime = false}) {
    String s =
        "${addTrailingZero(date.day)}$sep${addTrailingZero(date.month)}$sep${date.year}";
    late String hours;

    if (includeTime) {
      hours =
          ' à ${addTrailingZero(date.hour)}:${addTrailingZero(date.minute)}'; // typo
    }

    return includeTime ? s + hours : s;
  }

  static DateTime futureDate({required DateTime d, required int step}) {
    DateTime futureDate = d.add(Duration(days: step)); // Ajoute 30 jours
    return futureDate;
  }

  // static String formatTeacherMatricule(String m) {
  //   return m.substring(0, 3) + " " + m.substring(3);
  // }

  static String buildBasicAuthorization(String matricule, String password) {
    return 'Basic ${base64.encode(utf8.encode('$matricule:$password'))}';
  }

  static String getBearerToken() {
    final AuthData authData = locator.get();
    return 'Bearer ${authData.accessToken}';
  }

  static Map<String, String> getRequestHeader({bool jsonContentType = false}) {
    final AuthData authData = locator.get();
    return {
      'Authorization': 'Bearer ${authData.accessToken}',
      if (jsonContentType) 'Content-Type': 'application/json'
    };
  }

  static String addTrailingZero(int n) => n < 10 ? '0$n' : n.toString();

}
