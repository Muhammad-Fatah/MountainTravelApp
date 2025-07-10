// Merepresentasikan model data untuk sebuah destinasi wisata.
class Destination {
  String image;
  String name;
  String description;
  String altitude;

  Destination({
    required this.image,
    required this.name,
    required this.description,
    required this.altitude,
  });

  // Factory constructor untuk membuat instance [Destination] dari data JSON.
  // Menangani kemungkinan nilai null dari API dengan memberikan nilai default.
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'Tidak ada deskripsi',
      image: json['mountain_img'] ?? '',
      altitude: json['altitude'] ?? 'Unknown',
    );
  }
}