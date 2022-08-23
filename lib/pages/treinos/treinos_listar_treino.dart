import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_anamnese_aluno.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treino_nome.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treinos_musculo.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_aluno.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_treino.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treino_nome.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treinos_dia.dart';
import 'package:mcfitness/pages/treinos/treinos_listar_treinos_musculo.dart';

enum SingingCharacter { nome, cnpj }

class TreinosListarTreino extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;
  final int objetivoIdGlobal;

  const TreinosListarTreino(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal,
      required this.objetivoIdGlobal
    }
  ) : super(key: key);

  @override
  _TreinosListarTreinoState createState() => _TreinosListarTreinoState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal,
    objetivoIdLocal: objetivoIdGlobal
  );
}

bool termoMaiorTres = false;

class _TreinosListarTreinoState extends State<TreinosListarTreino> {

  final int alunoIdLocal;
  final String alunoNomeLocal;
  final int objetivoIdLocal;

  _TreinosListarTreinoState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal,
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
  bool treinoSelecionadoDia = false;
  bool isCheckDia = true;
  bool isCheckGeral = false;
  int notificarDia = 0;
  int notificarGeral = 0;
  String idSelecionado = "";
  String idSelecionadoDia = "";
  bool isButtonDisable = false;

  DateTime data = DateTime.now();

  List treinosGeral = [];
  List treinosDia = [];

  Future<void> _treinosAluno() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.treinosPorAluno(alunoIdLocal);

      print("aqui");
      

      if (result['obterTreinoAluno'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          treinosGeral = result['obterTreinoAluno'];
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

  Future<void> _treinosAlunoDia() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.treinosNomePorDiaAluno(
        alunoIdLocal,
        data.weekday
      );

      print("aqui");
      

      if (result['obterTreinoNomeAluno'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          treinosDia = result['obterTreinoNomeAluno'];
        });

        _treinosAluno();

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
    _treinosAlunoDia();
    //_treinosAluno();
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
                    _treinosAluno();
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
                    "Treinos - $alunoNomeLocal",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    value: isCheckDia, 
                    onChanged: (value) {
                      setState(() {
                        isCheckDia = value!;
                        if(isCheckDia == true){
                          notificarDia = 1;
                          setState(() {
                            isCheckGeral = false;
                          });
                        }else{
                          notificarDia = 0;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'Treino de hoje'
                ),
                SizedBox(
                  width: 98,
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    value: isCheckGeral, 
                    onChanged: (value) {
                      setState(() {
                        isCheckGeral = value!;
                        if(isCheckGeral == true){
                          notificarGeral = 1;
                          setState(() {
                            isCheckDia = false;
                          });
                        }else{
                          notificarGeral = 0;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'Todos os treinos'
                ),
              ],
            ),
            loading ? indicadorProgresso() : isCheckDia ? widgetListaRolagemDia() : widgetListaRolagemGeral(),
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
                        if((treinoSelecionado || treinoSelecionadoDia)){
                          Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => TreinosListarTreinosDia(
                              alunoIdGlobal: alunoIdLocal,
                              alunoNomeGlobal: alunoNomeLocal,
                              musculoIdGlobal: 1,
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
                      color: (treinoSelecionado || treinoSelecionadoDia) ? Colors.black : Colors.grey,
                      child: Text(
                        'Ver Treino',
                        style: TextStyle(
                          color: (treinoSelecionado || treinoSelecionadoDia) ? Colors.white : Colors.black 
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

  widgetListaRolagemGeral() {
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
                                        if(idSelecionado == treinosGeral[index]['nome']){
                                          treinoSelecionado = !treinoSelecionado;
                                          idSelecionado = "";
                                          nomeTreino = "";
                                          diaSemanaId = 0;
                                          diaSemanaDia = "";
                                        }else{
                                          treinoSelecionado = true;
                                          idSelecionado = treinosGeral[index]['nome'];
                                          nomeTreino = treinosGeral[index]['nome'];
                                          diaSemanaId = treinosGeral[index]['diaSemana']['id'];
                                          diaSemanaDia = treinosGeral[index]['diaSemana']['dia'];
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (treinoSelecionado && idSelecionado == treinosGeral[index]['nome']) ? Colors.blue[400] : Colors.white,
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
                                                    "assets/peito.jpg"
                                                    /*treinos[index]['musculoAlvo']['descricao'] == "Ombro" ? 
                                                      "assets/ombro.jpg" : 
                                                    treinos[index]['musculoAlvo']['descricao'] == "Peito" ?
                                                      "assets/peito.jpg" : "assets/triceps.jpg"*/
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
                                                      treinosGeral[index]['nome'],  
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
                  itemCount: treinosGeral.length
              ),
            ),
          ),
        )
    );
  }

  widgetListaRolagemDia() {
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
                                        if(idSelecionadoDia == treinosDia[index]['nome']){
                                          print("Deselecionou");
                                          treinoSelecionadoDia = !treinoSelecionadoDia;
                                          idSelecionadoDia = "";
                                          nomeTreino = "";
                                          diaSemanaId = 0;
                                          diaSemanaDia = "";
                                        }else{
                                          treinoSelecionadoDia = true;
                                          print("Selecionou");
                                          print(treinoSelecionadoDia);
                                          print(idSelecionadoDia);
                                          idSelecionadoDia = treinosDia[index]['nome'];
                                          nomeTreino = treinosDia[index]['nome'];
                                          diaSemanaId = data.weekday;
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (treinoSelecionadoDia && idSelecionadoDia == treinosDia[index]['nome']) ? Colors.blue[400] : Colors.white,
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
                                                    "assets/peito.jpg"
                                                    /*treinos[index]['musculoAlvo']['descricao'] == "Ombro" ? 
                                                      "assets/ombro.jpg" : 
                                                    treinos[index]['musculoAlvo']['descricao'] == "Peito" ?
                                                      "assets/peito.jpg" : "assets/triceps.jpg"*/
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
                                                      treinosDia[index]['nome'],  
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
                  itemCount: treinosDia.length
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

 