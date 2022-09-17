import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:provider/provider.dart';

import 'usuario_alterarSenha.dart';

enum SingingCharacter { nome, cnpj }

class UsuarioPerfil extends StatefulWidget {
  final int usuarioGlobal;
  final String usuarioNomeGlobal;
  final String fotoGlobal;
  final String crefGlobal;

  const UsuarioPerfil({
    Key? key,
    required this.usuarioNomeGlobal,
    required this.usuarioGlobal,
    required this.fotoGlobal,
    required this.crefGlobal
  }) : super(key: key);

  @override
  _UsuarioPerfilState createState() => _UsuarioPerfilState();
}

class _UsuarioPerfilState extends State<UsuarioPerfil> {
  SingingCharacter? _character = SingingCharacter.nome;

  final _formKey = GlobalKey<FormState>();
  final senha = TextEditingController();
  final confirmacaoSenha = TextEditingController();
  final nomeTxt = TextEditingController();
  final apelidoTxt = TextEditingController();
  final linkLogoTxt = TextEditingController();
  //final entidade = 5;

  int idLocal = 0;
  bool loading = false;
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
  String apelido = "";
  String email = "";
  String cpf = "";
  String areaBase = "";
  String entidadeId = "";
  String ativo = "";
  String linkLogo = "";

  bool isCheck = false;
  bool verSenha = true;
  bool verSenhaConfirmacao = true;
  bool editarPerfil = false;

  List precos = [];

  Future<void> _salvarUsuario() async {
    try {
      /*Map<String, dynamic> result = await Graphql.salvarPessoaFisica(
        PessoaFisica(
          id: int.parse(widget.usuarioGlobal),
          apelido: apelidoTxt.text,
          areaBase: areaBase,
          ativo: int.parse(ativo),
          cpf: cpf,
          email: email,
          entidade: entidadeId,
          linkLogo: linkLogoTxt.text,
          login: "",
          senha: "",
          nome: nomeTxt.text
        )
      );

      if (int.parse(result['pessoaFisica']['id']) >= 0) {
        //_buscarUsusario();
      }*/
    } catch (erro) {
      if (erro.toString().contains("Connection failed")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1000),
            backgroundColor: Colors.red,
            content: Icon(Icons.highlight_remove),
          ),
        );

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Você está sem conexão com a internet'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                  ],
                ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1000),
            backgroundColor: Colors.red,
            content: Icon(Icons.highlight_remove),
          ),
        );

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Não foi possivel realizar a edição'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                  ],
                ));
      }

      setState(() {
        clicouAtivar = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //_buscarUsusario();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context)
              .size
              .width, //Pegar a largura da tela quando usamos o SingleChildScrollView
          height: MediaQuery.of(context).size.height,
          child: Container(
            child: loading
                ? indicadorProgresso()
                : Column(children: [
                    Expanded(
                        child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Stack(alignment: Alignment.center, children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(children: [
                                SizedBox(height: editarPerfil ? 10 : 100),
                                editarPerfil ?
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: TextFormField(
                                    controller: linkLogoTxt,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      prefixIcon: Icon(
                                        Icons.app_registration,
                                        color: Colors.black
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50.0)
                                      ),
                                      hintText: "Link da logo",
                                      hintStyle: TextStyle(
                                        color: Colors.grey
                                      )
                                    ),
                                  ),
                                ) : Container(),
                                editarPerfil ?
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: TextFormField(
                                    controller: nomeTxt,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      prefixIcon: Icon(
                                        Icons.app_registration,
                                        color: Colors.black
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50.0)
                                      ),
                                    ),
                                  ),
                                )
                                :
                                Text(
                                  widget.usuarioNomeGlobal,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "CREF: ",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    editarPerfil ?
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width/1.5,
                                      child: TextFormField(
                                        controller: apelidoTxt,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                          prefixIcon: Icon(
                                            Icons.app_registration,
                                            color: Colors.black
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50.0)
                                          ),
                                        ),
                                      ),
                                    )
                                    :
                                    Text(
                                      "CREF ${widget.crefGlobal}",
                                      style: const TextStyle(
                                        color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 80,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: 
                                  !editarPerfil ?
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              editarPerfil = !editarPerfil;
                                              nomeTxt.text = widget.usuarioNomeGlobal;
                                              apelidoTxt.text = apelido;
                                            });
                                          },
                                          child: const Text(
                                            'Editar Perfil',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: MaterialButton(
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      UsuarioAlterarSenha(
                                                        usuarioGlobal: widget
                                                            .usuarioGlobal,
                                                        usuarioNomeGlobal: widget
                                                            .usuarioNomeGlobal,
                                                      ))),
                                          child: const Text(
                                            'Mudar senha',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ) :
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              _salvarUsuario();
                                              
                                              editarPerfil = !editarPerfil;
                                            });
                                          },
                                          child: const Text(
                                            'Salvar',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              editarPerfil = !editarPerfil;
                                            });
                                          },
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            !editarPerfil ?
                            Align(
                              heightFactor: 3.2,
                              alignment: Alignment.topCenter,
                              child: CircleAvatar(
                                radius: 80.0,
                                backgroundImage: NetworkImage(
                                  widget.fotoGlobal == "" ? "https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png" : 
                                  widget.fotoGlobal,
                                ),
                                /*Icon(
                                  Icons.person,
                                  size: 80,
                                ),*/
                              ),
                            ) :
                            Container()
                          ]
                          ),
                        ],
                      ),
                    )),
                  ]),
          ),
        ),
      ),
    );
  }

  indicadorProgresso() {
    return const Center(
        child: CircularProgressIndicator(
      color: Colors.black,
    ));
  }
}




 