class SearchModel {
  final String? type;
  final String? date;

  SearchModel({
    this.type,
    this.date,
  });


  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'date': date.toString(),
    };
  }
}
