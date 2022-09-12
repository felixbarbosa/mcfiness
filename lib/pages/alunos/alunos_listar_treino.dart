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

  SingingCharacter? _character = SingingCharacter.nome;

  final _formKey = GlobalKey<FormState>();
  final termo = TextEditingController();

  String clienteQueryId = "";
  String pedidoId = "";
  String status = "";
  //String responsavelId = "Pegar id do usuario logado";
  double valorMetaQuery = 0.0;
  String abertura = "";
  String fechamento = "";
  String clienteNome = "";
  String urlImagemLocal = "";
  String musculoNomeLocal = "";
  String nomeTreino = "";
  String diaSemanaDia = "";
  int diaSemanaId = 0;
  int objetivoLocal = 0;
  //String entidadeIdQuery = entidadeId; 

  bool loading = false;
  bool treinoSelecionado = false;
  String idSelecionado = "";
  bool isButtonDisable = false;

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
      /*floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(
            size: 22,
            color: Colors.white
          ),
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.shop,
                color: Colors.white,
              ),
              backgroundColor: CustomColorTheme.primaryColor,
              onTap: () async { 

                var tela = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ClientesListarCanaisVendas(
                    entidadeGlobal: entidadeId, 
                    usuarioGlobal: usuarioId,
                    usuarioNomeGlobal: usuarioNomeLocal,
                    )));

                if(tela == 1){
                  setState(() {
                    _treinosAluno();
                  });
                }

              },
              label: 'Canal de Vendas',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0
              ),
              labelBackgroundColor: CustomColorTheme.primaryColor
            ),
          ]
        )
      ),*/
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
          backgroundColor: Colors.blue[400],
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
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
                color: Colors.blue[400],
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
            ButtonTheme(
              child: Container(
                color: Colors.blue[400],
                child: ButtonBar(
                  buttonMinWidth: 100,
                  alignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
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
                      color: Colors.black,
                      child: Text(
                        'Novo Treino',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if(treinoSelecionado){
                          Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => AlunosListarTreinoNome(
                              alunoIdGlobal: alunoIdLocal,
                              alunoNomeGlobal: alunoNomeLocal,
                              treinoNomeGlobal: nomeTreino,
                              diaSemanaIdGlobal: diaSemanaId,
                              objetivoIdGlobal: objetivoIdLocal,
                            )
                          )
                        );
                        }
                      },
                      color: treinoSelecionado ? Colors.black : Colors.grey,
                      child: Text(
                        'Ver Treino',
                        style: TextStyle(
                          color: treinoSelecionado ? Colors.white : Colors.black 
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ],
                ),
              ),
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

 