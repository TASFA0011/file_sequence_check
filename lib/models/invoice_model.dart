
// import 'dart:developer';

import 'package:file_sequence_check/models/invoice_address_model.dart';

class InvoiceModel {
  final String id;
  final String key;
  final String idOp;
  final String origine;
  final String destination;
  final String service;
  final String mois;
  final int? nombreCall;
  final double? volume;
  final double? tarif;
  final String devise;
  final double? montant;
  final String type;
  final int? nombreSms;
  final InvoiceAddressModel? address;

  InvoiceModel({
    required this.id,
    required this.idOp,
    required this.origine,
    required this.service,
    required this.destination,
    required this.mois,
    required this.key,
    this.nombreCall,
    required this.devise,
    required this.montant,
    required this.tarif,
    this.volume,
    required this.type,
    this.nombreSms,
    this.address
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> data) {
    // log(name: 'invoice', data.toString());
    return InvoiceModel(
      id: data['_id'], 
      key: data['id'].toString(),
      idOp: data['idOp'], 
      origine: data['origine'], 
      service: data['service'], 
      destination: data['destination'], 
      mois: data['mois'], 
      nombreCall: data['nombreCall'], 
      devise: data['devise'], 
      montant: data['montant']?.toDouble(), 
      tarif: data['tarif']?.toDouble(), 
      volume: data['volume']?.toDouble(),
      type: data['type'],
      nombreSms: data['nombre_sms'],
      address: data['address']!= null?InvoiceAddressModel.fromJson(data['address']): null
    );
  }


}
