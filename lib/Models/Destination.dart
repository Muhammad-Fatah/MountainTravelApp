class Destination {
  String image;
  String name;
  String description;

  Destination({
    required this.image,
    required this.name,
    required this.description,
  });
}

final List<Destination> destinations = [
  Destination(
      image: 'assets/GunungFuji.png',
      name: 'Gunung Fuji',
      description:
      'Gunung Fuji menjulang gagah dengan bentuk kerucut sempurna, dikelilingi lanskap alam yang memesona. Di latar depan, tampak jalur pendakian Yoshida Trail yang berkelok naik melalui vegetasi rendah, lengkap dengan penanda jalur dan shelter pendaki. Semakin ke atas, pepohonan menghilang dan berganti dengan medan berbatu vulkanik yang berwarna kemerahan. Di beberapa titik, terlihat pendaki dengan headlamp berjalan pelan, menikmati udara dingin dan langit bertabur bintang, menanti momen sunrise dari puncak.'),
  Destination(
      image: 'assets/GunungMerbabu.png',
      name: 'Gunung Merbabu',
      description:
      'Gunung Merbabu membentang anggun di cakrawala Jawa Tengah, dengan jalur pendakian yang menghampar lewat padang sabana luas, lereng hijau, dan punggungan yang menantang. Di sepanjang jalur Selo, terlihat hamparan rumput yang bergoyang tertiup angin, dengan bunga edelweiss bermekaran di beberapa titik. Pendaki dapat melihat siluet Gunung Merapi yang aktif berdiri gagah di kejauhan, menambah dramatisnya lanskap.'),
  Destination(
      image: 'assets/GunungPrau.png',
      name: 'Gunung Prau',
      description:
      'Gunung Prau, permata dari Dataran Tinggi Dieng, menyuguhkan pengalaman pendakian yang singkat namun luar biasa. Di jalur pendakian seperti Patak Banteng, jalan setapak menanjak melalui ladang warga dan hutan pinus sebelum membuka ke hamparan bukit rumput yang luas. Langit malam di puncak Prau bertabur bintang, sementara tenda-tenda berwarna-warni berjejer rapi di padang terbuka.'),
  Destination(
      image: 'assets/GunungSindoro.png',
      name: 'Gunung Sindoro',
      description:
      'Gunung Sindoro berdiri kokoh sebagai raksasa vulkanik di Jawa Tengah, berhadapan langsung dengan Gunung Sumbing. Dari kejauhan, bentuknya tampak kerucut sempurna, diselimuti kabut tipis dan hembusan asap dari kawah aktif di puncaknya. Jalur pendakian populer seperti Kledung dan Tambi menawarkan trek menanjak melalui hutan pinus, ladang warga, hingga padang rumput terbuka dengan panorama pegunungan sekeliling.'),
  Destination(
      image: 'assets/GunungBromo.png',
      name: 'Gunung Bromo',
      description:
      'Gunung Bromo berdiri megah di tengah lautan pasir luas, bagian dari Taman Nasional Bromo Tengger Semeru. Pemandangan ikonik terlihat dari atas Penanjakan: kabut tipis menyelimuti lautan pasir, dengan siluet Bromo yang mengeluarkan asap putih dari kawah aktifnya, dikelilingi Gunung Batok yang berbentuk seperti kubah, serta Gunung Semeru menjulang di kejauhan dengan puncaknya menyemburkan asap tipis.'),
];
