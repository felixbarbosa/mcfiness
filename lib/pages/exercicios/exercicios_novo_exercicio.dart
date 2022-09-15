import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final urlVideo = TextEditingController();
  final urlImage = TextEditingController();
  final email = TextEditingController();
  final instrucao = TextEditingController();
  //final entidade = 5;

  int idLocal = 0;
  bool loading = false;
  bool uploadingImage = true;
  bool uploadingVideo = true;
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
  String linkImage = "";
  String linkVideo = "";

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

  List<Reference> refs = [];
  List<String> arquivos = [];

  XFile? fileImage;
  XFile? fileVideo;

  Future<void> _novoExercicio() async {

    try{

      Map<String, dynamic> result = await Graphql.salvarExercicio(
        Exercicio(
          id: editandoLocal ? exercicioIdLocal : 0,
          musculo: musculoId,
          nome: nome.text,
          professor: personalIdLocal,
          urlImagem: linkImage,
          urlVideo: linkVideo,
          instrucao: instrucao.text
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
            clicouSalvar = false;
          });

        } else {
          setState(() {
            loading = false;
            clicouSalvar = false;
          });
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
            clicouSalvar = false;
          });

        } else {
          setState(() {
            loading = false;
            clicouSalvar = false;
          });
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
        clicouSalvar = false;
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

        setState(() {
          loading = false;
          clicouSalvar = false;
        });

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

  pickAndUploadVideo(XFile? file) async {
    //XFile? file = await getVideo();
    if (file != null) {
      UploadTask task = await uploadVideo(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            loading = true;
            //total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          final photoRef = snapshot.ref;

          // final newMetadata = SettableMetadata(
          //   cacheControl: "public, max-age=300",
          //   contentType: "image/jpeg",
          // );
          // await photoRef.updateMetadata(newMetadata);

          arquivos.add(await photoRef.getDownloadURL());
          refs.add(photoRef);
          linkVideo = await photoRef.getDownloadURL();
          // final SharedPreferences prefs = await _prefs;
          // prefs.setStringList('images', arquivos);

          if(linkVideo != "" && !uploadingImage){
            uploadingVideo = false;
            setState(() {
              loading = false;
            });
            print("Imagem = ${linkImage}");
            print("Video = ${linkVideo}");
            print("Preparando para salvar...");
            _novoExercicio();
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

          // final newMetadata = SettableMetadata(
          //   cacheControl: "public, max-age=300",
          //   contentType: "image/jpeg",
          // );
          // await photoRef.updateMetadata(newMetadata);

          arquivos.add(await photoRef.getDownloadURL());
          refs.add(photoRef);
          linkImage = await photoRef.getDownloadURL();
          // final SharedPreferences prefs = await _prefs;
          // prefs.setStringList('images', arquivos);

          if(linkImage != ""){
            uploadingImage = false;
            pickAndUploadVideo(fileVideo);
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

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    //XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      urlImage.text = image == null ? "" : image.path;
    });
    return image;
  }

  Future<XFile?> getVideo() async {
    final ImagePicker _picker = ImagePicker();
    //XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      urlVideo.text = video == null ? "" : video.path;
    });
    return video;
  }

  Future<UploadTask> uploadVideo(String path) async {
    File file = File(path);
    try {
      String ref = 'videos/${personalIdLocal}-${nome.text}.mp4';
      //String ref = 'images/img-${DateTime.now().toString()}.mp4';
      final storageRef = FirebaseStorage.instance.ref();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=300",
              //contentType: "image/jpeg",
              contentType: "video/mp4",
              customMetadata: {
                "user": "123",
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future<UploadTask> uploadImage(String path) async {
    File file = File(path);
    try {
      String ref = 'images/${personalIdLocal}-${nome.text}.jpeg';
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
        body: Stack(
          children: [
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
                                  hintText: "Imagem demonstrativa",
                                  hintStyle: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Demonstração do Exercicio',
                                style: TextStyle(
                                  fontSize: 23.0
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextFormField(
                                controller: urlVideo,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.video_camera_back,
                                      color: Colors.black
                                    ),
                                    onPressed: () async {
                                      //pickAndUploadVideo();
                                      fileVideo = await getVideo();
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
                                  hintText: "Video demonstrativo",
                                  hintStyle: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Instrução do Exercicio",
                                style: TextStyle(
                                  fontSize: 23
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 100.0,
                                child: TextFormField(
                                  controller: instrucao,
                                  maxLines: 5,
                                  style: TextStyle(
                                    color: Colors.black
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Instrução de como executar o exercicio",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12.0
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17.0)),
                                color: (clicouSalvar || nome.text == "" || musculoId == 0) ? Colors.grey : Colors.grey[900],
                                textColor: Colors.white,
                                minWidth: double.infinity,
                                height: 42,
                                onPressed: () {
                                  if(!clicouSalvar && nome.text != "" && musculoId != 0){
                                    pickAndUploadImage(fileImage);
                                  }
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
                              SizedBox(
                                height: 20,
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
              loading ?
              indicadorProgresso() : Container()
          ]
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
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height/7,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black
          ),
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    'Uploading...',
                    style: TextStyle(
                      color: Colors.blue[400]
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

 