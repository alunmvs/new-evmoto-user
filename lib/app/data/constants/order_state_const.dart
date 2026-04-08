class OrderState {
  static const int LOOKING_FOR_DRIVER = 1;
  static const int DRIVER_ACCEPT_ORDER = 2;
  static const int DRIVER_PICK_UP_PASSENGER = 3;
  static const int DRIVER_ARRIVED_ORIGIN = 4;
  static const int DRIVER_ON_GOING_DESTINATION = 5;
  static const int DRIVER_ARRIVED_DESTINATION = 6;
  static const int DRIVER_SEND_INVOICE = 7;
  static const int WAITING_RATING_EVALUATION = 8;
  static const int ORDER_COMPLETED = 9;
  static const int ORDER_CANCELLED = 10;
  static const int REASSIGN_ANOTHER_DRIVER = 11;
  static const int WAITING_FOR_CANCELLATION_PAYMENT = 12;
  static const List<int> ACTIVE_STATE_LIST = [
    OrderState.LOOKING_FOR_DRIVER,
    OrderState.DRIVER_ACCEPT_ORDER,
    OrderState.DRIVER_PICK_UP_PASSENGER,
    OrderState.DRIVER_ARRIVED_ORIGIN,
    OrderState.DRIVER_ON_GOING_DESTINATION,
    OrderState.DRIVER_ARRIVED_DESTINATION,
    OrderState.DRIVER_SEND_INVOICE,
    OrderState.REASSIGN_ANOTHER_DRIVER,
  ];
  static const List<int> COMPLETED_STATE_LIST = [
    OrderState.WAITING_RATING_EVALUATION,
    OrderState.ORDER_COMPLETED,
    OrderState.ORDER_CANCELLED,
    OrderState.WAITING_FOR_CANCELLATION_PAYMENT,
  ];
  static const List<int> CANCELLED_STATE_LIST = [
    OrderState.ORDER_CANCELLED,
    OrderState.WAITING_FOR_CANCELLATION_PAYMENT,
  ];
}
