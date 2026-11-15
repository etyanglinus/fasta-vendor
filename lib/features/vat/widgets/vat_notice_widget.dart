import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fasta_deliveries_store/api/api_client.dart';
import 'package:fasta_deliveries_store/features/auth/controllers/auth_controller.dart';
import 'package:fasta_deliveries_store/features/vat/controllers/vat_controller.dart';
import 'package:fasta_deliveries_store/helper/route_helper.dart';
import 'package:fasta_deliveries_store/util/dimensions.dart';
import 'package:fasta_deliveries_store/util/styles.dart';

/// Home screen reminder for the owner while the seller VAT rule is scheduled or on and the
/// store has not told Fasta whether it is VAT registered (or is waiting for / failed the check).
class VatNoticeWidget extends StatefulWidget {
  const VatNoticeWidget({super.key});

  @override
  State<VatNoticeWidget> createState() => _VatNoticeWidgetState();
}

class _VatNoticeWidgetState extends State<VatNoticeWidget> {
  late final bool _isOwner = Get.find<AuthController>().getUserType() == 'owner';

  @override
  void initState() {
    super.initState();
    if (!_isOwner) return;
    if (!Get.isRegistered<VatController>()) {
      Get.put(VatController(apiClient: Get.find<ApiClient>()));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => Get.find<VatController>().getVat());
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOwner) return const SizedBox();

    return GetBuilder<VatController>(
      builder: (controller) {
        final vat = controller.vat;
        if (vat == null || !vat.needsAction || vat.vatStatus == 'pending') return const SizedBox();

        return InkWell(
          onTap: () => Get.toNamed(RouteHelper.getTaxAndVatRoute()),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.orange),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Text(
                    vat.enforced
                        ? 'vat_not_added_action'.tr
                        : 'vat_rule_starts_short'.trParams({'date': _date(vat.enforcedFrom!)}),
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _date(DateTime d) =>
      '${d.day} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.year}';
}
