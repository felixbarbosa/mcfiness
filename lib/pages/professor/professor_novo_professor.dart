import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/avaliacaoFisica.dart';
import 'package:mcfitness/model/personal.dart';
import 'package:mcfitness/model/treino.dart';
import 'package:mcfitness/pages/teste/preview_page.dart';
import 'package:numberpicker/numberpicker.dart';

enum SingingCharacter { padrao, personalizado }

class Professor_novo_professor extends StatefulWidget {

  final int alunoIdGlobal;
  final String alunoNomeGlobal;

  const Professor_novo_professor(
    {
      Key? key, 
      required this.alunoIdGlobal, 
      required this.alunoNomeGlobal
    }
  ) : super(key: key);

  @override
  _Professor_novo_professorState createState() => _Professor_novo_professorState(
    alunoIdLocal: alunoIdGlobal, 
    alunoNomeLocal: alunoNomeGlobal
  );
}

class _Professor_novo_professorState extends State<Professor_novo_professor> {

  final int alunoIdLocal;
  final String alunoNomeLocal;

  String abertura = "";
  String fechamento = "";

  _Professor_novo_professorState(
    {
      required this.alunoIdLocal, 
      required this.alunoNomeLocal
    }
  );

  SingingCharacter? _character = SingingCharacter.padrao;

  final _formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final cpf = TextEditingController();
  final email = TextEditingController();
  final cref = TextEditingController();
  final senha = TextEditingController();
  final confirmacaoSenha = TextEditingController();
  //final entcpf = 5;

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
  final urlImage = TextEditingController();
  int promocao = 0;
  double preco = 0.0;
  double desconto = 0.0;
  double totalItem = 0.0;
  String tabelaPreco = "";
  String txtQtde = "0";
  String generoSelecionado = "";
  XFile? fileImage;
  bool jaMudou = false;
  bool mostrarExplicacaoMedicao = false;
  bool mostrarNumberPickerRepeticoes = false;
  bool mostrarNumberPickerDescanso = false;
  bool selecionouMusculo = false;
  bool selecionouExercicio = false;
  bool clicouSalvar = false;

  int idade = 0;

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
                          " passar a fita na email do umbigo, envolvendo todo o diâmetro do corpo" + 
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
  String veloccpfSelecionada = "";
  String urlFrente = "";
  String urlLado = "";
  String urlCostas = "";
  String linkImage = "";
  DateTime dataSelecionada = DateTime.now();

  bool isCheck = false;
  bool nomePadrao = true;
  bool nomePersonalizado = false;
  bool senhaInvisivel = true;
  bool confirmacaoSenhaInvisivel = true;
  bool uploading = false;
  bool crefValido = false;

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

  List<String> veloccpf = [
    'Cadenciado', 'Normal', 'Rápido'
  ];

  List<String> generos = [
    'Masculino', 'Feminino'
  ];

  List<String> ufs = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR',
    'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  List<Reference> refs = [];

  List<String> separacaoCref = [];

  List<String> separacaoCaracteres = [];

  String digitos = "";

  String caracteres = "";

  final GlobalKey<FormFieldState> _keyExercicio = GlobalKey<FormFieldState>();

  Future<void> _novoProfessor() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.salvarPersonal(
        Personal(
          id: 0,
          cpf: cpf.text,
          cref: cref.text,
          email: email.text,
          idade: idade,
          login: email.text,
          nome: nome.text,
          senha: senha.text,
          sexo: generoSelecionado,
          foto: linkImage
        )
      );

      if (result['salvarPersonal']['id'] >= 0) {
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

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    //XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      urlImage.text = image == null ? "" : image.path;
    });
    return image;
  }

  pickAndUploadImage(XFile? file) async {
    setState(() {
      loading = true;
      clicouSalvar = true;
    });
    if (file != null) {
      UploadTask task = await uploadImage(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            loading = true;
            //total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          final photoRef = snapshot.ref;

          refs.add(photoRef);
          linkImage = await photoRef.getDownloadURL();
          // final SharedPreferences prefs = await _prefs;
          // prefs.setStringList('images', arquivos);

          if(linkImage != ""){

            _novoProfessor();

          }else{
            print("Esperando o final do upload...");
          }
        }
      });
    }else{
      setState(() {
        loading = false;
      });
    }
  }

  Future<UploadTask> uploadImage(String path) async {
    File file = File(path);
    try {
      String ref = 'images/ADM-${nome.text}.jpeg';
      //String ref = 'images/img-${DateTime.now().toString()}.mp4';
      final storageRef = FirebaseStorage.instance.ref();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=300",
              //contentType: "image/jpeg",
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
    dataMostradaSelecionada = dataMostradaInicio;
    dataFormatadaInicio = ano + "-" + mes + "-" + dia;
    dataFormatadaSelecionada = dataFormatadaInicio;
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
                  "Professor",
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
                                  child: Text(
                                    'Novo Professor',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.white
                                    ),
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
                                            'Nome:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: nome,
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
                                              hintText: "Seu Nome",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Email:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: email,
                                            keyboardType: TextInputType.emailAddress,
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
                                              hintText: "Seu Email",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'CPF:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: cpf,
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
                                              hintText: "Seu CPF",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'CREF:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: cref,
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
                                              hintText: "Seu CREF ativo",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Nova Senha:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: senha,
                                            obscureText: senhaInvisivel,
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
                                              suffixIcon: IconButton(
                                                splashRadius: 25.0,
                                                onPressed: () => setState(
                                                    () => senhaInvisivel = !senhaInvisivel),
                                                icon: Icon(
                                                  senhaInvisivel
                                                      ? Icons.visibility_off_rounded
                                                      : Icons.visibility_rounded,
                                                  color: Theme.of(context).disabledColor,
                                                ),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Senha para o login",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Confirmar senha:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: confirmacaoSenha,
                                            obscureText: confirmacaoSenhaInvisivel,
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
                                              suffixIcon: IconButton(
                                                splashRadius: 25.0,
                                                onPressed: () => setState(
                                                    () => confirmacaoSenhaInvisivel = !confirmacaoSenhaInvisivel),
                                                icon: Icon(
                                                  confirmacaoSenhaInvisivel
                                                      ? Icons.visibility_off_rounded
                                                      : Icons.visibility_rounded,
                                                  color: Theme.of(context).disabledColor,
                                                ),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              hintText: "Repita a senha",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Data de Nascimento:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          GestureDetector(
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: Colors.black
                                                ),
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
                                                      dataMostradaSelecionada,
                                                      style: TextStyle(
                                                        color: Colors.black
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: (){
                                              showDatePicker(
                                                context: context, 
                                                initialDate: dataSelecionada, 
                                                firstDate: DateTime(1930), 
                                                lastDate: DateTime(DateTime.now().year+1)
                                              ).then((value) {
                                                
                                                dia = value!.day.toString();
                                                mes = value.month.toString();
                                                ano = value.year.toString();

                                                if(dia.length < 2){
                                                  dia = "0" + value.day.toString();
                                                }

                                                if(mes.length < 2){
                                                  mes = "0" + value.month.toString();
                                                }

                                                setState(() {
                                                  dataSelecionada = value;
                                                  dataFormatadaSelecionada = ano + "-" + mes + "-" + dia;
                                                  dataMostradaSelecionada = dia + "/" + mes + "/" + ano;
                                                });
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Sexo:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
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
                                              items: generos.map((String value){
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
                                                  
                                                  generoSelecionado = valorSelecionado == "Masculino" ? "M" : "F";
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
                                                hintText: "Sexo",
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                )
                                              ),
                                            )
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text(
                                            'Foto:',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            controller: urlImage,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.image,
                                                  color: Colors.black
                                                ),
                                                onPressed: () async {
                                                  //pickAndUploadImage();
                                                  fileImage = await getImage();
                                                },
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(25.0)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50.0)
                                              ),
                                              hintText: "Foto de Perfil",
                                              hintStyle: TextStyle(
                                                color: Colors.grey
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

                                              calculoIdade();

                                              if(nome.text == "" || email.text == "" || cpf.text == "" || 
                                              cref.text == "" || senha.text == "" || confirmacaoSenha.text == ""
                                              || generoSelecionado == ""){

                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                        title: const Text('Preencha todos os campos'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: const Text('Fechar'),
                                                          ),
                                                        ],
                                                      ));

                                              }else{

                                                if(!RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(email.text)){

                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text('Email informado é inválido!'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text('Fechar'),
                                                        ),
                                                      ],
                                                    )
                                                  );

                                                }else if(!CPFValidator.isValid(cpf.text)){
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text('CPF informado é inválido!'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text('Fechar'),
                                                        ),
                                                      ],
                                                    )
                                                  );
                                                }else if(!validarCref()){
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text('CREF informado é inválido!'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text('Fechar'),
                                                        ),
                                                      ],
                                                    )
                                                  );
                                                }
                                                else if(idade < 16){
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                          title: const Text('Idade não permitida para ser professor(a)!'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              child: const Text('Fechar'),
                                                            ),
                                                          ],
                                                        ));
                                                }else if(senha.text != confirmacaoSenha.text){
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                          title: const Text('Senhas diferentes'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              child: const Text('Fechar'),
                                                            ),
                                                          ],
                                                        ));
                                                }else{
                                                  pickAndUploadImage(fileImage);
                                                }

                                              }

                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Realizar Cadastro",
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
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

  calculoIdade(){

    //dataMostradaInicio //Data atual (dd/MM/aaaa)
    //dataMostradaSelecionada //Data Nascimento (dd/MM/aaaa)

    int anoAtual = int.parse(dataMostradaInicio.split("/")[2]);
    int anoNascimento = int.parse(dataMostradaSelecionada.split("/")[2]);
    int mesAtual = int.parse(dataMostradaInicio.split("/")[1]);
    int mesNascimento = int.parse(dataMostradaSelecionada.split("/")[1]);
    int diaAtual = int.parse(dataMostradaInicio.split("/")[0]);
    int diaNascimento = int.parse(dataMostradaSelecionada.split("/")[0]);
    
    if(mesAtual < mesNascimento){
      print("Mes atual menor que o mes de nascimento");
      idade = (anoAtual - anoNascimento) - 1;
    }else if(mesAtual > mesNascimento){
      print("Mes atual maior que o mes de nascimento");
      idade = anoAtual - anoNascimento;
    }else{
      print("Mes atual igual ao mes de nascimento");
      if(diaAtual < diaNascimento){
        print("Dia atual menor que o dia de nascimento");
        idade = (anoAtual - anoNascimento) - 1;
      }else{
        print("Dia atual igual ou maior que o dia de nascimento");
        idade = anoAtual - anoNascimento;
      }
    }

    print("Você tem $idade anos");


  }

  bool validarCref(){

    if(cref.text.contains("-") && cref.text.contains("/")){

      separacaoCref = cref.text.split("-"); //['000000','G/PE']

      caracteres = separacaoCref[1]; //'G/PE'

      separacaoCaracteres = caracteres.split("/"); //['G', 'PE']

      digitos = separacaoCref[0]; //'000000'

      try{

        if(digitos.length == 6){

          if(int.parse(digitos) != null){
            if(separacaoCaracteres[0].toUpperCase() == "G"){
              if(ufs.contains(separacaoCaracteres[1].toUpperCase())){
                crefValido = true;
              }else{
                crefValido = false;
              }
            }else{
              crefValido = false;
            }
          }else{
            crefValido = false;
          }

        }else{
          crefValido = false;
        }

      }catch(Exception){
        return false;
      }
      

    }else{
      crefValido = false;
    }

    return crefValido;

  }

  indicadorProgresso(){
    return Padding(
    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/4, MediaQuery.of(context).size.height/3, MediaQuery.of(context).size.width/4,  MediaQuery.of(context).size.height/2.8),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[400],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Salvando...",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
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

 