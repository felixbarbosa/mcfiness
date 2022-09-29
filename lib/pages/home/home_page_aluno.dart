import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/anamnese/anamnese_nova_anamnese.dart';
import 'package:mcfitness/pages/avaliacaoFisica/avaliacaoFisica_nova_avaliacao.dart';
import 'package:mcfitness/pages/carga/carga_listar_musculos.dart';
import 'package:mcfitness/pages/login/login.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treino.dart';
import 'package:mcfitness/pages/usuario/usuario_perfil.dart';

import 'widgets/home_button_widget.dart';

class Home_Page_Aluno extends StatefulWidget {

  final String personalNomeGlobal;
  final int personalIdGlobal;
  final int idUsuarioGlobal;
  final String nomeUsuarioGlobal;
  final String documentoUsuarioGlobal;

  const Home_Page_Aluno({
    Key? key,
    required this.personalNomeGlobal,
    required this.idUsuarioGlobal,
    required this.nomeUsuarioGlobal,
    required this.documentoUsuarioGlobal,
    required this.personalIdGlobal
    
  }) : super(key: key);

  @override
  _Homemodulestate createState() => _Homemodulestate(
    documentoUsuarioLocal: documentoUsuarioGlobal,
    idUsuarioLocal: idUsuarioGlobal,
    personalNomeLocal: personalNomeGlobal,
    nomeUsuarioLocal: nomeUsuarioGlobal,
    personalIdLocal: personalIdGlobal
  );
}

class _Homemodulestate extends State<Home_Page_Aluno> {
  int _pageIndex = 0;
  final PageController _pageCtrl = PageController();

  final String personalNomeLocal;
  final int personalIdLocal;
  final int idUsuarioLocal;
  final String nomeUsuarioLocal;
  final String documentoUsuarioLocal;

  _Homemodulestate(
    {
      required this.personalNomeLocal, 
      required this.idUsuarioLocal, 
      required this.nomeUsuarioLocal, 
      required this.documentoUsuarioLocal,
      required this.personalIdLocal
    }
  );

  bool anamnesePreenchida = false;

  

  void _changePage(int index) {
    if (_pageIndex != index) {
      setState(() => _pageIndex = index);
      _pageCtrl.jumpToPage(index);
    }
  }

  Future<void> _buscarAnamnesePorAluno() async {

    try{

      Map<String, dynamic> result = await Graphql.obterAnamnesePorAluno(idUsuarioLocal);

      print("aqui");
      

      if (result['obterAnamnesePorAluno'].length > 0) {
        print("Resultado buscado");

        setState(() {
          anamnesePreenchida = true;
        });

      } else {
        setState(() {
          anamnesePreenchida = false;
        });
      }

    }catch(erro){

      print("Erro = ${erro.toString()}");

    }

    
  }

  @override
  void initState() {
    super.initState();

    _buscarAnamnesePorAluno();
    
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
              Colors.black,
              Color.fromARGB(255, 132, 136, 139)
            ],
          )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(children: <Widget>[
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.white,
                    child: Image(
                      image: AssetImage(
                        "assets/logo_mc_fitness.png"
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Professor(a): $personalNomeLocal',
                        style: TextStyle(
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aluno(a): $nomeUsuarioLocal',
                        style: TextStyle(
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                        },
                        child: Text(
                          'Sair',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GridView(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.4,
                    ),
                    children: [
                      HomeButtonWidget(
                        notificacao: false,
                        icon: Icons.person,
                        buttonName: 'Treino',
                        color: Colors.black,
                        onPressed: () {

                          if(!anamnesePreenchida){

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Preencha a sua Anamnese!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Fechar'),
                                  ),
                                ],
                              )
                            );

                          }else{
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context) => TreinosListarTreino(
                                  alunoIdGlobal: idUsuarioLocal,
                                  alunoNomeGlobal: nomeUsuarioLocal,
                                  objetivoIdGlobal: 1,
                                )
                              )
                            );
                          }
                          
                        },
                      ),
                      HomeButtonWidget(
                        notificacao: false,
                        icon: Icons.sports_gymnastics,
                        buttonName: 'Meu Progresso',
                        color: Colors.black,
                        onPressed: () {

                          if(!anamnesePreenchida){

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Preencha a sua Anamnese!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Fechar'),
                                  ),
                                ],
                              )
                            );

                          }else{

                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context) => CargaListarMusculos(
                                  alunoIdGlobal: idUsuarioLocal,
                                  personalIdGlobal: personalIdLocal,
                                )
                              )
                            );


                          }
                          
                        },
                      ),
                      HomeButtonWidget(
                        notificacao: !anamnesePreenchida,
                        icon: Icons.analytics,
                        buttonName: 'Anamnese',
                        color: Colors.black,
                        onPressed: () async {

                          if(anamnesePreenchida){

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Você ja preencheu sua anamnese. Não é mais possível alterá-la.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Fechar'),
                                    ),
                                  ],
                                )
                              );

                          }else{

                            var tela = await Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context) => AnamneseNovaAnamnese(
                                  alunoIdGlobal: idUsuarioLocal,
                                  alunoNomeGlobal: nomeUsuarioLocal,
                                )
                              )
                            );

                            if(tela == 1){
                              _buscarAnamnesePorAluno();
                            }
                          }

                        },
                      ),
                      HomeButtonWidget(
                        notificacao: false,
                        icon: Icons.analytics,
                        buttonName: 'Avaliação Fisica',
                        color: Colors.black,
                        onPressed: (){
                          
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => AvaliacaoFisicaNovaAvaliacao(
                                alunoIdGlobal: idUsuarioLocal,
                                alunoNomeGlobal: nomeUsuarioLocal
                              )
                            )
                          );
                        
                          
                        },
                      ),
                      HomeButtonWidget(
                        notificacao: false,
                        icon: Icons.analytics,
                        buttonName: 'Feedbacks',
                      )
                    ],
                  ),
                  UsuarioPerfil(
                    usuarioGlobal: idUsuarioLocal,
                    isPersonalGlobal: false,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black,
        selectedIndex: _pageIndex,
        onDestinationSelected: _changePage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

