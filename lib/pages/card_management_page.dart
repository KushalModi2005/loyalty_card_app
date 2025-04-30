import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/loyalty_card.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CardManagementPage extends StatefulWidget {
  final LoyaltyCard? card; // Optional card for editing

  CardManagementPage({this.card});

  @override
  _CardManagementPageState createState() => _CardManagementPageState();
}

class _CardManagementPageState extends State<CardManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  DateTime? _expirationDate;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _nameController.text = widget.card!.name;
      _barcodeController.text = widget.card!.barcode;
      _expirationDate = widget.card!.expirationDate;
      _imagePath = widget.card!.imagePath;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void saveCard() {
    if (_formKey.currentState!.validate()) {
      final card = LoyaltyCard(
        id: widget.card?.id ?? DateTime.now().toString(), // Use current timestamp for a new card
        name: _nameController.text,
        barcode: _barcodeController.text,
        expirationDate: _expirationDate ?? DateTime.now(),
        imagePath: _imagePath ?? '', // Ensure an image path is provided
      );

      if (widget.card == null) {
        // Insert new card
        DatabaseHelper().insertCard(card);
      } else {
        // Update existing card logic (optional)
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card == null ? 'Add Card' : 'Edit Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Card Name'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter card name';
                  return null;
                },
              ),
              TextFormField(
                controller: _barcodeController,
                decoration: InputDecoration(labelText: 'Barcode/QR Code'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter barcode';
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_expirationDate == null
                      ? 'Select Expiration Date'
                      : 'Expiration Date: ${_expirationDate!.toLocal()}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _expirationDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _expirationDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              _imagePath == null
                  ? Text('No image selected.')
                  : Image.file(File(_imagePath!), height: 100, width: 100),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick Image'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: saveCard,
                child: Text('Save Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
