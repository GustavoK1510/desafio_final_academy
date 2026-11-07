
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../features/clients/domain/entities/client.dart';
import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../../features/orders/domain/entities/order.dart';
import '../../../features/orders/domain/enums/payment_option.dart';
import '../../../features/products/domain/entities/product.dart';
import '../../../features/store/domain/entities/store.dart';
import 'models/receipt_item_model.dart';

/// Generates PDF receipts for orders.
class OrderReceiptPdfService {

  /// Creates a receipt and opens the print preview.
  Future<void> generate({
    required Order order,
    required Client client,
    required Store store,
    required DeliveryService deliveryService,
    required List<Product> products,
  }) async {
    /// Creates the PDF document.
    final document = pw.Document();

    /// Loads the store logo when available.
    pw.MemoryImage? logo;

    if (store.logoPath.isNotEmpty) {
      final logoFile = File(store.logoPath);

      /// Checks whether the logo file exists.
      if (await logoFile.exists()) {
        final logoBytes = await logoFile.readAsBytes();
        logo = pw.MemoryImage(logoBytes);
      }
    }

    /// Matches order items with registered products.
    final orderItems = order.orderItems.map((item) {
      final product = products.firstWhere(
            (product) => product.id == item.productId,
        orElse: () => throw StateError(
          'Product ${item.productId} was not found.',
        ),
      );

      /// Calculates the item subtotal.
      final subtotal = item.unitPrice * item.quantity;

      /// Calculates the item discount.
      final discountAmount = subtotal * item.discount / 100;

      /// Creates the receipt item.
      return ReceiptItem(
        name: product.name,
        brand: product.brand,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        discount: item.discount,
        discountAmount: discountAmount,
        total: subtotal - discountAmount,
      );
    }).toList();

    /// Calculates the subtotal before discounts.
    final productsSubtotal = orderItems.fold<double>(
      0,
          (total, item) => total + item.unitPrice * item.quantity,
    );

    /// Calculates the total product discounts.
    final productsDiscount = orderItems.fold<double>(
      0,
          (total, item) => total + item.discountAmount,
    );

    /// Calculates the order total before payment fees.
    final baseTotal =
        productsSubtotal - productsDiscount + order.deliveryPrice;

    /// Calculates the payment surcharge.
    final paymentSurcharge = order.price - baseTotal;

    /// Formats the client's delivery address.
    final clientAddress =
        '${client.street}, ${client.number} - '
        '${client.city}/${client.state} - CEP ${client.zipCode}';

    /// Formats the store address.
    final storeAddress =
        '${store.street}, ${store.number} - '
        '${store.city}/${store.state} - CEP ${store.zipCode}';

    /// Formats the delivery date.
    final day = order.deliveryDate.day.toString().padLeft(2, '0');
    final month = order.deliveryDate.month.toString().padLeft(2, '0');
    final formattedDate = '$day/$month/${order.deliveryDate.year}';

    /// Formats the products subtotal.
    final productsSubtotalFormatted =
        'R\$ ${productsSubtotal.toStringAsFixed(2).replaceAll('.', ',')}';

    /// Formats the total discounts.
    final productsDiscountFormatted =
        '- R\$ ${productsDiscount.toStringAsFixed(2).replaceAll('.', ',')}';

    /// Formats the delivery price.
    final deliveryPriceFormatted =
        'R\$ ${order.deliveryPrice.toStringAsFixed(2).replaceAll('.', ',')}';

    /// Formats the final order price.
    final finalPriceFormatted =
        'R\$ ${order.price.toStringAsFixed(2).replaceAll('.', ',')}';

    /// Provides a fallback for the store company name.
    final storeCompanyName = store.companyName.trim().isEmpty
        ? 'Not informed'
        : store.companyName;

    /// Provides a fallback for the client company name.
    final clientCompanyName = client.companyName.trim().isEmpty
        ? 'Not informed'
        : client.companyName;

    /// Provides a fallback for the client phone number.
    final clientPhone = client.phoneNumber?.trim().isNotEmpty == true
        ? client.phoneNumber!
        : 'Not informed';

    /// Provides a fallback for the delivery company name.
    final deliveryCompanyName =
    deliveryService.companyName.trim().isEmpty
        ? 'Not informed'
        : deliveryService.companyName;

    /// Provides a fallback for the delivery phone number.
    final deliveryPhone =
    deliveryService.phoneNumber?.trim().isNotEmpty == true
        ? deliveryService.phoneNumber!
        : 'Not informed';

    /// Provides a fallback for payment observations.
    final paymentObservations =
    order.paymentObs.trim().isNotEmpty == true
        ? order.paymentObs
        : 'None';

    /// Converts the payment option into a readable label.
    final paymentLabel = switch (order.paymentOption) {
      PaymentOption.creditCard => 'Credit card',
      PaymentOption.cash => 'Cash',
      PaymentOption.bankTransferTed => 'Bank transfer (TED)',
      PaymentOption.bankTransferDoc => 'Bank transfer (DOC)',
      PaymentOption.pix => 'PIX',
    };

    /// Adds the receipt content to the PDF.
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          /// Displays the store logo and business information.
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (logo != null)
                pw.Container(
                  width: 75,
                  height: 75,
                  margin: const pw.EdgeInsets.only(right: 16),
                  child: pw.Image(
                    logo,
                    fit: pw.BoxFit.contain,
                  ),
                ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      store.name,
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(storeCompanyName),
                    pw.Text('CNPJ: ${store.cnpj}'),
                    pw.Text(storeAddress),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 24),

          /// Displays the order number and date.
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'ORDER #${order.id}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text('Date: $formattedDate'),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          /// Displays the client's registration information.
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text(
              'CLIENT INFORMATION',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800,
              ),
            ),
          ),

          /// Builds the client information table.
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              ['Name', client.name],
              ['Company', clientCompanyName],
              ['CNPJ', client.cnpj],
              ['Phone', clientPhone],
              ['Delivery address', clientAddress],
            ].map((row) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      row[0],
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      row[1],
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          pw.SizedBox(height: 20),

          /// Displays the products included in the order.
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text(
              'ORDER ITEMS',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800,
              ),
            ),
          ),

          /// Builds the order items table.
          pw.TableHelper.fromTextArray(
            headers: [
              'Product',
              'Qty.',
              'Unit price',
              'Discount',
              'Total',
            ],
            data: orderItems.map((item) {
              /// Includes the brand when available.
              final productName = item.brand.isEmpty
                  ? item.name
                  : '${item.name}\n${item.brand}';

              /// Formats the item unit price.
              final unitPrice =
                  'R\$ ${item.unitPrice.toStringAsFixed(2)
                  .replaceAll('.', ',')}';

              /// Formats the item discount.
              final discountAmount =
                  'R\$ ${item.discountAmount.toStringAsFixed(2)
                  .replaceAll('.', ',')}';

              /// Formats the item total.
              final total =
                  'R\$ ${item.total.toStringAsFixed(2).replaceAll('.', ',')}';

              return [
                productName,
                item.quantity.toString(),
                unitPrice,
                '${item.discount.toStringAsFixed(2)}% ($discountAmount)',
                total,
              ];
            }).toList(),

            /// Defines the proportional column widths.
            columnWidths: {
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(0.6),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(1.4),
              4: const pw.FlexColumnWidth(1.2),
            },

            /// Defines the table header style.
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),

            /// Defines the table cell style.
            cellStyle: const pw.TextStyle(fontSize: 8),

            /// Sets the table header background.
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),

            /// Adds borders around the table cells.
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),

            /// Aligns the cell content.
            cellAlignment: pw.Alignment.centerLeft,

            /// Adds spacing inside each cell.
            cellPadding: const pw.EdgeInsets.all(6),
          ),

          pw.SizedBox(height: 12),

          /// Displays the order financial summary.
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.SizedBox(
              width: 250,
              child: pw.Column(
                children: [
                  /// Displays the products subtotal.
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment:
                      pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Products subtotal'),
                        pw.Text(productsSubtotalFormatted),
                      ],
                    ),
                  ),

                  /// Displays the total discounts.
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment:
                      pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Discounts'),
                        pw.Text(productsDiscountFormatted),
                      ],
                    ),
                  ),

                  /// Displays the delivery cost.
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment:
                      pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Freight'),
                        pw.Text(deliveryPriceFormatted),
                      ],
                    ),
                  ),

                  /// Displays the payment surcharge when applicable.
                  if (paymentSurcharge > 0.01)
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Row(
                        mainAxisAlignment:
                        pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Payment surcharge'),
                          pw.Text(
                            'R\$ ${paymentSurcharge.toStringAsFixed(2)
                                .replaceAll('.', ',')}',
                          ),
                        ],
                      ),
                    ),

                  pw.Divider(),

                  /// Displays the final order amount.
                  pw.Row(
                    mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'FINAL TOTAL',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      pw.Text(
                        finalPriceFormatted,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          pw.SizedBox(height: 20),

          /// Displays the delivery service information.
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text(
              'DELIVERY INFORMATION',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800,
              ),
            ),
          ),

          /// Builds the delivery information table.
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              ['Carrier', deliveryService.name],
              ['Company', deliveryCompanyName],
              ['CNPJ', deliveryService.cnpj],
              ['Phone', deliveryPhone],
              [
                'Distance',
                '${order.deliveryDistance.toStringAsFixed(2)} km',
              ],
              ['Freight cost', deliveryPriceFormatted],
            ].map((row) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      row[0],
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      row[1],
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          pw.SizedBox(height: 20),

          /// Displays the payment method and observations.
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text(
              'PAYMENT INFORMATION',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800,
              ),
            ),
          ),

          /// Builds the payment information table.
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              ['Payment method', paymentLabel],
              ['Installments', order.installments.toString()],
              ['Payment observations', paymentObservations],
            ].map((row) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      row[0],
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      row[1],
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          pw.SizedBox(height: 28),
          pw.Divider(),

          /// Displays the receipt identification.
          pw.Center(
            child: pw.Text(
              'Order receipt #${order.id}',
              style: const pw.TextStyle(
                fontSize: 9,
                color: PdfColors.grey700,
              ),
            ),
          ),
        ],
      ),
    );

    /// Opens the generated PDF in the print preview.
    await Printing.layoutPdf(
      onLayout: (format) async => document.save(),
      name: 'order_${order.id}_receipt.pdf',
    );
  }
}
