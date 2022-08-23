import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treinos_musculo.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_treino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treinos_musculo.dart';

enum SingingCharacter { nome, cnpj }

class TreinosListarTreinoNome extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final String treinoNomeGlobal;
  final int diaSemanaIdGlobal;
  final int objetivoIdGlobal;

  const TreinosListarTreinoNome(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal,
      required this.treinoNomeGlobal,
      required this.diaSemanaIdGlobal,
      required this.objetivoIdGlobal
    }
  ) : super(key: key);

  @override
  _TreinosListarTreinoNomeState createState() => _TreinosListarTreinoNomeState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal,
    treinoNomeLocal: treinoNomeGlobal,
    diaSemanaIdLocal: diaSemanaIdGlobal,
    objetivoIdLocal: objetivoIdGlobal
  );
}

bool termoMaiorTres = false;

class _TreinosListarTreinoNomeState extends State<TreinosListarTreinoNome> {

  final int alunoIdLocal;
  final String alunoNomeLocal;
  final String treinoNomeLocal;
  final int diaSemanaIdLocal;
  final int objetivoIdLocal;

  _TreinosListarTreinoNomeState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal,
      required this.treinoNomeLocal,
      required this.diaSemanaIdLocal,
      required this.objetivoIdLocal
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
  String urlImagemLocal = "";
  String musculoNomeLocal = "";
  String nomeTreino = "";
  String diaSemanaDia = "";
  int diaSemanaId = 0;
  int objetivoLocal = 0;
  //String entidadeIdQuery = entidadeId; 

  bool loading = false;
  bool treinoSelecionado = false;
  int idSelecionado = 0;
  bool isButtonDisable = false;

  List treinos = [];

  Future<void> _treinosAluno() async {

    setState(() {
      loading = true;
    });

    print("Aluno Id = $alunoIdLocal");
    print("Nome Treino = $treinoNomeLocal");

    try{

      Map<String, dynamic> result = await Graphql.treinosPorAlunoNome(alunoIdLocal, treinoNomeLocal);

      print("aqui");
      

      if (result['obterTreinoAlunoNome'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          treinos = result['obterTreinoAlunoNome'];
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

  /*Future<void> _vender() async {

    setState(() {
      loading = true;
    });

    String dia = "0";
    String mes = "0";
    String ano = "0";

    dia = DateTime.now().day.toString();
    mes = DateTime.now().month.toString();
    ano = DateTime.now().year.toString();

    if(dia.length < 2){
      dia = "0" + DateTime.now().day.toString();
    }

    if(mes.length < 2){
      mes = "0" + DateTime.now().month.toString();
    }

    abertura = ano + "-" + mes + "-" + dia;
    fechamento = abertura;

    Map<String, dynamic> result = await Graphql.criarPedido(PedidoVenda(
      id: 0,
      cliente: idSelecionado,
      responsavel: usuarioId,
      status: 1,
      abertura: abertura,
      fechamento: fechamento,
      fase: 1,
      valorPedido: 0.0,
      valorMeta: valorMetaQuery,
      entidade: entidadeId,
    ));

    Map<String, dynamic> resultPrecoVenda = await Graphql.pedidos_venda_por_cliente(ItemPedidoVendaCliente(
      cliente: idSelecionado,
      entidade: entidadeId,
    ));

    print("aqui");

    int count = 0;
    double valorPedido = 0.0;

    if (result['pedido'].length > 0) {
      print("Resultado buscado");

      setState(() {
        loading = false;
        termoMaiorTres = false;
      });

      pedidoId = result['pedido']['id'];
      if(result['pedido']['status']['descricao'] == null){
        status = "-";
      }else{
        status = result['pedido']['status']['descricao'];
      }

      while(count < resultPrecoVenda.length){

        if(resultPrecoVenda['pedidosCliente'][count]['id'] == pedidoId){
          valorPedido = resultPrecoVenda['pedidosCliente'][count]['valorPedido'];
          break;
        }else{
          count++;
        }

      }

      var tela = await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        SalePageProdutos(
          entidadeGlobal: entidadeId, 
          pedidoGlobal: pedidoId, 
          usuarioGlobal: usuarioId,
          statusGlobal: status,
          clienteGlobal: idSelecionado,
          usuarioNomeGlobal: usuarioNomeLocal,
        )
      ));

      if(tela == 1){
        setState(() {
          loading = false;
        });
      }

    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Não foi possivel criar um pedido'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        )
      );
    }

    
  }*/

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
      termoMaiorTres = true;
    });
    _treinosAluno();
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
        body: Container(
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
                  child: Text(
                    "$treinoNomeLocal - $alunoNomeLocal",
                    style: TextStyle(
                      fontSize: 20
                    ),
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
                      onPressed: () {
                        if(treinoSelecionado){
                          Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => TreinosListarTreinosMusculo(
                              alunoIdGlobal: alunoIdLocal,
                              alunoNomeGlobal: alunoNomeLocal,
                              musculoIdGlobal: idSelecionado,
                              urlImagemGlobal: urlImagemLocal,
                              musculoNomeGlobal: musculoNomeLocal,
                              diaSemanaDiaGlobal: diaSemanaDia,
                              diaSemanaIdGlobal: diaSemanaId,
                              nomeTreinoGlobal: nomeTreino,
                              objetivoGlobal: objetivoLocal,
                            )
                          )
                        );
                        }
                      },
                      color: treinoSelecionado ? Colors.black : Colors.grey,
                      child: Text(
                        'Ver Treino',
                        style: TextStyle(
                          color: treinoSelecionado ? Colors.white : Colors.black 
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
                return _treinosAluno();
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
                                        if(idSelecionado == treinos[index]['musculoAlvo']['id']){
                                          treinoSelecionado = !treinoSelecionado;
                                          idSelecionado = 0;
                                        }else{
                                          treinoSelecionado = true;
                                          idSelecionado = treinos[index]['musculoAlvo']['id'];
                                          musculoNomeLocal = treinos[index]['musculoAlvo']['descricao'];
                                          urlImagemLocal = treinos[index]['musculoAlvo']['descricao'] == "Ombro" ? 
                                            "assets/ombro.jpg" : 
                                          treinos[index]['musculoAlvo']['descricao'] == "Peito" ?
                                            "assets/peito.jpg" : "assets/triceps.jpg";
                                          nomeTreino = treinos[index]['nome'];
                                          diaSemanaId = treinos[index]['diaSemana']['id'];
                                          diaSemanaDia = treinos[index]['diaSemana']['dia'];
                                          //objetivoLocal = treinos[index]['objetivo']['id'];
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (treinoSelecionado && idSelecionado == treinos[index]['musculoAlvo']['id']) ? Colors.blue[400] : Colors.white,
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
                                                    treinos[index]['musculoAlvo']['descricao'] == "Ombro" ? 
                                                      "assets/ombro.jpg" : 
                                                    treinos[index]['musculoAlvo']['descricao'] == "Peito" ?
                                                      "assets/peito.jpg" : treinos[index]['musculoAlvo']['descricao'] == "Tríceps" ?
                                                      "assets/triceps.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Costas" ?
                                                      "assets/costas.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Biceps" ?
                                                      "assets/biceps.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Quadriceps" ?
                                                      "assets/quadriceps.png" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Posterior de Coxa" ?
                                                      "assets/posterior.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Panturrilha" ?
                                                      "assets/panturrilha.jpg" : 
                                                      treinos[index]['musculoAlvo']['descricao'] == "Abdomen" ?
                                                      "assets/abdomen.jpg" :
                                                      treinos[index]['musculoAlvo']['descricao'] == "Trapezio" ?
                                                      "assets/trapezio.jpg" :
                                                      treinos[index]['musculoAlvo']['descricao'] == "Ante Braço" ?
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
                                                      treinos[index]['musculoAlvo']['descricao'],  
                                                      overflow: TextOverflow.fade,                          
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15.0,
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
                  itemCount: treinos.length
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

 