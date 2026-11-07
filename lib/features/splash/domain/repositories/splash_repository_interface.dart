import 'package:fasta_deliveries_store/interface/repository_interface.dart';

abstract class SplashRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getConfigData();
  Future<bool> initSharedData();
  bool showIntro();
  void setIntro(bool intro);
  Future<bool> removeSharedData();
  bool handleInitialTopicSubscription();
}
