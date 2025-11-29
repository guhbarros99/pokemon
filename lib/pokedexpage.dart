import 'package:flutter/material.dart';
import 'package:pokemon/favorites_pages.dart';
import 'package:pokemon/pokedex_local.dart';
import 'package:pokemon/services/pokemon_services.dart';
import 'pokemon_page.dart';

// Adicione esta função main
void main() {
  runApp(
    const MaterialApp(home: PokedexPage(), debugShowCheckedModeBanner: false),
  );
}

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  List<int> myPokedex = [];

  @override
  void initState() {
    super.initState();
    loadMyPokedex();
  }

  Future<void> loadMyPokedex() async {
    myPokedex = await PokedexLocal.getMyPokedex();
    setState(() {});
  }

  Future<void> toggleFavorite(int id) async {
    if (myPokedex.contains(id)) {
      await PokedexLocal.removePokemon(id);
    } else {
      await PokedexLocal.addPokemon(id);
    }

    await loadMyPokedex(); // atualiza a lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 150, 3, 3),
      appBar: AppBar(
        title: const Text("Pokémon", style: TextStyle(color: Colors.white),  ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 255, 0, 0),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ],
        flexibleSpace: Container(color: Color(0xFF1A1A1A),),
      ),
      body: FutureBuilder(
        future: fetchPokemonList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final pokemons = snapshot.data!;

          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              final id = pokemon["id"];
              final name = pokemon["name"];

              return ListTile(
                leading: Image.network(
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
                  width: 100,
                ),
                title: Text(name.toUpperCase()),
                subtitle: Text("ID: $id"),
                trailing: IconButton(
                  icon: Icon(
                    myPokedex.contains(id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.black,
                  ),
                  onPressed: () => toggleFavorite(id),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PokemonPage(id: id)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
