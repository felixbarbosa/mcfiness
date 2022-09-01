import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/carga.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_exercicio.dart';
import  'package:circular_countdown/circular_countdown.dart';
import 'package:timer_controller/timer_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

enum SingingCharacter { nome, cnpj }

class TreinosListarTreinosDia extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final int musculoIdGlobal;
  final String urlImagemGlobal;
  final String musculoNomeGlobal;
  final String nomeTreinoGlobal;
  final String diaSemanaDiaGlobal;
  final int diaSemanaIdGlobal;
  final int objetivoGlobal;

  const TreinosListarTreinosDia(
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
  _TreinosListarTreinosDiaState createState() => _TreinosListarTreinosDiaState(
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

class _TreinosListarTreinosDiaState extends State<TreinosListarTreinosDia> with TickerProviderStateMixin {

  final int alunoIdLocal;
  final String alunoNomeLocal;
  final int musculoIdLocal;
  final String urlImagemLocal;
  final String musculoNomeLocal;
  final String nomeTreinoLocal;
  final String diaSemanaDiaLocal;
  final int diaSemanaIdLocal;
  final int objetivoLocal;

  _TreinosListarTreinosDiaState(
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
  int exercicioSelecionado = 0;
  String nomeExercicio = "";
  String urlPassada = "";
  String cargaExercicio = "";
  //String entidadeIdQuery = entidadeId; 

  bool loading = false;
  bool alunoSelecionado = false;
  int idSelecionado = 0;
  int numeroSeries = 1;
  int tempoDescanso = 0;
  bool isButtonDisable = false;
  bool cargaEditavel = true;
  bool mostrarExplicacao = false;
  bool iniciarTreino= false;
  bool clicouIniciarExercicio = false;
  bool abrirVideo = false;
  bool fimDeSerie= false;
  bool temVideo = false;
  String dataCarga = "";

  List treinos = [];
  List<int> exerciciosFinalizados = [];

  final pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.1
  );

  late final TimerController _controller;
  final _scrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  
  late ChewieController chewieController;
  late VideoPlayerController _controllerLocal;

  carregarUrlVideo(String urlPassada) async {

    if(urlPassada != ""){

      setState(() {
        loading = true;
        temVideo = true;
        _controllerLocal = VideoPlayerController.network(urlPassada);
        
      });

      await _controllerLocal.initialize();

      setState(() {

        chewieController = ChewieController(
          videoPlayerController: _controllerLocal,
          autoPlay: true,
          looping: true
        );

        if(mostrarExplicacao == true){
          if(chewieController.videoPlayerController.value.isInitialized){
            print("Inicializado");
            abrirVideo = true;
            loading = false;
          }else{
            print("Não Inicializado");
          }
          //clicouVideo = false;
        }
        
      });

    }else{
      setState(() {
        abrirVideo = false;
        temVideo = false;
      });
    }

    
  }

  video(String urlPassada) {

    return Container(
      height: 250,
      child: Center(
          child: (
            AspectRatio(
              aspectRatio: 1,
              child: Chewie(
                controller: chewieController
              ),
            )
          ),
        ),
    );
    
  }

  Future<void> _salvarCargaExercicioAluno() async {

    try{

      Map<String, dynamic> result = await Graphql.salvarCargaExercicioAluno(Carga(
        id: 0,
        aluno: alunoIdLocal,
        carga: cargaExercicio,
        exercicio: exercicioSelecionado,
        data: dataCarga
      )
      );

      print("aqui");
      

      if (result['salvarCarga']['id'] >= 0) {
        print("Salvou");

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Não foi possivel registrar a carga do exercicio'),
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


  Future<void> _treinosPorAlunoPorDia() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.treinoPorAlunoPorDia(
        alunoIdLocal,
        diaSemanaIdLocal
      );

      print("aqui");
      

      if (result['obterTreinoAlunoPorDia'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          treinos = result['obterTreinoAlunoPorDia'];
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
    _treinosPorAlunoPorDia();
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
                          "$nomeTreinoLocal",
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
                          if((treinos.length == exerciciosFinalizados.length)){
                            Navigator.pop(context);
                          }
                        },
                        color: (treinos.length == exerciciosFinalizados.length) ? Colors.black : Colors.grey,
                        child: Text(
                          'Finalizar Treino',
                          style: TextStyle(
                            color: (treinos.length == exerciciosFinalizados.length) ? Colors.white : Colors.black
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
                                  abrirVideo = false;

                                  if(temVideo == true){
                                    chewieController.pause();
                                  }
                                  
                                });
                              }, 
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              )
                            )
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        child: loading ? indicadorProgresso() : abrirVideo ? video(urlPassada) : semVideo()
                      ),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            instrucao,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ): Container()
          ]
        )
    );
  }

  semVideo(){
    return Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
    child: Container(
      height: 250,
      child: Center(
        child: Text(
          "Nenhum vídeo para esse exercicio",
          style: TextStyle(
            color: Colors.red
          ),
        )
      )
    ),
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
                return _treinosPorAlunoPorDia();
              },
              child: ScrollablePositionedList.builder(
                physics: fimDeSerie ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemScrollController: itemScrollController,
                  itemBuilder: (BuildContext context, int index) {
                    print("URL: $urlImagemLocal");
                    descansoQuery =  treinos[index]['descanso'];
                    tempoDescanso = (60*int.parse(descansoQuery.substring(0,1))) + int.parse(descansoQuery.substring(2,4));

                    nomeExercicio = treinos[index]['variacaoExercicio'] == null ? 
                                      treinos[index]['exercicio']['descricao'] :
                                      treinos[index]['variacaoExercicio']['descricao'];
                    
                    return ListTile(
                        title: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                              children: [
                                Container(
                                    height: (fimDeSerie && (exercicioSelecionado == treinos[index]['exercicio']['id'])) ? 
                                              MediaQuery.of(context).size.height/1.35 : MediaQuery.of(context).size.height/1.55,
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
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width/6,
                                              height: 200,
                                              padding: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(treinos[index]['exercicio']['urlImagem'] == null ? 
                                                  "assets/Erro.png" :
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
                                            Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Text(
                                                        nomeExercicio,  
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
                                                            urlPassada = treinos[index]['exercicio']['urlVideo'] == null ? "" : treinos[index]['exercicio']['urlVideo'];
                                                            carregarUrlVideo(urlPassada);
                                                            mostrarExplicacao = true;
                                                            instrucao = treinos[index]['exercicio']['instrucao'] == null ? "Sem Instrução" : treinos[index]['exercicio']['instrucao'];
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
                                                      RaisedButton(
                                                        onPressed: () async {

                                                          if(exercicioSelecionado == treinos[index]['exercicio']['id'] || exercicioSelecionado == 0){
                                                            if(!clicouIniciarExercicio){
                                                              setState(() {
                                                                clicouIniciarExercicio = true;
                                                                cargaEditavel = false;
                                                                exercicioSelecionado = treinos[index]['exercicio']['id'];
                                                              });
                                                            }else{
                                                              setState(() {
                                                                fimDeSerie = true;
                                                                exercicioSelecionado = treinos[index]['exercicio']['id'];
                                                              });
                                                            }
                                                          }
                                                          
                                                        },
                                                        color: ((clicouIniciarExercicio && fimDeSerie) || (exercicioSelecionado != 0 && exercicioSelecionado != treinos[index]['exercicio']['id'])) ? Colors.grey : Color.fromARGB(255, 238, 238, 238),
                                                        child: Text(
                                                          clicouIniciarExercicio ? 'Fim da ${numeroSeries}º série' : 'Iniciar Exercicio',
                                                          style: TextStyle(
                                                            color: ((clicouIniciarExercicio && fimDeSerie) || (exercicioSelecionado != 0 && exercicioSelecionado != treinos[index]['exercicio']['id'])) ? Colors.white : Colors.blue[400]
                                                          ),
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5.0)
                                                        ),
                                                      ),
                                                      (fimDeSerie && (exercicioSelecionado == treinos[index]['exercicio']['id'])) ? 
                                                      TimeCircularCountdown(
                                                        unit: CountdownUnit.second,
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20
                                                        ),
                                                        countdownTotal: 5,//tempoDescanso,
                                                        onUpdated: (unit, remainingTime) => print('Updated'),
                                                        onFinished: () => setState(() {
                                                          fimDeSerie = false;
                                    
                                                          if(numeroSeries == int.parse(treinos[index]['series'])){
                                    
                                                            numeroSeries = 1;

                                                            exerciciosFinalizados.add(exercicioSelecionado);

                                                            print("Carga a ser salva = $cargaExercicio");
                                                            print("Exercicio a ser salvo = ${treinos[index]['exercicio']['descricao']}");
                                                            print("Id do exercicio = $exercicioSelecionado");
                                                            print("Data: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");

                                                            dataCarga = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

                                                            _salvarCargaExercicioAluno();

                                                            clicouIniciarExercicio = false;

                                                            cargaEditavel = true;

                                                            exercicioSelecionado = 0;
                                    
                                                            if(index + 1 < treinos.length){

                                                              setState(() {
                                                                itemScrollController.scrollTo(
                                                                  index: index+1,
                                                                  duration: Duration(seconds: 1),
                                                                  curve: Curves.easeInOutCubic);
                                                              });

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
                                                ),
                                            ),
                                            Flexible(
                                                child: Container(
                                                  color: Color.fromARGB(255, 235, 229, 229),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
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
                                                            width: MediaQuery.of(context).size.width/5,
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
                                                          SizedBox(
                                                            width: MediaQuery.of(context).size.width/5,
                                                          ),
                                                          Column(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.line_weight,
                                                                color: Colors.blue[400],
                                                                size: 30,
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              SizedBox(
                                                                height: 25,
                                                                width: 45,
                                                                child: IgnorePointer(
                                                                  ignoring: !cargaEditavel,
                                                                  child: TextFormField(
                                                                    keyboardType: TextInputType.number,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      color: Colors.black
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                      contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                                      fillColor: Colors.white,
                                                                      filled: true,
                                                                      border: new OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                      ),
                                                                      //hintText: estoques[index]['quantidade'].toString(),
                                                                      hintStyle: TextStyle(color: Colors.black),
                                                                    ),
                                                                    onChanged: (value){
                                                                
                                                                      setState(() {
                                                                        //modificouEstoque = true;
                                                                      });
                                                                
                                                                      print(value);
                                                                      //print("Tamanho do array = ${estoquesLocais.length}");
                                                                      if(value.isEmpty){
                                                                        print("Vazio");
                                                                        cargaExercicio = "";
                                                                      }else{
                                                                        cargaExercicio = value;
                                                                      }
                                                                      
                                                                      //produtoIdTemporiario = int.parse(estoques[index]['produto']['id']);
                                                                      //giroVendaDiaTemporario = estoques[index]['giroVendaDia'];
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                "CARGA",  
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
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ),
                                          ],
                                        ),
                                      exerciciosFinalizados.contains(treinos[index]['exercicio']['id']) ?
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.green.withOpacity(0.3),
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 300,
                                          ),
                                        ),
                                      ) : Container()
                                      ]
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
                return _treinosPorAlunoPorDia();
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
  return Padding(
  padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
  child: Container(
    height: 250,
    child: Center(
      child: CircularProgressIndicator()
    )
  ),
    );
}

 