import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PokedexLocal {
  static const String key = "my_pokedex";

  // Obter lista salva
  static Future<List<int>> getMyPokedex() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    return List<int>.from(jsonDecode(data));
  }

  // Adicionar Pokémon
  static Future<void> addPokemon(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getMyPokedex();
    
    if (!list.contains(id)) {
      list.add(id);
      await prefs.setString(key, jsonEncode(list));
    }
  }

  // Remover Pokémon
  static Future<void> removePokemon(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getMyPokedex();
    
    list.remove(id);
    await prefs.setString(key, jsonEncode(list));
  }
}
