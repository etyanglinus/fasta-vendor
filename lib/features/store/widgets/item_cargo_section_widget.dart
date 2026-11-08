import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fasta_deliveries_store/common/widgets/custom_text_field_widget.dart';
import 'package:fasta_deliveries_store/features/store/controllers/item_cargo_controller.dart';
import 'package:fasta_deliveries_store/util/dimensions.dart';
import 'package:fasta_deliveries_store/util/styles.dart';

/// "Delivery weight" and "Package size" on the product form. Optional: leave them empty to
/// use the category default. A heavy or bulky product then gets a vehicle that can carry it.
class ItemCargoSectionWidget extends StatelessWidget {
  const ItemCargoSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemCargoController>(builder: (cargo) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomTextFieldWidget(
          hintText: '${'delivery_weight'.tr} (${cargo.weightUnit})',
          labelText: '${'delivery_weight'.tr} (${cargo.weightUnit})',
          controller: cargo.weightController,
          isAmount: true,
        ),
        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
          child: Text(
            'delivery_weight_hint'.tr,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
          ),
        ),
        if (cargo.sizes.isNotEmpty) ...[
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          DropdownButtonFormField<int?>(
            // initialValue is read once; the key rebuilds the field when the saved size or the
            // size list (loaded after the form opens) changes.
            key: ValueKey('size-${cargo.dimensionId}-${cargo.sizes.length}'),
            initialValue: cargo.dimensionId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'package_size'.tr,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
            ),
            items: [
              DropdownMenuItem<int?>(value: null, child: Text('category_default'.tr)),
              ...cargo.sizes.map((s) => DropdownMenuItem<int?>(value: s.id, child: Text(s.name))),
            ],
            onChanged: cargo.setDimension,
          ),
        ],
      ]);
    });
  }
}
