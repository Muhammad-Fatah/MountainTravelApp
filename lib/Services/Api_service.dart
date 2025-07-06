import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mounttravel/Models/Destination.dart';

class ApiService {
  static const String url = 'https://mountain-api1.p.rapidapi.com/api/mountains';

  static Future<List<Destination>> fetchDestinations() async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-RapidAPI-Key': 'd8ca191bcemsh4dc5e0738514493p145d40jsn4ced6472d2a1',
        'X-RapidAPI-Host': 'mountain-api1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((json) => Destination(
        name: json['name'] ?? 'Unknown',
        description: json['description'] ?? 'Tidak ada deskripsi',
        image: json['mountain_img'] ?? '',
        altitude: json['altitude'] ?? 'Unknown',
      )).toList();

    } else {
      print("Status code: ${response.statusCode}");
      throw Exception('Gagal mengambil data dari API: ${response.statusCode}');
    }
  }
}
