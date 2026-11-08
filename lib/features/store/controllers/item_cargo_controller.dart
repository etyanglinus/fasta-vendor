import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fasta_deliveries_store/api/api_client.dart';
import 'package:fasta_deliveries_store/features/store/domain/models/item_model.dart';
import 'package:fasta_deliveries_store/util/app_constants.dart';

/// A package size the admin set up (Delivery management → Dimension setup).
class ItemSize {
  final int id;
  final String name;
  const ItemSize(this.id, this.name);
}

/// Delivery weight and package size on the add/edit product screen.
///
/// The server uses them to send a vehicle that can carry the order; both are optional and
/// fall back to the category default. Sizes and the weight unit come from
/// GET /api/v1/vendor/item-sizes.
class ItemCargoController extends GetxController {
  final TextEditingController weightController = TextEditingController();
  List<ItemSize> sizes = [];
  String weightUnit = 'kg';
  int? dimensionId;
  bool _loaded = false;

  /// Fill the fields for a new (null) or existing product, and load the size list once.
  void fill(Item? item) {
    final double? weight = item?.weight;
    weightController.text = weight == null
        ? ''
        : (weight == weight.roundToDouble() ? weight.toInt().toString() : weight.toString());
    dimensionId = item?.dimensionId;
    update();
    if (!_loaded) {
      loadSizes();
    }
  }

  Future<void> loadSizes() async {
    final Response response = await Get.find<ApiClient>().getData(AppConstants.itemSizesUri, handleError: false);
    if (response.statusCode == 200 && response.body is Map) {
      final dynamic content = response.body['content'] ?? response.body;
      if (content is Map) {
        weightUnit = (content['weight_unit'] ?? 'kg').toString();
        sizes = ((content['sizes'] as List?) ?? [])
            .whereType<Map>()
            .map((s) => ItemSize(int.tryParse(s['id'].toString()) ?? 0, s['name'].toString()))
            .where((s) => s.id > 0)
            .toList();
        _loaded = true;
      }
    }
    if (dimensionId != null && !sizes.any((s) => s.id == dimensionId)) {
      dimensionId = null; // a size that no longer exists
    }
    update();
  }

  void setDimension(int? id) {
    dimensionId = id;
    update();
  }

  /// The weight typed in, or null when empty. Returns false (and leaves the item unchanged)
  /// when the text is not a usable weight.
  bool apply(Item item) {
    final String text = weightController.text.trim().replaceAll(',', '.');
    if (text.isEmpty) {
      item.weight = null;
    } else {
      final double? weight = double.tryParse(text);
      if (weight == null || weight < 0 || weight > 99999) {
        return false;
      }
      item.weight = weight == 0 ? null : weight;
    }
    item.dimensionId = dimensionId;
    return true;
  }

  @override
  void onClose() {
    weightController.dispose();
    super.onClose();
  }
}
