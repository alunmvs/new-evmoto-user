class OpenMapDirection {
  String? code;
  List<Routes>? routes;
  List<Waypoints>? waypoints;

  OpenMapDirection({this.code, this.routes, this.waypoints});

  OpenMapDirection.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(new Routes.fromJson(v));
      });
    }
    if (json['waypoints'] != null) {
      waypoints = <Waypoints>[];
      json['waypoints'].forEach((v) {
        waypoints!.add(new Waypoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.routes != null) {
      data['routes'] = this.routes!.map((v) => v.toJson()).toList();
    }
    if (this.waypoints != null) {
      data['waypoints'] = this.waypoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Routes {
  List<Legs>? legs;
  String? weightName;
  Geometry? geometry;
  double? weight;
  double? duration;
  double? distance;

  Routes({
    this.legs,
    this.weightName,
    this.geometry,
    this.weight,
    this.duration,
    this.distance,
  });

  Routes.fromJson(Map<String, dynamic> json) {
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add(new Legs.fromJson(v));
      });
    }
    weightName = json['weight_name'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    weight = json['weight'];
    duration = double.tryParse(json['duration'].toString());
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.legs != null) {
      data['legs'] = this.legs!.map((v) => v.toJson()).toList();
    }
    data['weight_name'] = this.weightName;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    return data;
  }
}

class Legs {
  double? weight;
  String? summary;
  double? duration;
  double? distance;

  Legs({this.weight, this.summary, this.duration, this.distance});

  Legs.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    summary = json['summary'];
    duration = double.tryParse(json['duration'].toString());
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight'] = this.weight;
    data['summary'] = this.summary;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    return data;
  }
}

class Geometry {
  List? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Waypoints {
  String? hint;
  List<double>? location;
  String? name;
  double? distance;

  Waypoints({this.hint, this.location, this.name, this.distance});

  Waypoints.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    location = json['location'].cast<double>();
    name = json['name'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['location'] = this.location;
    data['name'] = this.name;
    data['distance'] = this.distance;
    return data;
  }
}
