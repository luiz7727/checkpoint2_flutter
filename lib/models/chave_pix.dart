class ChavePix {
  int id;
  String chave;
  int contaId;
  String tipo;

  ChavePix({ required this.id, required this.chave, required this.tipo, required this.contaId});

  factory ChavePix.fromMap(Map<String, dynamic> map) {
    return ChavePix(
      id: map['id'],
      chave: map['chave'],
      tipo: map['tipo'],
      contaId: map['conta_id']
    );
  }
}