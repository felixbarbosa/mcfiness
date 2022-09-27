import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_exercicio.dart';
import  'package:circular_countdown/circular_countdown.dart';
import 'package:timer_controller/timer_controller.dart';

enum SingingCharacter { nome, cnpj }

class TreinosListarTreinosMusculo extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final int musculoIdGlobal;
  final String urlImagemGlobal;
  final String musculoNomeGlobal;
  final String nomeTreinoGlobal;
  final String diaSemanaDiaGlobal;
  final int diaSemanaIdGlobal;
  final int objetivoGlobal;

  const TreinosListarTreinosMusculo(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal,
      required this.musculoIdGlobal,
      required this.urlImagemGlobal,
      required this.musculoNomeGlobal,
      required this.nomeTreinoGlobal,
      required this.diaSemanaDiaGlobal,
      required this.diaSemanaIdGlobal,
      required this.objetivoGlobal
    }
  ) : super(key: key);

  @override
  _TreinosListarTreinosMusculoState createState() => _TreinosListarTreinosMusculoState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal,
    musculoIdLocal: musculoIdGlobal,
    urlImagemLocal: urlImagemGlobal,
    musculoNomeLocal: musculoNomeGlobal,
    diaSemanaDiaLocal: diaSemanaDiaGlobal,
    diaSemanaIdLocal: diaSemanaIdGlobal,
    nomeTreinoLocal: nomeTreinoGlobal,
    objetivoLocal: objetivoGlobal
  );
}

bool termoMaiorTres = false;

class _TreinosListarTreinosMusculoState extends State<TreinosListarTreinosMusculo> with TickerProviderStateMixin {

  final int alunoIdLocal;
  final String alunoNomeLocal;
  final int musculoIdLocal;
  final String urlImagemLocal;
  final String musculoNomeLocal;
  final String nomeTreinoLocal;
  final String diaSemanaDiaLocal;
  final int diaSemanaIdLocal;
  final int objetivoLocal;

  _TreinosListarTreinosMusculoState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal,
      required this.musculoIdLocal,
      required this.urlImagemLocal,
      required this.musculoNomeLocal,
      required this.nomeTreinoLocal,
      required this.diaSemanaDiaLocal,
      required this.diaSemanaIdLocal,
      required this.objetivoLocal
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
  String instrucao = "";
  String descansoQuery = "";
  //String entidadeIdQuery = entidadeId; 

  bool loading = false;
  bool alunoSelecionado = false;
  int idSelecionado = 0;
  int numeroSeries = 1;
  int tempoDescanso = 0;
  bool isButtonDisable = false;
  bool mostrarExplicacao = false;
  bool iniciarTreino= false;
  bool clicouIniciarExercicio = false;
  bool fimDeSerie= false;

  List treinos = [];

  final pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.1
  );

  late final TimerController _controller;

  Future<void> _treinosPorMusculoAluno() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.treinoPorAlunoPorMusculo(
        alunoIdLocal,
        musculoIdLocal,
        nomeTreinoLocal
      );

      print("aqui");
      

      if (result['obterTreinoAlunoPorMusculo'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          treinos = result['obterTreinoAlunoPorMusculo'];
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
    _treinosPorMusculoAluno();
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
          backgroundColor: Colors.blue[400],
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: 
          [
            Container(
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
                    child: Column(
                      children: [
                        Text(
                          "Treinos - $alunoNomeLocal",
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                        Text(
                          "$musculoNomeLocal",
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ],
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

                          setState(() {
                            iniciarTreino = true;
                          });

                        },
                        color: Colors.black,
                        child: Text(
                          'Iniciar Treino',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        color: Colors.black,
                        child: Text(
                          'Finalizar Treino',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
            ),
          ),
          mostrarExplicacao ?
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black87.withOpacity(0.8),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[400],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  mostrarExplicacao = false;
                                });
                              }, 
                              icon: Icon(
                                Icons.close
                              )
                            )
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        child: Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.withOpacity(0.7),
                        child: Text(
                          instrucao
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ): 
          iniciarTreino ? 
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black87.withOpacity(0.8),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[400],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  iniciarTreino = false;
                                });
                              }, 
                              icon: Icon(
                                Icons.close
                              )
                            )
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: PageView.builder(
                            //physics: NeverScrollableScrollPhysics(),
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index){

                              descansoQuery =  treinos[index]['descanso'];

                              tempoDescanso = (60*int.parse(descansoQuery.substring(0,1))) + int.parse(descansoQuery.substring(2,4));

                              return ListTile(
                                minVerticalPadding: 0,
                                title: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    treinos[index]['exercicio']['urlImagem'] == null ? "assets/Erro.png" : treinos[index]['exercicio']['urlImagem']
                                                  ),
                                                  fit: BoxFit.fill
                                                ),
                                                //color: Colors.lightGreen[400]
                                              ),
                                            ),
                                            index + 1  < treinos.length ?
                                            Container(
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [ 
                                                    Icon(
                                                      Icons.chevron_right,
                                                      color: Colors.blue,
                                                      size: 50,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ) :
                                            Container()
                                          ]
                                        ),
                                      ),
                                      Text(
                                        treinos[index]['exercicio']['descricao'],
                                        style: TextStyle(
                                          color: Colors.black
                                        ),
                                      ),
                                      RaisedButton(
                                        onPressed: () async {
                                          if(!clicouIniciarExercicio){
                                            setState(() {
                                              clicouIniciarExercicio = true;
                                            });
                                          }else{
                                            setState(() {
                                              fimDeSerie = true;
                                            });
                                          }
                                        },
                                        color: (clicouIniciarExercicio && fimDeSerie) ? Colors.grey : Color.fromARGB(255, 238, 238, 238),
                                        child: Text(
                                          clicouIniciarExercicio ? 'Fim da ${numeroSeries}º série' : 'Iniciar Exercicio',
                                          style: TextStyle(
                                            color: (clicouIniciarExercicio && fimDeSerie) ? Colors.white : Colors.blue[400]
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0)
                                        ),
                                      ),
                                      fimDeSerie ? 
                                      TimeCircularCountdown(
                                        unit: CountdownUnit.second,
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20
                                        ),
                                        countdownTotal: tempoDescanso,
                                        onUpdated: (unit, remainingTime) => print('Updated'),
                                        onFinished: () => setState(() {
                                          fimDeSerie = false;

                                          if(numeroSeries == int.parse(treinos[index]['series'])){

                                            numeroSeries = 1;

                                            if(index + 1 < treinos.length){
                                              pageController.nextPage(
                                                duration: Duration(milliseconds: 400), 
                                                curve: Curves.easeIn
                                              );
                                            }else{
                                              iniciarTreino = false;
                                            }
                                            
                                          }else{
                                            numeroSeries++;
                                          }
                                          
                                        }),
                                        countdownRemainingColor: Colors.blue,
                                        countdownCurrentColor: Colors.blue,
                                        countdownTotalColor: Colors.grey,
                                        repeat: false,
                                      ) : Container()
                                    ],
                                  ),
                                )
                              );
                            },
                            itemCount: treinos.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          :Container()
          ]
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
                return _treinosPorMusculoAluno();
              },
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    print("URL: $urlImagemLocal");
                    return ListTile(
                        title: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                              children: [
                                Container(
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width/1.127,
                                    decoration: BoxDecoration(
                                      color: (alunoSelecionado && idSelecionado == treinos[index]['musculoAlvo']['id']) ? Colors.blue[400] : Colors.white,
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width/6,
                                            height: 200,
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(treinos[index]['exercicio']['urlImagem'] == null ? 
                                                urlImagemLocal :
                                                treinos[index]['exercicio']['urlImagem']
                                              ),
                                                fit: BoxFit.contain
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                bottomLeft: Radius.circular(4.0)
                                              ),
                                              color: Colors.white
                                            ),
                                          ),
                                          Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      treinos[index]['variacaoExercicio'] == null ? 
                                                      treinos[index]['exercicio']['descricao'] :
                                                      treinos[index]['variacaoExercicio']['descricao'],  
                                                      overflow: TextOverflow.fade,                          
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 30.0,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    RaisedButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          mostrarExplicacao = true;
                                                          instrucao = treinos[index]['instrucao'] == null ? "Sem Instrução" : treinos[index]['instrucao'];
                                                        });
                                                      },
                                                      color: Color.fromARGB(255, 238, 238, 238),
                                                      child: Text(
                                                        'Explicação Detalhada',
                                                        style: TextStyle(
                                                          color: Colors.blue[400]
                                                        ),
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ),
                                          Flexible(
                                              child: Container(
                                                color: Color.fromARGB(255, 235, 229, 229),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Icon(
                                                              Icons.check,
                                                              color: Colors.blue[400],
                                                              size: 30,
                                                            ),
                                                            Text(
                                                              treinos[index]['series'],  
                                                              overflow: TextOverflow.fade,                          
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 20.0,
                                                                fontWeight: FontWeight.normal
                                                              ),
                                                            ),
                                                            Text(
                                                              "SÉRIES",  
                                                              overflow: TextOverflow.fade,                          
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 10.0,
                                                                fontWeight: FontWeight.normal
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width/4,
                                                        ),
                                                        Column(
                                                          children: [
                                                            Icon(
                                                              Icons.repeat,
                                                              color: Colors.blue[400],
                                                              size: 30,
                                                            ),
                                                            Text(
                                                              treinos[index]['repeticoes'],  
                                                              overflow: TextOverflow.fade,                          
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 20.0,
                                                                fontWeight: FontWeight.normal
                                                              ),
                                                            ),
                                                            Text(
                                                              "REPETIÇÕES",  
                                                              overflow: TextOverflow.fade,                          
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 10.0,
                                                                fontWeight: FontWeight.normal
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.speed,
                                                                color: Colors.blue[400],
                                                                size: 30,
                                                              ),
                                                              Text(
                                                                treinos[index]['velocidade'],  
                                                                overflow: TextOverflow.fade,                          
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 20.0,
                                                                  fontWeight: FontWeight.normal
                                                                ),
                                                              ),
                                                              Text(
                                                                "VELOCIDADE",  
                                                                overflow: TextOverflow.fade,                          
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 10.0,
                                                                  fontWeight: FontWeight.normal
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: treinos[index]['velocidade'] == "Cadenciado" ? 5 : 20,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.timer,
                                                                color: Colors.blue[400],
                                                                size: 30,
                                                              ),
                                                              Text(
                                                                treinos[index]['descanso'],  
                                                                overflow: TextOverflow.fade,                          
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 20.0,
                                                                  fontWeight: FontWeight.normal
                                                                ),
                                                              ),
                                                              Text(
                                                                "DESCANSO",  
                                                                overflow: TextOverflow.fade,                          
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 10.0,
                                                                  fontWeight: FontWeight.normal
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ),
                                        ],
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

  /*widgetListaRolagem() {
    return Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          child: Container(
            child: RefreshIndicator(
              color: Colors.blue[400],
              onRefresh: (){
                return _treinosPorMusculoAluno();
              },
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    print("URL: $urlImagemLocal");
                    return ListTile(
                        title: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              children: [
                                Container(
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width/1.127,
                                    decoration: BoxDecoration(
                                      color: (alunoSelecionado && idSelecionado == treinos[index]['musculoAlvo']['id']) ? Colors.blue[400] : Colors.white,
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
                                                  treinos[index]['exercicio']['descricao'] == "Supino Reto" ? 
                                                    "assets/supino_reto_gif.gif" : 
                                                  treinos[index]['exercicio']['descricao'] == "Supino Inclinado" ? 
                                                    "assets/supino_inclinado_gif.webp" : 
                                                  treinos[index]['exercicio']['descricao'] == "Fly" ? 
                                                    "assets/voador_gif.webp" : 
                                                  treinos[index]['exercicio']['descricao'] == "Crossover " ? 
                                                    "assets/crossover_alta_gif.gif" : "assets/peito.jpg"
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
                                                    treinos[index]['exercicio']['descricao'],  
                                                    overflow: TextOverflow.fade,                          
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Séries: ",  
                                                        overflow: TextOverflow.fade,                          
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      Text(
                                                        treinos[index]['series'],  
                                                        overflow: TextOverflow.fade,                          
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Repetições: ",  
                                                        overflow: TextOverflow.fade,                          
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      Text(
                                                        treinos[index]['repeticoes'],  
                                                        overflow: TextOverflow.fade,                          
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Velocidade: ",  
                                                        overflow: TextOverflow.fade,                          
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      Text(
                                                        treinos[index]['velocidade'],  
                                                        overflow: TextOverflow.fade,                          
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Descanso: ",  
                                                        overflow: TextOverflow.fade,                          
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      Text(
                                                        treinos[index]['descanso'],  
                                                        overflow: TextOverflow.fade,                          
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ],
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
  }*/
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

 