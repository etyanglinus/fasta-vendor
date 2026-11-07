import 'package:fasta_deliveries_store/common/models/response_model.dart';

abstract class OrderEditRepositoryInterface {
  Future<ResponseModel> updateOrder(Map<String, dynamic> body);
}
