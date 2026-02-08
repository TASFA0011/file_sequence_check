
import 'package:file_sequence_check/models/invoice_model.dart';
import 'package:file_sequence_check/utils/utils.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';

class GenerateInvoicePdf extends pw.StatelessWidget {

  final InvoiceModel invoice;
  final pw.MemoryImage ? myImage;
  final List<int>? date;
  GenerateInvoicePdf(this.invoice, {this.myImage, this.date});

  static Future<pw.Document> generate(
    final InvoiceModel invoice,

  ) async {
    var document = pw.Document();
      final ByteData imageData = await rootBundle.load('assets/orange-Logo.png');
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      final image = pw.MemoryImage(imageBytes);
      
    document.addPage(pw.MultiPage(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        ),
        build: (pw.Context context) { 
            final headers = [
              'Réseau Origine',
              'Destination',
              'Service',
              'Période',
              invoice.type == 'call' ?'Nombre Appel':'Nombre SMS',
              if(invoice.type == 'call') 'Volume Minutes',
              'Tarif/${invoice.type == 'call'? 'Minutes': 'SMS'}',
              'Devise',
              'Monant dû'
            ];
            final date = Utils.toDate(invoice.mois);
            
            return [
              GenerateInvoicePdf(invoice, myImage: image, date: date),
              pw.SizedBox(height: 15.0),

              pw.Table(
                border:  const pw.TableBorder(),
                tableWidth: pw.TableWidth.max,
                columnWidths: {
                  0: const pw.FixedColumnWidth(100), // Largeur fixe de 300 pixels pour la cellule fusionnée
                  1: const pw.FixedColumnWidth(60),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(Colors.orange.value)),
                    children: List.generate(
                      headers.length,
                        (index) => pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            constraints: const pw.BoxConstraints(minHeight: 26.0),
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(headers[index],
                                style: pw.TextStyle(
                                    color: const PdfColor.fromInt(0xffffffff),
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold))))
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text(invoice.origine,
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text(invoice.destination,
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text(invoice.service,
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text(invoice.mois,
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text(invoice.type == 'call'? '${invoice.nombreCall??'N/A'}': '${invoice.nombreSms??'N/A'}',
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      ),
                      if(invoice.type == 'call') pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text('${invoice.volume ??'N/A'}',
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text('${invoice.tarif ??'N/A'}',
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text(invoice.devise ,
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        constraints: const pw.BoxConstraints(minHeight: 26.0),
                        padding: const pw.EdgeInsets.all(4),
                        color: PdfColor.fromInt(Colors.orange.shade50.value),
                        child: pw.Text('${invoice.montant ??'N/A'}',
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(Colors.black87.value),
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold
                          )
                        )
                      )
                          
                    ]
                  ),
                ],
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.full
              ),
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Container(
                    alignment: pw.Alignment.centerRight,
                    constraints: const pw.BoxConstraints(minHeight: 26.0),
                    padding: const pw.EdgeInsets.all(4),
                    color: PdfColor.fromInt(Colors.orange.shade50.value),
                    child: pw.Text('TOTAL EN FAVEUR DE ORANGE BF', style: pw.TextStyle(
                        color: PdfColor.fromInt(Colors.black54.value),
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold
                    ))
                  ),),
                  pw.Container(
                    width: 90.0,
                    alignment: pw.Alignment.centerRight,
                    constraints: const pw.BoxConstraints(minHeight: 26.0),
                    padding: const pw.EdgeInsets.all(4),
                    color: PdfColor.fromInt(Colors.orange.shade50.value),
                    child: pw.Text('${invoice.montant ??'N/A'}',
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(Colors.black87.value),
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold
                      )
                    )
                  ),
                ]
              ),
          
    
              pw.SizedBox(height: 20.0),
              pw.Center(
                child:  pw.Text(
                  "Date limite de paiement de la présente facture: le  ${Utils.formatDateTime(Utils.futureDate(d: DateTime.now(), step: 30))} à compter de la date de facturati on ci-dessus.",
                  style: const pw.TextStyle(fontSize: 9.0)),
              ),
              pw.SizedBox(height: 60.0),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                // pw.Expanded(child: pw.SizedBox()),
                  pw.SizedBox(),
                  pw.Text(
                      "Aminata FOFANA \nDirectrice Financière",
                      style: const pw.TextStyle(fontSize: 11.0))
                ]
              ),

               pw.SizedBox(height: 90.0),
               
              pw.Center(
                  child: pw.Text(
                      "Orange Burkina Faso S.A - 771,Avenue du President Aboubacar Sangoulé LAMIZANA - 01 BP 6622 Ouagadougou 01 Burkina Faso - Tél : +226 25 66 33 00 www.orange.bf - Capital Social : 2 513 172 000 F CFA ECOBANK : 00018 091700493801 - BOA : 010010 01067180004 49 - UBA : 421030010992 11 RCCM. N° BF OUA 2000 B 522 - N° IFU 00002888M - Directi ons des Grandes Entreprises - Régime : Réel Normal",
                      style: const pw.TextStyle(fontSize: 6.0)))
            ];}));

    return document;
  }

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Image(myImage!, width: 100),

        pw.SizedBox(height: 50.0),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Facture N° ${invoice.mois}/${invoice.key}/${invoice.origine}/DF/DG/DM-ORANGE BF',
                  style: const pw.TextStyle(fontSize: 9.0)
                ),
                pw.SizedBox(height: 5.0),
                pw.Text(
                  'Liaison : Orange Burkina Faso - ${invoice.origine}',
                  style: const pw.TextStyle(fontSize: 9.0)
                ),
                pw.SizedBox(height: 5.0),
                pw.Text(
                  'Trafic: Téléphone',
                  style: const pw.TextStyle(fontSize: 9.0)
                ),
                pw.SizedBox(height: 5.0),
                pw.Text(
                  'Mois: ${invoice.mois}',
                  style: const pw.TextStyle(fontSize: 9.0)
                )
              ]
            ),
            pw.Text(
              'Ouagadougou le ${Utils.formatDateTime(DateTime.now())}',
              // 'Ouagadougou, le 30/${date![1]+1 <=9 ? '0':''}${date![1]+1}/${date![0]}',
              style: const pw.TextStyle(fontSize: 9.0)
            )
          ]
        ),

        pw.SizedBox(height: 40),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                    ),
              ),
              child: pw.Text(
                'Adresse de paiement de la Facture \nCompte: ORANGE BURKINA FASO SA \n01 BP 6622 Ouagadougou 01 Burkina Faso \nNom de la Banque: ECOBANK \n49, Rue de l\'Hotel de ville \n01 BP 145 Ouagadougou 01 \nCode Banque: 26083 \nCode Guichet: 00018 \nN° Cpte: 170004937001 \nClé RIB: 39 \nSwift code: ECOCBFBF \nIBAN:26083 00018 170004937001 39',
                style: const pw.TextStyle(fontSize: 9.0)
              )
              // titleOrder("VISAS DE PASSAGE"),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              width: 250,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                    ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    invoice.service,
                    style: const pw.TextStyle(fontSize: 9.0)
                  ),
                  getValueText(invoice.address?.operateName),
                  getValueText(invoice.address?.address),
                  getValueText(invoice.address?.bp),
                  getValueText(invoice.address?.street),
                  getValueText(invoice.address?.city),
                  getValueText(invoice.address?.country),
                  getValueText(invoice.address?.phoneNumber),

                ]
              )
              // titleOrder("VISAS DE PASSAGE"),
            ),
          ]
        ),

        pw.SizedBox(height: 80),

        pw.Center(
          child: pw.Text(
            'FACTURE DE TERMINAISON DE TRAFIC ORANGE BURKINA FASO',
            style:  pw.TextStyle(fontSize: 9.0, fontWeight: pw.FontWeight.bold)
          ),
        )
        

      ]

    );
  }

}

pw.Widget getValueText(String? v ) {
  if(v !=null){
    return pw.Text(
      v,
      style: const pw.TextStyle(fontSize: 9.0)
    );
  }
  return pw.SizedBox.shrink();
}
