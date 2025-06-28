import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jogo.dart';

class JogoService {
  static const String url =
      'https://api-jogos-indie-humberto-52d50e1f5899.herokuapp.com/jogos';

  static Future<List<Jogo>> fetchJogos() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((jogo) => Jogo.fromJson(jogo)).toList();
    } else {
      throw Exception('Falha ao carregar os jogos');
    }
  }

  static Future<void> adicionarJogo(Jogo jogo) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': jogo.nome,
        'genero': jogo.genero,
        'plataforma': jogo.plataforma,
        'avaliacao': jogo.avaliacao,
        'descricao': jogo.descricao,
        'urlImagem': jogo.urlImagem,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Falha ao adicionar jogo');
    }
  }

  static Future<void> atualizarJogo(Jogo jogo) async {
    final response = await http.put(
      Uri.parse('$url/${jogo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': jogo.nome,
        'genero': jogo.genero,
        'plataforma': jogo.plataforma,
        'avaliacao': jogo.avaliacao,
        'descricao': jogo.descricao,
        'urlImagem': jogo.urlImagem,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar jogo');
    }
  }

  static Future<void> deletarJogo(int id) async {
    final response = await http.delete(Uri.parse('$url/$id'));

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar jogo');
    }
  }
}
