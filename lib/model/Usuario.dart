class UsuarioModel {
  String nome;
  String usuario;
  double valor;
  String vencimento;
  String descricao;
  String detalhes;

  UsuarioModel(
      {required this.nome,
      required this.usuario,
      required this.valor,
      required this.vencimento,
      required this.descricao,
      required this.detalhes});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'usuario': usuario,
      'valor': valor,
      'vencimento': vencimento,
      'descricao': descricao,
      'detalhes': detalhes
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
        nome: map['nome'],
        usuario: map['usuario'],
        valor: map['valor'],
        vencimento: map['vencimento'],
        descricao: map['descricao'],
        detalhes: map['detalhes']);
  }
}
