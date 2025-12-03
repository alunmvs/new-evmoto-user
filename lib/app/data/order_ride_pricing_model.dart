class OrderRidePricing {
  int? id;
  String? name;
  String? img;
  int? amount;
  int? price;
  double? mileage;
  int? duration;
  int? discountMoney;
  int? type;

  OrderRidePricing({
    this.id,
    this.name,
    this.img,
    this.amount,
    this.price,
    this.mileage,
    this.duration,
    this.discountMoney,
    this.type,
  });

  OrderRidePricing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    amount = json['amount'];
    price = json['price'];
    mileage = json['mileage'];
    duration = json['duration'];
    discountMoney = json['discountMoney'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['mileage'] = this.mileage;
    data['duration'] = this.duration;
    data['discountMoney'] = this.discountMoney;
    data['type'] = this.type;
    return data;
  }
}
