import 'package:expense_tracker/repository/chave_pix_repository.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ChavePixAtualizar extends StatefulWidget {
  const ChavePixAtualizar({super.key});

  @override
  State<ChavePixAtualizar> createState() => _ChavePixAtualizarState();
}

class _ChavePixAtualizarState extends State<ChavePixAtualizar> {

  final tipoChaveController = TextEditingController();
  final chaveController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    tipoChaveController.text = args['tipo']; 
    chaveController.text = args['chave'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Chave Pix"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChave(),
                const SizedBox(height: 30),
                _buildTipoChave(),
                const SizedBox(height: 30),
                _buildButton(args['id'])
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildChave() {
    return TextFormField(
      controller: chaveController,
      decoration: const InputDecoration(
        hintText: 'Informe a chave',
        labelText: 'Chave',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null) {
          return 'Informe a chave';
        }
        if(tipoChaveController.text == "e-mail" && !(value.endsWith("@gmail.com") || value.endsWith("@hotmail.com")) ) {
          return "Chave inválida, informe um email";
        }

        if(tipoChaveController.text == "telefone" && value.length != 9) {
          return "Chave inválida, informe um numero válido";
        }
        return null;
      },
    );
  }

  DropdownMenu<String> _buildTipoChave() {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width - 16,
      label: const Text("Tipo da chave"),
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: "e-mail", label: "E-mail"),
        DropdownMenuEntry(value: "telefone", label: "Telefone"),
        DropdownMenuEntry(value: "aleatória", label: "Aleatória"),
      ],
      onSelected: (value) {
        tipoChaveController.text = value!;
      },
      controller: tipoChaveController,
    );
  }

  SizedBox _buildButton(int chavePixId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final scaffold = ScaffoldMessenger.of(context);
            ChavePixRepository().atualizarChavePix(chavePixId,tipoChaveController.text,chaveController.text)
            .then((_) {
              scaffold.showSnackBar(const SnackBar(
                content: Text("Chave pix atualizada com sucesso")
              ));
              Navigator.of(context).pop(true);
            }).catchError((_) {
              scaffold.showSnackBar(const SnackBar(
                content: Text("Erro ao atualizar a chave pix")
              ));
              Navigator.of(context).pop(false);
            });
          }
        },
        child: const Text('Atualizar chave'),
      ),
    );
  }
}