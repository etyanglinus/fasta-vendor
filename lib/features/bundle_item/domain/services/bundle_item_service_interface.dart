import 'package:fasta_deliveries_store/api/api_client.dart';
import 'package:fasta_deliveries_store/common/models/response_model.dart';
import 'package:fasta_deliveries_store/features/bundle_item/domain/models/bundle_item_model.dart';
import 'package:fasta_deliveries_store/features/bundle_item/domain/repositories/bundle_item_repository.dart';

abstract class BundleItemServiceInterface {
  Future<BundlePackageModel?> getBundleList(String offset, {String? search});
  Future<BundlePackage?> getBundleDetails(int bundleId);
  Future<BundleSaveResult?> addBundle(
    Map<String, String> body,
    List<MultipartBody> selectedFile,
  );
  Future<BundleSaveResult?> updateBundle(
    int bundleId,
    Map<String, String> body,
    List<MultipartBody> selectedFile,
  );
  Future<ResponseModel?> deleteBundle(int bundleId);
  Future<ResponseModel?> changeBundleStatus(int bundleId, int status);
  Future<List<BundleCatalogueItem>?> getBundleItems({String? search});
}
