import 'package:fasta_deliveries_store/features/service_module/service_report/domain/models/service_disbursement_report_model.dart';
import 'package:fasta_deliveries_store/interface/repository_interface.dart';

abstract class ServiceDisbursementRepositoryInterface
    implements RepositoryInterface {
  Future<ServiceDisbursementReportModel?> getDisbursementReport(int offset);
}
