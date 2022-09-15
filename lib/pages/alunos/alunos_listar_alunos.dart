import 'package:flutter/material.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/pages/alunos/alunos_listar_treino.dart';
import 'package:mcfitness/pages/alunos/alunos_novo_aluno.dart';
import 'package:mcfitness/pages/anamnese/anamnese_listar_anamnese.dart';
import 'package:mcfitness/pages/avaliacaoFisica/avaliacaoFisica_listar_avaliacao.dart';
import 'package:mcfitness/pages/avaliacaoFisica/avaliacaoFisica_nova_avaliacao.dart';

enum SingingCharacter { nome, cnpj }

class AlunosListarAlunos extends StatefulWidget {

  final int professorIdGlobal;

  const AlunosListarAlunos(
    {
      Key? key, 
      required this.professorIdGlobal, 
    }
  ) : super(key: key);

  @override
  _AlunosListarAlunosState createState() => _AlunosListarAlunosState(
    professorIdLocal: professorIdGlobal, 
  );
}

bool termoMaiorTres = false;

class _AlunosListarAlunosState extends State<AlunosListarAlunos> {

  final int professorIdLocal;

  _AlunosListarAlunosState(
    {
      required this.professorIdLocal, 
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
  bool alunoSelecionado = false;
  int idSelecionado = 0;
  String nomeSelecionado = "";
  bool isButtonDisable = false;
  int objetivoIdLocal = 0;

  List alunos = [];
  List pedido_por_clientes = [];

  Future<void> _alunosPorPersonal() async {

    setState(() {
      loading = true;
    });

    try{

      Map<String, dynamic> result = await Graphql.alunosPorPersonal(1);

      print("aqui");
      

      if (result['obterAlunosProfessor'].length > 0) {
        print("Resultado buscado");

        setState(() {
          loading = false;
          termoMaiorTres = false;
          alunos = result['obterAlunosProfessor'];
        });

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nenhum aluno nesse Professor'),
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
    _alunosPorPersonal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: FloatingActionButton(
          onPressed: () async {
            var tela = await Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => AlunosNovoAluno(
                  professorIdGlobal: professorIdLocal,
                )
              )
            );

            if(tela == 1){
              _alunosPorPersonal();
            }
          },
          child: Icon(
            Icons.add
          ),
        )
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
                        if(alunoSelecionado){
                          var tela = await Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => AlunosListarTreino(
                                alunoIdGlobal: idSelecionado,
                                alunoNomeGlobal: nomeSelecionado,
                                objetivoIdGlobal: objetivoIdLocal,
                              )
                            )
                          );

                          if(tela == 1){
                            //_alunosPorPersonal();
                          }
                        }
                      },
                      color: alunoSelecionado ? Colors.black : Colors.grey,
                      child: Text(
                        'Treino',
                        style: TextStyle(
                          color: alunoSelecionado ? Colors.white : Colors.black 
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if(alunoSelecionado){
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => AnamneseListarAnamnese(
                                alunoIdGlobal: idSelecionado,
                                alunoNomeGlobal: nomeSelecionado
                              )
                            )
                          );
                        }
                      },
                      color: alunoSelecionado ? Colors.black : Colors.grey,
                      child: Text(
                        'Anamnese',
                        style: TextStyle(
                          color: alunoSelecionado ? Colors.white : Colors.black 
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {

                        if(alunoSelecionado){
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => AvaliacaoFisicaListarAvaliacao(
                                alunoIdGlobal: idSelecionado,
                                alunoNomeGlobal: nomeSelecionado
                              )
                            )
                          );
                        }
                        
                      },
                      color: alunoSelecionado ? Colors.black : Colors.grey,
                      child: Text(
                        'Avaliação Fisica',
                        style: TextStyle(
                          color: alunoSelecionado ? Colors.white : Colors.black 
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
                return _alunosPorPersonal();
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
                                        if(idSelecionado == alunos[index]['id']){
                                          alunoSelecionado = !alunoSelecionado;
                                          idSelecionado = 0;
                                        }else{
                                          alunoSelecionado = true;
                                          idSelecionado = alunos[index]['id'];
                                          nomeSelecionado = alunos[index]['nome'];
                                          //objetivoIdLocal = alunos[index]['objetivo']['id'];
                                          print("Objetivo = $objetivoIdLocal");
                                        }
                                        
                                      });
                                  },
                                  child: Container(
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width/1.127,
                                      decoration: BoxDecoration(
                                        color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.blue[400] : Colors.white,
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
                                                color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Color.fromARGB(255, 14, 93, 158) : Colors.blue[400]
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Gênero:",
                                                    style: TextStyle(
                                                      color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.white : Colors.black,
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                  Text(
                                                    alunos[index]['sexo'],
                                                    style: TextStyle(
                                                      color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.white : Colors.black,
                                                      fontSize: 13.0
                                                    ),
                                                    
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    "Idade:",
                                                    style: TextStyle(
                                                      color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.white : Colors.black,
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                  Text(
                                                    "${alunos[index]['idade']}",
                                                    style: TextStyle(
                                                      color: (alunoSelecionado && idSelecionado == alunos[index]['id']) ? Colors.white : Colors.black,
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
                                                      alunos[index]['nome'],  
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
                                                          "CPF: ",                            
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0,
                                                            fontWeight: FontWeight.normal
                                                          ),
                                                        ),
                                                        Text(
                                                          alunos[index]['cpf'],                            
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
                  itemCount: alunos.length
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

 