import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/user.dart';
import 'package:mcfitness/pages/home/home_page_aluno.dart';
import 'package:mcfitness/pages/home/home_page_professor.dart';
import 'package:mcfitness/pages/login/controllers/login_controller.dart';
import 'package:mcfitness/pages/professor/professor_novo_professor.dart';
import 'package:mcfitness/store/login_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


class Login extends StatefulWidget {

  const Login({Key? key,}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginStore _store = LoginStore();
  final LoginController _loginController = LoginController();
  final _formKey = GlobalKey<FormState>();
  final login = TextEditingController();
  final senha = TextEditingController();

  
  String dia = "0";
  String mes = "0";
  String ano = "0";
  String ipLocal = "";
  bool clicouEntrar = false;
  final bool _isLoading = false;
  bool _isPasswordObscure = true;
  bool _saveLogin = false;
  bool primeiroAcesso = false;
  bool isPersonal = false;
  int idUsuarioLocal = 0;
  String nomeUsuarioLocal = "";
  String documentoUsuarioLocal = "";

  //ProgressDialog progressDialog;

  Future<void> _login() async {

    print("Email = ${login.text.trim()}");
    print("Senha = ${senha.text}");

    setState(() {
      clicouEntrar = true;
    });

    try {
      Map<String, dynamic> result = await Graphql.login(
        login.text,
        senha.text
      );

      if (result['obterUsuario'].length > 0) {

        print("Deu Bom");

        context.read<User>().nome = result['obterUsuario'][0]['pessoa']['nome'];
        context.read<User>().email = login.text;
        context.read<User>().password = senha.text;

        print("${result['obterUsuario'][0]['id']}");

        idUsuarioLocal = result['obterUsuario'][0]['pessoa']['aluno'] == null ? 
                          result['obterUsuario'][0]['pessoa']['personal']['id'] :
                          result['obterUsuario'][0]['pessoa']['aluno']['id'];

        nomeUsuarioLocal = result['obterUsuario'][0]['pessoa']['nome'];

        print("${result['obterUsuario'][0]['pessoa']['nome']}");

        if(result['obterUsuario'][0]['pessoa']['cref'] == null){
          isPersonal = false;
          documentoUsuarioLocal = result['obterUsuario'][0]['pessoa']['cpf'];
        }else{
          isPersonal = true;
          documentoUsuarioLocal = result['obterUsuario'][0]['pessoa']['cref'];
        }

        if (_store.saveCredentials) {
          await _loginController.salvarCredenciais(
              login.text.trim());
          context.read<User>().credentialSaved = true;
        } else {
          await _loginController.apagarCredenciais();
          context.read<User>().credentialSaved = false;
        }

        setState(() {
          clicouEntrar = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) { 
              if(isPersonal){

                return Home_Page_Professor(
                  documentoUsuarioGlobal: documentoUsuarioLocal,
                  idUsuarioGlobal: idUsuarioLocal,
                  isPersonalGlobal: isPersonal,
                  nomeUsuarioGlobal: nomeUsuarioLocal,
                );

              }else{

                return Home_Page_Aluno(
                  documentoUsuarioGlobal: documentoUsuarioLocal,
                  idUsuarioGlobal: idUsuarioLocal,
                  isPersonalGlobal: isPersonal,
                  nomeUsuarioGlobal: nomeUsuarioLocal,
                );

              }
              
            }
          ),
        );
      } else {
        setState(() {
          clicouEntrar = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Conexão Inválida'),
                  content: const Text('E-mail ou senha incorretos'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                  ],
                ));
      }
    } catch (erro) {
      if(erro.toString().contains("Connection failed")){

        print("Mensagem de Erro = $erro");

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
          )
        );
      }else{

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro base de dados. Tente novamente mais tarde.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          )
        );
      }
      setState(() {
        clicouEntrar = false;
      });
    }
  }

  @override
  void dispose() {
    login.dispose();
    senha.dispose();
    super.dispose();
  }

  @override
  void initState() {
    /*if (context.read<User>().credentialSaved) {
      email.text = context.read<User>().email!;
      //password.text = context.read<User>().password!;
      _store.toggleSaveCredentials();
    }*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width, //Pegar a largura da tela quando usamos o SingleChildScrollView
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[400]!,
              Colors.grey,
            ],
          )
        ),
        child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SizedBox(
            child: Stack(
              key: _formKey,
              children: [
                Positioned.fill(
                  top: 740.0,
                  bottom: 10.0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      context.read<User>().versao!,
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                  ),
                  /*SizedBox(
                    height: 70,
                    child: Image.asset("assets/wisell_logo.png"),
                  ),*/
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Muscle Fitness",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 33.0,
                      color: Color(0xff3c4f9d),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 70.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'MC Fitness',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextFormField(
                      controller: login,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        prefixIcon: Icon(
                          Icons.account_circle,
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
                        hintText: "Login",
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextFormField(
                      obscureText: _isPasswordObscure,
                      controller: senha,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        prefixIcon: Icon(
                          Icons.password,
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
                        hintText: "Senha",
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                        suffixIcon: IconButton(
                          splashRadius: 25.0,
                          onPressed: () => setState(
                              () => _isPasswordObscure = !_isPasswordObscure),
                          icon: Icon(
                            _isPasswordObscure
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Observer(
                          builder: (_) => Switch(
                            activeColor: Colors.blue[400],
                            value: _store.saveCredentials, //_saveLogin, 
                            onChanged: (_) => _store.toggleSaveCredentials(), //_saveLogin = !_saveLogin 
                          ),
                        ),
                        const Text(
                          'Lembrar login',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          )
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                          },
                          child: const Text(
                            'Recuperar senha',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0)),
                      color: Colors.blue[400],
                      textColor: Colors.white,
                      minWidth: double.infinity,
                      height: 42,
                      onPressed: () {

                        if(!clicouEntrar && RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(login.text)){
                          _login();
                        }else{
                          print("Email inválido");
                        }

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      width: double.infinity,
                      child:  MaterialButton(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0)),
                        color: Colors.blue[400],
                        textColor: Colors.white,
                        minWidth: double.infinity,
                        height: 42,
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Professor_novo_professor(
                                alunoIdGlobal: 1,
                                alunoNomeGlobal: "",
                              ),
                            ),
                          );
                          
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Criar Conta",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ]
                ),
                clicouEntrar ?
                indicadorProgresso() : Container()
              ],
            ),
          ),
        ),
    ),
      ));
  }

  indicadorProgresso(){
    return Padding(
    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/4, MediaQuery.of(context).size.height/2, MediaQuery.of(context).size.width/4,  MediaQuery.of(context).size.height/2.8),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Entrando...",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(
              color: Colors.blue,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        )
      )
    ),
      );
  }

}

