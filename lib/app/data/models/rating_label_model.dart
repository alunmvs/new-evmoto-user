class RatingLabel {
  int? id;
  String? value;
  bool? isSelected;

  RatingLabel({this.value, this.isSelected});

  RatingLabel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['is_selected'] = this.isSelected;
    return data;
  }
}
