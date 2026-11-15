import 'package:flutter_test/flutter_test.dart';
import 'package:fasta_deliveries_store/features/vat/controllers/vat_controller.dart';
import 'package:fasta_deliveries_store/features/vat/domain/models/vat_model.dart';

void main() {
  test('reads GET /api/v1/vendor/vat', () {
    final vat = VatModel.fromJson({
      'kra_pin': 'P051234567X',
      'vat_registered': true,
      'vat_status': 'pending',
      'certificate_url': 'https://example.test/c.pdf',
      'enforced_from': '2026-11-29T00:00:00+03:00',
      'enforced': false,
      'charges_vat': true,
      'summary': [
        {'month': '2026-11', 'orders': 3, 'sales': 1500.5, 'vat': '207'},
      ],
    });
    expect(vat.vatStatus, 'pending');
    expect(vat.enforcedFrom, isNotNull);
    expect(vat.needsAction, isTrue);
    expect(vat.summary.single.vat, 207.0);
    expect(vat.summary.single.orders, 3);
  });

  test('a seller who is verified or not registered needs nothing', () {
    expect(VatModel.fromJson({'vat_status': 'verified', 'enforced_from': '2026-11-29T00:00:00Z'}).needsAction, isFalse);
    expect(VatModel.fromJson({'vat_status': 'not_registered', 'enforced_from': '2026-11-29T00:00:00Z'}).needsAction, isFalse);
    expect(VatModel.fromJson({'vat_status': 'unsubmitted'}).needsAction, isFalse, reason: 'rule not scheduled');
  });

  test('KRA PIN format', () {
    expect(VatController.pinPattern.hasMatch(VatController.normalizePin(' p 051234567-x ')), isTrue);
    expect(VatController.pinPattern.hasMatch('B051234567X'), isFalse);
    expect(VatController.pinPattern.hasMatch('P05123456X'), isFalse);
  });
}
