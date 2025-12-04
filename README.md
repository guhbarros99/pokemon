Pokédex Flutter App

Uma aplicação móvel desenvolvida em Flutter que permite aos utilizadores explorar, visualizar detalhes e gerir uma lista de Pokémon favoritos. O projeto integra autenticação via Firebase, consumo da PokéAPI e persistência de dados local.
📱 Funcionalidades

    Autenticação de Utilizador: Sistema de Login e Registo utilizando Email e Password (via Firebase Auth).

    Listagem de Pokémon: Visualização dos 151 Pokémon da primeira geração consumidos diretamente da PokéAPI.

    Detalhes do Pokémon: Ecrã detalhado com imagem, peso, altura e tipos do Pokémon.

    Sistema de Favoritos:

        Adicionar e remover Pokémon de uma lista de favoritos.

        Persistência de dados local utilizando SharedPreferences.

    Perfil de Utilizador:

        Visualização da foto de perfil.

        Upload e atualização da foto de perfil (armazenada no Firebase Storage) utilizando a câmara ou galeria.

        Funcionalidade de Logout.

    Notificações Locais: O utilizador recebe uma notificação no dispositivo ao adicionar ou remover um Pokémon dos favoritos.

🛠 Tecnologias Utilizadas

    Linguagem: Dart

    Framework: Flutter

    Backend & Cloud:

        Firebase Auth (Autenticação)

        Firebase Storage (Armazenamento de Imagens)

        Firebase Core

    API Externa: PokéAPI

    Packages Principais:

        http: Para requisições à API REST.

        shared_preferences: Para armazenamento local dos favoritos.

        flutter_local_notifications: Para exibir notificações no dispositivo.

        image_picker: Para selecionar imagens da galeria.

🚀 Como executar o projeto
Pré-requisitos

    Flutter SDK instalado (Versão recomendada: >=3.9.2).

    Um dispositivo físico ou emulador (Android/iOS).

    Conta no Firebase.
