import 'package:fasta_deliveries_store/features/service_module/order/domain/models/booking_model.dart';

class RunningBookingModel {
  String status;
  List<BookingModel> bookingList;
  int? totalSize;

  RunningBookingModel({
    required this.status,
    required this.bookingList,
    this.totalSize,
  });
}
