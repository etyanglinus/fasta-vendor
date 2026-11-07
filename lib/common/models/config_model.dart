import 'package:fasta_deliveries_store/helper/data_parser_helper.dart';

class ConfigModel {
  String? businessName;
  String? footerText;
  String? address;
  String? phone;
  String? email;
  String? country;
  DefaultLocation? defaultLocation;
  String? currencySymbol;
  String? currencySymbolDirection;
  String? distanceUnit;
  double? appMinimumVersionAndroid;
  String? appUrlAndroid;
  double? appMinimumVersionIos;
  String? appUrlIos;
  bool? scheduleOrder;
  bool? orderDeliveryVerification;
  bool? cashOnDelivery;
  bool? digitalPayment;
  double? freeDeliveryOver;
  bool? demo;
  bool? maintenanceMode;
  String? orderConfirmationModel;
  bool? showDmEarning;
  bool? canceledByDeliveryman;
  String? timeformat;
  List<Language>? language;
  bool? toggleVegNonVeg;
  bool? toggleDmRegistration;
  bool? toggleStoreRegistration;
  int? scheduleOrderSlotDuration;
  int? digitAfterDecimalPoint;
  bool? canceledByStore;
  ModuleConfig? moduleConfig;
  bool? prescriptionOrderStatus;
  bool? dmPictureUploadStatus;
  String? additionalChargeName;
  String? disbursementType;
  List<PaymentBody>? activePaymentMethodList;
  double? minAmountToPayStore;
  bool? storeReviewReply;
  double? adminCommission;
  int? subscriptionDeadlineWarningDays;
  String? subscriptionDeadlineWarningMessage;
  int? subscriptionFreeTrialDays;
  bool? subscriptionFreeTrialStatus;
  int? subscriptionBusinessModel;
  int? commissionBusinessModel;
  String? subscriptionFreeTrialType;
  String? systemTaxType;
  bool? systemTaxIncludeStatus;
  bool? openAiStatus;
  ReelsModule? reelsModule;
  ValidationConfig? validationConfig;
  MaintenanceModeData? maintenanceModeData;
  bool? storeCategoryStatus;
  ServiceModule? serviceModule;
  bool? productBundleStatus;
  List<String>? productBundleModuleTypes;

  ConfigModel({
    this.businessName,
    this.footerText,
    this.address,
    this.phone,
    this.email,
    this.country,
    this.defaultLocation,
    this.currencySymbol,
    this.currencySymbolDirection,
    this.distanceUnit,
    this.appMinimumVersionAndroid,
    this.appUrlAndroid,
    this.appMinimumVersionIos,
    this.appUrlIos,
    this.scheduleOrder,
    this.orderDeliveryVerification,
    this.cashOnDelivery,
    this.digitalPayment,
    this.freeDeliveryOver,
    this.demo,
    this.maintenanceMode,
    this.orderConfirmationModel,
    this.showDmEarning,
    this.canceledByDeliveryman,
    this.timeformat,
    this.language,
    this.toggleVegNonVeg,
    this.toggleDmRegistration,
    this.toggleStoreRegistration,
    this.scheduleOrderSlotDuration,
    this.digitAfterDecimalPoint,
    this.moduleConfig,
    this.canceledByStore,
    this.prescriptionOrderStatus,
    this.dmPictureUploadStatus,
    this.additionalChargeName,
    this.disbursementType,
    this.activePaymentMethodList,
    this.minAmountToPayStore,
    this.storeReviewReply,
    this.adminCommission,
    this.subscriptionDeadlineWarningDays,
    this.subscriptionDeadlineWarningMessage,
    this.subscriptionFreeTrialDays,
    this.subscriptionFreeTrialStatus,
    this.subscriptionBusinessModel,
    this.commissionBusinessModel,
    this.subscriptionFreeTrialType,
    this.systemTaxType,
    this.systemTaxIncludeStatus,
    this.openAiStatus,
    this.reelsModule,
    this.validationConfig,
    this.maintenanceModeData,
    this.storeCategoryStatus,
    this.serviceModule,
    this.productBundleStatus,
    this.productBundleModuleTypes,
  });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    footerText = json['footer_text'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    country = json['country'];
    defaultLocation = json['default_location'] != null
        ? DefaultLocation.fromJson(json['default_location'])
        : null;
    currencySymbol = json['currency_symbol'];
    currencySymbolDirection = json['currency_symbol_direction'];
    distanceUnit = json['distance_unit'];
    appMinimumVersionAndroid = json['app_minimum_version_android_store'] != null
        ? json['app_minimum_version_android_store']?.toDouble()
        : 0.0;
    appUrlAndroid = json['app_url_android_store'];
    appMinimumVersionIos = json['app_minimum_version_ios_store'] != null
        ? json['app_minimum_version_ios_store']?.toDouble()
        : 0.0;
    appUrlIos = json['app_url_ios_store'];
    scheduleOrder = DataParserHelper.parseBool(json['schedule_order']);
    orderDeliveryVerification = DataParserHelper.parseBool(
      json['order_delivery_verification'],
    );
    cashOnDelivery = DataParserHelper.parseBool(json['cash_on_delivery']);
    digitalPayment = DataParserHelper.parseBool(json['digital_payment']);
    freeDeliveryOver = json['free_delivery_over']?.toDouble();
    demo = DataParserHelper.parseBool(json['demo']);
    maintenanceMode = DataParserHelper.parseBool(json['maintenance_mode']);
    orderConfirmationModel = json['order_confirmation_model'];
    showDmEarning = DataParserHelper.parseBool(json['show_dm_earning']);
    canceledByDeliveryman = DataParserHelper.parseBool(
      json['canceled_by_deliveryman'],
    );
    timeformat = json['timeformat'];
    if (json['language'] != null) {
      language = <Language>[];
      json['language'].forEach((v) {
        language!.add(Language.fromJson(v));
      });
    }
    toggleVegNonVeg = DataParserHelper.parseBool(json['toggle_veg_non_veg']);
    toggleDmRegistration = DataParserHelper.parseBool(
      json['toggle_dm_registration'],
    );
    toggleStoreRegistration = DataParserHelper.parseBool(
      json['toggle_store_registration'],
    );
    scheduleOrderSlotDuration = json['schedule_order_slot_duration'] == 0
        ? 30
        : json['schedule_order_slot_duration'];
    digitAfterDecimalPoint = json['digit_after_decimal_point'];
    canceledByStore = DataParserHelper.parseBool(json['canceled_by_store']);
    moduleConfig = json['module_config'] != null
        ? ModuleConfig.fromJson(json['module_config'])
        : null;
    prescriptionOrderStatus = DataParserHelper.parseBool(
      json['prescription_order_status'],
    );
    dmPictureUploadStatus = DataParserHelper.parseBool(
      json['dm_picture_upload_status'],
    );
    additionalChargeName = json['additional_charge_name'];
    disbursementType = json['disbursement_type'];
    if (json['active_payment_method_list'] != null) {
      activePaymentMethodList = <PaymentBody>[];
      json['active_payment_method_list'].forEach((v) {
        activePaymentMethodList!.add(PaymentBody.fromJson(v));
      });
    }
    minAmountToPayStore = json['min_amount_to_pay_store']?.toDouble();
    storeReviewReply = DataParserHelper.parseBool(json['store_review_reply']);
    adminCommission = json['admin_commission'] != null
        ? double.tryParse(json['admin_commission'].toString())
        : null;
    subscriptionDeadlineWarningDays =
        json['subscription_deadline_warning_days'];
    subscriptionDeadlineWarningMessage =
        json['subscription_deadline_warning_message'];
    subscriptionFreeTrialDays = json['subscription_free_trial_days'];
    subscriptionFreeTrialStatus = DataParserHelper.parseBool(
      json['subscription_free_trial_status'],
    );
    subscriptionBusinessModel = json['subscription_business_model'];
    commissionBusinessModel = json['commission_business_model'];
    subscriptionFreeTrialType = json['subscription_free_trial_type'];
    systemTaxType = json['system_tax_type'];
    systemTaxIncludeStatus = DataParserHelper.parseBool(
      json['system_tax_include_status'],
    );
    openAiStatus = DataParserHelper.parseBool(json['open_ai_status']);
    reelsModule = json['reels_module'] != null
        ? ReelsModule.fromJson(json['reels_module'])
        : null;
    validationConfig = json['validation_config'] != null
        ? ValidationConfig.fromJson(json['validation_config'])
        : ValidationConfig(
            productVideoMaxFileSize: 20,
            maxFileSize: 2,
            maxUploadFileCount: 5,
          );
    maintenanceModeData = json['maintenance_mode_data'] != null
        ? MaintenanceModeData.fromJson(json['maintenance_mode_data'])
        : null;
    storeCategoryStatus = DataParserHelper.parseBool(
      json['store_category_status'],
    );
    serviceModule = json['service_module'] != null
        ? ServiceModule.fromJson(json['service_module'])
        : null;
    productBundleStatus = DataParserHelper.parseBool(
      json['product_bundle_status'],
    );
    productBundleModuleTypes = json['product_bundle_module_types'] != null
        ? List<String>.from(json['product_bundle_module_types'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_name'] = businessName;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['country'] = country;
    if (defaultLocation != null) {
      data['default_location'] = defaultLocation!.toJson();
    }
    data['currency_symbol'] = currencySymbol;
    data['currency_symbol_direction'] = currencySymbolDirection;
    data['distance_unit'] = distanceUnit;
    data['app_minimum_version_android'] = appMinimumVersionAndroid;
    data['app_url_android'] = appUrlAndroid;
    data['app_minimum_version_ios'] = appMinimumVersionIos;
    data['app_url_ios'] = appUrlIos;
    data['schedule_order'] = scheduleOrder;
    data['order_delivery_verification'] = orderDeliveryVerification;
    data['cash_on_delivery'] = cashOnDelivery;
    data['digital_payment'] = digitalPayment;
    data['free_delivery_over'] = freeDeliveryOver;
    data['demo'] = demo;
    data['maintenance_mode'] = maintenanceMode;
    data['order_confirmation_model'] = orderConfirmationModel;
    data['show_dm_earning'] = showDmEarning;
    data['canceled_by_deliveryman'] = canceledByDeliveryman;
    data['timeformat'] = timeformat;
    if (language != null) {
      data['language'] = language!.map((v) => v.toJson()).toList();
    }
    data['toggle_veg_non_veg'] = toggleVegNonVeg;
    data['toggle_dm_registration'] = toggleDmRegistration;
    data['toggle_store_registration'] = toggleStoreRegistration;
    data['schedule_order_slot_duration'] = scheduleOrderSlotDuration;
    data['digit_after_decimal_point'] = digitAfterDecimalPoint;
    data['canceled_by_store'] = canceledByStore;
    if (moduleConfig != null) {
      data['module_config'] = moduleConfig!.toJson();
    }
    data['prescription_order_status'] = prescriptionOrderStatus;
    data['dm_picture_upload_status'] = dmPictureUploadStatus;
    data['additional_charge_name'] = additionalChargeName;
    data['disbursement_type'] = disbursementType;
    if (activePaymentMethodList != null) {
      data['active_payment_method_list'] = activePaymentMethodList!
          .map((v) => v.toJson())
          .toList();
    }
    data['min_amount_to_pay_store'] = minAmountToPayStore;
    data['store_review_reply'] = storeReviewReply;
    data['admin_commission'] = adminCommission;
    data['subscription_deadline_warning_days'] =
        subscriptionDeadlineWarningDays;
    data['subscription_deadline_warning_message'] =
        subscriptionDeadlineWarningMessage;
    data['subscription_free_trial_days'] = subscriptionFreeTrialDays;
    data['subscription_free_trial_status'] = subscriptionFreeTrialStatus;
    data['subscription_business_model'] = subscriptionBusinessModel;
    data['commission_business_model'] = commissionBusinessModel;
    data['subscription_free_trial_type'] = subscriptionFreeTrialType;
    data['system_tax_type'] = systemTaxType;
    data['system_tax_include_status'] = systemTaxIncludeStatus;
    data['open_ai_status'] = openAiStatus;
    if (reelsModule != null) {
      data['reels_module'] = reelsModule!.toJson();
    }
    data['validation_config'] = validationConfig;
    if (maintenanceModeData != null) {
      data['maintenance_mode_data'] = maintenanceModeData!.toJson();
    }
    data['store_category_status'] = storeCategoryStatus;
    if (serviceModule != null) {
      data['service_module'] = serviceModule!.toJson();
    }
    data['product_bundle_status'] = productBundleStatus;
    data['product_bundle_module_types'] = productBundleModuleTypes;
    return data;
  }
}

class DefaultLocation {
  String? lat;
  String? lng;

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Language {
  String? key;
  String? value;

  Language({this.key, this.value});

  Language.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}

class ModuleConfig {
  List<String>? moduleType;
  Module? module;

  ModuleConfig({this.moduleType, this.module});

  ModuleConfig.fromJson(Map<String, dynamic> json) {
    moduleType = json['module_type'].cast<String>();
    module = json[moduleType![0]] != null
        ? Module.fromJson(json[moduleType![0]])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_type'] = moduleType;
    if (module != null) {
      data[moduleType![0]] = module!.toJson();
    }
    return data;
  }
}

class Module {
  OrderStatus? orderStatus;
  bool? orderPlaceToScheduleInterval;
  bool? addOn;
  bool? stock;
  bool? vegNonVeg;
  bool? unit;
  bool? orderAttachment;
  bool? alwaysOpen;
  bool? itemAvailableTime;
  bool? showRestaurantText;
  bool? isParcel;
  bool? newVariation;
  String? description;

  Module({
    this.orderStatus,
    this.orderPlaceToScheduleInterval,
    this.addOn,
    this.stock,
    this.vegNonVeg,
    this.unit,
    this.orderAttachment,
    this.alwaysOpen,
    this.itemAvailableTime,
    this.showRestaurantText,
    this.isParcel,
    this.newVariation,
    this.description,
  });

  Module.fromJson(Map<String, dynamic> json) {
    orderStatus = json['order_status'] != null
        ? OrderStatus.fromJson(json['order_status'])
        : null;
    orderPlaceToScheduleInterval = DataParserHelper.parseBool(
      json['order_place_to_schedule_interval'],
    );
    addOn = DataParserHelper.parseBool(json['add_on']);
    stock = DataParserHelper.parseBool(json['stock']);
    vegNonVeg = DataParserHelper.parseBool(json['veg_non_veg']);
    unit = DataParserHelper.parseBool(json['unit']);
    orderAttachment = DataParserHelper.parseBool(json['order_attachment']);
    alwaysOpen = DataParserHelper.parseBool(json['always_open']);
    itemAvailableTime = DataParserHelper.parseBool(json['item_available_time']);
    showRestaurantText = DataParserHelper.parseBool(
      json['show_restaurant_text'],
    );
    isParcel = DataParserHelper.parseBool(json['is_parcel']);
    newVariation = DataParserHelper.parseBool(json['new_variation']);
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderStatus != null) {
      data['order_status'] = orderStatus!.toJson();
    }
    data['order_place_to_schedule_interval'] = orderPlaceToScheduleInterval;
    data['add_on'] = addOn;
    data['stock'] = stock;
    data['veg_non_veg'] = vegNonVeg;
    data['unit'] = unit;
    data['order_attachment'] = orderAttachment;
    data['always_open'] = alwaysOpen;
    data['item_available_time'] = itemAvailableTime;
    data['show_restaurant_text'] = showRestaurantText;
    data['is_parcel'] = isParcel;
    data['new_variation'] = newVariation;
    data['description'] = description;
    return data;
  }
}

class OrderStatus {
  bool? accepted;

  OrderStatus({this.accepted});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    accepted = DataParserHelper.parseBool(json['accepted']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accepted'] = accepted;
    return data;
  }
}

class PaymentBody {
  String? getWay;
  String? getWayTitle;
  String? getWayImageFullUrl;

  PaymentBody({this.getWay, this.getWayTitle, this.getWayImageFullUrl});

  PaymentBody.fromJson(Map<String, dynamic> json) {
    getWay = json['gateway'];
    getWayTitle = json['gateway_title'];
    getWayImageFullUrl = json['gateway_image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gateway'] = getWay;
    data['gateway_title'] = getWayTitle;
    data['gateway_image_full_url'] = getWayImageFullUrl;
    return data;
  }
}

class ReelsModule {
  bool? vendorCanUploadReels;
  int? reelsMaxUploadSizeMb;
  int? reelsMaxDuration;
  String? reelsMaxDurationUnit;

  ReelsModule({
    this.vendorCanUploadReels,
    this.reelsMaxUploadSizeMb,
    this.reelsMaxDuration,
    this.reelsMaxDurationUnit,
  });

  ReelsModule.fromJson(Map<String, dynamic> json) {
    vendorCanUploadReels = DataParserHelper.parseBool(
      json['vendor_can_upload_reels'],
    );
    reelsMaxUploadSizeMb = json['reels_max_upload_size_mb'] != null
        ? int.parse(json['reels_max_upload_size_mb'].toString())
        : null;
    reelsMaxDuration = json['reels_max_duration'] != null
        ? int.parse(json['reels_max_duration'].toString())
        : null;
    reelsMaxDurationUnit = json['reels_max_duration_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor_can_upload_reels'] = vendorCanUploadReels == true ? 1 : 0;
    data['reels_max_upload_size_mb'] = reelsMaxUploadSizeMb;
    data['reels_max_duration'] = reelsMaxDuration;
    data['reels_max_duration_unit'] = reelsMaxDurationUnit;
    return data;
  }
}

class ServiceModule {
  bool? instantBooking;
  bool? repeatBooking;
  bool? scheduleBooking;
  bool? scheduleTimeRestrictionStatus;
  int? scheduleTimeRestrictionValue;
  String? scheduleTimeRestrictionUnit;
  bool? biddingSystem;
  bool? seeOtherProvidersOffers;
  int? postValidationDays;
  bool? otpForCompleteService;
  bool? completePhotoEvidence;
  bool? providerCanCancelBooking;
  bool? providerCanEditBooking;
  bool? providerCanReplyReview;
  bool? providerCategoryStatus;
  bool? serviceGallery;
  bool? accessAllServices;
  bool? servicemanCancelBookingReq;
  bool? atProviderPlace;
  bool? reviewSection;
  ServiceModuleTax? tax;

  ServiceModule({
    this.instantBooking,
    this.repeatBooking,
    this.scheduleBooking,
    this.scheduleTimeRestrictionStatus,
    this.scheduleTimeRestrictionValue,
    this.scheduleTimeRestrictionUnit,
    this.biddingSystem,
    this.seeOtherProvidersOffers,
    this.postValidationDays,
    this.otpForCompleteService,
    this.completePhotoEvidence,
    this.providerCanCancelBooking,
    this.providerCanEditBooking,
    this.providerCanReplyReview,
    this.providerCategoryStatus,
    this.serviceGallery,
    this.accessAllServices,
    this.servicemanCancelBookingReq,
    this.atProviderPlace,
    this.reviewSection,
    this.tax,
  });

  ServiceModule.fromJson(Map<String, dynamic> json) {
    instantBooking = DataParserHelper.parseBool(json['instant_booking']);
    repeatBooking = DataParserHelper.parseBool(json['repeat_booking']);
    scheduleBooking = DataParserHelper.parseBool(json['schedule_booking']);
    scheduleTimeRestrictionStatus = DataParserHelper.parseBool(
      json['schedule_time_restriction_status'],
    );
    scheduleTimeRestrictionValue = json['schedule_time_restriction_value'];
    scheduleTimeRestrictionUnit = json['schedule_time_restriction_unit'];
    biddingSystem = DataParserHelper.parseBool(json['bidding_system']);
    seeOtherProvidersOffers = DataParserHelper.parseBool(
      json['see_other_providers_offers'],
    );
    postValidationDays = json['post_validation_days'];
    otpForCompleteService = DataParserHelper.parseBool(
      json['otp_for_complete_service'],
    );
    completePhotoEvidence = DataParserHelper.parseBool(
      json['complete_photo_evidence'],
    );
    providerCanCancelBooking = DataParserHelper.parseBool(
      json['provider_can_cancel_booking'],
    );
    providerCanEditBooking = DataParserHelper.parseBool(
      json['provider_can_edit_booking'],
    );
    providerCanReplyReview = DataParserHelper.parseBool(
      json['provider_can_reply_review'],
    );
    providerCategoryStatus = DataParserHelper.parseBool(
      json['provider_category_status'],
    );
    serviceGallery = DataParserHelper.parseBool(json['service_gallery']);
    accessAllServices = DataParserHelper.parseBool(json['access_all_services']);
    servicemanCancelBookingReq = DataParserHelper.parseBool(
      json['serviceman_cancel_booking_req'],
    );
    atProviderPlace = DataParserHelper.parseBool(json['at_provider_place']);
    reviewSection = DataParserHelper.parseBool(json['review_section'] ?? true);
    tax = json['tax'] != null ? ServiceModuleTax.fromJson(json['tax']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instant_booking'] = instantBooking;
    data['repeat_booking'] = repeatBooking;
    data['schedule_booking'] = scheduleBooking;
    data['schedule_time_restriction_status'] = scheduleTimeRestrictionStatus;
    data['schedule_time_restriction_value'] = scheduleTimeRestrictionValue;
    data['schedule_time_restriction_unit'] = scheduleTimeRestrictionUnit;
    data['bidding_system'] = biddingSystem;
    data['see_other_providers_offers'] = seeOtherProvidersOffers;
    data['post_validation_days'] = postValidationDays;
    data['otp_for_complete_service'] = otpForCompleteService;
    data['complete_photo_evidence'] = completePhotoEvidence;
    data['provider_can_cancel_booking'] = providerCanCancelBooking;
    data['provider_can_edit_booking'] = providerCanEditBooking;
    data['provider_can_reply_review'] = providerCanReplyReview;
    data['provider_category_status'] = providerCategoryStatus;
    data['service_gallery'] = serviceGallery;
    data['access_all_services'] = accessAllServices;
    data['serviceman_cancel_booking_req'] = servicemanCancelBookingReq;
    data['at_provider_place'] = atProviderPlace;
    data['review_section'] = reviewSection;
    if (tax != null) {
      data['tax'] = tax!.toJson();
    }
    return data;
  }
}

class ServiceModuleTax {
  String? taxType;
  String? taxStatus;
  double? taxPercentage;

  ServiceModuleTax({this.taxType, this.taxStatus, this.taxPercentage});

  ServiceModuleTax.fromJson(Map<String, dynamic> json) {
    taxType = json['tax_type'];
    taxStatus = json['tax_status'];
    taxPercentage = json['tax_percentage'] != null
        ? double.tryParse(json['tax_percentage'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tax_type'] = taxType;
    data['tax_status'] = taxStatus;
    data['tax_percentage'] = taxPercentage;
    return data;
  }
}

class ValidationConfig {
  double productVideoMaxFileSize;
  double maxFileSize;
  int maxUploadFileCount;

  ValidationConfig({
    required this.productVideoMaxFileSize,
    required this.maxFileSize,
    // currently static
    required this.maxUploadFileCount,
  });

  factory ValidationConfig.fromJson(Map<String, dynamic> json) {
    return ValidationConfig(
      productVideoMaxFileSize:
          num.tryParse(
            json['product_video_max_file_size'].toString(),
          )?.toDouble() ??
          20,
      maxFileSize:
          num.tryParse(json['max_file_size'].toString())?.toDouble() ?? 2,
      maxUploadFileCount:
          num.tryParse(json['max_upload_file_count'].toString())?.toInt() ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_video_max_file_size'] = productVideoMaxFileSize;
    data['max_file_size'] = maxFileSize;
    data['max_upload_file_count'] = maxUploadFileCount;
    return data;
  }
}

class MaintenanceModeData {
  List<String>? maintenanceSystemSetup;
  MaintenanceMessageSetup? maintenanceMessageSetup;

  MaintenanceModeData({
    this.maintenanceSystemSetup,
    this.maintenanceMessageSetup,
  });

  MaintenanceModeData.fromJson(Map<String, dynamic> json) {
    maintenanceSystemSetup = json['maintenance_system_setup'].cast<String>();
    maintenanceMessageSetup = json['maintenance_message_setup'] != null
        ? MaintenanceMessageSetup.fromJson(json['maintenance_message_setup'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_system_setup'] = maintenanceSystemSetup;
    if (maintenanceMessageSetup != null) {
      data['maintenance_message_setup'] = maintenanceMessageSetup!.toJson();
    }
    return data;
  }
}

class MaintenanceDurationSetup {
  String? startDate;
  String? endDate;

  MaintenanceDurationSetup({this.startDate, this.endDate});

  MaintenanceDurationSetup.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}

class MaintenanceMessageSetup {
  int? businessNumber;
  int? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessageSetup({
    this.businessNumber,
    this.businessEmail,
    this.maintenanceMessage,
    this.messageBody,
  });

  MaintenanceMessageSetup.fromJson(Map<String, dynamic> json) {
    businessNumber = json['business_number'];
    businessEmail = json['business_email'];
    maintenanceMessage = json['maintenance_message'];
    messageBody = json['message_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_number'] = businessNumber;
    data['business_email'] = businessEmail;
    data['maintenance_message'] = maintenanceMessage;
    data['message_body'] = messageBody;
    return data;
  }
}
