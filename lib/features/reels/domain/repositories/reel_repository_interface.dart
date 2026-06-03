import 'package:get/get.dart';
import 'package:fasta_deliveries_vendor/api/api_client.dart';
import 'package:fasta_deliveries_vendor/features/reels/domain/models/reel_model.dart';
import 'package:fasta_deliveries_vendor/interface/repository_interface.dart';

abstract class ReelRepositoryInterface implements RepositoryInterface {
  Future<ReelsModel?> getReelsList(String offset, String status, String sortBy, {String? search});
  Future<Response> storeReel(Map<String, String> body, List<MultipartBody> files);
  Future<Response> updateReel(Map<String, String> body, List<MultipartBody> files);
  Future<Response> deleteReel(int reelId);
  Future<Response> changeReelStatus(int reelId, int status);
}
