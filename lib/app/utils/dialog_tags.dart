/// Stable identifiers for every app dialog.
///
/// Always pass one of these tags to [DialogHelper.show] and close the same
/// dialog with [DialogHelper.dismiss] using the matching tag.
class DialogTags {
  DialogTags._();

  static const loading = 'dialog.loading';

  static const serviceTimeValidation = 'dialog.service_time_validation';

  static const appVersionNewest = 'dialog.app_version_newest';
  static const appVersionUpdate = 'dialog.app_version_update';
  static const appSoftUpdate = 'dialog.app_soft_update';
  static const appForceUpdate = 'dialog.app_force_update';

  static const locationPermission = 'dialog.location_permission';

  static const cancelOrderBeforeDriver = 'dialog.cancel_order_before_driver';
  static const advancedBookingCancel = 'dialog.advanced_booking_cancel';
  static const advancedBookingExpired = 'dialog.advanced_booking_expired';
  static const driverCancel = 'dialog.driver_cancel';

  static const outsideServiceArea = 'dialog.outside_service_area';

  static const logoutConfirmation = 'dialog.logout_confirmation';
  static const accountDeletedSuccess = 'dialog.account_deleted_success';

  static const deleteAddressConfirmation = 'dialog.delete_address_confirmation';
}
