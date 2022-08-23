import 'package:flutter/material.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_alunos.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treino.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_exercicios.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_musculos.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treino.dart';

import 'widgets/home_button_widget.dart';

class Home_Page extends StatefulWidget {

  const Home_Page({
    Key? key,
  }) : super(key: key);

  @override
  _Homemodulestate createState() => _Homemodulestate();
}

class _Homemodulestate extends State<Home_Page> {
  int _pageIndex = 0;
  final PageController _pageCtrl = PageController();

  String nomeUsuario = "Victor Barbosa";
  String nomeProfessorUsuario = "Stella Cordeiro";
  bool isAluno = true;

  void _changePage(int index) {
    if (_pageIndex != index) {
      setState(() => _pageIndex = index);
      _pageCtrl.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "MC Fitness",
                  style: TextStyle(
                    fontSize: 35
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.blue[400],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(children: <Widget>[
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                isAluno ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Professor(a): $nomeProfessorUsuario',
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
                      isAluno ? 'Aluno(a): $nomeUsuario' : 'Professor(a): $nomeUsuario',
                      style: TextStyle(
                          fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: Text(
                        'Sair',
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
                      buttonName: isAluno ? 'Treino' : 'Alunos',
                      onPressed: () {

                        if(isAluno){

                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => TreinosListarTreino(
                                alunoIdGlobal: 1,
                                alunoNomeGlobal: nomeUsuario,
                                objetivoIdGlobal: 1,
                              )
                            )
                          );

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
                      buttonName: isAluno ? 'Meu Progresso' : 'Exercicios',
                      onPressed: () {

                        if(isAluno){

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
                    HomeButtonWidget(
                      icon: Icons.analytics,
                      buttonName: 'Feedbacks',
                    ),
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
      bottomNavigationBar: NavigationBar(
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

/*class Home_Page extends StatefulWidget {
  final String entidadeGlobal;
  final String usuarioGlobal;
  final String usuarioNomeGlobal;

  const Home_Page(
    {
      Key? key, 
      required this.entidadeGlobal, 
      required this.usuarioGlobal, 
      required this.usuarioNomeGlobal,
    }
  ) : super(key: key);

  @override
  _Home_PageState createState() => _Home_PageState(
    entidadeId: entidadeGlobal, 
    usuarioId: usuarioGlobal, 
    usuarioNomeLocal: usuarioNomeGlobal,
  );
}

class _Home_PageState extends State<Home_Page> {

  final String entidadeId;
  final String usuarioId;
  final String usuarioNomeLocal;
  int _indiceAtual = 0;

  _Home_PageState(
    {
      required this.entidadeId, 
      required this.usuarioId, 
      required this.usuarioNomeLocal,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Column(
          children: [
            SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    ' WISELL',
                    style: TextStyle(
                      color: Colors.blue[400]
                    ),
                  ),
                  Container(
                    height: 21,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Wiseller',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                usuarioNomeLocal,
                style: TextStyle(
                  fontSize: 12.0
                ),
              )
          ],
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false, //tirando botao de voltar
      ),
      body: Center(
        child: Container(
          child: ListView(children: <Widget>[
          Divider(
            color: Colors.blue[400],
            height: 3,
            thickness: 6,
          ),
          ListTile(
            title: Text('Vendas',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              )
            ),
            subtitle: Text('Iniciar ação de vendas',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              )
            ),
            onTap: () {
              print("Clicou em Vendas: $usuarioNomeLocal");
              /*Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SalePage(
                    entidadeGlobal: entidadeId, 
                    usuarioGlobal: usuarioId,
                    usuarioNomeGlobal: usuarioNomeLocal,
                    )));*/
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => SalePageSelecionarEmpresa(
                  entidadeGlobal: entidadeId, 
                  usuarioGlobal: usuarioId,
                  usuarioNomeGlobal: usuarioNomeLocal,
                  idVendedorGlobal: int.parse(usuarioId),
                  nomeVendedorGlobal: usuarioNomeLocal,
                  )
                )
              );
            },
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 50,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Estoque',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Estoque',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
            leading: Icon(
              Icons.timeline,
              color: Colors.white,
              size: 50,
            ),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => EstoqueProdutos(
                  entidadeGlobal: entidadeId, 
                  usuarioGlobal: usuarioId,
                  usuarioNomeGlobal: usuarioNomeLocal,
                  )
                )
              );
            },
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Agenda de Vendas',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
              // textAlign: ,
            ),
            subtitle: Text('Datas importantes de vendas',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
            leading: Icon(
              Icons.event,
              color: Colors.white,
              size: 50,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AgendaVendasListar(
                    entidadeGlobal: entidadeId, 
                    usuarioGlobal: usuarioId,
                    usuarioNomeGlobal: usuarioNomeLocal,
                    )));
            },
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Oportunidade de Vendas',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Ofertas de vendas',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                )),
            leading: Icon(
              Icons.real_estate_agent,
              color: Colors.grey,
              size: 50,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Monitor de Vendas',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Meu desempenho',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
            leading: Icon(
              Icons.dvr,
              color: Colors.white,
              size: 50,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ListagemMonitorVenda(
                    entidadeGlobal: entidadeId, 
                    usuarioGlobal: usuarioId,
                    usuarioNomeGlobal: usuarioNomeLocal,
                    pedidosVendasGlobal: [],
                    )));
            },
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Minha Carteira',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Carteira de clientes',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
            leading: Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 50,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Carteira(
                    entidadeGlobal: entidadeId, 
                    usuarioGlobal: usuarioId,
                    usuarioNomeGlobal: usuarioNomeLocal,
                    )));
            },
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Recomendações',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Recomendações',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
            leading: Icon(
              Icons.thumb_up,
              color: Colors.white,
              size: 50,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 40,
            ),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListarRecomendacoes(
                    entidadeGlobal: entidadeId, 
                    usuarioGlobal: usuarioId,
                    usuarioNomeGlobal: usuarioNomeLocal,
                  )
                )
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Trade Marketing',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Trade Marketing',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                )),
            leading: Icon(
              Icons.reduce_capacity,
              color: Colors.grey,
              size: 50,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Rede de Vendas',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Rede de Vendas',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              )
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RedeVendasListagemVendedores(
                    entidadeGlobal: entidadeId, 
                    usuarioGlobal: usuarioId,
                    usuarioNomeGlobal: usuarioNomeLocal,
                    )));
            },
            leading: Icon(
              Icons.lens_blur,
              color: Colors.white,
              size: 50,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Prestacão de Contas',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Prestacão de Contas',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                )),
            leading: Icon(
              Icons.receipt_long,
              color: Colors.grey,
              size: 50,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
              size: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Comissões',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              // textAlign: ,
            ),
            subtitle: Text('Comissões',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                )),
            leading: Icon(
              Icons.attach_money,
              color: Colors.grey,
              size: 50,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
              size: 40,
            ),
          ),
        ])),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onTabTapped,
        iconSize: 30,
        selectedIconTheme: IconThemeData(color: Colors.white),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        mouseCursor: SystemMouseCursors.grab,
        backgroundColor: Colors.blue[400],
        elevation: 1,
        unselectedIconTheme: IconThemeData(
          color: Colors.white,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person
            ),
            label: "Usuário",

          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings
              ),
              label: "Configurações"
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout
            ), 
            label: "Sair",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      print("Index = $index");
      _indiceAtual = index;

      if(index == 0){

        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          UsuarioPerfil(
            usuarioGlobal: usuarioId,
            usuarioNomeGlobal: usuarioNomeLocal,
          )
        ));

      }else if(index == 2){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
          Login()
        ));
      }
    });
  }

}*/
