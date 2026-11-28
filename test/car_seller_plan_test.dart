import 'package:fasta_deliveries_store/features/auth/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only BuyCar modules are car-seller modules (subscription only)', () {
    expect(AuthController.isCarSellerModule('buycar'), isTrue);
    for (final type in ['grocery', 'food', 'pharmacy', 'ecommerce', 'rental', 'service', null]) {
      expect(AuthController.isCarSellerModule(type), isFalse, reason: '$type');
    }
  });
}
