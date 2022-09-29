import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/avaliacaoFisica.dart';
import 'package:mcfitness/model/treino.dart';
import 'package:mcfitness/pages/teste/preview_page.dart';
import 'package:numberpicker/numberpicker.dart';

enum SingingCharacter { padrao, personalizado }

class AvaliacaoFisicaNovaAvaliacao extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;

  const AvaliacaoFisicaNovaAvaliacao(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal
    }
  ) : super(key: key);

  @override
  _AvaliacaoFisicaNovaAvaliacaoState createState() => _AvaliacaoFisicaNovaAvaliacaoState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal
  );
}

class _AvaliacaoFisicaNovaAvaliacaoState extends State<AvaliacaoFisicaNovaAvaliacao> {

  final int alunoIdLocal;
  final String alunoNomeLocal;

  String abertura = "";
  String fechamento = "";

  _AvaliacaoFisicaNovaAvaliacaoState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal
    }
  );

  SingingCharacter? _character = SingingCharacter.padrao;

  final _formKey = GlobalKey<FormState>();
  final objetivo = TextEditingController();
  final idade = TextEditingController();
  final altura = TextEditingController();
  final peso = TextEditingController();
  final peitoral = TextEditingController();
  final biceps = TextEditingController();
  final antebraco = TextEditingController();
  final cintura = TextEditingController();
  final abdome = TextEditingController();
  final quadril = TextEditingController();
  final coxa = TextEditingController();
  final fotoFrente = TextEditingController();
  final fotoLado = TextEditingController();
  final fotoCostas = TextEditingController();
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
  bool mostrarExplicacaoMedicao = false;
  bool mostrarNumberPickerRepeticoes = false;
  bool mostrarNumberPickerDescanso = false;
  bool selecionouMusculo = false;
  bool selecionouExercicio = false;
  bool clicouSalvar = false;

  bool clicouPeitoral = false;
  bool clicouBiceps = false;
  bool clicouAnteBraco= false;
  bool clicouCintura = false;
  bool clicouAbdome = false;
  bool clicouCoxa = false;
  bool clicouQuadril = false;

  String urlAdbome = "assets/medicao_abdome.png";
  String urlPeitoral = "assets/medicao_peitoral.jpg";
  String urlBiceps = "assets/medicao_biceps.jpg";
  String urlAnteBraco = "assets/medicao_antebraco.webp";
  String urlCintura = "assets/medicao_cintura.webp";
  String urlCoxa = "assets/medicao_coxa.jpg";
  String urlQuadril = "assets/medicao_quadril.jpg";

  String instrucaoAdbome = "Para medir sua circunferência abdominal, é importante posicionar a " + 
                          "fita métrica no ponto médio entre as duas últimas costelas e a parte" +
                          " superior do osso ilíaco. Se você não sabe onde ele se localiza, basta" +	
                          " passar a fita na altura do umbigo, envolvendo todo o diâmetro do corpo" + 
                          " nessa região. Tenha certeza de que a fita não está torta e nem 	enrolada.";

  String instrucaoPeitoral = "Para aferir corretamente a medida do peitoral você deve estar em pé, " +	
                        "ereto e com caixa torácica relaxada. Normalmente a maior circunferência se " +
                        "dá com a fita mais próxima às axilas no caso dos homens, e passando pelos " +
                        "mamilos no caso das mulheres.";

  String instrucaoBiceps = "Para a medida do braço, você pode aproveitar aquela marquinha da 	vacina" + 
                        " BCG (que a maioria das pessoas tem) para facilitar sua vida. Normalmente" + 
                        " essa medida é tirada com o braço esticado (músculo 	relaxado).";

  String instrucaoAnteBraco = "Geralmente a região de maior circunferência fica a uns 2 ou 3 dedos" +
                        " abaixo do cotovelo.";

  String instrucaoCintura = "Fique em pé com o abdômen relaxado e as pernas fechadas. " +
                        "Segure o ponto zero da fita métrica com uma mão, e com a outra, envolva o quadril. " +
                        "Você deve passar a fita na metade do bumbum. " + 
                        "Ajuste bem: não aperte muito, nem afrouxe a fita métrica.";

  String instrucaoCoxa = "A cintura é a região mais estreita do seu abdômen, localizada entre a última" +
                        " costela e o osso do quadril." + 
                        " Fique em pé, com o abdômen relaxado e as pernas paralelas." + 
                        " Segure o ponto zero da fita métrica com uma mão e, com a outra, passe ao" + 
                        " redor da cintura." + 
                        " A fita deve ficar ajustada, sem apertar muito, ou deixar larga.";

  String instrucaoQuadril = "Mais uma vez vamos procurar a região de maior circunferência do 	quadril," +
                        " geralmente localizada em um plano que passa pelo meio das nádegas.";

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
  String urlFrente = "";
  String urlLado = "";
  String urlCostas = "";
  DateTime dataSelecionada = DateTime.now();

  bool isCheck = false;
  bool nomePadrao = true;
  bool nomePersonalizado = false;
  bool uploading = false;

  int numeroSeries = 3;
  int numeroRepeticoes = 10;
  int numeroDescansoMin = 1;
  int numeroDescansoSec = 0;
  int exercicioIdSelecionado = 0;
  int count = 0;
  int aux = 0;

  List<String> exercicios = [];
  List<String> musculos = [];
  List<String> diasSemana = [];

  List<String> nomesPadroes = [
    'Treino A', 'Treino B', 'Treino C', 'Treino D', 'Treino E', 'Treino F', 'Treino G'
  ];

  List<String> velocidade = [
    'Cadenciado', 'Normal', 'Rápido'
  ];

  List<String> paths = [];

  final GlobalKey<FormFieldState> _keyExercicio = GlobalKey<FormFieldState>();

  Future<void> _novaAvaliacaoFisica() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.salvarAvaliacaoFisica(
        AvaliacaoFisica(
          id: 0,
          aluno: alunoIdLocal,
          abdome: abdome.text,
          altura: altura.text,
          anteBraco: antebraco.text,
          biceps: biceps.text,
          cintura: cintura.text,
          coxa: coxa.text,
          data: dataMostradaInicio,
          fotoCostas: urlCostas,
          fotoFrente: urlFrente,
          fotoLado: urlLado,
          idade: int.parse(idade.text),
          objetivo: objetivo.text,
          peitoral: peitoral.text,
          peso: double.parse(peso.text),
          quadril: quadril.text
        )
      );

      if (result['salvarAvaliacao']['id'] == 0) {
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

  showPreview(file, String foto) async {

    File? arq =  await Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => PreviewPage(file: file)
      )
    );

    if (arq != null) {
      print("Arquivo (Path) = ${arq.path}");
      print("Arquivo = ${arq}");

      if(foto == "frente"){
        fotoFrente.text = arq.path;
      }else if(foto == "lado"){
        fotoLado.text = arq.path;
      }else{
        fotoCostas.text = arq.path;
      }

      aux = 0;

      while(aux < paths.length){
        if(foto == paths[aux].split("-")[0]){
          paths.removeAt(aux);
        }else{
          aux++;
        }
      }

      paths.add("$foto-${arq.path}");
      
      Navigator.pop(context);
    }
  }

  pickAndUploadImage(String file, String foto) async {
    if (file != null) {
      UploadTask task = await upload(file);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {

          setState(() {
            uploading = true;
          });

        } else if (snapshot.state == TaskState.success) {
          final photoRef = snapshot.ref;

          print("Url gerada = ${await photoRef.getDownloadURL()}");

          if(foto == "frente"){
            urlFrente = await photoRef.getDownloadURL();
            print("Carregou URL frente");
          }else if(foto == "lado"){
            urlLado= await photoRef.getDownloadURL();
            print("Carregou URL lado");
          }else{
            urlCostas = await photoRef.getDownloadURL();
            print("Carregou URL costas");
          }

          if(urlFrente != "" && urlCostas != "" && urlLado != ""){
            setState(() {
              loading = false;
            });
            _novaAvaliacaoFisica();
          }else{
            print("Esperando o final do upload...");
          }
        }
      });
    }
  }

  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpeg';

      final storageRef = FirebaseStorage.instance.ref();

      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=300",
              contentType: "image/jpeg",
              customMetadata: {
                "user": "123",
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  @override
  void initState() {
    super.initState();

    dia = DateTime.now().day.toString();
    mes = DateTime.now().month.toString();
    ano = DateTime.now().year.toString();

    if(dia.length < 2){
      dia = "0" + DateTime.now().day.toString();
    }

    if(mes.length < 2){
      mes = "0" + DateTime.now().month.toString();
    }

    dataMostradaInicio = dia + "/" + mes + "/" + ano;
    
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
                  "Avaliação",
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
                      Colors.black,
                    Color.fromARGB(255, 132, 136, 139)
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
                              color: Color.fromARGB(255, 132, 136, 139),
                              child: Center(
                                //padding: const EdgeInsets.fromLTRB(10.0, 10.0, 6.5, 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Avaliação Física',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        alunoNomeLocal,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
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
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20, 0.0),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Qual seu objetivo?',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: objetivo,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Idade:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: idade,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Ex.: 23",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Altura:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: altura,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Ex.: 1.70",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Peso:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: peso,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Ex.: 55.5",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Peitoral:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    mostrarExplicacaoMedicao = true;
                                                    clicouPeitoral = true;
                                                  });
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.black,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: peitoral,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Biceps relaxado:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    mostrarExplicacaoMedicao = true;
                                                    clicouBiceps = true;
                                                  });
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.black,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: biceps,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Antebraço direito:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    mostrarExplicacaoMedicao = true;
                                                    clicouAnteBraco = true;
                                                  });
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.black,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: antebraco,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Cintura:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    mostrarExplicacaoMedicao = true;
                                                    clicouCintura = true;
                                                  });
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.black,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: cintura,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Abdome:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    mostrarExplicacaoMedicao = true;
                                                    clicouAbdome = true;
                                                  });
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.black,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: abdome,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Quadril:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    mostrarExplicacaoMedicao = true;
                                                    clicouQuadril = true;
                                                  });
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.black,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: quadril,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Coxa Medial:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    mostrarExplicacaoMedicao = true;
                                                    clicouCoxa = true;
                                                  });
                                                }, 
                                                icon: Icon(
                                                  Icons.smart_display_rounded,
                                                  color: Colors.black,
                                                )
                                              )
                                            ],
                                          ),
                                          TextFormField(
                                            controller: coxa,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(
                                            'Foto de Frente',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: fotoFrente,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              prefixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.blue[400]
                                                ),
                                                onPressed: (){
                                                  Navigator.push(
                                                    context, MaterialPageRoute(
                                                      builder: (context) => CameraCamera(
                                                        onFile: (file){
                                                          showPreview(file, "frente");
                                                        },
                                                      )
                                                    )
                                                  );
                                                },
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(
                                            'Foto de Lado',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: fotoLado,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              prefixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.blue[400]
                                                ),
                                                onPressed: (){
                                                  Navigator.push(
                                                    context, MaterialPageRoute(
                                                      builder: (context) => CameraCamera(
                                                        onFile: (file){
                                                          showPreview(file, "lado");
                                                        },
                                                      )
                                                    )
                                                  );
                                                },
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(
                                            'Foto de Costas',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: fotoCostas,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black
                                                )
                                              ),
                                              prefixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.blue[400]
                                                ),
                                                onPressed: (){
                                                  Navigator.push(
                                                    context, MaterialPageRoute(
                                                      builder: (context) => CameraCamera(
                                                        onFile: (file){
                                                          showPreview(file, "costas");
                                                        },
                                                      )
                                                    )
                                                  );
                                                },
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                            ),
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

                                                count = 0;

                                                while(count < paths.length){
                                                  
                                                  setState(() {
                                                    loading = true;
                                                  });

                                                  List <String> valorSeparado = paths[count].split("-");
                                                  //print("Foto: ${valorSeparado[0]}");
                                                  //print("Path: ${valorSeparado[1]}");
                                                  pickAndUploadImage(valorSeparado[1], valorSeparado[0]);
                                                  count++;
                                                }

                                                /*if(!uploading){
                                                  print("Inserindo avaliacao");
                                                  _novaAvaliacaoFisica();
                                                }*/

                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Enviar",
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          )
                                        ],
                                      ),
                                    ),
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
            mostrarExplicacaoMedicao ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black87.withOpacity(0.8),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[400],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {

                                  mostrarExplicacaoMedicao = false;

                                  clicouAbdome = false;
                                  clicouAnteBraco = false;
                                  clicouBiceps = false;
                                  clicouCintura = false;
                                  clicouCoxa = false;
                                  clicouPeitoral = false;
                                  clicouQuadril = false;
                                  
                                });
                              }, 
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              )
                            )
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        child: loading ? indicadorProgresso() : widgetMedicao(
                          clicouPeitoral ? urlPeitoral : clicouBiceps ? urlBiceps : clicouAnteBraco ? 
                          urlAnteBraco : clicouCintura ? urlCintura : clicouAbdome ? urlAdbome : clicouCoxa ? 
                          urlCoxa : clicouQuadril ? urlQuadril : "assets/Erro.png"
                        )
                      ),
                      Expanded(
                        child: Container(
                          //height: MediaQuery.of(context).size.height/6.2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              clicouPeitoral ? instrucaoPeitoral : clicouBiceps ? instrucaoBiceps : clicouAnteBraco ? 
                              instrucaoAnteBraco : clicouCintura ? instrucaoCintura : clicouAbdome ? instrucaoAdbome : clicouCoxa ? 
                              instrucaoCoxa : clicouQuadril ? instrucaoQuadril : "Sem Instrução",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
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
              indicadorProgresso() : Container()
            ]
          ),
      );
  }

  resetExercicio() {
    _keyExercicio.currentState!.reset();
  }

  indicadorProgresso(){
    return Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
    child: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Salvando...",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(
              color: Colors.blue,
            ),
          ],
        )
      )
    ),
      );
  }

  widgetMedicao(String urlImagem){
  return Container(
    height: MediaQuery.of(context).size.height/4,
      child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: Container(
        child: Center(
          child: Image(
            image: AssetImage(
              urlImagem
            )
          )
        )
      ),
    ),
  );
}

}

 