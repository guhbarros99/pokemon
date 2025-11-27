import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon/model/berry.dart';


Future<Berry> fetchBerry(String idOrName) async {
  final url = Uri.parse('https://pokeapi.co/api/v2/berry/$idOrName');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Berry.fromJson(data);
  } else {
    throw Exception("Erro ao carregar berry: ${response.statusCode}");
  }
}
