import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treino.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treino_nome.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treinos_musculo.dart';
import 'package:mcfitness/pages/anamnese/anamnese_listar_anamnese.dart';
import 'package:mcfitness/pages/anamnese/anamnese_nova_anamnese.dart';
import 'package:mcfitness/pages/avaliacaoFisica/avaliacaoFisica_listar_avaliacao.dart';
import 'package:mcfitness/pages/avaliacaoFisica/avaliacaoFisica_nova_avaliacao.dart';
import 'package:mcfitness/pages/carga/carga_listar_cargas.dart';
import 'package:mcfitness/pages/carga/carga_listar_musculos.dart';
import 'package:mcfitness/pages/home/widgets/home_button_widget.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treino.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treinos_dia.dart';

enum SingingCharacter { nome, cnpj }

class AlunosListarAlunos extends StatefulWidget {

  final int professorIdGlobal;
  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final String alunoFotoGlobal;

  const AlunosListarAlunos(
    {
      Key? key, 
      required this.professorIdGlobal,
      required this.alunoIdGlobal,
      required this.alunoNomeGlobal,
      required this.alunoFotoGlobal
    }
  ) : super(key: key);

  @override
  _AlunosListarAlunosState createState() => _AlunosListarAlunosState(
    professorIdLocal: professorIdGlobal, 
    alunoIdLocal: alunoIdGlobal,
    alunoNomeLocal: alunoNomeGlobal,
    alunoFotoLocal: alunoFotoGlobal
  );
}

bool termoMaiorTres = false;

class _AlunosListarAlunosState extends State<AlunosListarAlunos> {

  final int professorIdLocal;
  final int alunoIdLocal;
  final String alunoNomeLocal;
  final String alunoFotoLocal;

  _AlunosListarAlunosState(
    {
      required this.professorIdLocal,
      required this.alunoIdLocal,
      required this.alunoNomeLocal,
      required this.alunoFotoLocal
    }
  );

  bool loading = false;
  bool alunoSelecionado = false;
  int idSelecionado = 0;
  String nomeSelecionado = "";
  int objetivoIdLocal = 0;

  List alunos = [];

  Future<void> _alunosPorPersonal() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.alunosPorPersonal(1);

      print("aqui");
      

      if (result['obterAlunosProfessor'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
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
    _alunosPorPersonal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              SizedBox(
                height: 8.0,
              ),
              Text(
                'MC Fitness',
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                "Alunos",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              )
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.undo, ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
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
          child: Column(
            children: [
            SizedBox(
              height: 50,
            ),
            Container(
              //height: MediaQuery.of(context).size.height/1.235,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: NetworkImage(alunoFotoLocal),
                        fit: BoxFit.fill
                      )
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 0, 0),
                    child: Text(
                      'Aluno(a): $alunoNomeLocal',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 65,
            ),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.4,
                ),
                children: [
                  HomeButtonWidget(
                    icon: Icons.sports_gymnastics,
                    buttonName: 'Treinos',
                    notificacao: false,
                    color: Colors.black,
                    onPressed: () {

                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AlunosListarTreino(
                                alunoIdGlobal: alunoIdLocal,
                                alunoNomeGlobal: alunoNomeLocal,
                                objetivoIdGlobal: 1,
                              );
                            } 
                          )
                        );
                      
                    },
                  ),
                  HomeButtonWidget(
                    icon: Icons.book,
                    buttonName: 'Avaliações',
                    notificacao: false,
                    color: Colors.black,
                    onPressed: () {

                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AvaliacaoFisicaListarAvaliacao(
                                alunoIdGlobal: alunoIdLocal,
                                alunoNomeGlobal: alunoNomeLocal,
                              );
                            } 
                          )
                        );
                      
                    },
                  ),
                  HomeButtonWidget(
                    icon: Icons.book,
                    buttonName: 'Anamnese',
                    notificacao: false,
                    color: Colors.black,
                    onPressed: () {

                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AnamneseListarAnamnese(
                                alunoIdGlobal: alunoIdLocal,
                                alunoNomeGlobal: alunoNomeLocal,
                              );
                            } 
                          )
                        );
                      
                    },
                  ),
                  HomeButtonWidget(
                    icon: Icons.auto_graph,
                    buttonName: 'Progressão',
                    notificacao: false,
                    color: Colors.black,
                    onPressed: () {

                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return CargaListarMusculos(
                                alunoIdGlobal: alunoIdLocal,
                                personalIdGlobal: professorIdLocal,
                              );
                            } 
                          )
                        );
                      
                    },
                  ),
                ],
              ),
            )
            /*Container(
              width: MediaQuery.of(context).size.width/1.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: GestureDetector(
                      onTap: (){
                        print("Clicou");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AlunosListarTreino(
                                alunoIdGlobal: alunoIdLocal,
                                alunoNomeGlobal: alunoNomeLocal,
                                objetivoIdGlobal: 1,
                              );
                            } 
                          )
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                        ),
                        height: 33,
                        width: MediaQuery.of(context).size.width/2,
                        child: Center(
                          child: Text(
                            "Treinos",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: GestureDetector(
                      onTap: (){
                        print("Clicou");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AlunosListarTreino(
                                alunoIdGlobal: alunoIdLocal,
                                alunoNomeGlobal: alunoNomeLocal,
                                objetivoIdGlobal: 1,
                              );
                            } 
                          )
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                        ),
                        height: 33,
                        width: MediaQuery.of(context).size.width/2,
                        child: Center(
                          child: Text(
                            "Avaliações",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: GestureDetector(
                      onTap: (){
                        print("Clicou");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AlunosListarTreino(
                                alunoIdGlobal: alunoIdLocal,
                                alunoNomeGlobal: alunoNomeLocal,
                                objetivoIdGlobal: 1,
                              );
                            } 
                          )
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                        ),
                        height: 33,
                        width: MediaQuery.of(context).size.width/2,
                        child: Center(
                          child: Text(
                            "Anamnese",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                    child: GestureDetector(
                      onTap: (){
                        print("Clicou");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AlunosListarTreino(
                                alunoIdGlobal: alunoIdLocal,
                                alunoNomeGlobal: alunoNomeLocal,
                                objetivoIdGlobal: 1,
                              );
                            } 
                          )
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                        ),
                        height: 33,
                        width: MediaQuery.of(context).size.width/2,
                        child: Center(
                          child: Text(
                            "Progressão",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  //widgetRolagemAlunos(),
                ],
              ),
            ),*/
          ]
          ),
        )
    );
  }

  widgetListaRolagem() {
    return Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          child: Container(
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
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              children: [
                                MaterialButton(
                                  padding: EdgeInsets.all(0.0),
                                  onPressed: () {
                                    setState(() {
                                        if(idSelecionado == alunos[index]['id']){
                                          alunoSelecionado = !alunoSelecionado;
                                          idSelecionado = 0;
                                        }else{
                                          alunoSelecionado = true;
                                          idSelecionado = alunos[index]['id'];
                                          nomeSelecionado = alunos[index]['nome'];
                                          print("Objetivo = $objetivoIdLocal");
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.blue[400] : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(4.0),
                                          bottomRight: Radius.circular(4.0),
                                          topLeft: Radius.circular(4.0),
                                          bottomLeft: Radius.circular(4.0)
                                        )
                                      ),
                                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width/6,
                                              padding: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  bottomLeft: Radius.circular(4.0)
                                                ),
                                                color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Color.fromARGB(255, 14, 93, 158) : Colors.blue[400]
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Gênero:",
                                                    style: TextStyle(
                                                      color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.white : Colors.black,
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                  Text(
                                                    alunos[index]['sexo'],
                                                    style: TextStyle(
                                                      color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.white : Colors.black,
                                                      fontSize: 13.0
                                                    ),
                                                    
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    "Idade:",
                                                    style: TextStyle(
                                                      color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.white : Colors.black,
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                  Text(
                                                    "${alunos[index]['idade']}",
                                                    style: TextStyle(
                                                      color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.white : Colors.black,
                                                      fontSize: 15.0
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      alunos[index]['nome'],  
                                                      overflow: TextOverflow.fade,                          
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13.0,
                                                        fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "CPF: ",                            
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0,
                                                            fontWeight: FontWeight.normal
                                                          ),
                                                        ),
                                                        Text(
                                                          alunos[index]['cpf'],                            
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15.0
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 3,
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
        )
    );
  }
}

indicadorProgresso(){
  return Expanded(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: Container(
        child: Center(
          child: CircularProgressIndicator()
        )
      ),
    ),
  );
}

 