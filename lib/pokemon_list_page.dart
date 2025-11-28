import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> pokedex = [];
  bool isLoading = false;
  String errorMessage = "";
  Future<void> fetchPokemon(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon/$query");

    try {
      final response = await http.get(
        url,
        headers: {"User-Agent": "poke-app"}, // evita bloqueios
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          pokedex.add({
            "name": data["name"],
            "id": data["id"],
            "sprite": data["sprites"]["front_default"],
          });
        });
      } else {
        setState(() {
          errorMessage = "Pokémon não encontrado!";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Erro: $e";
        print("ERRO REAL: $e");
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void removePokemon(int index) {
    setState(() {
      pokedex.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokédex"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CAMPO DE PESQUISA
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Digite o nome ou ID do Pokémon",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_controller.text.isNotEmpty) {
                            fetchPokemon(_controller.text.toLowerCase());
                            _controller.clear();
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Add"),
                ),
              ],
            ),

            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 20),

            // LISTA DOS POKEMONS ADICIONADOS
            Expanded(
              child: ListView.builder(
                itemCount: pokedex.length,
                itemBuilder: (context, index) {
                  final pokemon = pokedex[index];

                  return ListTile(
                    leading: pokemon["sprite"] != null
                        ? Image.network(pokemon["sprite"])
                        : null,
                    title: Text(pokemon["name"]),
                    subtitle: Text("ID: ${pokemon['id']}"),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removePokemon(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
