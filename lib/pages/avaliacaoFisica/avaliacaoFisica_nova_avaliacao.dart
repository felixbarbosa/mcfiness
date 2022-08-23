import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/treino.dart';
import 'package:numberpicker/numberpicker.dart';

enum SingingCharacter { padrao, personalizado }

class AvaliacaoFisicaNovaAvaliacao extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;

  const AvaliacaoFisicaNovaAvaliacao(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal
    }
  ) : super(key: key);

  @override
  _AvaliacaoFisicaNovaAvaliacaoState createState() => _AvaliacaoFisicaNovaAvaliacaoState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal
  );
}

class _AvaliacaoFisicaNovaAvaliacaoState extends State<AvaliacaoFisicaNovaAvaliacao> {

  final int alunoIdLocal;
  final String alunoNomeLocal;

  String abertura = "";
  String fechamento = "";

  _AvaliacaoFisicaNovaAvaliacaoState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal
    }
  );

  SingingCharacter? _character = SingingCharacter.padrao;

  final _formKey = GlobalKey<FormState>();
  final objetivo = TextEditingController();
  final atividadeFisica = TextEditingController();
  final refeicoes = TextEditingController();
  final dieta = TextEditingController();
  final suplementacao = TextEditingController();
  final sono = TextEditingController();
  final fumante = TextEditingController();
  final bebidaAlcoolica = TextEditingController();
  final colesterol = TextEditingController();
  final alteracaoCardiaca = TextEditingController();
  final diabetes = TextEditingController();
  final hipertenso = TextEditingController();
  final pulmonar = TextEditingController();
  final medicamento = TextEditingController();
  final cirurgia = TextEditingController();
  final dores = TextEditingController();
  final problemaOrtopedico = TextEditingController();
  final observacoes = TextEditingController();
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

  Future<void> _novoExercicio() async {

    print("Aluno id = $alunoIdLocal");
    print("musculo id = $musculoIdLocal");
    print("series = ${numeroSeries.toString()}");
    print("repeticoes = ${numeroRepeticoes.toString()}");
    print("velocidade = $velocidadeSelecionada");
    print("exercicio = $exercicioIdSelecionado");
    print("Descanso = ${numeroDescansoMin.toString()} + ${numeroDescansoSec.toString()}");

    try{

      Map<String, dynamic> result = await Graphql.incluirExercicioTreino(
        Treino(
          id: 0,
          aluno: alunoIdLocal,
          musculo: musculoIdLocal,
          series: numeroSeries.toString(),
          repeticoes: numeroRepeticoes.toString(),
          velocidade: velocidadeSelecionada,
          exercicio: exercicioIdSelecionado,
          descanso: numeroDescansoMin.toString() + "'" + numeroDescansoSec.toString() + "''"
        )
      );

      if (result['salvarTreino']['id'] == 0) {
        print("Resultado buscado");

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

        Navigator.of(context).pop(1);

        setState(() {
          loading = false;
        });

      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Exercicio não incluido'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                  ],
                ));
      }

    }catch(erro){

      setState(() {
        loading = false;
      });

      if(erro.toString().contains("Connection failed")){

        print("Mensagem de Erro = $erro");

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
          )
        );

        
      }else{

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro base de dados. Tente novamente mais tarde.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          )
        );
      }
    }
  }

  Future<void> _buscarMusculos() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.obterTodosOsMusculos();

      print("aqui");
      

      if (result['obterMusculos'].length > 0) {
        print("Resultado buscado");

        int count = 0;
        String addMusculo = "";

        while(count < result['obterMusculos'].length){

          addMusculo = result['obterMusculos'][count]['id'].toString() + " - " + result['obterMusculos'][count]['descricao'];
          setState(() {
            musculos.add(addMusculo);
          });
          
          count++;
        }

        setState(() {
          loading = false;
        });

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum musculo cadastrado'),
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

  Future<void> _buscarDiasSemana() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.obterDiasSemana();

      print("aqui");
      

      if (result['obterDiasSemana'].length > 0) {
        print("Resultado buscado");

        int count = 0;
        String addDia = "";

        while(count < result['obterDiasSemana'].length){

          addDia = result['obterDiasSemana'][count]['id'].toString() + " - " + result['obterDiasSemana'][count]['dia'];
          setState(() {
            diasSemana.add(addDia);
          });
          
          count++;
        }

        setState(() {
          loading = false;
        });

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum musculo cadastrado'),
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

  Future<void> _buscarExerciciosPorMusculo() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.exerciciosPorMusculo(musculoIdLocal);

      print("aqui");
      

      if (result['obterExerciciosPorMusculo'].length > 0) {
        print("Resultado buscado");

        exercicios.clear();

        int count = 0;
        String addExercicio = "";

        while(count < result['obterExerciciosPorMusculo'].length){
          print("Dentro do while");
          print("Id = ${result['obterExerciciosPorMusculo'][count]['id']}");
          print("Descricao = ${result['obterExerciciosPorMusculo'][count]['descricao']}");

          addExercicio = result['obterExerciciosPorMusculo'][count]['id'].toString() + " - " + result['obterExerciciosPorMusculo'][count]['descricao'];
          
          exercicios.add(addExercicio);
          
          count++;
        }

        setState(() {
          loading = false;
          selecionouMusculo = true;
        });

      } else {

        setState(() {
          loading = false;
          selecionouMusculo = false;
        });

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
    _buscarDiasSemana();
    _buscarMusculos();
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
                  "Avaliação",
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
                width: MediaQuery.of(context).size.width, //Pegar a largura da tela quando usamos o SingleChildScrollView
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue[400]!,
                      Colors.grey,
                    ],
                  )
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
                              color: Colors.black,
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
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20, 0.0),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Qual seu objetivo?',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: objetivo,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Idade:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: atividadeFisica,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Ex.: 23",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Data da avaliação:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: refeicoes,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Ex.: dd/mm/aaaa",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Altura:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: dieta,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Ex.: 1.70",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Peso:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: suplementacao,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Ex.: 55.5",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Peitoral:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  print("Clicou");
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.red,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: sono,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Biceps relaxado:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  print("Clicou");
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.red,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: fumante,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Antebraço direito:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  print("Clicou");
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.red,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: bebidaAlcoolica,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Cintura:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  print("Clicou");
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.red,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: colesterol,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Abdomem:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  print("Clicou");
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.red,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: alteracaoCardiaca,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Quadril:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  print("Clicou");
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.red,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: diabetes,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Coxa Medial:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  print("Clicou");
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.red,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: hipertenso,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(
                                            'Foto de Frente',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: pulmonar,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              prefixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.blue[400]
                                                ),
                                                onPressed: (){
                                                  print("Clicou Foto");
                                                },
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(
                                            'Foto de Lado',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: pulmonar,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              prefixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.blue[400]
                                                ),
                                                onPressed: (){
                                                  print("Clicou Foto");
                                                },
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(
                                            'Foto de Costas',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: pulmonar,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              prefixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.blue[400]
                                                ),
                                                onPressed: (){
                                                  print("Clicou Foto");
                                                },
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(17.0)),
                                            color: clicouSalvar ? Colors.grey : Colors.grey[900],
                                            textColor: Colors.white,
                                            minWidth: double.infinity,
                                            height: 42,
                                            onPressed: () {
                                              if(exercicioSelecionado != "" && velocidadeSelecionada != ""){
                                                _novoExercicio();
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
                                          ),
                                          clicouSalvar ? indicadorProgresso() : SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                ),
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

 