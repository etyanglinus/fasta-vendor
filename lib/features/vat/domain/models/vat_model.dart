/// Tax & VAT status of the seller's store, from GET /api/v1/vendor/vat.
///
/// Only sellers registered for VAT with KRA, and checked by Fasta, may charge VAT.
class VatModel {
  final String? kraPin;
  final bool vatRegistered;

  /// unsubmitted | not_registered | pending | verified | rejected
  final String vatStatus;
  final String? vatNote;
  final String? certificateUrl;
  final DateTime? enforcedFrom;
  final bool enforced;
  final bool chargesVat;
  final List<VatMonth> summary;

  VatModel({
    this.kraPin,
    required this.vatRegistered,
    required this.vatStatus,
    this.vatNote,
    this.certificateUrl,
    this.enforcedFrom,
    required this.enforced,
    required this.chargesVat,
    required this.summary,
  });

  factory VatModel.fromJson(Map<String, dynamic> json) => VatModel(
    kraPin: json['kra_pin']?.toString(),
    vatRegistered: json['vat_registered'] == true || json['vat_registered'] == 1,
    vatStatus: (json['vat_status'] ?? 'unsubmitted').toString(),
    vatNote: json['vat_note']?.toString(),
    certificateUrl: json['certificate_url']?.toString(),
    enforcedFrom: json['enforced_from'] != null ? DateTime.tryParse(json['enforced_from'].toString())?.toLocal() : null,
    enforced: json['enforced'] == true,
    chargesVat: json['charges_vat'] != false,
    summary: (json['summary'] is List ? json['summary'] as List : const [])
        .whereType<Map>()
        .map((row) => VatMonth.fromJson(Map<String, dynamic>.from(row)))
        .toList(),
  );

  /// The rule is scheduled or on and this seller is not cleared either way.
  bool get needsAction => enforcedFrom != null && vatStatus != 'verified' && vatStatus != 'not_registered';
}

class VatMonth {
  final String month;
  final int orders;
  final double sales;
  final double vat;

  VatMonth({required this.month, required this.orders, required this.sales, required this.vat});

  factory VatMonth.fromJson(Map<String, dynamic> json) => VatMonth(
    month: json['month']?.toString() ?? '',
    orders: int.tryParse(json['orders'].toString()) ?? 0,
    sales: double.tryParse(json['sales'].toString()) ?? 0,
    vat: double.tryParse(json['vat'].toString()) ?? 0,
  );
}
