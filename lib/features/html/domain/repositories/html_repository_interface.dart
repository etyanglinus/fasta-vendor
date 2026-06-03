import 'package:fasta_deliveries_vendor/interface/repository_interface.dart';

abstract class HtmlRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getHtmlText(bool isPrivacyPolicy);
}