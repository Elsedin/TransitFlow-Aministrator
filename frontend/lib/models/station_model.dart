class Station {
  final int id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int cityId;
  final String cityName;
  final int zoneId;
  final String zoneName;
  final bool isActive;

  Station({
    required this.id,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    required this.cityId,
    required this.cityName,
    required this.zoneId,
    required this.zoneName,
    required this.isActive,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      cityId: json['cityId'] as int,
      cityName: json['cityName'] as String,
      zoneId: json['zoneId'] as int,
      zoneName: json['zoneName'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}

class CreateStationRequest {
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int cityId;
  final int zoneId;

  CreateStationRequest({
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    required this.cityId,
    required this.zoneId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'cityId': cityId,
      'zoneId': zoneId,
    };
  }
}

class UpdateStationRequest {
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int cityId;
  final int zoneId;
  final bool isActive;

  UpdateStationRequest({
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    required this.cityId,
    required this.zoneId,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'cityId': cityId,
      'zoneId': zoneId,
      'isActive': isActive,
    };
  }
}

class City {
  final int id;
  final String name;
  final String? postalCode;
  final int? countryId;
  final String countryName;
  final bool isActive;

  City({
    required this.id,
    required this.name,
    this.postalCode,
    this.countryId,
    required this.countryName,
    required this.isActive,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      name: json['name'] as String,
      postalCode: json['postalCode'] as String?,
      countryId: json['countryId'] as int?,
      countryName: json['countryName'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}

class Zone {
  final int id;
  final String name;
  final String? description;
  final bool isActive;

  Zone({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool,
    );
  }
}
