import 'package:flutter/material.dart';
import 'package:pokemon/pokedex_local.dart';
import 'package:pokemon/services/pokemon_services.dart';
import 'pokemon_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<int> myPokedex = [];
  List<Map<String, dynamic>> allPokemons = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    myPokedex = await PokedexLocal.getMyPokedex();
    allPokemons = await fetchPokemonList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favoritePokemons = allPokemons
        .where((p) => myPokedex.contains(p["id"]))
        .toList();

    if (favoritePokemons.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Voltar"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.yellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Center(child: Text("Nenhum Pokémon favoritado ainda!")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Favoritos"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: favoritePokemons.length,
        itemBuilder: (context, index) {
          final pokemon = favoritePokemons[index];
          final id = pokemon["id"];

          return ListTile(
            leading: Image.network(
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
              width: 80,
            ),
            title: Text(pokemon["name"].toUpperCase()),
            subtitle: Text("ID: $id"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PokemonPage(id: id)),
              );
            },
          );
        },
      ),
    );
  }
}
