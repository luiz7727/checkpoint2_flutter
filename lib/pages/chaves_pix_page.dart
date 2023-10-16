import 'package:expense_tracker/models/conta.dart';
import 'package:expense_tracker/repository/chave_pix_repository.dart';
import 'package:flutter/material.dart';
import '../models/chave_pix.dart';

class ChavePixPage extends StatefulWidget {
  const ChavePixPage({super.key});

  @override
  State<ChavePixPage> createState() => _ChavePixState();
}

class _ChavePixState extends State<ChavePixPage> {
  
  @override
  Widget build(BuildContext context) {
    
    final args = ModalRoute.of(context)!.settings.arguments as Conta;
    final contaId = args.id;
    final chavesPixFuture = ChavePixRepository().listarChavesPixDeUmaConta(contaId);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chaves Pix",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<ChavePix>>(
        future: chavesPixFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar todas as chaves pix"),
            );
          }
          else if(snapshot.data!.isEmpty){
            return const Center(
              child: Text("Nenhuma chave pix cadastrada"),
            );
          }
          else {
            final chavesPix = snapshot.data!;
            return ListView.builder(
              itemCount: chavesPix.length,
              itemBuilder: (context, index) {
                final chavePix = chavesPix[index];
                return ListTile(
                  title: Text(chavePix.chave),
                  subtitle: Text(chavePix.tipo),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/chave-pix-atualizar",arguments: {'id':chavePix.id, 'chave':chavePix.chave,'tipo':chavePix.tipo});
                        },
                        icon: const Icon(Icons.edit)
                      ),
                      IconButton(
                        onPressed: () {
                          ChavePixRepository().deletarChavePixDeUmaConta(chavePix.id)
                          .then((_){
                            //renderiza dnv o widget
                          });
                        },
                        icon: const Icon(Icons.delete)
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "cadastrar-chave-pix",
        onPressed: () {
          Navigator.pushNamed(context, '/chave-pix-cadastro',arguments: contaId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}