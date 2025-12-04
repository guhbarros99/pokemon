import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokemon/pokedexpage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  bool _isLogin = true; // alterna entre login e cadastro

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // LOGIN
  Future<void> _loginFirebase() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PokedexPage()),
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Erro no login");
    }
  }

  // CADASTRO
  Future<void> _cadastroFirebase() async {
    if (_senhaController.text.length < 6) {
      _showMessage("A senha precisa ter no mínimo 6 caracteres.");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      _showMessage("Conta criada com sucesso! Faça login.");

      setState(() {
        _isLogin = true;
        _senhaController.clear();
      });

    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Erro ao cadastrar");
    }
  }

  // ESQUECI A SENHA
  Future<void> _resetSenha() async {
    if (_emailController.text.isEmpty) {
      _showMessage("Digite seu email para recuperar a senha.");
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      _showMessage("Email de recuperação enviado!");
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Erro ao enviar email");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.catching_pokemon, size: 180, color: Colors.redAccent),
              const SizedBox(height: 50),

              // EMAIL
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // SENHA
              TextField(
                controller: _senhaController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // BOTÃO PRINCIPAL (Login ou Cadastro)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                ),
                onPressed: _isLogin ? _loginFirebase : _cadastroFirebase,
                child: Text(
                  _isLogin ? "ENTRAR" : "CADASTRAR",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 12),

              // ESQUECI A SENHA (aparece só no modo Login)
              if (_isLogin)
                TextButton(
                  onPressed: _resetSenha,
                  child: const Text("Esqueci a senha"),
                ),

              const SizedBox(height: 8),

              // ALTERNAR LOGIN/CADASTRO
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _senhaController.clear(); // limpa senha ao trocar
                  });
                },
                child: Text(
                  _isLogin
                      ? "Não tem conta? Cadastre-se"
                      : "Já tem conta? Entre",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
