import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_alunos.dart';
import 'package:mcfitness/pages/anamnese/anamnese_nova_anamnese.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_musculos.dart';
import 'package:mcfitness/pages/login/login.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treino.dart';

import 'widgets/home_button_widget.dart';

class Home_Page extends StatefulWidget {

  final bool isPersonalGlobal;
  final int idUsuarioGlobal;
  final String nomeUsuarioGlobal;
  final String documentoUsuarioGlobal;

  const Home_Page({
    Key? key,
    required this.isPersonalGlobal,
    required this.idUsuarioGlobal,
    required this.nomeUsuarioGlobal,
    required this.documentoUsuarioGlobal
    
  }) : super(key: key);

  @override
  _Homemodulestate createState() => _Homemodulestate(
    documentoUsuarioLocal: documentoUsuarioGlobal,
    idUsuarioLocal: idUsuarioGlobal,
    isPersonalLocal: isPersonalGlobal,
    nomeUsuarioLocal: nomeUsuarioGlobal
  );
}

class _Homemodulestate extends State<Home_Page> {
  int _pageIndex = 0;
  final PageController _pageCtrl = PageController();

  final bool isPersonalLocal;
  final int idUsuarioLocal;
  final String nomeUsuarioLocal;
  final String documentoUsuarioLocal;

  _Homemodulestate(
    {
      required this.isPersonalLocal, 
      required this.idUsuarioLocal, 
      required this.nomeUsuarioLocal, 
      required this.documentoUsuarioLocal
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

    if(!isPersonalLocal){
      _buscarAnamnesePorAluno();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Center(
            child: Text(
              "MC Fitness",
              style: TextStyle(
                fontSize: 30
              ),
            ),
          ),
          backgroundColor: Colors.blue[400],
        ),
      ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(children: <Widget>[
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  !isPersonalLocal ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Professor(a): ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ) : Container(),
                  SizedBox(
                    height: 30,
                  ),            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        !isPersonalLocal ? 'Aluno(a): $nomeUsuarioLocal' : 'Professor(a): $nomeUsuarioLocal',
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
                            color: Colors.black
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
                        icon: Icons.person,
                        buttonName: !isPersonalLocal ? 'Treino' : 'Alunos',
                        onPressed: () {

                          if(!isPersonalLocal){

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

                          }else{
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context) => AlunosListarAlunos(
                                  professorIdGlobal: 1,
                                )
                              )
                            );
                          }
                          
                        },
                      ),
                      HomeButtonWidget(
                        icon: Icons.sports_gymnastics,
                        buttonName: !isPersonalLocal ? 'Meu Progresso' : 'Exercicios',
                        onPressed: () {

                          if(!isPersonalLocal){

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

                            }

                          }else{
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context) => ExerciciosListarMusculos(
                                  personalIdGlobal: 1,
                                )
                              )
                            );
                          }
                          
                        },
                      ),
                      !isPersonalLocal ?
                      HomeButtonWidget(
                        icon: Icons.analytics,
                        buttonName: 'Anamnese',
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
                      ) : Container(),
                      !isPersonalLocal ?
                      HomeButtonWidget(
                        icon: Icons.analytics,
                        buttonName: 'Avaliação Fisica',
                        onPressed: (){
                          
                        },
                      ) : Container(),
                      HomeButtonWidget(
                        icon: Icons.analytics,
                        buttonName: 'Feedbacks',
                      )
                      /*HomeButtonWidget(
                        icon: Icons.real_estate_agent,
                        buttonName: 'Preços e Promoções',
                        onPressed: () {
                        },
                      ),
                      HomeButtonWidget(
                        icon: Icons.thumb_up,
                        buttonName: 'Recomendações',
                        onPressed: () {

                          
                        }
                      ),
                      HomeButtonWidget(
                        icon: Icons.people,
                        buttonName: 'Clientes',
                        onPressed: () {

                          
                        }
                      ),
                      HomeButtonWidget(
                        icon: Icons.event,
                        buttonName: 'Agenda de Vendas',
                        onPressed: () {

                          
                        }
                      ),
                      HomeButtonWidget(
                        icon: Icons.lens_blur,
                        buttonName: 'Produtos',
                        onPressed: (){
                        },
                      ),
                      HomeButtonWidget(
                        icon: Icons.reduce_capacity,
                        buttonName: 'Entidades Jurídicas',
                        onPressed: () {

                          
                        }
                      ),
                      HomeButtonWidget(
                        icon: Icons.reduce_capacity,
                        buttonName: 'Fornecedores',
                        onPressed: (){
                        },
                      ),
                      const HomeButtonWidget(
                        icon: Icons.reduce_capacity,
                        buttonName: 'Trade Marketing',
                      ),
                      HomeButtonWidget(
                        icon: Icons.lens_blur,
                        buttonName: 'Vendedores',
                        onPressed: (){
                        },
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey,
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

