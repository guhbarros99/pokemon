import 'package:flutter/material.dart';
import 'package:pokemon/services/berry_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon',
      home: const BerryPage(berryId: "1"),
    );
  }
}

class BerryPage extends StatelessWidget {
  final String berryId;

  const BerryPage({required this.berryId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Berry: $berryId")),
      body: FutureBuilder(
        future: fetchBerry(berryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final berry = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome: ${berry.name}", style: TextStyle(fontSize: 22)),
                SizedBox(height: 8),
                Text("ID: ${berry.id}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text(
                  "Tempo de crescimento: ${berry.growthTime}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
