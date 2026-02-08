import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:z_file/z_file.dart';

class MultipleImagePicker extends StatefulWidget {
  final List<Zfile>? initialFiles;
  final Function(List<Zfile>) onChanged;

  const MultipleImagePicker({
    super.key,
    this.initialFiles,
    required this.onChanged,
  });

  @override
  State<MultipleImagePicker> createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  late List<Zfile> files;

  @override
  void initState() {
    super.initState();
    files = widget.initialFiles ?? [];
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xlsm', 'xlsb'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        files.addAll(result.paths.map((path) => Zfile.fromUrl(path!)));
      });
      widget.onChanged(files);
    }
  }

  void _onDelete(Zfile file) {
    setState(() {
      files.remove(file);
    });
    widget.onChanged(files);
  }

  void _deleteAll() {
    setState(() {
      files.clear();
    });
    widget.onChanged(files);
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = files.isEmpty;

    return Column(
      children: [
        GestureDetector(
          onTap: _pickFiles,
          child: Container(
            height: 500,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                  color: Colors.grey, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            child: isEmpty ? _buildPlaceholder() : _buildFileList(),
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
          // SvgPicture.asset('http://www.w3.org/2000/svg', width: 40, height: 40),
          SizedBox(height: 10),
          Text('Cliquez pour choisir ou glissez déposez des fichiers'),
          Text('Types de fichier pris en charge: .xlsx, .xlsm, .xlsb'),
        ],
      ),
    );
  }

  Widget _buildFileList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return ImageItem(
            file: file,
            onDelete: () {
              _onDelete(file);
            });
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(onPressed: _pickFiles, child: const Text('Ajouter')),
        const SizedBox(width: 16),
        TextButton(
          onPressed: _deleteAll,
          child: const Text('Supprimer tous les fichiers',
              style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class ImageItem extends StatelessWidget {
  final Zfile file;
  final VoidCallback onDelete;

  const ImageItem({super.key, required this.file, required this.onDelete});

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
