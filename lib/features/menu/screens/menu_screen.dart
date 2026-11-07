import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fasta_deliveries_store/features/auth/domain/models/module_permission_model.dart';
import 'package:fasta_deliveries_store/features/menu/domain/models/menu_model.dart';
import 'package:fasta_deliveries_store/features/menu/widgets/menu_button_widget.dart';
import 'package:fasta_deliveries_store/features/profile/controllers/profile_controller.dart';
import 'package:fasta_deliveries_store/features/profile/domain/models/profile_model.dart';
import 'package:fasta_deliveries_store/features/splash/controllers/splash_controller.dart';
import 'package:fasta_deliveries_store/helper/responsive_helper.dart';
import 'package:fasta_deliveries_store/features/bundle_item/controllers/bundle_item_controller.dart';
import 'package:fasta_deliveries_store/helper/route_helper.dart';
import 'package:fasta_deliveries_store/util/app_constants.dart';
import 'package:fasta_deliveries_store/util/dimensions.dart';
import 'package:fasta_deliveries_store/util/images.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Store? store = Get.find<ProfileController>().profileModel?.stores;
    ModulePermissionModel? modulePermission =
        Get.find<ProfileController>().modulePermission;

    final List<MenuModel> menuList = [];

    menuList.add(
      MenuModel(
        icon: '',
        title: 'edit_profile'.tr,
        route: RouteHelper.getUpdateProfileRoute(),
      ),
    );

    if (modulePermission!.item!) {
      menuList.add(
        MenuModel(
          icon: Images.addFood,
          title: 'all_items'.tr,
          route: RouteHelper.getAllItemsRoute(),
          isBlocked: !store!.itemSection!,
        ),
      );
    }

    if (modulePermission.item!) {
      menuList.add(
        MenuModel(
          icon: Images.pendingItemIcon,
          title: 'pending_item'.tr,
          route: RouteHelper.getPendingItemRoute(),
        ),
      );
    }

    if (modulePermission.storeSetup!) {
      menuList.add(
        MenuModel(
          icon: Images.settingIcon,
          title:
              Get.find<SplashController>()
                  .configModel!
                  .moduleConfig!
                  .module!
                  .showRestaurantText!
              ? 'restaurant_config'.tr
              : 'store_config'.tr,
          route: RouteHelper.getStoreSettingsRoute(store!),
        ),
      );
    }

    if (modulePermission.category!) {
      menuList.add(
        MenuModel(
          icon: Images.categories,
          title: 'categories'.tr,
          route: RouteHelper.getCategoriesRoute(),
        ),
      );
    }

    if (modulePermission.banner!) {
      menuList.add(
        MenuModel(
          icon: Images.bannerIcon,
          title: 'banner'.tr,
          route: RouteHelper.getBannerListRoute(),
        ),
      );
    }

    if (modulePermission.advertisementList!) {
      menuList.add(
        MenuModel(
          icon: Images.adsMenu,
          title: 'advertisements'.tr,
          route: RouteHelper.getAdvertisementListRoute(),
        ),
      );
    }

    if (modulePermission.campaign!) {
      menuList.add(
        MenuModel(
          icon: Images.campaign,
          title: 'campaign'.tr,
          route: RouteHelper.getCampaignRoute(),
        ),
      );
    }

    /// Happy hour is a discount window over the whole store, which only means
    /// something where customers buy items. Service bookings and rental trips
    /// are priced per booking, so the entry is hidden for those modules.
    final String? moduleType = store?.module?.moduleType;
    final bool supportsOfferCampaigns =
        moduleType != null &&
        moduleType != 'rental' &&
        moduleType != AppConstants.service;

    if (supportsOfferCampaigns) {
      menuList.add(
        MenuModel(
          icon: Images.bogo,
          title: 'bogo_offer'.tr,
          route: RouteHelper.getBogoOfferRoute(),
        ),
      );
      menuList.add(
        MenuModel(
          icon: Images.happyHour,
          iconColor: Colors.white,
          title: 'happy_hour'.tr,
          route: RouteHelper.getHappyHourRoute(),
        ),
      );
    }

    // supportedModuleTypes is the structural constraint (a bundle needs per-line
    // pricing, so parcel/rental/ride-share can never have one); the config flags
    // are the admin's separate on/off switch on top of that.
    final bool bundleFeatureEnabled =
        moduleType != null &&
        BundleItemController.supportedModuleTypes.contains(moduleType) &&
        (Get.find<SplashController>().configModel!.productBundleStatus ??
            false) &&
        (Get.find<SplashController>().configModel!.productBundleModuleTypes
                ?.contains(moduleType) ??
            false);
    if (bundleFeatureEnabled) {
      menuList.add(
        MenuModel(
          icon: Images.bundleIcon,
          iconColor: Colors.white,
          title: 'bundle_item'.tr,
          route: RouteHelper.getBundlePackageListRoute(),
        ),
      );
    }

    if (modulePermission.deliveryman! || modulePermission.deliverymanList!) {
      if (store?.selfDeliverySystem == 1 &&
          store?.storeBusinessModel != 'subscription') {
        menuList.add(
          MenuModel(
            icon: Images.deliveryMan,
            iconColor: Colors.white,
            title: 'delivery_man'.tr,
            route: RouteHelper.getDeliveryManRoute(),
          ),
        );
      } else if (store?.selfDeliverySystem == 1 &&
          store?.storeBusinessModel == 'subscription' &&
          (Get.find<ProfileController>()
                  .profileModel!
                  .subscription!
                  .selfDelivery ==
              1)) {
        menuList.add(
          MenuModel(
            icon: Images.deliveryMan,
            iconColor: Colors.white,
            title: 'delivery_man'.tr,
            route: RouteHelper.getDeliveryManRoute(),
            isNotSubscribe:
                store?.storeBusinessModel == 'subscription' &&
                Get.find<ProfileController>()
                        .profileModel!
                        .subscription!
                        .selfDelivery ==
                    0,
          ),
        );
      }
    }

    if (store?.module!.moduleType != 'food') {
      menuList.add(
        MenuModel(
          icon: Images.warning,
          iconColor: Colors.white,
          title: 'low_stock'.tr,
          route: RouteHelper.getLowStockRoute(),
        ),
      );
    }

    if (modulePermission.reviews!) {
      menuList.add(
        MenuModel(
          icon: Images.review,
          title: 'reviews'.tr,
          route: RouteHelper.getCustomerReviewRoute(),
          isNotSubscribe:
              store?.storeBusinessModel == 'subscription' &&
              Get.find<ProfileController>()
                      .profileModel!
                      .subscription!
                      .review ==
                  0,
        ),
      );
    }

    if (modulePermission.businessPlan!) {
      menuList.add(
        MenuModel(
          icon: Images.mySubscriptionIcon,
          title: 'my_business_plan'.tr,
          route: RouteHelper.getMySubscriptionRoute(),
        ),
      );
    }

    if (store?.module!.moduleType == 'food' && modulePermission.addon!) {
      menuList.add(
        MenuModel(
          icon: Images.addon,
          title: 'addons'.tr,
          route: RouteHelper.getAddonsRoute(),
        ),
      );
    }

    if (modulePermission.chat!) {
      menuList.add(
        MenuModel(
          icon: Images.chat,
          title: 'conversation'.tr,
          route: RouteHelper.getConversationListRoute(),
          isNotSubscribe:
              (store?.storeBusinessModel == 'subscription' &&
              Get.find<ProfileController>().profileModel!.subscription!.chat ==
                  0),
        ),
      );
    }

    if (modulePermission.reels! &&
        Get.find<SplashController>()
                .configModel!
                .reelsModule
                ?.vendorCanUploadReels ==
            true) {
      menuList.add(
        MenuModel(
          icon: Images.reels,
          title: 'reels'.tr,
          route: RouteHelper.getReelsRoute(),
        ),
      );
    }
    menuList.add(
      MenuModel(
        icon: Images.language,
        title: 'language'.tr,
        route: '',
        isLanguage: true,
      ),
    );

    if (modulePermission.coupon!) {
      menuList.add(
        MenuModel(
          icon: Images.coupon,
          title: 'coupon'.tr,
          route: RouteHelper.getCouponRoute(),
        ),
      );
    }

    if (modulePermission.expenseReport! || modulePermission.vatReport!) {
      menuList.add(
        MenuModel(
          icon: Images.expense,
          title: 'reports'.tr,
          route: RouteHelper.getReportsRoute(),
        ),
      );
    }

    if (modulePermission.disbursementReport! ||
        modulePermission.walletMethod!) {
      if (Get.find<SplashController>().configModel!.disbursementType ==
          'automated') {
        menuList.add(
          MenuModel(
            icon: Images.disbursementIcon,
            title: 'disbursement'.tr,
            route: RouteHelper.getDisbursementMenuRoute(),
          ),
        );
      }
    }
    menuList.add(
      MenuModel(
        icon: Images.settingIcon,
        title: 'settings'.tr,
        route: RouteHelper.getSettingRoute(),
      ),
    );

    menuList.add(
      MenuModel(
        icon: Images.policy,
        title: 'privacy_policy'.tr,
        route: RouteHelper.getPrivacyRoute(),
      ),
    );
    menuList.add(
      MenuModel(
        icon: Images.terms,
        title: 'terms_condition'.tr,
        route: RouteHelper.getTermsRoute(),
      ),
    );
    menuList.add(MenuModel(icon: Images.logOut, title: 'logout'.tr, route: ''));

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Dimensions.radiusExtraLarge),
        ),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: ResponsiveHelper.isTab(context)
                  ? 1 / 1.5
                  : (1 / 1.22),
              crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
              mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
            ),
            itemCount: menuList.length,
            itemBuilder: (context, index) {
              return MenuButtonWidget(
                menu: menuList[index],
                isProfile: index == 0,
                isLogout: index == menuList.length - 1,
              );
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    );
  }
}
