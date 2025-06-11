class Destination {
  String image;
  String name;
  String description;
  bool isFavorite;

  Destination({
    required this.image,
    required this.name,
    required this.description,
    this.isFavorite = false,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] ?? 'Unknown',
      description: json['location'] ?? 'No description',
      image: json['mountain_img'] ?? 'https://example.com/default.jpg',

    );
  }
}
