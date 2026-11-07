import 'package:fasta_deliveries_store/common/models/api_error.dart';
import 'package:fasta_deliveries_store/features/auth/controllers/auth_controller.dart';
import 'package:fasta_deliveries_store/helper/route_helper.dart';
import 'package:fasta_deliveries_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class ApiChecker {
  /// Single place every failed response passes through: signs the user out on
  /// 401, otherwise shows the resolved message.
  static void checkApi(Response response) =>
      handleError(ApiError.fromResponse(response));

  static void handleError(ApiError error, {bool showSnackBar = true}) {
    if (error.isUnauthorized) {
      _forceSignOut();
    } else if (showSnackBar) {
      showCustomSnackBar(error.message);
    }
  }

  static void _forceSignOut() {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().clearSharedData();
    }
    Get.offAllNamed(RouteHelper.getSignInRoute());
  }
}
