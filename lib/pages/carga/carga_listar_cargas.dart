import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/carga/carga_listar_exercicios.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_exercicios.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_variacoes.dart';
import 'package:mcfitness/pages/exercicios/exercicios_novo_exercicio.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

enum SingingCharacter { nome, cnpj }

class CargaListarCargas extends StatefulWidget {

  final int alunoIdGlobal;
  final int personalIdGlobal;
  final int exercicioIdGlobal;
  final String exercicioNomeGlobal;

  const CargaListarCargas(
    {
      Key? key, 
      required this.alunoIdGlobal,
      required this.personalIdGlobal,
      required this.exercicioIdGlobal,
      required this.exercicioNomeGlobal
    }
  ) : super(key: key);

  @override
  _musculosListarMusculosState createState() => _musculosListarMusculosState(
    alunoIdLocal: alunoIdGlobal,
    personalIdLocal: personalIdGlobal,
    exercicioIdLocal: exercicioIdGlobal,
    exercicioNomeLocal: exercicioNomeGlobal
  );
}

bool termoMaiorTres = false;

class _musculosListarMusculosState extends State<CargaListarCargas> {

  final int alunoIdLocal;
  final int personalIdLocal;
  final int exercicioIdLocal;
  final String exercicioNomeLocal;

  _musculosListarMusculosState({
    required this.alunoIdLocal,
    required this.personalIdLocal,
    required this.exercicioIdLocal,
    required this.exercicioNomeLocal
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
  String urlTeste = "";
  String nomeMusculo = "";
  int musculoId = 0;
  String nomeExercicio = "";
  String urlExercicio = "";
  //String entidadeIdQuery = entidadeId; 

  bool loading = false;
  bool cargaSelecionada = false;
  bool criadorExercicio = false;
  int idSelecionado = 0;
  bool isButtonDisable = false;
  String urlImagemLocal = "";
  String cargaInicio = "";
  String dataInicio = "";
  String cargaAtual = "";
  String dataAtual = "";
  //List cargaInicial = [];
  //List cargaAtual = [];
  List pedido_por_clientes = [];
  List<String> listaUrls = [];

  Future<void> _cargaInicialExercicioPorAluno() async {

    setState(() {
      loading = true;
    });

    print("Exercicio id = $exercicioIdLocal");

    try{

      Map<String, dynamic> result = await Graphql.obterPrimeiraCargaPorAlunoPorExercicio(
        alunoIdLocal,
        exercicioIdLocal
      );

      print("aqui");
      

      if (result['cargaInicial']['id'] > 0) {
        print("Resultado buscado");

        setState(() {
          dataInicio = result['cargaInicial']['data'];
          cargaInicio = result['cargaInicial']['carga'];
          urlExercicio = result['cargaInicial']['exercicio']['urlImagem'] == null ? "" : result['cargaInicial']['exercicio']['urlImagem'];
          _cargaAtualExercicioPorAluno();
        });

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum exercicio cadastrado'),
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

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Nenhuma carga registrada nesse exercicio!'),
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

      setState(() {
        cargaAtual = "-";
        cargaInicio = "-";
        dataAtual = "--/--/----";
        dataInicio = "--/--/----";
      });

    }
    
  }

  Future<void> _cargaAtualExercicioPorAluno() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.obterUltimaCargaPorAlunoPorExercicio(
        alunoIdLocal,
        exercicioIdLocal
      );

      print("aqui");
      

      if (result['cargaAtual']['id'] > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          dataAtual = result['cargaAtual']['data'];
          cargaAtual = result['cargaAtual']['carga'];
        });

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum exercicio cadastrado'),
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

  Future<void> _removerExercicios() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.removerExercicios(idSelecionado);

      print("aqui");
      

      if (result['deletarExercicio'] == true) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(
              milliseconds: 1000
            ),
            backgroundColor: Colors.green,
            content: Icon(
              Icons.check
            ),
          ),
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exercicio removido com sucesso!'),
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

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(
              milliseconds: 1000
            ),
            backgroundColor: Colors.red,
            content: Icon(
              Icons.error
            ),
          ),
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exercicio sendo utilizado em algum treino.'),
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
    _cargaInicialExercicioPorAluno();
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
                "Carga",
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
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color.fromARGB(255, 132, 136, 139),
                child: Center(
                    //padding: const EdgeInsets.fromLTRB(10.0, 10.0, 6.5, 10.0),
                    heightFactor: 1.5,
                    child: Column(
                      children: [
                        Text(
                          'Histórico de Carga',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white
                          ),
                        ),
                      ],
                    )
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
                return _cargaInicialExercicioPorAluno();
              },
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {

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
                                      color: Colors.white,
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
                                            decoration: urlExercicio != "" ? 
                                            BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  urlExercicio
                                                ),
                                                fit: BoxFit.fill
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                bottomLeft: Radius.circular(4.0)
                                              ),
                                              color: Colors.white
                                            ) : 
                                            BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                bottomLeft: Radius.circular(4.0)
                                              ),
                                              color: Colors.blue
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Flexible(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    exercicioNomeLocal,  
                                                    overflow: TextOverflow.fade,                          
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            dataInicio,  
                                                            overflow: TextOverflow.fade,                          
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                          Text(
                                                            "${cargaInicio}Kg",  
                                                            overflow: TextOverflow.fade,                          
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            dataAtual,  
                                                            overflow: TextOverflow.fade,                          
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                          Text(
                                                            "${cargaAtual}Kg",  
                                                            overflow: TextOverflow.fade,                          
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                              ],
                            ),
                          ),
                        ));
                  },
                  itemCount: 1
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

 