import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_variacoes.dart';
import 'package:mcfitness/pages/exercicios/exercicios_novo_exercicio.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

enum SingingCharacter { nome, cnpj }

class ExerciciosListarExercicios extends StatefulWidget {

  final int personalIdGlobal;
  final int musculoIdGlobal;
  final String urlGlobal;

  const ExerciciosListarExercicios(
    {
      Key? key, 
      required this.personalIdGlobal,
      required this.musculoIdGlobal,
      required this.urlGlobal
    }
  ) : super(key: key);

  @override
  _ExerciciosPorMusculoListarExerciciosState createState() => _ExerciciosPorMusculoListarExerciciosState(
    personalIdLocal: personalIdGlobal,
    musculoIdLocal: musculoIdGlobal,
    urlLocal: urlGlobal
  );
}

bool termoMaiorTres = false;

class _ExerciciosPorMusculoListarExerciciosState extends State<ExerciciosListarExercicios> {

  final int personalIdLocal;
  final int musculoIdLocal;
  final String urlLocal;

  _ExerciciosPorMusculoListarExerciciosState({
    required this.personalIdLocal,
    required this.musculoIdLocal,
    required this.urlLocal
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
  String nomeMusculo = "";
  int musculoId = 0;
  int isVariacao = 0;
  String nomeExercicio = "";
  //String entidadeIdQuery = entidadeId; 

  bool loading = false;
  bool exercicioSelecionado = false;
  bool criadorExercicio = false;
  int idSelecionado = 0;
  bool isButtonDisable = false;
  String urlImagemLocal = "";
  int donoExercicio = 0;

  List exercicios = [];
  List pedido_por_clientes = [];

  Future<void> _exerciciosPorMusculo() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.exerciciosPorMusculo(musculoIdLocal, personalIdLocal);

      print("aqui");
      

      if (result['obterExerciciosPorMusculo'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          exercicios = result['obterExerciciosPorMusculo'];
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
                  _exerciciosPorMusculo();
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
    _exerciciosPorMusculo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {

            var tela = await Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => ExerciciosNovoExercicio(
                  personalIdGlobal: personalIdLocal,
                  editandoGlobal: false,
                  exercicioIdGlobal: idSelecionado,
                  musculoIdGlobal: musculoId,
                  nomeExercicioGlobal: nomeExercicio,
                  nomeMusculoGlobal: nomeMusculo,
                  urlGlobal: "",
                )
              )
            );

            if(tela == 1){
              _exerciciosPorMusculo();
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
                "Exercicios",
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
            loading ? indicadorProgresso() : widgetListaRolagem(),
            SizedBox(
              height: 2,
            ),
            ButtonTheme(
              child: Container(
                color: Colors.black,
                child: ButtonBar(
                  buttonMinWidth: 100,
                  alignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {

                        if(exercicioSelecionado && criadorExercicio){

                          var tela = await Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => ExerciciosNovoExercicio(
                                personalIdGlobal: personalIdLocal,
                                editandoGlobal: true,
                                exercicioIdGlobal: idSelecionado,
                                musculoIdGlobal: musculoId,
                                nomeExercicioGlobal: nomeExercicio,
                                nomeMusculoGlobal: nomeMusculo,
                                urlGlobal: urlImagemLocal,
                              )
                            )
                          );

                          if(tela == 1){
                            idSelecionado = 0;
                            exercicioSelecionado = false;
                            _exerciciosPorMusculo();
                          }

                        }
                        
                      },
                      color: (exercicioSelecionado && criadorExercicio) ? Colors.white : Color.fromARGB(255, 107, 107, 107),
                      child: Text(
                        'Editar',
                        style: TextStyle(
                          color: Colors.black 
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {

                        if(exercicioSelecionado && criadorExercicio){

                          _removerExercicios();

                        }
                        
                      },
                      color: (exercicioSelecionado && criadorExercicio) ? Colors.white : Color.fromARGB(255, 107, 107, 107),
                      child: Text(
                        'Remover',
                        style: TextStyle(
                          color: Colors.black 
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if((exercicioSelecionado && isVariacao == 0)){
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => ExerciciosListarVariacoes(
                                personalIdGlobal: personalIdLocal,
                                editandoGlobal: false,
                                exercicioIdGlobal: idSelecionado,
                                musculoIdGlobal: musculoId,
                                nomeExercicioGlobal: nomeExercicio,
                                nomeMusculoGlobal: nomeMusculo,
                                urlGlobal: urlImagemLocal,
                              )
                            )
                          );
                        }
                      },
                      color: (exercicioSelecionado && isVariacao == 0) ? Colors.white : Color.fromARGB(255, 107, 107, 107),
                      child: Text(
                        'Variações',
                        style: TextStyle(
                          color: Colors.black 
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
                return _exerciciosPorMusculo();
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
                                        if(idSelecionado == exercicios[index]['id']){
                                          exercicioSelecionado = !exercicioSelecionado;
                                        }else{
                                          exercicioSelecionado = true;
                                          idSelecionado = exercicios[index]['id'];
                                          isVariacao = exercicios[index]['isVariacao'];
                                          nomeExercicio = exercicios[index]['descricao'];
                                          musculoId = exercicios[index]['musculo']['id'];
                                          nomeMusculo = exercicios[index]['musculo']['descricao'];
                                          urlImagemLocal = exercicios[index]['urlImagem'] == null ? "" : exercicios[index]['urlImagem'];
            
                                          if(exercicios[index]['professor']['id'] == personalIdLocal){
                                            criadorExercicio = true;
                                          }else{
                                            criadorExercicio = false;
                                          }
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (exercicioSelecionado && idSelecionado == exercicios[index]['id']) ? Colors.blue[400] : Colors.white,
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
                                                    urlLocal
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
                                                      exercicios[index]['descricao'],  
                                                      overflow: TextOverflow.fade,                          
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13.0,
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
                  itemCount: exercicios.length
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

 