import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/exercicio.dart';

enum SingingCharacter { nome, cnpj }

class ExerciciosNovoExercicio extends StatefulWidget {

  final int personalIdGlobal;
  final int exercicioIdGlobal;
  final String nomeExercicioGlobal;
  final int musculoIdGlobal;
  final bool editandoGlobal;
  final String nomeMusculoGlobal;
  final String urlGlobal;

  const ExerciciosNovoExercicio(
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
  _ExerciciosNovoExercicioState createState() => _ExerciciosNovoExercicioState(
    personalIdLocal: personalIdGlobal,
    editandoLocal: editandoGlobal,
    musculoIdLocal: musculoIdGlobal,
    nomeExercicioLocal: nomeExercicioGlobal,
    nomeMusculoLocal: nomeMusculoGlobal,
    exercicioIdLocal: exercicioIdGlobal,
    urlLocal: urlGlobal
  );
}

class _ExerciciosNovoExercicioState extends State<ExerciciosNovoExercicio> {

  final int personalIdLocal;
  final int exercicioIdLocal;
  final String nomeExercicioLocal;
  final int musculoIdLocal;
  final bool editandoLocal;
  final String nomeMusculoLocal;
  final String urlLocal;

  String abertura = "";
  String fechamento = "";

  _ExerciciosNovoExercicioState({
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
  final nome = TextEditingController();
  final cpf = TextEditingController();
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
  bool carregouMusculos = false;
  bool clicouSalvar = false;
  final similares = TextEditingController();
  final observacao = TextEditingController();
  int qtdVendidaInt = 0;
  String pessoaIdRetornado = "";
  String uf = "";
  String dataFormatadaInicio = "";
  String dataMostradaInicio = "";
  String dia = "0";
  String mes = "0";
  String ano = "0";
  int musculoId = 0;
  bool selecionouImagem = false;
  String urlSelecionada = "";

  DateTime dataSelecionada = DateTime.now();

  bool isCheck = false;

  List precos = [];

  List<String> urls = [
    "assets/supino_reto_gif.gif",
    "assets/supino_inclinado_gif.webp",
    "assets/voador_gif.webp",
    "assets/crossover_alta_gif.gif",
    "assets/triceps-puxada-no-pulley.webp"
  ];

  List<String> musculos = [];

  Future<void> _novoExercicio() async {

    try{

      Map<String, dynamic> result = await Graphql.salvarExercicio(
        Exercicio(
          id: editandoLocal ? exercicioIdLocal : 0,
          musculo: musculoId,
          nome: nome.text,
          professor: personalIdLocal,
          urlImagem: urlSelecionada
        )
      );

      if(!editandoLocal){

        if (result['salvarExercicio']['id'] == 0) {
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

      }else{
        if (result['salvarExercicio']['id'] == exercicioIdLocal) {
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

  @override
  void initState() {
    super.initState();

    if(editandoLocal){
      print("Editando... $exercicioIdLocal");
      nome.text = nomeExercicioLocal;
      musculoId = musculoIdLocal;
      urlSelecionada = urlLocal;
    }
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
                            child: Text(
                              'Novo Exercicio',
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
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50, 0.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                              'Nome',
                              style: TextStyle(
                                fontSize: 23.0
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
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
                                hintText: "Nome do Exercicio",
                                hintStyle: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Musculo Alvo',
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
  
                                    List <String> valorSeparado = valorSelecionado.split(" - ");
                                    print("\"${valorSeparado[0]}\"");
                                    musculoId = int.parse(valorSeparado[0]);
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
                                  hintText: editandoLocal ? "$musculoIdLocal - $nomeMusculoLocal" : "Musculo Alvo",
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
                              'Imagem Ilustrativa',
                              style: TextStyle(
                                fontSize: 23.0
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            SizedBox(
                              height: 50.0,
                              child: Container(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.black,
                                  items: urls.map((String value){
                                    return DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 80,
                                            child: Image(
                                              image: AssetImage(
                                               value,
                                              ),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Text(
                                            value,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                      value: value,
                                    );
                                  }).toList(),  
                                  onChanged: (valorSelecionado){

                                    print("URl selecionada = $valorSelecionado");

                                    setState(() {
                                      selecionouImagem = true;
                                      if(valorSelecionado != ""){
                                        urlSelecionada = valorSelecionado!;
                                      }
                                    });

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
                                    hintText: (editandoLocal && urlSelecionada != "") ? "$urlSelecionada" : "Imagem do Exercicio",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            ),
                            selecionouImagem || (editandoLocal && urlSelecionada != "") ? 
                              Container(
                                height: 200,
                                child: Image(
                                  image: AssetImage(
                                    urlSelecionada,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ) : Container(),
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
                                _novoExercicio();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Salvar",
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
        /*body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width, //Pegar a largura da tela quando usamos o SingleChildScrollView
            height: MediaQuery.of(context).size.height,
            child: Container(
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
                          ],
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(50.0, 70.0, 50, 8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Nome',
                              style: TextStyle(
                                fontSize: 23.0
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
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
                                hintText: "Nome do Exercicio",
                                hintStyle: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Musculo Alvo',
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
  
                                    List <String> valorSeparado = valorSelecionado.split(" - ");
                                    print("\"${valorSeparado[0]}\"");
                                    musculoId = int.parse(valorSeparado[0]);
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
                                  hintText: editandoLocal ? "$musculoIdLocal - $nomeMusculoLocal" : "Musculo Alvo",
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
                              'Imagem Ilustrativa',
                              style: TextStyle(
                                fontSize: 23.0
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            SizedBox(
                              height: 50.0,
                              child: Container(
                                child: Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      dropdownColor: Colors.white,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.black,
                                      items: urls.map((String value){
                                        return DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 80,
                                                child: Image(
                                                  image: AssetImage(
                                                    value,
                                                  ),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Text(
                                                value,
                                                style: TextStyle(
                                                  color: Colors.black
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                          value: value,
                                        );
                                      }).toList(),  
                                      onChanged: (valorSelecionado){

                                        print("URl selecionada = $valorSelecionado");

                                        selecionouImagem = true;
                                        if(valorSelecionado != ""){
                                          urlSelecionada = valorSelecionado!;
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
                                        hintText: editandoLocal ? "$musculoIdLocal - $nomeMusculoLocal" : "Imagem do Exercicio",
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                        )
                                      ),
                                    ),
                                    selecionouImagem ? 
                                    Container(
                                      height: 300,
                                      child: Image(
                                        image: AssetImage(
                                          urlSelecionada,
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ) : Container()
                                  ],
                                ),
                              )
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
                                _novoExercicio();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Salvar",
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

 