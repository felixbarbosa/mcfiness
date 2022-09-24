import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_aluno.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_exercicio.dart';

enum SingingCharacter { nome, cnpj }

class AlunosListarTreinosMusculo extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final int musculoIdGlobal;
  final String urlImagemGlobal;
  final String musculoNomeGlobal;
  final String nomeTreinoGlobal;
  final String diaSemanaDiaGlobal;
  final int diaSemanaIdGlobal;
  final int objetivoGlobal;

  const AlunosListarTreinosMusculo(
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
  _AlunosListarTreinosMusculoState createState() => _AlunosListarTreinosMusculoState(
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

class _AlunosListarTreinosMusculoState extends State<AlunosListarTreinosMusculo> {

  final int alunoIdLocal;
  final String alunoNomeLocal;
  final int musculoIdLocal;
  final String urlImagemLocal;
  final String musculoNomeLocal;
  final String nomeTreinoLocal;
  final String diaSemanaDiaLocal;
  final int diaSemanaIdLocal;
  final int objetivoLocal;

  _AlunosListarTreinosMusculoState(
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
  double valorMetaQuery = 0.0;
  String abertura = "";
  String fechamento = "";
  String clienteNome = "";
  String urlPassada = "";
  String instrucao = "";

  bool loading = false;
  bool alunoSelecionado = false;
  bool mostrarExplicacao = false;
  bool abrirVideo = false;
  int idSelecionado = 0;
  bool isButtonDisable = false;

  List treinos = [];

  late VoidCallback listener;
  late ChewieController chewieController;
  late VideoPlayerController _controllerLocal;

  carregarUrlVideo(String urlPassada) async {

    if(urlPassada != ""){

      setState(() {
        loading = true;
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

  Future<void> _treinosPorMusculoAluno() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.treinoPorAlunoPorMusculo(
        alunoIdLocal,
        musculoIdLocal
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

  loadImages() async {
    // final SharedPreferences prefs = await _prefs;
    // arquivos = prefs.getStringList('images') ?? [];

    // if (arquivos.isEmpty) {
    //refs = (await storage.ref('images').listAll()).items;
    Reference ref = FirebaseStorage.instance.ref().child('videos/Victor-Puxada Alta');

    print("URL = ${ref.getDownloadURL()}");
    /*for (var ref in refs) {
      final arquivo = await ref.getDownloadURL();
      arquivos.add(arquivo);
    }*/
    // prefs.setStringList('images', arquivos);
    // }
    setState(() => loading = false);
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
        body: Stack(
          children: [
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
                          
                          var tela = await Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => AlunosNovoExercicio(
                                alunoIdGlobal: alunoIdLocal,
                                musculoIdGlobal: musculoIdLocal,
                                musculoNomeGlobal: musculoNomeLocal,
                                diaSemanaIdGlobal: diaSemanaIdLocal,
                                objetivoGlobal: objetivoLocal,
                                nomeTreinoGlobal: nomeTreinoLocal,
                              )
                            )
                          );
        
                          if(tela == 1){
                            _treinosPorMusculoAluno();
                          }
                        },
                        color: Colors.black,
                        child: Text(
                          'Adicionar Exercicio',
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
                                  abrirVideo = false;
                                  if(chewieController.videoPlayerController.value.isInitialized){
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
                                          Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      treinos[index]['exercicio']['descricao'],  
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
                                                          width: 5,
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

 