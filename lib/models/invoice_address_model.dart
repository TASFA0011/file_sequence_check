class InvoiceAddressModel {
  final String key;
  final int id;
  final String operateName;
  final String operateId;
  final String? address;
  final String? bp;
  final String? street;
  final String? city;
  final String? country;
  final String? phoneNumber;

  InvoiceAddressModel({
    required this.key,
    required this.id,
    required this.operateId,
    required this.operateName,
    this.address,
    this.bp,
    this.city,
    this.country,
    this.phoneNumber,
    this.street,
  });
  

  factory InvoiceAddressModel.fromJson(Map<String, dynamic> data) {
    return InvoiceAddressModel(
      key: data['_id'],
      id: data['id'],  
      operateId: data['idOp'], 
      operateName: data['nompOpInc'],
      address: data['adresse'],
      bp: data['bp']?.toString(),
      city: data['nomRue'],
      country: data['pays'],
      phoneNumber: data['telephone'],
      street: data['ville']
    );
  }
}