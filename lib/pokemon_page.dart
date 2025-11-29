import 'package:flutter/material.dart';
import 'package:pokemon/services/pokemon_services.dart';

class PokemonPage extends StatelessWidget {
  final int id;

  const PokemonPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 150, 3, 3),
      appBar: AppBar(title: Text("Pokémon #$id", style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))), flexibleSpace: Container( color: const  Color(0xFFC62828),),),
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
                Container(
                  height: 300,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    pokemon["sprites"]["front_default"],
                    height: 200,
                  ),
                ),

                const SizedBox(height: 10),
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
