import 'package:flutter_test/flutter_test.dart';
import 'package:fasta_deliveries_store/features/store/controllers/item_cargo_controller.dart';
import 'package:fasta_deliveries_store/features/store/domain/models/item_model.dart';

void main() {
  // Item.fromJson/toJson need the running app's SplashController, so they are not unit-tested here.
  test('the weight field accepts decimals, empty and rejects nonsense', () {
    final cargo = ItemCargoController();
    final item = Item();

    cargo.weightController.text = '1,5';
    cargo.dimensionId = 3;
    expect(cargo.apply(item), isTrue);
    expect(item.weight, 1.5);
    expect(item.dimensionId, 3);

    cargo.weightController.text = '';
    expect(cargo.apply(item), isTrue);
    expect(item.weight, isNull, reason: 'empty uses the category default');

    for (final bad in ['-2', 'heavy', '1000000']) {
      cargo.weightController.text = bad;
      expect(cargo.apply(item), isFalse, reason: bad);
    }
  });
}
