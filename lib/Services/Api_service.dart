import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mounttravel/Models/Destination.dart';

class ApiService {
  static const String url = 'https://mountain-api1.p.rapidapi.com/api/mountains';

  static Future<List<Destination>> fetchDestinations() async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-RapidAPI-Key': '8f1b817305mshc40981d2f9f4ccep11763fjsnf4ccad2c8d13',
        'X-RapidAPI-Host': 'mountain-api1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((json) => Destination(
        name: json['name'] ?? 'Unknown',
        description: json['description'] ?? 'Tidak ada deskripsi',
        image: 'https://upload.wikimedia.org/wikipedia/commons/6/62/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg', // placeholder gambar
      )).toList();
    } else {
      print("Status code: ${response.statusCode}");
      throw Exception('Gagal mengambil data dari API: ${response.statusCode}');
    }
  }
}
