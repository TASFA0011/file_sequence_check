import 'dart:developer';
import 'dart:typed_data';

import 'package:error_screen/error_screen.dart';
import 'package:file_sequence_check/blocs/search_bloc.dart';
import 'package:file_sequence_check/constants/navigation_service.dart';
import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/models/invoice_model.dart';
import 'package:file_sequence_check/models/seach_model.dart';
import 'package:file_sequence_check/service/api.dart';
import 'package:file_sequence_check/ui/components/generate_pdf.dart';
import 'package:file_sequence_check/ui/components/invoice_data_row.dart';
import 'package:file_sequence_check/ui/components/loading_dialog.dart';
import 'package:file_sequence_check/ui/components/my_outline_text_field.dart';
import 'package:file_sequence_check/ui/pages/facturation/generate_invoice_pdf.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:my_input_formatter/my_input_formatter.dart';
import 'package:my_table/my_table.dart';
import 'package:my_utils/my_utils.dart';

class FacturationsIntercoPage extends StatefulWidget {
  const FacturationsIntercoPage({super.key});

  @override
  State<FacturationsIntercoPage> createState() => _FacturationsIntercoPageState();
}

class _FacturationsIntercoPageState extends State<FacturationsIntercoPage> {
  late Future<List<InvoiceModel>> future;
  late final FormValidatorBloc _bloc;
  late SearchModel query;

  @override
  void initState() {
    super.initState();
    query = SearchModel();
    _bloc = getSearchBloc(query);
    future = Api.getFactures(query.toMap());
  }
 
    void _onSearch() {
    if (_bloc.data.isLoading || !_bloc.validate()) {
      return;
    }

    _bloc.setLoadingStatus(true);

    setState(() {
      future = Api.getFactures(_bloc.getFormValues());
    });

    _bloc.setLoadingStatus(false);
  }

  void _onChange<T>(String key, T value) {
    _bloc.changeValue(key, value);
  }

  Future<void> _onReload() async {
    final data = Api.getFactures(query.toMap());
    setState(() {
      future = data;
    });
  }

  void _showElement(String id) {
    NavigationService.navigate(Routes.FACTURATION, arguments: id);
  }

  void _goToRegister() {
    NavigationService.navigate(Routes.REGISTER_FACTURATION);
  }

  Future<void> _down(List<InvoiceModel>? invoice) async {
    final controller = showLoadingDialog(context: context);
    try {

      if(invoice == null || invoice.isEmpty) {
        controller.close();
        return;
      }
      

      List<String> names = [];
      List<Uint8List> filesData = [];

      for(var invo in invoice) {
        var document = await GenerateInvoicePdf.generate(invo);
        filesData.add(await document.save());
        names.add('Facture N° ${invo.mois}_${invo.key}_${invo.origine}_DF_DG_DM-ORANGE_BF.pdf');
      }

      var path = await GeneratePdf.saveMultipleFiles(filesData, names);
      // var document = await GenerateInvoicePdf.generate(invoice);
      // var data = await document.save();
      // var path = await GeneratePdf.saveFile(data, '${invoice.origine}.pdf');
      log(name: 'path', path.toString());
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Votre fichier a bien été enregistré'),
        // action: SnackBarAction(
        //     label: 'Ouvrir le fichier',
        //     onPressed: () {
        //       launchUrl(Uri.parse('$path'));
        //     }),
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
    return  FutureBuilder<List<InvoiceModel>>(
          future: future,
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
                return NetworkErrorScreen(onRetry: _onReload);
              }
              final invoices = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text("Listes des factures"),
                ),
                backgroundColor: Colors.white,
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton.extended(
                    onPressed: _goToRegister,
                    icon: const Icon(Icons.g_mobiledata_rounded),
                    label: const Text('Upload un fichier')),
                    if(invoices.isNotEmpty)
                      FloatingActionButton.extended(
                        backgroundColor: Colors.lightBlueAccent,
                        onPressed: (){_down(invoices);},
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('Telecharger les factures')),
                  ],
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: _contentWidget(invoices)
              );
              // _contentWidget(snapshot.data!, size);
            }
            return const Center(child: CircularProgressIndicator());
          });
    
  }

  Widget _contentWidget(List<InvoiceModel> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: MyOutlineTextField(
                    onChanged: (value) => _onChange('type', value),
                    labelText: "Type de facture",
                    initialValue: _bloc.data.fields["type"]!.value,
                    prefixIcon: const Icon(Icons.voicemail_outlined),
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: MyOutlineTextField(
                    onChanged: (value) => _onChange("date", value),
                    labelText: "Date de Debut",
                    initialValue: _bloc.data.fields["date"]!.value,
                    // errorText: s ? null : 'Veuillez renseigner une date valide',
                    errorText: _bloc.data.fields["date"]!.errorMessage,
                    inputFormatters: [DateInputFormatter()],
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                  ),
                ),
                SizedBox(
                    width: 200,
                    child: FilledButton.tonal(
                      onPressed: _onSearch,
                      style: const ButtonStyle(
                          minimumSize:
                              WidgetStatePropertyAll(Size(320.0, 52.0))),
                      child: const Text('rechercher'),
                    )),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                    onPressed: _onReload, icon: const Icon(Icons.cached)),
              ],
            )),
        data.isEmpty
            ? EmptyStateScreen(
                title: const Text(
                  'Votre liste est vide Actuelle',
                  style: TextStyle(fontSize: 16.0),
                ), // FIXEM typo
              )
            : Expanded(child: _contentWidgetInvoice(data)),
      ],
    );
  }

  Widget _contentWidgetInvoice(List<InvoiceModel> data) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MyTable(
                  // headerTextStyle: _tableHeaderStyle,
                  headerTextStyle: const TextStyle(
                      color: Color.fromRGBO(125, 125, 125, 1.0),
                      fontWeight: FontWeight.w600),
                  border: const TableBorder(),
                  columnWidths: const {
                    0: FixedColumnWidth(180.0),
                    1: FixedColumnWidth(140.0),
                    // 2: FixedColumnWidth(140.0)
                  },
                  header: MyTableRow(
                      height: 36.0,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 249, 249, 249)),
                      children: const [
                        Text("Origine"),
                        Text("Destination"),
                        Text("service"),
                        Text("Mois"),
                        Text('type'),
                        Text('Nombre'),
                        Text("Tarif"),
                        Text("Montant"),
                      ]),
                  rows: List.generate(data.length, (index) {
                    var e = data[index];
                    return InvoiceDataRow(e, onTap: _showElement);
                  }),
                ),
              ),
            ),
            const SizedBox(
              height: 80.0,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}