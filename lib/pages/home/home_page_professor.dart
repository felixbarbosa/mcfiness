import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_alunos.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_aluno.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_musculos.dart';
import 'package:mcfitness/pages/login/login.dart';
import 'package:mcfitness/pages/usuario/usuario_perfil.dart';

class Home_Page_Professor extends StatefulWidget {

  final bool isPersonalGlobal;
  final int idUsuarioGlobal;
  final String nomeUsuarioGlobal;
  final String documentoUsuarioGlobal;
  final String fotoGlobal;
  final String senhaGlobal;

  const Home_Page_Professor({
    Key? key,
    required this.isPersonalGlobal,
    required this.idUsuarioGlobal,
    required this.nomeUsuarioGlobal,
    required this.documentoUsuarioGlobal,
    required this.fotoGlobal,
    required this.senhaGlobal
    
  }) : super(key: key);

  @override
  _Homemodulestate createState() => _Homemodulestate(
    documentoUsuarioLocal: documentoUsuarioGlobal,
    idUsuarioLocal: idUsuarioGlobal,
    isPersonalLocal: isPersonalGlobal,
    nomeUsuarioLocal: nomeUsuarioGlobal,
    fotoLocal: fotoGlobal,
    senhaLocal: senhaGlobal
  );
}

class _Homemodulestate extends State<Home_Page_Professor> {
  int _pageIndex = 0;
  final PageController _pageCtrl = PageController();

  final bool isPersonalLocal;
  final int idUsuarioLocal;
  final String nomeUsuarioLocal;
  final String documentoUsuarioLocal;
  final String fotoLocal;
  final String senhaLocal;

  _Homemodulestate(
    {
      required this.isPersonalLocal, 
      required this.idUsuarioLocal, 
      required this.nomeUsuarioLocal, 
      required this.documentoUsuarioLocal,
      required this.fotoLocal,
      required this.senhaLocal
    }
  );

  bool loading = false;
  bool alunoSelecionado = false;
  String linkImage = "";
  
  int idSelecionadoAluno = 0;

  List alunos = [];
  

  void _changePage(int index) {
    print("Index da pagina = $index");
    if (_pageIndex != index) {
      if(index == 0){
        _obterPersonal();
      }
      setState(() => _pageIndex = index);
      _pageCtrl.jumpToPage(index);
    }
  }

  Future<void> _obterPersonal() async {
    setState(() {
      loading = true;
    });
    try {
      Map<String, dynamic> result = await Graphql.obterPersonalPorId(
        idUsuarioLocal
      );

      if (result['obterPersonalPorId']['id'] >= 0) {
        setState(() {
          linkImage = result['obterPersonalPorId']['foto'];
          loading = false;
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
    }
  }

  Future<void> _alunosPorPersonal() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.alunosPorPersonal(idUsuarioLocal);

      print("aqui");
      

      if (result['obterAlunosProfessor'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          alunos = result['obterAlunosProfessor'];
        });

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum aluno nesse Professor'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    loading = false;
                  });
                },
                child: const Text('Fechar'),
              ),
            ],
          )
        );
      }

    }catch(erro){

      print("Erro = ${erro.toString()}");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro na base de dados'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  loading = false;
                });
              },
              child: const Text('Fechar'),
            ),
          ],
        )
      );

    }

    
  }

  @override
  void initState() {
    super.initState();
    linkImage = fotoLocal;
    _alunosPorPersonal();
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
          //color: Colors.black
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(children: <Widget>[
            const SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (!linkImage.isEmpty) ?
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(linkImage),
                              fit: BoxFit.fill
                            )
                          ),
                        ) :
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: AssetImage("assets/Erro.png"),
                              fit: BoxFit.fill
                            )
                          ),
                        ),
                        Text(
                          'Professor(a): $nomeUsuarioLocal',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          ),
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
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 100),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Alunos Ativos",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width/2.8,
                                        ),
                                        TextButton(
                                          onPressed: () async {

                                            var tela = await Navigator.push(
                                              context, MaterialPageRoute(
                                                builder: (context) => AlunosNovoAluno(
                                                  professorIdGlobal: idUsuarioLocal,
                                                )
                                              )
                                            );

                                            if(tela == 1){
                                              _alunosPorPersonal();
                                            }
                                            
                                          }, 
                                          child: Text(
                                            "+ Aluno",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  widgetRolagemAlunos(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context) => ExerciciosListarMusculos(
                                      personalIdGlobal: idUsuarioLocal,
                                    )
                                  )
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.black,
                                ),
                                height: 30,
                                width: MediaQuery.of(context).size.width/2,
                                child: Center(
                                  child: Text(
                                    "Exercicios",
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  UsuarioPerfil(
                    usuarioGlobal: idUsuarioLocal,
                    isPersonalGlobal: true,
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
            icon: Icon(
              Icons.home_rounded,
              color: Colors.white,
            ),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_rounded,
              color: Colors.white
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  widgetRolagemAlunos() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: Container(
        height: MediaQuery.of(context).size.height/5,
        child: RefreshIndicator(
          color: Colors.blue[400],
          onRefresh: (){
            return _alunosPorPersonal();
          },
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            MaterialButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context) => AlunosListarAlunos(
                                      professorIdGlobal: idUsuarioLocal,
                                      alunoFotoGlobal: alunos[index]['foto'] == null ? "https://banner2.cleanpng.com/20180329/lqq/kisspng-computer-icons-person-clip-art-font-5abd6e0bd0e9a2.3426644315223639158557.jpg" : 
                                      alunos[index]['foto'],
                                      alunoNomeGlobal: alunos[index]['nome'],
                                      alunoIdGlobal: alunos[index]['id'],
                                    )
                                  )
                                );
                              },
                              child: Container(
                                  //height: 70,
                                  width: MediaQuery.of(context).size.width/1.4,
                                  decoration: BoxDecoration(
                                    //color: (alunoSelecionado && idSelecionadoAluno == alunos[index]['id']) ? Colors.blue[400] : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(4.0),
                                      bottomRight: Radius.circular(4.0),
                                      topLeft: Radius.circular(4.0),
                                      bottomLeft: Radius.circular(4.0)
                                    )
                                  ),
                                  //padding: EdgeInsets.all(2.0),
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/8,
                                          padding: EdgeInsets.all(2.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                (alunos[index]['foto'] == null || alunos[index]['foto'] == "") ? "https://banner2.cleanpng.com/20180329/lqq/kisspng-computer-icons-person-clip-art-font-5abd6e0bd0e9a2.3426644315223639158557.jpg" : alunos[index]['foto']
                                              ),
                                              fit: BoxFit.fill
                                            ),
                                            color: (alunoSelecionado && idSelecionadoAluno == alunos[index]['id']) ? Color.fromARGB(255, 14, 93, 158) : Colors.blue[400]
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                                  child: Text(
                                                    alunos[index]['nome'],  
                                                    overflow: TextOverflow.fade,                          
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
              itemCount: alunos.length
          ),
        ),
      ),
    );
  }

}

