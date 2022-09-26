import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treino_nome.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treinos_musculo.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_aluno.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_treino.dart';

enum SingingCharacter { nome, cnpj }

class AlunosListarTreino extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final int objetivoIdGlobal;

  const AlunosListarTreino(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal,
      required this.objetivoIdGlobal
    }
  ) : super(key: key);

  @override
  _AlunosListarTreinoState createState() => _AlunosListarTreinoState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal,
    objetivoIdLocal: objetivoIdGlobal
  );
}

bool termoMaiorTres = false;

class _AlunosListarTreinoState extends State<AlunosListarTreino> {

  final int alunoIdLocal;
  final String alunoNomeLocal;
  final int objetivoIdLocal;

  _AlunosListarTreinoState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal,
      required this.objetivoIdLocal
    }
  );

  String urlImagemLocal = "";
  String musculoNomeLocal = "";
  String nomeTreino = "";
  String diaSemanaDia = "";
  String idSelecionado = "";

  int diaSemanaId = 0;
  int objetivoLocal = 0;

  bool loading = false;
  bool treinoSelecionado = false;

  List treinos = [];

  Future<void> _treinosAluno() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.treinosPorAluno(alunoIdLocal);

      print("aqui");
      

      if (result['obterTreinoAluno'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          treinos = result['obterTreinoAluno'];
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
        padding: EdgeInsets.fromLTRB(0, 0, 15, 20),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {

            var tela = await Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => AlunosNovoTreino(
                  alunoIdGlobal: alunoIdLocal,
                  diaSemanaIdGlobal: diaSemanaId,
                  nomeTreinoGlobal: nomeTreino,
                  alunoNomeGlobal: alunoNomeLocal,
                )
              )
            );

            if(tela == 1){
              _treinosAluno();
              treinoSelecionado = false;
              idSelecionado = "";
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
                    "Treinos - $alunoNomeLocal",
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
                                        
                                        if(idSelecionado == treinos[index]['nome']){
                                          treinoSelecionado = !treinoSelecionado;
                                          idSelecionado = "";
                                          nomeTreino = "";
                                          diaSemanaId = 0;
                                          diaSemanaDia = "";
                                        }else{
                                          Navigator.push(
                                            context, MaterialPageRoute(
                                              builder: (context) => AlunosListarTreinoNome(
                                                alunoIdGlobal: alunoIdLocal,
                                                alunoNomeGlobal: alunoNomeLocal,
                                                treinoNomeGlobal: treinos[index]['nome'],
                                                diaSemanaIdGlobal: treinos[index]['diaSemana']['id'],
                                                objetivoIdGlobal: objetivoIdLocal,
                                              )
                                            )
                                          );
                                          treinoSelecionado = true;
                                          idSelecionado = treinos[index]['nome'];
                                          nomeTreino = treinos[index]['nome'];
                                          diaSemanaId = treinos[index]['diaSemana']['id'];
                                          diaSemanaDia = treinos[index]['diaSemana']['dia'];
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (treinoSelecionado && idSelecionado == treinos[index]['nome']) ? Colors.blue[400] : Colors.white,
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
                                              width: MediaQuery.of(context).size.width/6,
                                              height: 50,
                                              padding: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    "assets/peito.jpg"
                                                    /*treinos[index]['musculoAlvo']['descricao'] == "Ombro" ? 
                                                      "assets/ombro.jpg" : 
                                                    treinos[index]['musculoAlvo']['descricao'] == "Peito" ?
                                                      "assets/peito.jpg" : "assets/triceps.jpg"*/
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
                                                      treinos[index]['nome'],  
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

 