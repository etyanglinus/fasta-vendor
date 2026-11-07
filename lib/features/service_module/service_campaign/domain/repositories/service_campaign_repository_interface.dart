import 'package:fasta_deliveries_store/interface/repository_interface.dart';

abstract class ServiceCampaignRepositoryInterface
    implements RepositoryInterface {
  Future<dynamic> joinCampaign(int? campaignID);
  Future<dynamic> leaveCampaign(int? campaignID);
}
