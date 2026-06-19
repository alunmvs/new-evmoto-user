class AdvancedBookingState {
  /// PENDING — UX: Menunggu
  /// Booking dibuat oleh user, belum didistribusikan ke driver
  static const int PENDING = 0;

  /// DISTRIBUTING — UX: Menunggu
  /// Spawned order sudah dibuat di t_order_private_car, sedang mencari driver di Order Hall
  static const int DISTRIBUTING = 1;

  /// DRIVER_FOUND — UX: Menunggu
  /// Driver sudah grab spawned order, trip belum mulai
  static const int DRIVER_FOUND = 2;

  /// ONGOING — UX: Dalam Pesanan
  /// Driver mulai perjalanan (spawned order state 3/4/5)
  static const int ONGOING = 3;

  /// COMPLETED — UX: Selesai
  /// Trip selesai (spawned order state 8/9)
  static const int COMPLETED = 4;

  /// CANCELLED — UX: Dibatalkan
  /// Dibatalkan oleh user
  static const int CANCELLED = 5;

  /// EXPIRED — UX: Dibatalkan
  /// Tidak ada driver yang menerima hingga T-15 menit sebelum pickup
  static const int EXPIRED = 6;

  static const List<int> WAITING_STATE_LIST = [
    AdvancedBookingState.PENDING,
    AdvancedBookingState.DISTRIBUTING,
    AdvancedBookingState.DRIVER_FOUND,
  ];

  static const List<int> ACTIVE_STATE_LIST = [
    AdvancedBookingState.PENDING,
    AdvancedBookingState.DISTRIBUTING,
    AdvancedBookingState.DRIVER_FOUND,
    AdvancedBookingState.ONGOING,
  ];

  static const List<int> COMPLETED_STATE_LIST = [
    AdvancedBookingState.COMPLETED,
  ];

  static const List<int> CANCELLED_STATE_LIST = [
    AdvancedBookingState.CANCELLED,
    AdvancedBookingState.EXPIRED,
  ];
}
