import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';

Future<bool> isOrderHasBeenCancelled({
  required String orderId,
  required int orderType,
}) async {
  var orderRideRepository = OrderRideRepository();
  var orderDetail = await orderRideRepository.getOrderRideDetailbyOrderId(
    orderType: orderType,
    orderId: orderId,
  );
  return orderDetail.state == 10;
}
