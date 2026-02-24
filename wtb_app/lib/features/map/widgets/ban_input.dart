import 'package:flutter/material.dart';

class BanInputDialog extends StatefulWidget {
  final String? intiaName;
  final String? intiaDistrict;
  const BanInputDialog({super.key, this.intiaDistrict, this.intiaName});

  @override
  State<BanInputDialog> createState() => _BanInputDialogState();
}

class _BanInputDialogState extends State<BanInputDialog> {
  late TextEditingController _nameController;
  late TextEditingController _districtController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.intiaName);
    _districtController = TextEditingController(text: widget.intiaDistrict);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Village Information'),

      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Village Name'),
              validator: (v) =>
                  v!.isEmpty ? "Please enter a name of ban" : null,
            ),
            TextFormField(
              controller: _districtController,
              decoration: const InputDecoration(labelText: 'District'),
              validator: (v) => v!.isEmpty ? "Please enter a district" : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'name': _nameController.text,
                'district': _districtController.text,
              });
            }
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
