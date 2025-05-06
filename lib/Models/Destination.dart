// Model data destinasi gunung
class Destination {
  String image;
  String name;
  String description;
  bool isFavorite; // Menyimpan status favorit

  Destination({
    required this.image,
    required this.name,
    required this.description,
    this.isFavorite = false, // Default favoritnya adalah false
  });
}

// Daftar destinasi gunung yang digunakan di HomeScreen
final List<Destination> destinations = [
  Destination(
    image: 'assets/GunungFuji.png',
    name: 'Gunung Fuji',
    description:
    'Gunung Fuji menjulang gagah dengan bentuk kerucut sempurna, dikelilingi lanskap alam yang memesona. Di latar depan, tampak jalur pendakian Yoshida Trail yang berkelok naik melalui vegetasi rendah...',

  ),
  Destination(
    image: 'assets/GunungMerbabu.png',
    name: 'Gunung Merbabu',
    description:
    'Gunung Merbabu membentang anggun di cakrawala Jawa Tengah, dengan jalur pendakian yang menghampar lewat padang sabana luas...',

  ),
  Destination(
    image: 'assets/GunungPrau.png',
    name: 'Gunung Prau',
    description:
    'Gunung Prau, permata dari Dataran Tinggi Dieng, menyuguhkan pengalaman pendakian yang singkat namun luar biasa...',

  ),
  Destination(
    image: 'assets/GunungSindoro.png',
    name: 'Gunung Sindoro',
    description:
    'Gunung Sindoro berdiri kokoh sebagai raksasa vulkanik di Jawa Tengah, berhadapan langsung dengan Gunung Sumbing...',

  ),
  Destination(
    image: 'assets/GunungBromo.png',
    name: 'Gunung Bromo',
    description:
    'Gunung Bromo berdiri megah di tengah lautan pasir luas, bagian dari Taman Nasional Bromo Tengger Semeru...',

  ),
];
