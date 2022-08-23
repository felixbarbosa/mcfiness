import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_exercicios.dart';
import 'package:mcfitness/pages/exercicios/exercicios_listar_variacoes.dart';
import 'package:mcfitness/pages/exercicios/exercicios_novo_exercicio.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

enum SingingCharacter { nome, cnpj }

class ExerciciosListarMusculos extends StatefulWidget {

  final int personalIdGlobal;

  const ExerciciosListarMusculos(
    {
      Key? key, 
      required this.personalIdGlobal
    }
  ) : super(key: key);

  @override
  _musculosListarMusculosState createState() => _musculosListarMusculosState(
    personalIdLocal: personalIdGlobal
  );
}

bool termoMaiorTres = false;

class _musculosListarMusculosState extends State<ExerciciosListarMusculos> {

  final int personalIdLocal;

  _musculosListarMusculosState({
    required this.personalIdLocal
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
  //String entidadeIdQuery = entidadeId; 

  bool loading = false;
  bool musculoSelecionado = false;
  bool criadorExercicio = false;
  int idSelecionado = 0;
  bool isButtonDisable = false;
  String urlImagemLocal = "";

  List musculos = [];
  List pedido_por_clientes = [];
  List<String> listaUrls = [];

  Future<void> _musculos() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.obterTodosOsMusculos();

      print("aqui");
      

      if (result['obterMusculos'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          musculos = result['obterMusculos'];
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
                  _musculos();
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
    _musculos();
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
          backgroundColor: Colors.blue[400],
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
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
                color: Colors.blue[400],
                child: ButtonBar(
                  buttonMinWidth: 100,
                  alignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {

                        if(musculoSelecionado){

                          var tela = await Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => ExerciciosListarExercicios(
                                personalIdGlobal: personalIdLocal,
                                musculoIdGlobal: idSelecionado,
                                urlGlobal: urlImagemLocal,
                              )
                            )
                          );

                          if(tela == 1){
                            idSelecionado = 0;
                            musculoSelecionado = false;
                            _musculos();
                          }

                        }
                        
                      },
                      color: (musculoSelecionado) ? Colors.black : Colors.grey,
                      child: Text(
                        'Ver Exercicios',
                        style: TextStyle(
                          color: musculoSelecionado ? Colors.white : Colors.black 
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
                return _musculos();
              },
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {

                    urlTeste = musculos[index]['descricao'] == "Ombro" ? 
                      "assets/ombro.jpg" : 
                      musculos[index]['descricao'] == "Peito" ?
                      "assets/peito.jpg" : musculos[index]['descricao'] == "Tríceps" ?
                      "assets/triceps.jpg" : 
                      musculos[index]['descricao'] == "Costas" ?
                      "assets/costas.jpg" : 
                      musculos[index]['descricao'] == "Biceps" ?
                      "assets/biceps.jpg" : 
                      musculos[index]['descricao'] == "Quadriceps" ?
                      "assets/quadriceps.png" : 
                      musculos[index]['descricao'] == "Posterior de Coxa" ?
                      "assets/posterior.jpg" : 
                      musculos[index]['descricao'] == "Panturrilha" ?
                      "assets/panturrilha.jpg" : 
                      musculos[index]['descricao'] == "Abdomen" ?
                      "assets/abdomen.jpg" :
                      musculos[index]['descricao'] == "Trapezio" ?
                      "assets/trapezio.jpg" :
                      musculos[index]['descricao'] == "Ante Braço" ?
                      "assets/antebraco.jpg" : "assets/Erro.png";

                    listaUrls.add(urlTeste);

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
                                        if(idSelecionado == musculos[index]['id']){
                                          musculoSelecionado = !musculoSelecionado;
                                        }else{
                                          musculoSelecionado = true;
                                          idSelecionado = musculos[index]['id'];
                                          urlImagemLocal = listaUrls[index];
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (musculoSelecionado && idSelecionado == musculos[index]['id']) ? Colors.blue[400] : Colors.white,
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
                                                    urlTeste
                                                  ),
                                                  fit: BoxFit.fill
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  bottomLeft: Radius.circular(4.0)
                                                ),
                                                color: Colors.white
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
                                                      musculos[index]['descricao'],  
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
                  itemCount: musculos.length
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

 