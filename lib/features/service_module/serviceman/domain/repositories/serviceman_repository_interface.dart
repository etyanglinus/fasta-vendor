import 'package:image_picker/image_picker.dart';
import 'package:fasta_deliveries_store/common/models/response_model.dart';
import 'package:fasta_deliveries_store/features/service_module/serviceman/domain/models/service_man_completed_booking_model.dart';
import 'package:fasta_deliveries_store/features/service_module/serviceman/domain/models/service_man_list_model.dart';
import 'package:fasta_deliveries_store/features/service_module/serviceman/domain/models/service_man_model.dart';
import 'package:fasta_deliveries_store/interface/repository_interface.dart';

abstract class ServicemanRepositoryInterface
    extends RepositoryInterface<Object> {
  Future<ServiceManListModel?> getServiceManList({required String offset});
  Future<ServiceManModel?> getServiceManDetails(int id);
  Future<ServiceManCompletedBookingListModel?> getServiceManCompletedBookings(
    int id, {
    required String offset,
  });
  Future<ResponseModel> addServiceMan(
    ServiceManModel serviceMan,
    String pass,
    XFile? image,
    List<XFile> identities,
    bool isAdd,
  );
  Future<ResponseModel> deleteServiceMan(int id);
  Future<ResponseModel> updateServiceManStatus(int id, int status);
}
