import 'package:file_sequence_check/models/invoice_model.dart';
import 'package:file_sequence_check/ui/components/status_text_widget.dart';

import 'package:flutter/material.dart';
import 'package:my_table/my_table.dart';

class InvoiceDataRow extends MyTableRow {
  InvoiceDataRow(InvoiceModel data, {required void Function(String) onTap})
      : super(
          onTap: () => onTap(data.id),
          children: [
            Text(
              data.origine,
              style: const TextStyle(
                  // color: Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              data.destination,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              data.service,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              data.mois ,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            StatusTextWidget(
              data.type,
              color: data.type=='call' ? Colors.green : Colors.orange,
            ),
             
            Text(
              data.type == 'call'?'${data.nombreCall ?? 'N/A'}' :'${data.nombreSms ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${data.tarif ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
             '${data.montant ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            
          ],
        );
}
