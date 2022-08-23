import 'package:flutter/material.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_aluno.dart';

enum SingingCharacter { nome, cnpj }

class AlunosAnamneseAluno extends StatefulWidget {

  final int alunoIdGlobal;

  const AlunosAnamneseAluno(
    {
      Key? key, 
      required this.alunoIdGlobal, 
    }
  ) : super(key: key);

  @override
  _AlunosAnamneseAlunoState createState() => _AlunosAnamneseAlunoState(
    alunoIdLocal: alunoIdGlobal, 
  );
}

bool termoMaiorTres = false;

class _AlunosAnamneseAlunoState extends State<AlunosAnamneseAluno> {

  final int alunoIdLocal;

  _AlunosAnamneseAlunoState(
    {
      required this.alunoIdLocal, 
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
  bool clienteSelecionado = false;
  String idSelecionado = "";
  bool isButtonDisable = false;

  List clientesVendedores = [];
  List pedido_por_clientes = [];

  /*Future<void> _clientesPorVendedor() async {

    setState(() {
      loading = true;
    });

    Map<String, dynamic>? result = await Graphql.clientesPorVendedor(usuarioId);

    print("aqui");

    if(result == null){
      setState(() {
        loading = false;
        termoMaiorTres = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro na Query clientesPorVendedor'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        )
      );
    }else{

      if (result['clientesVendedor'].length > 0) {
      print("Resultado buscado");

      setState(() {
        loading = false;
        termoMaiorTres = false;
        clientesVendedores = result['clientesVendedor'];
      });

    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Nenhum cliente nesse Vendedor'),
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

  Future<void> _vender() async {

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
    //_clientesPorVendedor();
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
                    "Anamnese",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
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
                                      if(idSelecionado == clientesVendedores[index]['id']){
                                        clienteSelecionado = !clienteSelecionado;
                                      }else{
                                        clienteSelecionado = true;
                                        idSelecionado = clientesVendedores[index]['id'];
                                        valorMetaQuery = clientesVendedores[index]['metaValor'];
                                        print("Id Selecionado = $idSelecionado");
                                        print("Valor Meta Selecionado = $valorMetaQuery");
                                      }
                                      
                                    });
                                },
                                child: Container(
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width/1.127,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                bottomLeft: Radius.circular(4.0)
                                              ),
                                              color: (clienteSelecionado && idSelecionado == clientesVendedores[index]['id']) ? Colors.yellow : Colors.red
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "ID:",
                                                  style: TextStyle(
                                                    color: (clienteSelecionado && idSelecionado == clientesVendedores[index]['id']) ? Colors.white : Colors.black,
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                                Text(
                                                  clientesVendedores[index]['id'],
                                                  style: TextStyle(
                                                    color: (clienteSelecionado && idSelecionado == clientesVendedores[index]['id']) ? Colors.white : Colors.black,
                                                    fontSize: 13.0
                                                  ),
                                                  
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  "Ult.Compra:",
                                                  style: TextStyle(
                                                    color: (clienteSelecionado && idSelecionado == clientesVendedores[index]['id']) ? Colors.white : Colors.black,
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                                Text(
                                                  clientesVendedores[index]['dataUltimaCompra'] == null ? "-" : "${clientesVendedores[index]['dataUltimaCompra']}",
                                                  style: TextStyle(
                                                    color: (clienteSelecionado && idSelecionado == clientesVendedores[index]['id']) ? Colors.white : Colors.black,
                                                    fontSize: 15.0
                                                  ),
                                                ),
                                              ],
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
                                                    clientesVendedores[index]['nomeFantasia'],  
                                                    overflow: TextOverflow.fade,                          
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "CNPJ: ",                            
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight.normal
                                                        ),
                                                      ),
                                                      Text(
                                                        clientesVendedores[index]['cnpj'],                            
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0
                                                        ),
                                                      )
                                                    ],
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
                itemCount: clientesVendedores.length
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

 