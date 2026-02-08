import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:z_file/z_file.dart';

class SingleFilePicker extends StatefulWidget {
  final Zfile? initialFile;
  final Function(Zfile?) onChanged;

  const SingleFilePicker({
    super.key,
    this.initialFile,
    required this.onChanged,
  });

  @override
  State<SingleFilePicker> createState() => _SingleFilePickerState();
}

class _SingleFilePickerState extends State<SingleFilePicker> {
  Zfile? file;

  @override
  void initState() {
    super.initState();
    file = widget.initialFile;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // ← Changé à false
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xlsm', 'xlsb'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        file = Zfile.fromUrl(result.paths.first!);
      });
      widget.onChanged(file);
    }
  }

  void _deleteFile() {
    setState(() {
      file = null;
    });
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = file == null;

    return Column(
      children: [
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                  color: Colors.grey, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            child: isEmpty ? _buildPlaceholder() : _buildFileDisplay(),
          ),
        ),
        if (!isEmpty) _buildActionButtons(),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 40.0,
          ),
          SizedBox(height: 10),
          Text('Cliquez pour choisir un fichier'),
          Text('Types de fichier pris en charge: .xlsx, .xlsm, .xlsb'),
        ],
      ),
    );
  }

  Widget _buildFileDisplay() {
    return Center(
      child: FileItem(
        file: file!,
        onDelete: _deleteFile,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(onPressed: _pickFile, child: const Text('Remplacer')),
        const SizedBox(width: 16),
        TextButton(
          onPressed: _deleteFile,
          child: const Text('Supprimer le fichier',
              style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class FileItem extends StatelessWidget {
  final Zfile file;
  final VoidCallback onDelete;

  const FileItem({super.key, required this.file, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('assets/excel_img.png', width: 24, height: 24),
      title: Text(file.name),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onDelete,
      ),
    );
  }
}