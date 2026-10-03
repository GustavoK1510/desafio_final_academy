import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/products/domain/entities/product.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';

/// Manages the product form.
class ProductFormProvider extends ChangeNotifier {
  /// Class constructor.
  ProductFormProvider({
    required this._useCase,
    this._product,
  }) {
    _initialize();
  }

  final ProductUseCase _useCase;
  final Product? _product;

  final ImagePicker _imagePicker = ImagePicker();

  /// Name field controller
  final nameController = TextEditingController();

  /// Brand field controller
  final brandController = TextEditingController();

  /// Barcode field controller
  final barcodeController = TextEditingController();

  /// Price field controller
  final priceController = TextEditingController();

  /// Description field controller
  final descriptionController = TextEditingController();

  final List<File> _existingImages = [];
  final List<File> _newImages = [];

  bool _isSaving = false;
  String? _errorMessage;

  /// Whether the form is editing an existing product.
  bool get isEditing => _product != null;

  /// Existing product images.
  List<File> get existingImages => List.unmodifiable(_existingImages);

  /// Newly selected images.
  List<File> get newImages => List.unmodifiable(_newImages);

  /// Whether the product is being saved.
  bool get isSaving => _isSaving;

  /// Current error message.
  String? get errorMessage => _errorMessage;

  void _initialize() {
    final product = _product;

    if (product == null) {
      return;
    }

    nameController.text = product.name;
    brandController.text = product.brand;
    barcodeController.text = product.barcode;
    priceController.text = product.price.toStringAsFixed(2);

    descriptionController.text = product.description ?? '';

    for (final image in product.images) {
      _existingImages.add(File(image.path));
    }
  }

  /// Generates a barcode value.
  void generateBarcode() {
    final random = Random();

    final value = List.generate(
      12,
          (_) => random.nextInt(10),
    ).join();

    barcodeController.text = value;

    notifyListeners();
  }

  /// Selects multiple product images.
  Future<void> pickImages() async {
    final images = await _imagePicker.pickMultiImage();

    if (images.isEmpty) {
      return;
    }

    _newImages.addAll(
      images.map((image) => File(image.path)),
    );

    notifyListeners();
  }

  /// Removes an existing product image.
  void removeExistingImage(File image) {
    _existingImages.remove(image);
    notifyListeners();
  }

  /// Removes a newly selected image.
  void removeNewImage(File image) {
    _newImages.remove(image);
    notifyListeners();
  }

  /// Saves the product.
  Future<bool> saveProduct() async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final name = nameController.text.trim();
      final brand = brandController.text.trim();
      final barcode = barcodeController.text.trim();
      final description = descriptionController.text.trim();

      final price = double.tryParse(
        priceController.text.replaceAll(',', '.'),
      );

      if (name.isEmpty) {
        _errorMessage = 'Please enter a product name.';
        return false;
      }

      if (brand.isEmpty) {
        _errorMessage = 'Please enter a product brand.';
        return false;
      }

      if (barcode.isEmpty) {
        _errorMessage = 'Please enter or generate a barcode.';
        return false;
      }

      if (price == null || price < 0) {
        _errorMessage = 'Please enter a valid price.';
        return false;
      }

      final images = [
        ..._existingImages,
        ..._newImages,
      ];

      final product = Product(
        id: _product?.id,
        name: name,
        brand: brand,
        barcode: barcode,
        description: description.isEmpty ? null : description,
        price: price,
      );

      if (_product == null) {
        await _useCase.insertProduct(
          product,
          images,
        );
      } else {
        await _useCase.updateProduct(
          product,
          images,
        );
      }

      return true;
    } catch (error, stackTrace) {
      debugPrint('ERROR SAVING PRODUCT: $error');
      debugPrint('STACK TRACE: $stackTrace');

      _errorMessage = error.toString();

      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Notifies listeners when the barcode changes.
  void onBarcodeChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    barcodeController.dispose();
    priceController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}