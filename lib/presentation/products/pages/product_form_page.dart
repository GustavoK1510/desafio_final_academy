import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../features/products/domain/entities/product.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';
import '../../../ui/components/barcode_preview.dart';
import '../../../ui/components/product_image_picker.dart';
import '../providers/product_form_provider.dart';

/// Displays the product creation and editing form.
class ProductFormPage extends StatelessWidget {
  /// Class constructor.
  const ProductFormPage({
    required this.useCase,
    this.product,
    super.key,
  });

  /// Product use case.
  final ProductUseCase useCase;

  /// Product being edited.
  final Product? product;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(
        useCase: useCase,
        product: product,
      ),
      child: const _ProductFormContent(),
    );
  }
}

/// Displays the product form content.
class _ProductFormContent extends StatelessWidget {
  /// Class constructor.
  const _ProductFormContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ProductFormProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.isEditing
              ? l10n.editProduct
              : l10n.addProduct,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: provider.nameController,
                label: l10n.name,
                icon: Icons.inventory_2_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.brandController,
                label: l10n.brand,
                icon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),
              _buildBarcodeField(context, provider),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.priceController,
                label: l10n.price,
                icon: Icons.attach_money_outlined,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              _buildDescriptionField(
                provider: provider,
                label: l10n.description,
              ),
              const SizedBox(height: 24),
              BarcodePreview(
                value: provider.barcodeController.text,
              ),
              const SizedBox(height: 24),
              ProductImagePicker(
                existingImages: provider.existingImages,
                newImages: provider.newImages,
                onAdd: provider.pickImages,
                onRemoveExisting: provider.removeExistingImage,
                onRemoveNew: provider.removeNewImage,
              ),
              if (provider.errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  provider.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: provider.isSaving
                      ? null
                      : () => _save(context),
                  icon: provider.isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    provider.isEditing
                        ? l10n.saveChanges
                        : l10n.createProduct,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBarcodeField(
      BuildContext context,
      ProductFormProvider provider,
      ) {
    final l10n = AppLocalizations.of(context)!;

    return TextField(
      controller: provider.barcodeController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: l10n.barcode,
        prefixIcon: const Icon(
          Icons.qr_code_2_outlined,
        ),
        suffixIcon: IconButton(
          onPressed: provider.generateBarcode,
          icon: const Icon(Icons.autorenew),
          tooltip: l10n.generateBarcode,
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) {
        provider.onBarcodeChanged();
      },
    );
  }

  Widget _buildDescriptionField({
    required ProductFormProvider provider,
    required String label,
  }) {
    return TextField(
      controller: provider.descriptionController,
      maxLines: 5,
      minLines: 3,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 72),
          child: Icon(Icons.description_outlined),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final success = await context
        .read<ProductFormProvider>()
        .saveProduct();

    if (!success || !context.mounted) {
      return;
    }

    context.pop(true);
  }
}