import 'dart:async';

import 'package:flutter/material.dart';

const String _title = 'Form Page';
const String _name = 'Name';
const String _price = 'Price';
const String _product = 'Product';
const String _validate = 'Validate';
const String _cancel = 'Cancel';

class FormData extends StatefulWidget {
  const FormData({
    Key? key,
    required this.addData,
  }) : super(key: key);

  final FutureOr<void> Function(String amount, String client, String product)
      addData;

  @override
  State<FormData> createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: _name,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                hintText: _price,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _productController,
              decoration: const InputDecoration(
                hintText: _product,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.addData(
                            _priceController.text,
                            _nameController.text,
                            _productController.text,
                          );

                          _nameController.clear();
                          _priceController.clear();
                          _productController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data added'),
                            ),
                          );
                        }
                      },
                      child: const Text(_validate),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _nameController.clear();
                      _priceController.clear();
                      _productController.clear();
                    },
                    child: const Text(_cancel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
