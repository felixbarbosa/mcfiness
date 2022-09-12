import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/aluno.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

enum SingingCharacter { nome, cnpj }

class AlunosNovoAluno extends StatefulWidget {

  final int professorIdGlobal;

  const AlunosNovoAluno(
    {
      Key? key, required this.professorIdGlobal, 
    }
  ) : super(key: key);

  @override
  _AlunosNovoAlunoState createState() => _AlunosNovoAlunoState(
    professorIdLocal: professorIdGlobal, 
  );
}

class _AlunosNovoAlunoState extends State<AlunosNovoAluno> {

  final int professorIdLocal;

  String abertura = "";
  String fechamento = "";

  _AlunosNovoAlunoState(
    {
      required this.professorIdLocal, 
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
  bool clicouSalvar = false;
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
  String generoSelecionado = "";
  int numeroInicial = 0;
  int numeroFinal = 0;
  Random random = new Random();
  int indexLetra = 0;
  String codigoGerado = "";
  int idade = 0;
  DateTime dataSelecionada = DateTime.now();

  bool isCheck = false;

  List precos = [];

  List<String> letras = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r",
  "s", "t", "u", "v", "w", "x", "y", "z"];

  List<String> generos = [
    'Masculino', 'Feminino'
  ];

  Future<void> _salvarAluno() async {

    try{

      idade = DateTime.now().year - int.parse(ano);

      if (DateTime.now().month < int.parse(mes))
        idade--;
      else if (DateTime.now().month == int.parse(mes)){
        if (DateTime.now().day < int.parse(dia))
          idade--;
      }

      numeroInicial = random.nextInt(9); // 0 - 9
      indexLetra = random.nextInt(25); // 0 - 25
      numeroFinal = random.nextInt(99 - 11) + 10; // 10 - 99

      codigoGerado = numeroInicial.toString() + letras[indexLetra].toUpperCase() + numeroFinal.toString();

      Map<String, dynamic> result = await Graphql.salvarAluno(Aluno(
        id: 0,
        nome: nome.text,
        cpf: cpf.text,
        email: email.text,
        login: email.text,
        senha: codigoGerado,
        personal: professorIdLocal,
        idade: idade,
        sexo: generoSelecionado,
        objetivo: 1
      ));

      if (result['salvarAluno']['id'] > 0) {
        print("Resultado buscado");

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                "Login e Senha:",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
            content: Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login: ${email.text}",
                    style: TextStyle(
                      color: Colors.pink[100],
                      fontSize: 20
                    ),
                  ),
                  Text(
                    "Senha: ${codigoGerado}",
                    style: TextStyle(
                      color: Colors.pink[100],
                      fontSize: 20
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () async {

                      print("Clicou");

                      await Clipboard.setData(
                        ClipboardData(
                          text: 'Seu login é: ${email.text}, e a senha do seu acesso é: $codigoGerado!'
                        )
                      );

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.blue[400],
                        content: Padding(
                          padding: EdgeInsets.fromLTRB(20,0,20,0),
                          child: Text(
                            'Login copiado com sucesso!',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ));
                      
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(
                        milliseconds: 1000
                      ),
                      backgroundColor: Colors.green,
                      content: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  );

                  Navigator.pop(context);
                  Navigator.of(context).pop(1);

                },
                child: const Text(
                  'Fechar',
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
              ),
            ],
          )
        );

        print("Chegou aqui");

        setState(() {
          loading = false;
        });

      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Aluno não salvo'),
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
        body: SingleChildScrollView(
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
                              'Novo Aluno',
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
                      padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50, 8.0),
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
                                hintText: "Nome do Aluno",
                                hintStyle: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "CPF",
                              style: TextStyle(
                                fontSize: 23
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextField(
                              controller: cpf,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.black
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                prefixIcon: Icon(
                                  Icons.format_list_numbered,
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
                                hintText: "CPF do Aluno",
                                hintStyle: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 23
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: email,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.black
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0)
                                ),
                                hintText: "Email do Aluno",
                                hintStyle: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Sexo",
                              style: TextStyle(
                                fontSize: 23
                              ),
                            ),
                            SizedBox(
                              height: 8,
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
                              height: 20,
                            ),
                            Text(
                              "Data de Nascimento",
                              style: TextStyle(
                                fontSize: 23
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              child: Container(
                                height: 55,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
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
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0)),
                              color: clicouSalvar ? Colors.grey : Colors.grey[900],
                              textColor: Colors.white,
                              minWidth: double.infinity,
                              height: 42,
                              onPressed: () {
                                if(nome.text != "" && cpf.text != "" && email.text != "" && 
                                generoSelecionado != "" && dataFormatadaSelecionada != ""
                                && RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email.text)){
                                  _salvarAluno();
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
                                }else if(!RegExp(
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

                                } else{
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Preencha todos os campos!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Fechar'),
                                        ),
                                      ],
                                    )
                                  );
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

 