import 'package:http_parser/http_parser.dart';

// FIXME ajouter les type mime qui existe
MediaType? getMediaType(String fileName) {
  String? extension = () {
    int index = fileName.lastIndexOf(".");
    if (index == -1) {
      return null;
    }
    return fileName.substring(index + 1).toLowerCase();
  }();

  switch (extension) {
    case "xlsx":
      return MediaType("application", "xlsx");
    case "xlsm":
      return MediaType("application", "xlms");
    case "xlsb":
      return MediaType("application", "xlsb");

    default:
      return null;
  }
}
