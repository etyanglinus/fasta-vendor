import 'package:get/get.dart';
import 'package:fasta_deliveries_vendor/features/rental_module/driver/domain/services/driver_service_interface.dart';

class DriverController extends GetxController implements GetxService {
  final DriverServiceInterface driverServiceInterface;
  DriverController({required this.driverServiceInterface});
  
}