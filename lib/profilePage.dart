import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // carrega o usuário corretamente
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setState(() => isLoading = true);

    final ref = FirebaseStorage.instance
        .ref()
        .child("profile_pictures/${user!.uid}.jpg");

    await ref.putFile(File(file.path));
    final url = await ref.getDownloadURL();

    await user!.updatePhotoURL(url);
    await user!.reload();

    setState(() {
      user = FirebaseAuth.instance.currentUser;
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Meu Perfil", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[800],
              backgroundImage:
                  (user != null && user!.photoURL != null)
                      ? NetworkImage(user!.photoURL!)
                      : null,
              child: (user == null || user!.photoURL == null)
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: isLoading ? null : _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("Trocar Foto"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text("Sair da Conta"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
