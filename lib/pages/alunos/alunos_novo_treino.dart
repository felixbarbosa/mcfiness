import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/aluno.dart';
import 'package:mcfitness/model/treino.dart';
import 'package:numberpicker/numberpicker.dart';

enum SingingCharacter { padrao, personalizado, midia }

class AlunosNovoTreino extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final int diaSemanaIdGlobal;
  final String nomeTreinoGlobal;

  const AlunosNovoTreino(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.diaSemanaIdGlobal,
      required this.nomeTreinoGlobal,
      required this.alunoNomeGlobal
    }
  ) : super(key: key);

  @override
  _AlunosNovoTreinoState createState() => _AlunosNovoTreinoState(
    alunoIdLocal: alunoIdGlobal, 
    diaSemanaIdLocal: diaSemanaIdGlobal,
    nomeTreinoLocal: nomeTreinoGlobal,
    alunoNomeLocal: alunoNomeGlobal
  );
}

class _AlunosNovoTreinoState extends State<AlunosNovoTreino> {

  final int alunoIdLocal;
  final int diaSemanaIdLocal;
  final String nomeTreinoLocal;
  final String alunoNomeLocal;

  String abertura = "";
  String fechamento = "";

  _AlunosNovoTreinoState(
    {
      required this.alunoIdLocal, 
      required this.diaSemanaIdLocal,
      required this.nomeTreinoLocal,
      required this.alunoNomeLocal
    }
  );

  SingingCharacter? _character = SingingCharacter.padrao;
  SingingCharacter? _characterMidia = SingingCharacter.midia;

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

  bool isCheckMidia = false;
  bool nomePadrao = true;
  bool addMidia = false;
  bool nomePersonalizado = false;

  int numeroSeries = 3;
  int numeroRepeticoes = 10;
  int numeroDescansoMin = 1;
  int numeroDescansoSec = 0;
  int exercicioIdSelecionado = 0;
  int notificarMidia = 0;

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
    print("dia semana id = $diaSemanaIdLocal");
    print("musculo id = $musculoIdLocal");
    print("series = ${numeroSeries.toString()}");
    print("repeticoes = ${numeroRepeticoes.toString()}");
    print("velocidade = $velocidadeSelecionada");
    print("exercicio = $exercicioIdSelecionado");
    print("Nome = $nomeTreinoLocal");
    print("Descanso = ${numeroDescansoMin.toString()} + ${numeroDescansoSec.toString()}");

    try{

      Map<String, dynamic> result = await Graphql.incluirExercicioTreino(
        Treino(
          id: 0,
          aluno: alunoIdLocal,
          diaSemana: nomeTreinoLocal != "" ? diaSemanaIdLocal : diaSemanaIdSelecionado,
          musculo: musculoIdLocal,
          series: numeroSeries.toString(),
          repeticoes: numeroRepeticoes.toString(),
          velocidade: velocidadeSelecionada,
          instrucao: instrucao.text,
          exercicio: exercicioIdSelecionado,
          nome: nomeTreinoLocal != "" ? nomeTreinoLocal : nomePadrao ? treinoPadraoSelecionado : nome.text,
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
                                        nomeTreinoLocal != "" ? 'Novo Exercicio' : 'Novo Treino',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        nomeTreinoLocal != "" ?  "$nomeTreinoLocal - $alunoNomeLocal" : alunoNomeLocal,
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
                                      nomeTreinoLocal == "" ?
                                      Text(
                                        'Nome',
                                        style: TextStyle(
                                          fontSize: 23.0
                                        ),
                                      ) : Container(),
                                      nomeTreinoLocal == "" ? 
                                      SizedBox(
                                        height: 8.0,
                                      ) : Container(),
                                      nomeTreinoLocal == "" ?
                                      !nomePadrao ? 
                                      TextFormField(
                                        controller: nome,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                            color: Colors.black
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50.0)
                                          ),
                                          hintText: "Nome do Treino",
                                          hintStyle: TextStyle(
                                            color: Colors.grey
                                          ),
                                        ),
                                      ) : 
                                      SizedBox(
                                        height: 50.0,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          iconDisabledColor: Colors.black,
                                          items: nomesPadroes.map((String value){
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
                                              
                                              treinoPadraoSelecionado = valorSelecionado;
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
                                            hintText: "Treinos Padrões",
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                            )
                                          ),
                                        )
                                      ) : Container(),
                                      nomeTreinoLocal == "" ?
                                      Row(
                                        children: <Widget>[
                                            Radio<SingingCharacter>(
                                              value: SingingCharacter.padrao,
                                              groupValue: _character,
                                              onChanged: (SingingCharacter? value) {
                                                setState(() {
                                                  print("Pessoa Fisica Ativo");
                                                  nomePersonalizado = false;
                                                  nomePadrao = true;
                                                  _character = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              "Padrão"
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Radio<SingingCharacter>(
                                              value: SingingCharacter.personalizado,
                                              groupValue: _character,
                                              onChanged: (SingingCharacter? value) {
                                                setState(() {
                                                  print("Pessoa Juridica Ativo");
                                                  nomePersonalizado = true;
                                                  nomePadrao = false;
                                                  _character = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              "Personalizado"
                                            )
                                        ],
                                      ) : Container(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      nomeTreinoLocal == "" ?
                                      Text(
                                        'Dia da Semana',
                                        style: TextStyle(
                                          fontSize: 23.0
                                        ),
                                      ) : Container(),
                                      nomeTreinoLocal == "" ? 
                                      SizedBox(
                                        height: 8.0,
                                      ) : Container(),
                                      nomeTreinoLocal == "" ? 
                                      SizedBox(
                                        height: 50.0,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          iconDisabledColor: Colors.black,
                                          items: diasSemana.map((String value){
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
                                              
                                              //musculoNomeLocal = valorSelecionado;
            
                                              List <String> valorSeparado = valorSelecionado.split(" - ");
                                              print("\"${valorSeparado[0]}\"");
                                              diaSemanaIdSelecionado = int.parse(valorSeparado[0]);
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
                                            hintText: "Dia da semana",
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                            )
                                          ),
                                        )
                                      ) : Container(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Musculo',
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
                                          items: musculos.map((String value){
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
                                              
                                              musculoNomeLocal = valorSelecionado;
            
                                              List <String> valorSeparado = valorSelecionado.split(" - ");
                                              print("\"${valorSeparado[0]}\"");
                                              musculoIdLocal = int.parse(valorSeparado[0]);
            
                                              setState(() {
                                                selecionouMusculo = false;
                                                selecionouExercicio = false;
                                              });
            
                                              resetExercicio();
            
                                              _buscarExerciciosPorMusculo();
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
                                            hintText: "Musculo Alvo",
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
                                          key: _keyExercicio,
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
            
                                              List <String> valorSeparado = valorSelecionado.split(" - ");
                                              print("\"${valorSeparado[0]}\"");
                                              exercicioIdSelecionado = int.parse(valorSeparado[0]);
                                              exercicioSelecionado = valorSeparado[1];
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
              ) : Container(),
              loading ? 
              indicadorProgresso(): Container()
            ]
          ),
      );
  }

  resetExercicio() {
    _keyExercicio.currentState!.reset();
  }

  indicadorProgresso(){
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height/7,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black
          ),
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    'Uploading...',
                    style: TextStyle(
                      color: Colors.blue[400]
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}

 