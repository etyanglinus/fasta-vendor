import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:fasta_deliveries_store/api/api_client.dart';
import 'package:fasta_deliveries_store/api/api_response.dart';
import 'package:fasta_deliveries_store/common/widgets/custom_snackbar_widget.dart';
import 'package:fasta_deliveries_store/features/vat/domain/models/vat_model.dart';
import 'package:fasta_deliveries_store/util/app_constants.dart';

/// Store owner's Tax & VAT screen: KRA PIN, VAT registration and the monthly VAT summary.
class VatController extends GetxController {
  final ApiClient apiClient;
  VatController({required this.apiClient});

  /// KRA PIN: A (individual) or P (company), 9 digits, a letter.
  static final RegExp pinPattern = RegExp(r'^[AP]\d{9}[A-Z]$');

  static String normalizePin(String pin) => pin.replaceAll(RegExp(r'[\s\-]+'), '').toUpperCase();

  VatModel? _vat;
  VatModel? get vat => _vat;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  bool? _registered;
  bool? get registered => _registered;

  FilePickerResult? _certificate;
  FilePickerResult? get certificate => _certificate;

  /// Field errors from the last save, by field name (kra_pin, certificate).
  Map<String, String> _errors = {};
  Map<String, String> get errors => _errors;

  Future<void> getVat() async {
    _isLoading = true;
    update();
    Response response = await apiClient.getData(AppConstants.vendorVatUri);
    if (response.statusCode == 200) {
      _vat = VatModel.fromJson(response.contentMap);
      _registered = _vat!.vatStatus == 'unsubmitted' ? null : _vat!.vatRegistered;
      _certificate = null;
      _errors = {};
    }
    _isLoading = false;
    update();
  }

  void setRegistered(bool value) {
    _registered = value;
    _errors.remove('vat_registered');
    update();
  }

  Future<void> pickCertificate() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty) return;
    if (result.files.single.size > 4 * 1024 * 1024) {
      showCustomSnackBar('certificate_too_large'.tr);
      return;
    }
    _certificate = result;
    _errors.remove('certificate');
    update();
  }

  /// Returns true when saved.
  Future<bool> save(String pin) async {
    _errors = {};
    final String cleaned = normalizePin(pin);
    if (!pinPattern.hasMatch(cleaned)) {
      _errors['kra_pin'] = 'kra_pin_invalid'.tr;
    }
    if (_registered == null) {
      _errors['vat_registered'] = 'choose_vat_registered'.tr;
    }
    if (_registered == true && _certificate == null && _vat?.certificateUrl == null) {
      _errors['certificate'] = 'upload_kra_certificate'.tr;
    }
    if (_errors.isNotEmpty) {
      update();
      return false;
    }

    _isSaving = true;
    update();
    Response response = await apiClient.postMultipartData(
      AppConstants.vendorVatUri,
      {'kra_pin': cleaned, 'vat_registered': _registered! ? '1' : '0'},
      [],
      multipartDocument: _certificate != null ? [MultipartDocument('certificate', _certificate)] : null,
      handleError: false,
    );
    _isSaving = false;

    if (response.statusCode == 200) {
      _vat = VatModel.fromJson(response.contentMap);
      _certificate = null;
      update();
      showCustomSnackBar((response.contentMap['saved_message'] ?? 'vat_saved'.tr).toString(), isError: false);
      return true;
    }

    final dynamic body = response.body;
    if (body is Map && body['errors'] is List) {
      for (final dynamic error in body['errors']) {
        if (error is Map && error['code'] != null) {
          _errors[error['code'].toString()] = (error['message'] ?? '').toString();
        }
      }
    }
    if (_errors.isEmpty) {
      showCustomSnackBar(response.statusText ?? 'vat_save_failed'.tr);
    }
    update();
    return false;
  }
}
