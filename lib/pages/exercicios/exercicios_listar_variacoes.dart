import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/exercicios/exercicios_nova_variacao.dart';

enum SingingCharacter { nome, cnpj }

class ExerciciosListarVariacoes extends StatefulWidget {

  final int personalIdGlobal;
  final int exercicioIdGlobal;
  final String nomeExercicioGlobal;
  final int musculoIdGlobal;
  final bool editandoGlobal;
  final String nomeMusculoGlobal;
  final String urlGlobal;

  const ExerciciosListarVariacoes(
    {
      Key? key, 
      required this.personalIdGlobal,
      required this.editandoGlobal,
      required this.musculoIdGlobal,
      required this.nomeExercicioGlobal,
      required this.nomeMusculoGlobal,
      required this.exercicioIdGlobal,
      required this.urlGlobal
    }
  ) : super(key: key);

  @override
  _ExerciciosListarVariacoesState createState() => _ExerciciosListarVariacoesState(
    personalIdLocal: personalIdGlobal,
    editandoLocal: editandoGlobal,
    musculoIdLocal: musculoIdGlobal,
    nomeExercicioLocal: nomeExercicioGlobal,
    nomeMusculoLocal: nomeMusculoGlobal,
    exercicioIdLocal: exercicioIdGlobal,
    urlLocal: urlGlobal
  );
}

bool termoMaiorTres = false;

class _ExerciciosListarVariacoesState extends State<ExerciciosListarVariacoes> {

  final int personalIdLocal;
  final int exercicioIdLocal;
  final String nomeExercicioLocal;
  final int musculoIdLocal;
  final bool editandoLocal;
  final String nomeMusculoLocal;
  final String urlLocal;

  _ExerciciosListarVariacoesState({
    required this.personalIdLocal,
    required this.exercicioIdLocal,
    required this.nomeExercicioLocal,
    required this.musculoIdLocal,
    required this.editandoLocal,
    required this.nomeMusculoLocal,
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
  //String entidadeIdQuery = entidadeId; 

  bool loading = false;
  bool variacoeselecionado = false;
  int idSelecionado = 0;
  bool isButtonDisable = false;

  List variacoes = [];
  List pedido_por_clientes = [];

  Future<void> _variacoes() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.obterVariacoesExercicio(exercicioIdLocal, 1);

      print("aqui");
      

      if (result['obterVariacoesExerciciosPorExercicio'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          variacoes = result['obterVariacoesExerciciosPorExercicio'];
        });

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum variação encontrada para esse exercicio'),
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
    _variacoes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {

            var tela = Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => ExerciciosNovaVariacao(
                  personalIdGlobal: personalIdLocal,
                  editandoGlobal: false,
                  exercicioIdGlobal: exercicioIdLocal,
                  musculoIdGlobal: musculoIdLocal,
                  nomeExercicioGlobal: nomeExercicioLocal,
                  nomeMusculoGlobal: nomeMusculoLocal,
                  urlGlobal: urlLocal,
                )
              )
            );

            if(tela == 1){
              setState(() {
                _variacoes();
              });
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
                "variacoes",
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
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Variações do $nomeExercicioLocal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ),
                    )
                  ),
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
                return _variacoes();
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
                                        if(idSelecionado == variacoes[index]['id']){
                                          variacoeselecionado = !variacoeselecionado;
                                        }else{
                                          variacoeselecionado = true;
                                          idSelecionado = variacoes[index]['id'];
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (variacoeselecionado && idSelecionado == variacoes[index]['id']) ? Colors.blue[400] : Colors.white,
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
                                                    variacoes[index]['musculo']['descricao'] == "Ombro" ? 
                                                      "assets/ombro.jpg" : 
                                                    variacoes[index]['musculo']['descricao'] == "Peito" ?
                                                      "assets/peito.jpg" : variacoes[index]['musculo']['descricao'] == "Tríceps" ?
                                                      "assets/triceps.jpg" : 
                                                      variacoes[index]['musculo']['descricao'] == "Costas" ?
                                                      "assets/costas.jpg" : 
                                                      variacoes[index]['musculo']['descricao'] == "Biceps" ?
                                                      "assets/biceps.jpg" : 
                                                      variacoes[index]['musculo']['descricao'] == "Quadriceps" ?
                                                      "assets/quadriceps.png" : 
                                                      variacoes[index]['musculo']['descricao'] == "Posterior de Coxa" ?
                                                      "assets/posterior.jpg" : 
                                                      variacoes[index]['musculo']['descricao'] == "Panturrilha" ?
                                                      "assets/panturrilha.jpg" : 
                                                      variacoes[index]['musculo']['descricao'] == "Abdomen" ?
                                                      "assets/abdomen.jpg" :
                                                      variacoes[index]['musculo']['descricao'] == "Trapezio" ?
                                                      "assets/trapezio.jpg" :
                                                      variacoes[index]['musculo']['descricao'] == "Ante Braço" ?
                                                      "assets/antebraco.jpg" : "assets/triceps.jpg"
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
                                                      variacoes[index]['descricao'],  
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
                  itemCount: variacoes.length
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

 