import 'package:fasta_deliveries_store/common/models/response_model.dart';
import 'package:fasta_deliveries_store/features/service_module/booking_edit/domain/models/booking_edit_catalog_model.dart';
import 'package:fasta_deliveries_store/features/service_module/booking_edit/domain/models/booking_edit_preview_model.dart';

abstract class BookingEditRepositoryInterface {
  Future<BookingEditCatalogResponseModel?> getEditCatalog(int bookingId);
  Future<BookingEditPreviewResult> previewEdit(
    int bookingId,
    Map<String, dynamic> body,
  );
  Future<ResponseModel> updateEdit(int bookingId, Map<String, dynamic> body);
}
