import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchPokemonList() async {
  final url = Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=151");

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception("Erro ao carregar Pokédex");
  }

  final data = jsonDecode(response.body);
  final List results = data["results"];

  // adiciona id baseado na URL
  return results.asMap().entries.map((entry) {
    final index = entry.key + 1;
    return {
      "id": index,
      "name": entry.value["name"],
      "url": entry.value["url"],
    };
  }).toList();
}

Future<Map<String, dynamic>> fetchPokemon(int id) async {
  final url = Uri.parse("https://pokeapi.co/api/v2/pokemon/$id");

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception("Erro ao carregar Pokémon");
  }

  return jsonDecode(response.body);
}
