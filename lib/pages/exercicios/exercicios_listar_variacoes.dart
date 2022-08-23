import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';

enum SingingCharacter { nome, cnpj }

class ExerciciosListarVariacoes extends StatefulWidget {

  final int exercicicoIdGlobal;

  const ExerciciosListarVariacoes(
    {
      Key? key, 
      required this.exercicicoIdGlobal
    }
  ) : super(key: key);

  @override
  _ExerciciosListarVariacoesState createState() => _ExerciciosListarVariacoesState(
    exercicioIdLocal: exercicicoIdGlobal
  );
}

bool termoMaiorTres = false;

class _ExerciciosListarVariacoesState extends State<ExerciciosListarVariacoes> {

  final int exercicioIdLocal;

  _ExerciciosListarVariacoesState({
    required this.exercicioIdLocal
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

      Map<String, dynamic> result = await Graphql.obterVariacoesExercicio(exercicioIdLocal);

      print("aqui");
      

      if (result['obterVariacoes'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          variacoes = result['obterVariacoes'];
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
                    _clientesPorVendedor();
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
                      },
                      color: Colors.black,
                      child: Text(
                        'Nova Variação',
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

 