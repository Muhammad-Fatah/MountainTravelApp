class Destination {
  String image;
  String name;
  String description;
  String altitude;
  bool isFavorite;

  Destination({
    required this.image,
    required this.name,
    required this.description,
    required this.altitude,
    this.isFavorite = false,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'Tidak ada deskripsi',
      image: json['mountain_img'] ?? '',
      altitude: json['altitude'] ?? 'Unknown',
    );
  }
}
