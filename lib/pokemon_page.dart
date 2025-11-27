import 'package:flutter/material.dart';
import 'package:pokemon/services/pokemon_services.dart';

class PokemonPage extends StatelessWidget {
  final int id;

  const PokemonPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pokémon #$id")),
      body: FutureBuilder(
        future: fetchPokemon(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final pokemon = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  pokemon["sprites"]["front_default"],
                  width: 150,
                ),
                const SizedBox(height: 20),
                Text(
                  pokemon["name"].toUpperCase(),
                  style: const TextStyle(fontSize: 26),
                ),
                const SizedBox(height: 10),
                Text("Altura: ${pokemon["height"]}"),
                Text("Peso: ${pokemon["weight"]}"),
                const SizedBox(height: 20),
                Text(
                  "Tipos:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children: pokemon["types"]
                      .map<Widget>((t) => Chip(label: Text(t["type"]["name"])))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
