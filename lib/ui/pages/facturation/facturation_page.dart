import 'dart:developer';

import 'package:error_screen/error_screen.dart';
import 'package:file_sequence_check/models/invoice_model.dart';
import 'package:file_sequence_check/service/api.dart';
import 'package:file_sequence_check/ui/components/generate_pdf.dart';
import 'package:file_sequence_check/ui/components/loading_dialog.dart';
import 'package:file_sequence_check/ui/pages/facturation/generate_invoice_pdf.dart';
import 'package:flutter/material.dart';
import 'package:my_grid/my_grid.dart';
import 'package:my_utils/my_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class FacturationPage extends StatefulWidget {
  final String id;
  const FacturationPage({super.key, required this.id});

  @override
  State<FacturationPage> createState() => _FacturationPageState();
}

class _FacturationPageState extends State<FacturationPage> with SingleTickerProviderStateMixin{
  late final TabController _tabController;
  late Future<InvoiceModel> _future;

  @override
  void initState() {
    super.initState();
    _future = Api.getFacture(widget.id);
    _tabController = TabController(length: 1, vsync: this);
  }

  void _onPrinter(InvoiceModel invoice) async {
    final controller = showLoadingDialog(context: context);
    try {
      var document = await GenerateInvoicePdf.generate(invoice);
      var data = await document.save();
      var path = await GeneratePdf.saveFile(data, 'Facture N° ${invoice.mois}_${invoice.key}_${invoice.origine}_DF_DG_DM-ORANGE_BF.pdf');

      if (path == null || !mounted) {
        controller.close();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Votre fichier a bien été enregistré'),
        action: SnackBarAction(
            label: 'Ouvrir le fichier',
            onPressed: () {
              launchUrl(Uri.file(path));
            }),
      ));
      controller.close();
    } catch (err) {
      controller.close();
      log(err.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Une erreur s\'est produite')));
      }
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InvoiceModel>(
        future: _future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              var err = snapshot.error;
              if (err is HttpError) {
                if (err.statusCode == 404) {
                  return NotFoundScreen();
                }
                return WrongThingScreen();
              }
              return NetworkErrorScreen(onRetry: (){});
            }
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                    title: const Text("Facture"),),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    _onPrinter(snapshot.data!);
                  },
                  label: const Text("Imprimer",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(Icons.print_rounded),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: _contentWidget(snapshot.data!)
              );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _contentWidget(InvoiceModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getHeaderWidget(data),
          TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.black38,
            labelColor: Colors.black87,
            tabs: const [
              Tab(text: "Informations"),
            ],
          ),
          Expanded(child: _getInformationWidget(data))
        ],
      ),
    );
  }

    Widget _getHeaderWidget(InvoiceModel invoice) {
    return SizedBox(
      height: 100.0,
      // color: Colors.black12,
      child: Row(
        children: [
          // ImageOrLettersWidget(name: data.fullName, radius: 30.0),
          const SizedBox(width: 15.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Facture N° ${invoice.mois}/${invoice.key}/${invoice.origine}/DF/DG/DM-ORANGE BF',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                invoice.service,
                style: const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              )
            ],
          ),
          const Expanded(child: SizedBox()),

          // StatusTextWidget.fromUserRole('Gérant'),
        ],
      ),
    );
  }

  Widget _getInformationWidget(InvoiceModel data) {
    return MyGrid(
      axisCount: 2,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Réseau Origine"),
          subtitle: Text(data.origine),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Destination"),
          subtitle: Text(data.destination),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Service"),
          subtitle: Text(data.service),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Période"),
          subtitle: Text(data.mois),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title:  Text("Nombres ${data.type == 'call'? 'Appel': 'Sms'}"),
          subtitle: Text('${data.type == 'call'? data.nombreCall: data.nombreSms}'),
        ),
        if(data.type == 'call')
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Volume Minutes"),
          subtitle: Text('${data.volume ?? 'N/A'}'),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title:  Text("Tarif/${data.type == 'call'? 'Minute': 'Sms'}"),
          subtitle: Text('${data.tarif ?? 'N/A'}'),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Devise"),
          subtitle: Text(data.devise),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Monant dû"),
          subtitle: Text('${data.montant ?? 'N/A'}'),
        ),

         ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Adresse"),
          subtitle: Text(data.address?.address ?? 'N/A'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}