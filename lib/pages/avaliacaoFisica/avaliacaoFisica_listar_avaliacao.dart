import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/aluno.dart';
import 'package:mcfitness/model/treino.dart';
import 'package:numberpicker/numberpicker.dart';

enum SingingCharacter { padrao, personalizado }

class AvaliacaoFisicaListarAvaliacao extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;

  const AvaliacaoFisicaListarAvaliacao(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal
    }
  ) : super(key: key);

  @override
  _AvaliacaoFisicaListarAvaliacaoState createState() => _AvaliacaoFisicaListarAvaliacaoState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal
  );
}

class _AvaliacaoFisicaListarAvaliacaoState extends State<AvaliacaoFisicaListarAvaliacao> {

  final int alunoIdLocal;
  final String alunoNomeLocal;

  String abertura = "";
  String fechamento = "";

  _AvaliacaoFisicaListarAvaliacaoState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal
    }
  );

  SingingCharacter? _character = SingingCharacter.padrao;

  final _formKey = GlobalKey<FormState>();
  //final entidade = 5;

  int idLocal = 0;
  bool loading = false;
  bool produtoSelecionado = false;
  String idSelecionado = "";
  bool isButtonDisable = false;
  int musculoIdLocal = 0;
  int diaSemanaIdSelecionado = 0;
  String musculoNomeLocal = "";
  String treinoPadraoSelecionado = "";
  double valorUnitarioQuery = 0.0;
  final qtdVendida = TextEditingController();
  final estoque = TextEditingController();
  final giroMes = TextEditingController();
  final ultimoPreco = TextEditingController();
  int promocao = 0;
  double preco = 0.0;
  double desconto = 0.0;
  double totalItem = 0.0;
  String tabelaPreco = "";
  String txtQtde = "0";
  bool jaMudou = false;
  bool mostrarNumberPickerSeries = false;
  bool mostrarNumberPickerRepeticoes = false;
  bool mostrarNumberPickerDescanso = false;
  bool selecionouMusculo = false;
  bool selecionouExercicio = false;
  bool clicouSalvar = false;
  final similares = TextEditingController();
  final observacao = TextEditingController();
  int qtdVendidaInt = 0;
  String pessoaIdRetornado = "";
  String uf = "";
  String dataFormatadaInicio = "";
  String dataMostradaInicio = "";
  String dataFormatadaSelecionada = "";
  String dataMostradaSelecionada = "";
  String dia = "0";
  String mes = "0";
  String ano = "0";
  String exercicioSelecionado = "";
  String velocidadeSelecionada = "";
  String objetivo = "";
  String altura= "";
  String peso= "";
  String peitoral= "";
  String biceps= "";
  String anteBraco= "";
  String cintura= "";
  String abdome= "";
  String quadril= "";
  String coxaMedial= "";
  String fotoFrente= "";
  String fotoLado= "";
  String fotoCostas= "";
  String cirurgia= "";
  String dores= "";
  String problemaOrtopedico= "";
  String observacoes= "";
  int idade = 0;
  DateTime dataSelecionada = DateTime.now();

  bool isCheck = false;
  bool nomePadrao = true;
  bool nomePersonalizado = false;

  int numeroSeries = 3;
  int numeroRepeticoes = 10;
  int numeroDescansoMin = 1;
  int numeroDescansoSec = 0;
  int exercicioIdSelecionado = 0;

  bool temAvaliacao = false;

  List<String> exercicios = [];
  List<String> musculos = [];
  List<String> diasSemana = [];

  List<String> nomesPadroes = [
    'Treino A', 'Treino B', 'Treino C', 'Treino D', 'Treino E', 'Treino F', 'Treino G'
  ];

  List<String> velocidade = [
    'Cadenciado', 'Normal', 'Rápido'
  ];

  final GlobalKey<FormFieldState> _keyExercicio = GlobalKey<FormFieldState>();


  Future<void> _buscarAvaliacaoAluno() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.obterAvaliacaoPorAluno(alunoIdLocal);

      print("aqui");
      

      if (result['obterAvaliacaoPorAluno'].length > 0) {
        print("Resultado buscado");

        setState(() {
          temAvaliacao = true;
        });

        int index = result['obterAvaliacaoPorAluno'].length - 1;

        print("Objetivo = ${result['obterAvaliacaoPorAluno'][index]['objetivo']}");

        objetivo = result['obterAvaliacaoPorAluno'][index]['objetivo'];
        
        idade = result['obterAvaliacaoPorAluno'][index]['idate'];
        altura = result['obterAvaliacaoPorAluno'][index]['altura'];
        peso = result['obterAvaliacaoPorAluno'][index]['peso'].toString();
        
        peitoral = result['obterAvaliacaoPorAluno'][index]['peitoral'];
        biceps = result['obterAvaliacaoPorAluno'][index]['biceps'];
        anteBraco = result['obterAvaliacaoPorAluno'][index]['anteBraco'];
        cintura = result['obterAvaliacaoPorAluno'][index]['cintura'];
        abdome = result['obterAvaliacaoPorAluno'][index]['abdome'];
        
        quadril = result['obterAvaliacaoPorAluno'][index]['quadril'];
        coxaMedial = result['obterAvaliacaoPorAluno'][index]['coxa'];
        fotoFrente = result['obterAvaliacaoPorAluno'][index]['fotoFrente'];
        fotoLado = result['obterAvaliacaoPorAluno'][index]['fotoLado'];
        fotoCostas = result['obterAvaliacaoPorAluno'][index]['fotoCostas'];

        setState(() {
          loading = false;
        });

      } else {
        setState(() {
          temAvaliacao = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('O aluno ainda não preencheu a avaliação fisica...'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
    //_buscarDiasSemana();
    _buscarAvaliacaoAluno();
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
          body: Stack(
            children: 
              [
                Container(
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
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent) {
                      
                    }
                    return true;
                  },
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
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
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Avaliação Física',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        alunoNomeLocal,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10, 0.0),
                                  child: temAvaliacao ? 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Objetivo:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        objetivo,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Idade:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$idade anos",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Altura',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$altura metros",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Peso',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$peso Kg",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Peitoral:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$peitoral cm",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Bíceps:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$biceps cm",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Antebraço direito:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$anteBraco cm",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Cintura:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$cintura cm",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Abdome:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$abdome cm",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Quadril:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$quadril cm",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Coxa Medial:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "$coxaMedial cm",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Foto Frente',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Container(
                                        child: Image.network(
                                          fotoFrente,
                                        )
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Foto Lado:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Container(
                                        child: Image.network(
                                          fotoLado,
                                        )
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Foto Costas:',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Container(
                                        child: Image.network(
                                          fotoCostas,
                                        )
                                      ),
                                      /*MaterialButton(
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17.0)),
                                        color: clicouSalvar ? Colors.grey : Colors.grey[900],
                                        textColor: Colors.white,
                                        minWidth: double.infinity,
                                        height: 42,
                                        onPressed: () {
                                          if(exercicioSelecionado != "" && velocidadeSelecionada != ""){
                                            //_novoExercicio();
                                          }else{
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Preencha todos os campos!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text('Fechar'),
                                                  ),
                                                ],
                                              )
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            "Enviar",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                            ),
                                          ),
                                        ),
                                      ),*/
                                    ],
                                  ) : Container()
                              ),
                            )
                          ),
                        ]
                        ),
                      ),
                    ),
                  ),
                ),
            ),
            mostrarNumberPickerSeries ? Center(
                child: Container(
                  color: Colors.black87,
                  height: MediaQuery.of(context).size.height/4,
                  width: MediaQuery.of(context).size.width/3,
                  child: Column(
                    children: [
                      NumberPicker(
                        value: numeroSeries,
                        minValue: 0,
                        maxValue: 20,
                        step: 1,
                        haptics: true,
                        onChanged: (value) {
                          setState(() {
                            numeroSeries = value;
                          });
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey
                        ),
                        child: IconButton(
                          color: Color.fromARGB(255, 114, 228, 49),
                          onPressed: (){
                            setState(() {
                              mostrarNumberPickerSeries = false;
                            });
                          }, 
                          icon: Icon(
                            Icons.check
                          )
                        ),
                      )
                    ],
                  ),
                )
              ) : Container(),
              mostrarNumberPickerRepeticoes ? Center(
                child: Container(
                  color: Colors.black87,
                  height: MediaQuery.of(context).size.height/4,
                  width: MediaQuery.of(context).size.width/3,
                  child: Column(
                    children: [
                      NumberPicker(
                        value: numeroRepeticoes,
                        minValue: 1,
                        maxValue: 50,
                        step: 1,
                        haptics: true,
                        onChanged: (value) {
                          setState(() {
                            numeroRepeticoes = value;
                          });
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey
                        ),
                        child: IconButton(
                          color: Color.fromARGB(255, 114, 228, 49),
                          onPressed: (){
                            setState(() {
                              mostrarNumberPickerRepeticoes = false;
                            });
                          }, 
                          icon: Icon(
                            Icons.check
                          )
                        ),
                      )
                    ],
                  ),
                )
              ) : Container(),
              mostrarNumberPickerDescanso ? Center(
                child: Container(
                  color: Colors.black87,
                  height: MediaQuery.of(context).size.height/3,
                  width: MediaQuery.of(context).size.width/1.8,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Min",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/5,
                          ),
                          Text(
                            "Sec",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            value: numeroDescansoMin,
                            minValue: 0,
                            maxValue: 5,
                            step: 1,
                            haptics: true,
                            onChanged: (value) {
                              setState(() {
                                numeroDescansoMin = value;
                              });
                            },
                          ),
                          NumberPicker(
                            value: numeroDescansoSec,
                            minValue: 0,
                            maxValue: 59,
                            step: 1,
                            haptics: true,
                            onChanged: (value) {
                              setState(() {
                                numeroDescansoSec = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey
                        ),
                        child: IconButton(
                          color: Color.fromARGB(255, 114, 228, 49),
                          onPressed: (){
                            setState(() {
                              mostrarNumberPickerDescanso = false;
                            });
                          }, 
                          icon: Icon(
                            Icons.check
                          )
                        ),
                      )
                    ],
                  ),
                )
              ) : Container()
            ]
          ),
      );
  }

  resetExercicio() {
    _keyExercicio.currentState!.reset();
  }

  indicadorProgresso(){
  return Expanded(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: Container(
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          )
        )
      ),
    ),
  );
}

}

 