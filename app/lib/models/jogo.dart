class Jogo {
  final int id;
  final String nome;
  final String genero;
  final String plataforma;
  final double avaliacao;
  final String descricao;
  final String urlImagem;

  Jogo({
    required this.id,
    required this.nome,
    required this.genero,
    required this.plataforma,
    required this.avaliacao,
    required this.descricao,
    required this.urlImagem,
  });

  factory Jogo.fromJson(Map<String, dynamic> json) {
    return Jogo(
      id: json['id'],
      nome: json['nome'],
      genero: json['genero'],
      plataforma: json['plataforma'],
      avaliacao: (json['avaliacao'] as num).toDouble(),
      descricao: json['descricao'],
      urlImagem: json['urlImagem'],
    );
  }
}
