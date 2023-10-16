import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chave_pix.dart';

class ChavePixRepository {
  Future<List<ChavePix>> listarChavesPixDeUmaConta(int contaId) async {
    final supabase = Supabase.instance.client;
    final data = await supabase.from('chavepix').select<List<Map<String, dynamic>>>("*").eq('conta_id', contaId);
    final chavespix = data.map((e) {return ChavePix.fromMap(e);}).toList();
    return chavespix;
  }

  Future<void> cadastrarChavePix(ChavePix chavePix, int contaId) async {
    final supabase = Supabase.instance.client;
    await supabase.from("chavepix").insert(
      {
        'tipo':chavePix.tipo,
        'chave':chavePix.chave,
        'conta_id':chavePix.contaId
      }
    );
  }

  Future<void> atualizarChavePix(int chavePixId, String tipo, String chave) async {
    final supabase = Supabase.instance.client;
    await supabase.from("chavepix").update(
      {
        'tipo':tipo,
        'chave':chave,
      }
    ).match({'id':chavePixId});
  }

  Future<void> deletarChavePixDeUmaConta(int chavePixId) async {
    final supabase = Supabase.instance.client;
    await supabase.from("chavepix").delete().eq('id', chavePixId);
  }
}