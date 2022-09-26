import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treinos_musculo.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_treino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

enum SingingCharacter { nome, cnpj }

class AlunosListarTreinoNome extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final String treinoNomeGlobal;
  final int diaSemanaIdGlobal;
  final int objetivoIdGlobal;

  const AlunosListarTreinoNome(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal,
      required this.treinoNomeGlobal,
      required this.diaSemanaIdGlobal,
      required this.objetivoIdGlobal
    }
  ) : super(key: key);

  @override
  _AlunosListarTreinoNomeState createState() => _AlunosListarTreinoNomeState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal,
    treinoNomeLocal: treinoNomeGlobal,
    diaSemanaIdLocal: diaSemanaIdGlobal,
    objetivoIdLocal: objetivoIdGlobal
  );
}

bool termoMaiorTres = false;

class _AlunosListarTreinoNomeState extends State<AlunosListarTreinoNome> {

  final int alunoIdLocal;
  final String alunoNomeLocal;
  final String treinoNomeLocal;
  final int diaSemanaIdLocal;
  final int objetivoIdLocal;

  _AlunosListarTreinoNomeState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal,
      required this.treinoNomeLocal,
      required this.diaSemanaIdLocal,
      required this.objetivoIdLocal
    }
  );

  String urlImagemLocal = "";
  String musculoNomeLocal = "";
  String nomeTreino = "";
  String diaSemanaDia = "";

  int diaSemanaId = 0;
  int objetivoLocal = 0;
  int idSelecionado = 0;

  bool loading = false;
  bool treinoSelecionado = false;
  bool isButtonDisable = false;

  List treinos = [];

  Future<void> _treinosAluno() async {

    setState(() {
      loading = true;
    });

    print("Aluno Id = $alunoIdLocal");
    print("Nome Treino = $treinoNomeLocal");

    try{

      Map<String, dynamic> result = await Graphql.treinosPorAlunoNome(alunoIdLocal, treinoNomeLocal);

      print("aqui");
      

      if (result['obterTreinoAlunoNome'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          treinos = result['obterTreinoAlunoNome'];
        });

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum treino cadastrado para esse aluno'),
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
    setState(() {
      loading = true;
      termoMaiorTres = true;
    });
    _treinosAluno();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15, 20),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {

            var tela = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AlunosNovoTreino(
                alunoIdGlobal: alunoIdLocal,
                alunoNomeGlobal: alunoNomeLocal,
                diaSemanaIdGlobal: diaSemanaIdLocal,
                nomeTreinoGlobal: treinoNomeLocal,
                )));

            if(tela == 1){
              setState(() {
                _treinosAluno();
              });
            }

          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
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
          child: Column(children: [
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color.fromARGB(255, 132, 136, 139),
                child: Center(
                  heightFactor: 1.5,
                  child: Text(
                    "$treinoNomeLocal - $alunoNomeLocal",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
            loading ? indicadorProgresso() : widgetListaRolagem(),
            SizedBox(
              height: 2,
            ),
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
                return _treinosAluno();
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
                                        if(idSelecionado == treinos[index]['musculoAlvo']['id']){
                                          treinoSelecionado = !treinoSelecionado;
                                          idSelecionado = 0;
                                        }else{
                                          Navigator.push(
                                            context, MaterialPageRoute(
                                              builder: (context) => AlunosListarTreinosMusculo(
                                                alunoIdGlobal: alunoIdLocal,
                                                alunoNomeGlobal: alunoNomeLocal,
                                                musculoIdGlobal: treinos[index]['musculoAlvo']['id'],
                                                urlImagemGlobal: "assets/ombro.jpg",
                                                musculoNomeGlobal: treinos[index]['musculoAlvo']['descricao'],
                                                diaSemanaDiaGlobal: treinos[index]['diaSemana']['dia'],
                                                diaSemanaIdGlobal: treinos[index]['diaSemana']['id'],
                                                nomeTreinoGlobal: nomeTreino,
                                                objetivoGlobal: objetivoLocal,
                                              )
                                            )
                                          );
                                          treinoSelecionado = true;
                                          idSelecionado = treinos[index]['musculoAlvo']['id'];
                                          musculoNomeLocal = treinos[index]['musculoAlvo']['descricao'];
                                          urlImagemLocal = treinos[index]['musculoAlvo']['descricao'] == "Ombro" ? 
                                            "assets/ombro.jpg" : 
                                          treinos[index]['musculoAlvo']['descricao'] == "Peito" ?
                                            "assets/peito.jpg" : "assets/triceps.jpg";
                                          nomeTreino = treinos[index]['nome'];
                                          diaSemanaId = treinos[index]['diaSemana']['id'];
                                          diaSemanaDia = treinos[index]['diaSemana']['dia'];
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (treinoSelecionado && idSelecionado == treinos[index]['musculoAlvo']['id']) ? Colors.blue[400] : Colors.white,
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
                                              height: 50,
                                              padding: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    treinos[index]['musculoAlvo']['descricao'] == "Ombro" ? 
                                                      "assets/ombro.jpg" : 
                                                    treinos[index]['musculoAlvo']['descricao'] == "Peito" ?
                                                      "assets/peito.jpg" : treinos[index]['musculoAlvo']['descricao'] == "Tríceps" ?
                                                      "assets/triceps.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Costas" ?
                                                      "assets/costas.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Biceps" ?
                                                      "assets/biceps.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Quadriceps" ?
                                                      "assets/quadriceps.png" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Posterior de Coxa" ?
                                                      "assets/posterior.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Panturrilha" ?
                                                      "assets/panturrilha.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Abdomen" ?
                                                      "assets/abdomen.jpg" :
                                                      treinos[index]['musculoAlvo']['descricao'] == "Trapezio" ?
                                                      "assets/trapezio.jpg" :
                                                      treinos[index]['musculoAlvo']['descricao'] == "Ante Braço" ?
                                                      "assets/antebraco.jpg" : "assets/triceps.jpg"
                                                  ),
                                                  fit: BoxFit.fill
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  bottomLeft: Radius.circular(4.0)
                                                ),
                                                color: Colors.purple
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
                                                      treinos[index]['musculoAlvo']['descricao'],  
                                                      overflow: TextOverflow.fade,                          
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15.0,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 12,
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
                  itemCount: treinos.length
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

 