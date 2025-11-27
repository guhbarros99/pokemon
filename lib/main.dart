import 'package:flutter/material.dart';
import 'package:pokemon/services/pokemon_services.dart';
import 'pokemon_page.dart';

class PokedexPage extends StatelessWidget {
  const PokedexPage({super.key});

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
                  width: 50,
                ),
                title: Text(name.toUpperCase()),
                subtitle: Text("ID: $id"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PokemonPage(id: id),
                    ),
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
