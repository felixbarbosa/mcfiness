import 'package:flutter/material.dart';

enum SingingCharacter { nome, cnpj }

class UsuarioAlterarSenha extends StatefulWidget {
  final int usuarioGlobal;
  final String usuarioNomeGlobal;

  const UsuarioAlterarSenha(
      {Key? key, required this.usuarioNomeGlobal, required this.usuarioGlobal})
      : super(key: key);

  @override
  _UsuarioAlterarSenhaState createState() => _UsuarioAlterarSenhaState();
}

class _UsuarioAlterarSenhaState extends State<UsuarioAlterarSenha> {
  final SingingCharacter? _character = SingingCharacter.nome;

  final _formKey = GlobalKey<FormState>();
  final senha = TextEditingController();
  final confirmacaoSenha = TextEditingController();
  //final entidade = 5;

  int idLocal = 0;
  final bool _isLoading = false;
  bool produtoSelecionado = false;
  String idSelecionado = "";
  bool isButtonDisable = false;

  double valorUnitarioQuery = 0.0;
  final qtdVendida = TextEditingController();
  final estoque = TextEditingController();
  final giroMes = TextEditingController();
  final ultimoPreco = TextEditingController();
  int promocao = 0;
  double preco = 0.0;
  double desconto = 0.0;
  double totalItem = 0.0;
  String tabelaPreco = "";
  String txtQtde = "0";
  bool jaMudou = false;
  bool clicouAtivar = false;
  final similares = TextEditingController();
  final observacao = TextEditingController();
  int qtdVendidaInt = 0;
  String pessoaNomeRetornado = "";
  String pessoaIdRetornado = "";
  String pessoaEmailRetornado = "";
  String entidadeRetornada = "";

  bool isCheck = false;
  bool _isPasswordObscure = true;
  bool verSenhaConfirmacao = true;

  List precos = [];

  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.blue),
          title: const Text('Redefinir Senha',
              style: TextStyle(color: Colors.blue)),
          elevation: 0,
          backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Nova Senha',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              TextFormField(
                //hintText: 'Nova Senha',
                //counterText: '',
                keyboardType: TextInputType.visiblePassword,
                obscureText: _isPasswordObscure,
                maxLength: 18,
                enabled: !_isLoading,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                textInputAction: TextInputAction.done,
                /*suffixIcon: IconButton(
                  splashRadius: 25.0,
                  onPressed: () =>
                      setState(() => _isPasswordObscure = !_isPasswordObscure),
                  icon: Icon(
                    _isPasswordObscure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Theme.of(context).disabledColor,
                  ),
                ),*/
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo não pode ser vazio';
                  } else if (value.length < 5) {
                    return 'Senha muito curta';
                  } else {
                    return null;
                  }
                },
                controller: senha,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Confirmar Senha",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextFormField(
                //hintText: 'Confirmar Senha',
                //counterText: '',
                keyboardType: TextInputType.visiblePassword,
                obscureText: _isPasswordObscure,
                maxLength: 18,
                enabled: !_isLoading,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                textInputAction: TextInputAction.done,
                /*suffixIcon: IconButton(
                  splashRadius: 25.0,
                  onPressed: () =>
                      setState(() => _isPasswordObscure = !_isPasswordObscure),
                  icon: Icon(
                    _isPasswordObscure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Theme.of(context).disabledColor,
                  ),
                ),*/
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo não pode ser vazio';
                  } else if (value.length < 5) {
                    return 'Senha muito curta';
                  } else {
                    return null;
                  }
                },
                controller: confirmacaoSenha,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  if (senha.text != confirmacaoSenha.text) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Senhas diferentes!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    senha.clear();
                                    confirmacaoSenha.clear();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Fechar'),
                                ),
                              ],
                            ));
                  } else {
                    //_alterarSenha();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Confirmar",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              clicouAtivar ? indicadorProgresso() : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

indicadorProgresso() {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 10.0, 60),
      child: Container(
          child: Center(
              child: CircularProgressIndicator(
        color: Colors.black,
      ))),
    ),
  );
}
