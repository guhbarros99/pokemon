import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokédex")),
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
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    if (myPokedex.contains(id)) {
                      await PokedexLocal.removePokemon(id);
                    } else {
                      await PokedexLocal.addPokemon(id);
                    }

                    await loadMyPokedex(); // atualiza a tela
                  },
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
