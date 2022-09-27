import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/aluno.dart';
import 'package:mcfitness/model/personal.dart';
import 'package:provider/provider.dart';

import 'usuario_alterarSenha.dart';

enum SingingCharacter { nome, cnpj }

class UsuarioPerfil extends StatefulWidget {
  final int usuarioGlobal;
  final bool isPersonalGlobal;

  const UsuarioPerfil({
    Key? key,
    required this.usuarioGlobal,
    required this.isPersonalGlobal,
  }) : super(key: key);

  @override
  _UsuarioPerfilState createState() => _UsuarioPerfilState();
}

class _UsuarioPerfilState extends State<UsuarioPerfil> {
  SingingCharacter? _character = SingingCharacter.nome;

  final _formKey = GlobalKey<FormState>();
  final senhaAtual = TextEditingController();
  final novaSenha = TextEditingController();
  final confirmacaoSenha = TextEditingController();
  final nomeTxt = TextEditingController();
  final documentoTxt = TextEditingController();
  final linkImageTxt = TextEditingController();
  //final entidade = 5;

  int idLocal = 0;
  bool loading = false;
  bool loadingFoto = false;
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
  bool clicouSalvar = false;
  final similares = TextEditingController();
  final observacao = TextEditingController();
  int qtdVendidaInt = 0;
  String pessoaNomeRetornado = "";
  String pessoaIdRetornado = "";
  String pessoaEmailRetornado = "";
  String entidadeRetornada = "";
  String nome = "";
  String email = "";
  String cpf = "";
  String documento = "";
  String entidadeId = "";
  String linkImage = "";
  String linkImageFixo = "";
  String senhaAtualQuery = "";

  bool isCheck = false;
  bool verSenha = true;
  bool verSenhaConfirmacao = true;
  bool editarPerfil = false;

  XFile? fileImage;

  List precos = [];

  List<Reference> refs = [];

  Future<void> _salvarUsuarioPersonal() async {
    setState(() {
      clicouSalvar = true;
      loading = true;
      loadingFoto = true;
    });
    print("Salvando Personal...");
    print("Id = ${widget.usuarioGlobal}");
    print("Link Imagem = ${linkImage}");
    print("Senha = ${senhaAtual.text}");
    try {
      Map<String, dynamic> result = await Graphql.salvarPersonal(
        Personal(
          id: widget.usuarioGlobal,
          cpf: "",
          cref: "",
          email: "",
          foto: linkImage,
          idade: 0,
          login: "",
          nome: "",
          senha: editarPerfil ? novaSenha.text : senhaAtualQuery,
          sexo: ""
        )
      );

      if (result['salvarPersonal']['id'] >= 0) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Edição salva com sucesso!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ],
              ));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1000),
            backgroundColor: Colors.greenAccent,
            content: Icon(Icons.check),
          ),
        );
        setState(() {
          linkImage = linkImage;
          clicouSalvar = false;
          loading = false;
          loadingFoto = false;
          editarPerfil = false;
          _obterPersonal();
          senhaAtual.text = "";
          novaSenha.text = "";
          confirmacaoSenha.text = "";
        });
      }
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
        linkImage = linkImage;
        clicouSalvar = false;
        loading = false;
        loadingFoto = false;
        editarPerfil = false;
      });
    }
  }

  Future<void> _salvarUsuarioAluno() async {
    setState(() {
      clicouSalvar = true;
      loading = true;
      loadingFoto = true;
    });
    print("Id = ${widget.usuarioGlobal}");
    print("Link Imagem = ${linkImage}");
    try {
      Map<String, dynamic> result = await Graphql.salvarAluno(
        Aluno(
          id: widget.usuarioGlobal,
          cpf: "",
          personal: 0,
          email: "",
          foto: linkImage,
          idade: 0,
          login: "",
          nome: "",
          senha: editarPerfil ? novaSenha.text : senhaAtualQuery,
          sexo: ""
        )
      );

      if (result['salvarAluno']['id'] >= 0) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Edição salva com sucesso!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ],
              ));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1000),
            backgroundColor: Colors.greenAccent,
            content: Icon(Icons.check),
          ),
        );
        setState(() {
          linkImage = linkImage;
          clicouSalvar = false;
          loading = false;
          loadingFoto = false;
          editarPerfil = false;
          _obterAluno();
          senhaAtual.text = "";
          novaSenha.text = "";
          confirmacaoSenha.text = "";
        });
      }
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
        linkImage = linkImage;
        clicouSalvar = false;
        loading = false;
        loadingFoto = false;
        editarPerfil = false;
      });
    }
  }

  Future<void> _obterPersonal() async {
    setState(() {
      loading = true;
      loadingFoto = true;
    });
    print("Id = ${widget.usuarioGlobal}");
    try {
      Map<String, dynamic> result = await Graphql.obterPersonalPorId(
        widget.usuarioGlobal
      );

      if (result['obterPersonalPorId']['id'] >= 0) {
        setState(() {
          linkImage = linkImage;
          nome = result['obterPersonalPorId']['nome'];
          documento = result['obterPersonalPorId']['cref'];
          senhaAtualQuery = result['obterPersonalPorId']['senha'];
          linkImage = result['obterPersonalPorId']['foto'];
          linkImageFixo = linkImage;
          clicouSalvar = false;
          loading = false;
          loadingFoto = false;
        });
      }
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
        clicouSalvar = false;
      });
    }
  }

  Future<void> _obterAluno() async {
    setState(() {
      loading = true;
      loadingFoto = true;
    });
    print("Id = ${widget.usuarioGlobal}");
    try {
      Map<String, dynamic> result = await Graphql.obterAlunoPorId(
        widget.usuarioGlobal
      );

      if (result['obterAlunoPorId']['id'] >= 0) {
        setState(() {
          linkImage = linkImage;
          nome = result['obterAlunoPorId']['nome'];
          documento = result['obterAlunoPorId']['cpf'];
          senhaAtualQuery = result['obterAlunoPorId']['senha'];
          linkImage = result['obterAlunoPorId']['foto'];
          clicouSalvar = false;
          loading = false;
          loadingFoto = false;
        });
      }
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
        clicouSalvar = false;
      });
    }
  }

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    //XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  pickAndUploadImage() async {
    setState(() {
      loadingFoto = true;
      clicouSalvar = true;
    });
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await uploadImage(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            loadingFoto = true;
            //total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          final photoRef = snapshot.ref;

          refs.add(photoRef);
          linkImage = await photoRef.getDownloadURL();
          // final SharedPreferences prefs = await _prefs;
          // prefs.setStringList('images', arquivos);

          if(linkImage != ""){

            setState(() {
              loadingFoto = false;
            });

          }else{
            print("Esperando o final do upload...");
          }
        }
      });
    }else{
      setState(() {
        loadingFoto = false;
        linkImage = linkImageFixo;
      });
    }
  }

  Future<UploadTask> uploadImage(String path) async {
    File file = File(path);
    try {
      String ref = 'images/Perfil-${nome}.jpeg';
      //String ref = 'images/img-${DateTime.now().toString()}.mp4';
      final storageRef = FirebaseStorage.instance.ref();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=300",
              //contentType: "image/jpeg",
              contentType: "image/jpeg",
              customMetadata: {
                "user": "123",
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.isPersonalGlobal){
      print("É Personal, e o id = ${widget.usuarioGlobal}");
      _obterPersonal();
    }else{
      _obterAluno();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context)
              .size
              .width, //Pegar a largura da tela quando usamos o SingleChildScrollView
          height: MediaQuery.of(context).size.height,
          child: Container(
            color: Colors.black,
            child:Column(children: [
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
                                SizedBox(height: 100),
                                !loading ?
                                Column(
                                  children: [
                                    Text(
                                      nome,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    !editarPerfil ? 
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.isPersonalGlobal ? "CREF: " : "CPF: ",
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
                                            controller: documentoTxt,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              prefixIcon: Icon(
                                                Icons.edit,
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
                                          widget.isPersonalGlobal ? "CREF ${documento}" : documento,
                                          style: const TextStyle(
                                            color: Colors.black
                                          ),
                                        ),
                                      ],
                                    ) :
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Senha Atual",
                                              style: TextStyle(
                                                color: Colors.black
                                              ),
                                            ),
                                            SizedBox(
                                              width: 70,
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 190,
                                              child: TextFormField(
                                                controller: senhaAtual,
                                                obscureText: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(25.0)
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(50.0)
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(25.0),
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  hintText: "Senha Atual",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey
                                                  )
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Nova Senha",
                                              style: TextStyle(
                                                color: Colors.black
                                              ),
                                            ),
                                            SizedBox(
                                              width: 70,
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 190,
                                              child: TextFormField(
                                                controller: novaSenha,
                                                obscureText: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(25.0),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(50.0)
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(25.0),
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  hintText: "Nova Senha",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey
                                                  )
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Confirmar Nova Senha",
                                              style: TextStyle(
                                                color: Colors.black
                                              ),
                                            ),
                                            SizedBox(width: 8,),
                                            SizedBox(
                                              height: 30,
                                              width: 190,
                                              child: TextFormField(
                                                controller: confirmacaoSenha,
                                                obscureText: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(25.0)
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(50.0)
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(25.0),
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  hintText: "Confirmação",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey
                                                  )
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ) : indicadorProgresso(),
                                SizedBox(
                                  height: editarPerfil ? 40 : 80,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                          onPressed: (){
      
                                            if(editarPerfil){
                                              if(senhaAtual.text != senhaAtualQuery){
      
                                              print("Senha atual não confere!");
      
                                              }else if (novaSenha.text != confirmacaoSenha.text){
                                                print("Nova senha e confirmação de senha não confere");
                                              }else{
                                                widget.isPersonalGlobal ? _salvarUsuarioPersonal() : 
                                                _salvarUsuarioAluno();
                                              }
                                            }else{
                                              widget.isPersonalGlobal ? _salvarUsuarioPersonal() : 
                                              _salvarUsuarioAluno();
                                            }
                                            
                                          },
                                          child: const Text(
                                            'Salvar',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                            ),
                                          ),
                                        ),
                                      ),
                                      !editarPerfil ? 
                                      Expanded(
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              editarPerfil = true;
                                            });
                                          },
                                          child: const Text(
                                            'Mudar senha',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                            ),
                                          ),
                                        ),
                                      ) : Container()
                                    ],
                                  )
                                )
                              ]),
                            ),
                            Align(
                              heightFactor: 3.2,
                              alignment: Alignment.topCenter,
                              child: CircleAvatar(
                                radius: 80.0,
                                child: loadingFoto ? indicadorProgresso() : 
                                Align(
                                  heightFactor: 3.2,
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: Colors.blue[400],
                                    child: Center(
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(
                                          Icons.edit,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          linkImage = "";
                                          pickAndUploadImage();
                                  
                                        }),
                                    ),
                                  ),
                                ),
                                backgroundImage: NetworkImage(
                                  linkImage == "" ? "https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png" : 
                                  linkImage,
                                ),
                              ),
                            ) 
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
      color: Colors.blue,
    ));
  }
}




 