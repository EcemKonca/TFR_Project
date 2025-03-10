class OrderModel {
  final String orderNumber;
  final String deliveryDate;
  final String restaurantName;
  final String restaurantAddress;

  OrderModel({
    required this.orderNumber,
    required this.deliveryDate,
    required this.restaurantName,
    required this.restaurantAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // In the API response, the order information comes in "populated_order"
    final orderData = json['populated_order'] ?? {};
    final restaurantData = orderData['populated_restaurant'] ?? {};

    return OrderModel(
      orderNumber: orderData['order_number']?.toString() ?? "Unknown",
      deliveryDate: orderData['deliver_date']?.toString() ?? "Unknown",
      restaurantName: restaurantData['name']?.toString() ?? "Unknown",
      restaurantAddress: restaurantData['address']?.toString() ?? "Unknown",
    );
  }
}