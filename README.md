# API e App - Jogos Indie

Projeto desenvolvido para a disciplina de Reengenharia de Aplicativo Mobile, contendo:

- Backend (API) em Java + Spring Boot + Heroku  
- Aplicativo mobile em Flutter
---

# Descrição do Projeto
Sistema completo de gerenciamento de Jogos Indie, permitindo:

- Listar jogos
- Cadastrar novos jogos
- Atualizar informações de jogos
- Deletar jogos
---

# Funcionalidades

 GET: Listar todos os jogos  
 POST: Criar um novo jogo  
 PUT: Atualizar informações de um jogo existente  
 DELETE: Remover um jogo da base
---

# Tecnologias Utilizadas
- Backend (API): Java, Spring Boot, Maven, Heroku  
- Frontend (App Mobile): Flutter, Dart
---

# Como Rodar o Projeto
#1. Backend (API Spring Boot)

1. Navegue até a pasta `api/`
2. Abra no IntelliJ ou VS Code com suporte a Java e Maven
3. Execute a classe principal `JogosApplication.java`
4. A API estará disponível localmente em:  
   `http://localhost:8080/jogos`

API online (Heroku): 
[https://api-jogos-indie-humberto-52d50e1f5899.herokuapp.com/jogos](https://api-jogos-indie-humberto-52d50e1f5899.herokuapp.com/jogos)
---

#2. Aplicativo Mobile (Flutter)

1. Navegue até a pasta `app/`
2. No terminal, execute:

flutter pub get
flutter run

