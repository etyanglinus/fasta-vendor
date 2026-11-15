import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fasta_deliveries_store/api/api_client.dart';
import 'package:fasta_deliveries_store/common/widgets/custom_app_bar_widget.dart';
import 'package:fasta_deliveries_store/common/widgets/custom_button_widget.dart';
import 'package:fasta_deliveries_store/features/vat/controllers/vat_controller.dart';
import 'package:fasta_deliveries_store/features/vat/domain/models/vat_model.dart';
import 'package:fasta_deliveries_store/helper/date_converter_helper.dart';
import 'package:fasta_deliveries_store/helper/price_converter_helper.dart';
import 'package:fasta_deliveries_store/util/dimensions.dart';
import 'package:fasta_deliveries_store/util/styles.dart';

/// Menu → Tax & VAT. The same as Store → Tax & VAT on the seller website.
class VatScreen extends StatefulWidget {
  const VatScreen({super.key});

  @override
  State<VatScreen> createState() => _VatScreenState();
}

class _VatScreenState extends State<VatScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<VatController>()) {
      Get.put(VatController(apiClient: Get.find<ApiClient>()));
    }
    Get.find<VatController>().getVat().then((_) {
      _pinController.text = Get.find<VatController>().vat?.kraPin ?? '';
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  static String _date(DateTime date) => DateConverterHelper.estimatedDate(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'tax_and_vat'.tr),
      body: GetBuilder<VatController>(
        builder: (controller) {
          final VatModel? vat = controller.vat;
          if (vat == null) {
            return Center(
              child: controller.isLoading
                  ? const CircularProgressIndicator()
                  : TextButton(onPressed: controller.getVat, child: Text('retry'.tr)),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.getVat,
            child: ListView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              children: [
                Text('vat_intro'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if (vat.enforcedFrom != null && !vat.enforced && vat.vatStatus != 'verified')
                  _notice(context, 'vat_rule_starts'.trParams({'date': _date(vat.enforcedFrom!)}), Colors.orange),
                if (vat.vatStatus == 'rejected' && (vat.vatNote ?? '').isNotEmpty)
                  _notice(context, vat.vatNote!, Theme.of(context).colorScheme.error),

                _card(
                  context,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'your_tax_details'.tr,
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                          ),
                        ),
                        _statusBadge(context, vat.vatStatus),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Text('kra_pin'.tr, style: robotoMedium),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _pinController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 20,
                      decoration: InputDecoration(
                        hintText: 'A123456789Z',
                        helperText: 'kra_pin_help'.tr,
                        helperMaxLines: 2,
                        errorText: controller.errors['kra_pin'],
                        errorMaxLines: 3,
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Text('are_you_vat_registered'.tr, style: robotoMedium),
                    RadioGroup<bool>(
                      groupValue: controller.registered,
                      onChanged: (v) {
                        if (v != null) controller.setRegistered(v);
                      },
                      child: Column(
                        children: [
                          RadioListTile<bool>(
                            contentPadding: EdgeInsets.zero,
                            value: true,
                            title: Text('yes_vat_registered'.tr),
                          ),
                          RadioListTile<bool>(contentPadding: EdgeInsets.zero, value: false, title: Text('no'.tr)),
                        ],
                      ),
                    ),
                    if (controller.errors['vat_registered'] != null)
                      Text(
                        controller.errors['vat_registered']!,
                        style: robotoRegular.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    Text(
                      'not_registered_help'.tr,
                      style: robotoRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),

                    if (controller.registered == true) ...[
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Text('kra_certificate'.tr, style: robotoMedium),
                      const SizedBox(height: 6),
                      OutlinedButton.icon(
                        onPressed: controller.pickCertificate,
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          controller.certificate?.files.single.name ?? 'choose_file'.tr,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'certificate_types'.tr,
                        style: robotoRegular.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                      if (controller.errors['certificate'] != null)
                        Text(
                          controller.errors['certificate']!,
                          style: robotoRegular.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      if (vat.certificateUrl != null && controller.certificate == null)
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () =>
                              launchUrl(Uri.parse(vat.certificateUrl!), mode: LaunchMode.externalApplication),
                          child: Text('view_uploaded_certificate'.tr),
                        ),
                    ],
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    CustomButtonWidget(
                      buttonText: 'save'.tr,
                      isLoading: controller.isSaving,
                      onPressed: controller.isSaving
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              if (await controller.save(_pinController.text)) {
                                _pinController.text = controller.vat?.kraPin ?? _pinController.text;
                              }
                            },
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                _card(
                  context,
                  children: [
                    Text('vat_on_your_sales'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: 6),
                    Text(
                      vat.chargesVat ? 'vat_is_added'.tr : 'vat_is_not_added'.tr,
                      style: robotoMedium.copyWith(color: vat.chargesVat ? Colors.green : Theme.of(context).hintColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'vat_summary_help'.tr,
                      style: robotoRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    if (vat.summary.isEmpty)
                      Text(
                        'no_delivered_orders_yet'.tr,
                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                      )
                    else
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1.3),
                          1: FlexColumnWidth(0.8),
                          2: FlexColumnWidth(1.4),
                          3: FlexColumnWidth(1.2),
                        },
                        children: [
                          TableRow(
                            children: [
                              _cell('month'.tr, bold: true),
                              _cell('orders'.tr, bold: true, end: true),
                              _cell('sales'.tr, bold: true, end: true),
                              _cell('vat'.tr, bold: true, end: true),
                            ],
                          ),
                          for (final VatMonth row in vat.summary)
                            TableRow(
                              children: [
                                _cell(_month(row.month)),
                                _cell('${row.orders}', end: true),
                                _cell(PriceConverterHelper.convertPrice(row.sales), end: true),
                                _cell(PriceConverterHelper.convertPrice(row.vat), end: true),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _month(String yearMonth) {
    final List<String> parts = yearMonth.split('-');
    final int? m = parts.length == 2 ? int.tryParse(parts[1]) : null;
    return m != null && m >= 1 && m <= 12 ? '${_monthNames[m - 1]} ${parts[0]}' : yearMonth;
  }

  Widget _cell(String text, {bool bold = false, bool end = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text(
      text,
      textAlign: end ? TextAlign.end : TextAlign.start,
      style: (bold ? robotoMedium : robotoRegular).copyWith(fontSize: Dimensions.fontSizeSmall),
    ),
  );

  Widget _card(BuildContext context, {required List<Widget> children}) => Container(
    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _notice(BuildContext context, String text, Color color) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      border: Border.all(color: color.withValues(alpha: 0.4)),
    ),
    child: Text(text, style: robotoRegular),
  );

  Widget _statusBadge(BuildContext context, String status) {
    final Map<String, (String, Color)> styles = {
      'unsubmitted': ('vat_status_unsubmitted'.tr, Colors.grey),
      'not_registered': ('vat_status_not_registered'.tr, Colors.grey),
      'pending': ('vat_status_pending'.tr, Colors.orange),
      'verified': ('vat_status_verified'.tr, Colors.green),
      'rejected': ('vat_status_rejected'.tr, Theme.of(context).colorScheme.error),
    };
    final (String label, Color color) = styles[status] ?? styles['unsubmitted']!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: robotoMedium.copyWith(color: color, fontSize: Dimensions.fontSizeSmall),
      ),
    );
  }
}
