import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/aluno.dart';
import 'package:mcfitness/model/treino.dart';
import 'package:numberpicker/numberpicker.dart';

enum SingingCharacter { nome, cnpj }

class AlunosNovoExercicio extends StatefulWidget {

  final int alunoIdGlobal;
  final int musculoIdGlobal;
  final String musculoNomeGlobal;
  final int diaSemanaIdGlobal;
  final int objetivoGlobal;
  final String nomeTreinoGlobal;

  const AlunosNovoExercicio(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.musculoIdGlobal,
      required this.musculoNomeGlobal,
      required this.diaSemanaIdGlobal,
      required this.objetivoGlobal,
      required this.nomeTreinoGlobal
    }
  ) : super(key: key);

  @override
  _AlunosNovoExercicioState createState() => _AlunosNovoExercicioState(
    alunoIdLocal: alunoIdGlobal, 
    musculoIdLocal: musculoIdGlobal,
    musculoNomeLocal: musculoNomeGlobal,
    diaSemanaIdLocal: diaSemanaIdGlobal,
    objetivoLocal: objetivoGlobal,
    nomeTreinoLocal: nomeTreinoGlobal
  );
}

class _AlunosNovoExercicioState extends State<AlunosNovoExercicio> {

  final int alunoIdLocal;
  final int musculoIdLocal;
  final String musculoNomeLocal;
  final int diaSemanaIdLocal;
  final int objetivoLocal;
  final String nomeTreinoLocal;

  String abertura = "";
  String fechamento = "";

  _AlunosNovoExercicioState(
    {
      required this.alunoIdLocal, 
      required this.musculoIdLocal,
      required this.musculoNomeLocal,
      required this.diaSemanaIdLocal,
      required this.objetivoLocal,
      required this.nomeTreinoLocal
    }
  );

  SingingCharacter? _character = SingingCharacter.nome;

  final _formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final instrucao = TextEditingController();
  final email = TextEditingController();
  //final entidade = 5;

  int idLocal = 0;
  bool loading = false;
  bool produtoSelecionado = false;
  String idSelecionado = "";
  bool isButtonDisable = false;

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

  int numeroSeries = 3;
  int numeroRepeticoes = 10;
  int numeroDescansoMin = 1;
  int numeroDescansoSec = 0;
  int exercicioIdSelecionado = 0;
  int variacaoIdSelecionado = 0;

  List<String> exercicios = [];

  List<String> velocidade = [
    'Cadenciado', 'Normal', 'Rápido'
  ];

  Future<void> _novoExercicio() async {

    try{

      Map<String, dynamic> result = await Graphql.incluirExercicioTreino(
        Treino(
          id: 0,
          aluno: alunoIdLocal,
          diaSemana: diaSemanaIdLocal,
          musculo: musculoIdLocal,
          series: numeroSeries.toString(),
          repeticoes: numeroRepeticoes.toString(),
          instrucao: instrucao.text,
          velocidade: velocidadeSelecionada,
          exercicio: exercicioIdSelecionado,
          nome: nomeTreinoLocal,
          descanso: numeroDescansoMin.toString() + "'" + numeroDescansoSec.toString() + "''",
          variacaoExercicio: variacaoIdSelecionado != 0 ? variacaoIdSelecionado : null
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

  Future<void> _buscarExerciciosPorMusculo() async {

    setState(() {
      loading = true;
    });

    print("Musculo = $musculoIdLocal");

    try{

      Map<String, dynamic> result = await Graphql.exerciciosPorMusculo(musculoIdLocal);

      print("aqui");
      

      if (result['obterExerciciosPorMusculo'].length > 0) {
        print("Resultado buscado");

        int count = 0;
        String addExercicio = "";

        while(count < result['obterExerciciosPorMusculo'].length){
          print("Dentro do while");
          print("Id = ${result['obterExerciciosPorMusculo'][count]['id']}");
          print("Descricao = ${result['obterExerciciosPorMusculo'][count]['descricao']}");

          addExercicio = result['obterExerciciosPorMusculo'][count]['id'].toString() + " - " + result['obterExerciciosPorMusculo'][count]['descricao'];
          setState(() {
            print("SetState");
            exercicios.add(addExercicio);
          });
          
          count++;
        }

        _buscarVariacoesPorMusculo();

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
          title: const Text('Erro na base de dados de exercicios'),
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

  Future<void> _buscarVariacoesPorMusculo() async {

    print("Musculo = $musculoIdLocal");

    try{

      Map<String, dynamic> result = await Graphql.obterVariacoesExercicioPorMusculo(musculoIdLocal);

      print("aqui");
      

      if (result['obterVariacoesPorMusculo'].length > 0) {
        print("Resultado buscado");

        int count = 0;
        String addExercicio = "";

        while(count < result['obterVariacoesPorMusculo'].length){
          print("Dentro do while");
          print("Id = ${result['obterVariacoesPorMusculo'][count]['id']}");
          print("Descricao = ${result['obterVariacoesPorMusculo'][count]['descricao']}");

          addExercicio = result['obterVariacoesPorMusculo'][count]['id'].toString() + 
          " - " + 
          result['obterVariacoesPorMusculo'][count]['descricao'] + 
          " ¨${result['obterVariacoesPorMusculo'][count]['exercicio']['id']}¨";
          setState(() {
            print("SetState");
            exercicios.add(addExercicio);
          });
          
          count++;
        }

        setState(() {
          loading = false;
        });

      } else {

        setState(() {
          loading = false;
        });
        
      }

    }catch(erro){

      print("Erro = ${erro.toString()}");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro na base de dados de variacoes de exercicios'),
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
    _buscarExerciciosPorMusculo();
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
                                        'Novo Exercicio',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        musculoNomeLocal,
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
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50, 0.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Exercicio',
                                        style: TextStyle(
                                          fontSize: 23.0
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      SizedBox(
                                        height: 50.0,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          iconDisabledColor: Colors.black,
                                          items: exercicios.map((String value){
                                            return DropdownMenuItem(
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                
                                              ),
                                              value: value,
                                            );
                                          }).toList(),  
                                          onChanged: (valorSelecionado){
                        
                                            if(valorSelecionado != null){
                        
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              
                                              exercicioSelecionado = valorSelecionado;
                                              List <String> valorSeparado = valorSelecionado.split(" - ");

                                              if(valorSelecionado.contains('¨')){

                                                String exercicioNaVariacaao = valorSelecionado.substring(valorSelecionado.length - 2, valorSelecionado.length - 1);

                                                exercicioIdSelecionado = int.parse(exercicioNaVariacaao);

                                                variacaoIdSelecionado = int.parse(valorSeparado[0]);

                                              }else{
                                                
                                                print("\"${valorSeparado[0]}\"");
                                                exercicioIdSelecionado = int.parse(valorSeparado[0]);
                                              }

                                            }
                                            
                                            
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.location_on,
                                              color: Colors.black,
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(30))
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "Exercicio",
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                            )
                                          ),
                                        )
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Instrução do Exercicio",
                                        style: TextStyle(
                                          fontSize: 23
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        height: 100.0,
                                        child: TextFormField(
                                          controller: instrucao,
                                          maxLines: 5,
                                          style: TextStyle(
                                            color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "Instrução de como executar o exercicio",
                                            hintStyle: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12.0
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Séries",
                                        style: TextStyle(
                                          fontSize: 23
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 55,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.date_range,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 85,
                                                ),
                                                Text(
                                                  "$numeroSeries séries",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          print("Clicou");
                                          setState(() {
                                            mostrarNumberPickerSeries = true;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Repetições",
                                        style: TextStyle(
                                          fontSize: 23
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 55,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.date_range,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 55,
                                                ),
                                                Text(
                                                  "$numeroRepeticoes repetições",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          print("Clicou");
                                          setState(() {
                                            mostrarNumberPickerRepeticoes = true;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Velocidade",
                                        style: TextStyle(
                                          fontSize: 23
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        height: 50.0,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          iconDisabledColor: Colors.black,
                                          items: velocidade.map((String value){
                                            return DropdownMenuItem(
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                
                                              ),
                                              value: value,
                                            );
                                          }).toList(),  
                                          onChanged: (valorSelecionado){
                        
                                            if(valorSelecionado != null){
                                              setState(() {
                                                
                                              });
                        
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              
                                              velocidadeSelecionada = valorSelecionado;
                                            }
                                            
                                            
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.location_on,
                                              color: Colors.black,
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(30))
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "Velocidade do movimento",
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                            )
                                          ),
                                        )
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Descanso",
                                        style: TextStyle(
                                          fontSize: 23
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 55,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.date_range,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 95,
                                                ),
                                                Text(
                                                  "$numeroDescansoMin'$numeroDescansoSec''",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          print("Clicou");
                                          setState(() {
                                            mostrarNumberPickerDescanso = true;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
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
                                            "Incluir Exercicio",
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
        /*body: Stack(
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
                    child: SingleChildScrollView(
                    child: IntrinsicHeight(
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
                            color: Color.fromARGB(255, 51, 51, 51),
                            child: Center(
                                //padding: const EdgeInsets.fromLTRB(10.0, 10.0, 6.5, 10.0),
                                heightFactor: 1.5,
                                child: Column(
                                  children: [
                                    Text(
                                      'Novo Exercicio',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      musculoNomeLocal,
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
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50, 8.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Exercicio',
                                      style: TextStyle(
                                        fontSize: 23.0
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        dropdownColor: Colors.white,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        items: exercicios.map((String value){
                                          return DropdownMenuItem(
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              
                                            ),
                                            value: value,
                                          );
                                        }).toList(),  
                                        onChanged: (valorSelecionado){
                      
                                          if(valorSelecionado != null){
                      
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            
                                            exercicioSelecionado = valorSelecionado;
                        
                                            List <String> valorSeparado = valorSelecionado.split(" - ");
                                            print("\"${valorSeparado[0]}\"");
                                            exercicioIdSelecionado = int.parse(valorSeparado[0]);
                                          }
                                          
                                          
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: "Exercicio",
                                          hintStyle: TextStyle(
                                            color: Colors.black,
                                          )
                                        ),
                                      )
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Instrução do Exercicio",
                                      style: TextStyle(
                                        fontSize: 23
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      height: 100.0,
                                      child: TextFormField(
                                        controller: instrucao,
                                        maxLines: 5,
                                        style: TextStyle(
                                          color: Colors.black
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: "Instrução de como executar o exercicio",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12.0
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Séries",
                                      style: TextStyle(
                                        fontSize: 23
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        height: 55,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.date_range,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 85,
                                              ),
                                              Text(
                                                "$numeroSeries séries",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        print("Clicou");
                                        setState(() {
                                          mostrarNumberPickerSeries = true;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Repetições",
                                      style: TextStyle(
                                        fontSize: 23
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        height: 55,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.date_range,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 55,
                                              ),
                                              Text(
                                                "$numeroRepeticoes repetições",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        print("Clicou");
                                        setState(() {
                                          mostrarNumberPickerRepeticoes = true;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Velocidade",
                                      style: TextStyle(
                                        fontSize: 23
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        dropdownColor: Colors.white,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        items: velocidade.map((String value){
                                          return DropdownMenuItem(
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              
                                            ),
                                            value: value,
                                          );
                                        }).toList(),  
                                        onChanged: (valorSelecionado){
                      
                                          if(valorSelecionado != null){
                                            setState(() {
                                              
                                            });
                      
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            
                                            velocidadeSelecionada = valorSelecionado;
                                          }
                                          
                                          
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: "Velocidade do movimento",
                                          hintStyle: TextStyle(
                                            color: Colors.black,
                                          )
                                        ),
                                      )
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Descanso",
                                      style: TextStyle(
                                        fontSize: 23
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        height: 55,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.date_range,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 95,
                                              ),
                                              Text(
                                                "$numeroDescansoMin'$numeroDescansoSec''",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        print("Clicou");
                                        setState(() {
                                          mostrarNumberPickerDescanso = true;
                                        });
                                      },
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
                                          "Incluir Exercicio",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    clicouSalvar ? indicadorProgresso() : SizedBox()
                                  ],
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
        ),*/
    );
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

 