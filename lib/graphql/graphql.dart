import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mcfitness/model/aluno.dart';
import 'package:mcfitness/model/anamnese.dart';
import 'package:mcfitness/model/avaliacaoFisica.dart';
import 'package:mcfitness/model/carga.dart';
import 'package:mcfitness/model/exercicio.dart';
import 'package:mcfitness/model/personal.dart';
import 'package:mcfitness/model/treino.dart';
import 'package:mcfitness/model/variacoesExercicio.dart';
import 'package:path_provider/path_provider.dart';

class Graphql {

  //Endereco IP fixo = 186.208.231.150

  static Link _link =
      HttpLink('https://geradorodigo.herokuapp.com/graphql'); //clientes

  /*static Link _link =
    HttpLink('https://10.0.2.2:9095/graphql');*/ //clientes

  static GraphQLClient getClient() {
    return new GraphQLClient(
      link: _link,
      cache: GraphQLCache(),
    );
  }

  static Future<Map<String, dynamic>> treinoPorAlunoPorMusculo(int alunoId, int musculoId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($alunoId: Int!, $musculoId: Int!){
        obterTreinoAlunoPorMusculo(alunoId:$alunoId, musculoId: $musculoId){
          exercicio{
            descricao,
            urlImagem,
            urlVideo,
            instrucao
          },
          series,
          repeticoes,
          descanso,
          velocidade,
        }
      }
      '''),
      variables: {
        "alunoId": alunoId,
        "musculoId": musculoId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> login(String login, String senha) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($login: String!, $senha: String!){
        obterUsuario(login: $login, senha: $senha){
          id,
          foto,
          pessoa{
            nome,
            cref,
            cpf,
            aluno{
              id,
              nome,
              cpf,
              sexo,
              idade,
              personal{
                id,
                nome,
                cref,
                foto
              },
            },
            personal{
              id,
              cref,
              nome,
              cpf,
              sexo,
              email,
              idade,
              foto        
            }
          }
        }
      }
      '''),
      variables: {
        "login": login,
        "senha": senha
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> treinoPorAlunoPorDia(int alunoId, int dia) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($alunoId: Int!, $diaSemanaId: Int!){
        obterTreinoAlunoPorDia(alunoId:$alunoId, diaSemanaId: $diaSemanaId){
          exercicio{
            id,
            descricao,
            urlImagem,
            urlVideo,
            instrucao
          },
          series,
          repeticoes,
          descanso,
          velocidade,
          variacaoExercicio{
            id,
            descricao
          },
        }
      }
      '''),
      variables: {
        "alunoId": alunoId,
        "diaSemanaId": dia
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> alunosPorPersonal(int personalId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($professorId: Int!){
        obterAlunosProfessor(professorId: $professorId){
          id,
          nome,
          cpf,
          sexo,
          idade,
          foto
        }
      }
      '''),
      variables: {
        "professorId": personalId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> treinosPorAluno(int alunoId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($alunoId: Int!){
        obterTreinoAluno(alunoId:$alunoId){
          nome,
          diaSemana{
            id,
            dia
          },
        }
      }
      '''),
      variables: {
        "alunoId": alunoId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> treinosNomePorDiaAluno(int alunoId, int diaSemana) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($alunoId: Int!, $diaSemana: Int!){
        obterTreinoNomeAluno(alunoId: $alunoId, diaSemanaId: $diaSemana){
          nome
        }
      }
      '''),
      variables: {
        "alunoId": alunoId,
        "diaSemana": diaSemana
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> treinosPorAlunoNome(int alunoId, String nomeTreino) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($alunoId: Int!, $nome: String!){
        obterTreinoAlunoNome(alunoId:$alunoId, nome:$nome){
          nome,
          musculoAlvo{
            id,
            descricao
          },
          diaSemana{
            id,
            dia
          },
        }
      }
      '''),
      variables: {
        "alunoId": alunoId,
        "nome": nomeTreino
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterCargasPorAluno(int alunoId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($aluno: Int!){
        obterCargasPorAluno(aluno: $aluno){
          id,
          carga,
          aluno{
            id,
            nome
          },
          exercicio{
            id,
            descricao
          },
          data
        }
      }
      '''),
      variables: {
        "aluno": alunoId,
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterCargasPorAlunoPorExercicio(int alunoId, int exercicioId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($aluno: Int!, $exercicio: Int!){
        obterCargasPorAlunoPorExercicio(aluno: $aluno, exercicio:$exercicio){
          id,
          carga,
          aluno{
            id,
            nome
          },
          exercicio{
            id,
            descricao
          },
          data
        }
      }
      '''),
      variables: {
        "aluno": alunoId,
        "exercicio": exercicioId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> exerciciosPorMusculo(int musculoId, int professorId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($musculoId: Int!, $professorId: Int!){
        obterExerciciosPorMusculo(musculoId:$musculoId, professorId:$professorId){
          id,
          descricao,
          musculo{
            id,
            descricao
          },
          professor{
            id
          },
          urlImagem,
          urlVideo,
          instrucao,
          isVariacao
        }
      }
      '''),
      variables: {
        "musculoId": musculoId,
        "professorId": professorId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterVariacoesExercicio(int exercicioId, int professorId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($exercicioId: Int!, $professor: Int!){
        obterVariacoesExerciciosPorExercicio(exercicioId:$exercicioId, professorId: $professor){
          id,
          descricao,
          musculo{
            id,
            descricao
          },
          professor{
            id,
            nome
          },
          urlImagem,
          urlVideo,
          instrucao,
          isVariacao,
          exercicio{
            id,
            descricao
          }
        }
      }
      '''),
      variables: {
        "exercicioId": exercicioId,
        "professor": professorId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterVariacoesExercicioPorMusculo(int musculoId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($musculoId: Int!){
        obterVariacoesPorMusculo(musculoId: $musculoId){
          id,
          descricao,
          musculo{
            id,
            descricao
          },
          exercicio{
            id,
            descricao
          }
        }
      }
      '''),
      variables: {
        "musculoId": musculoId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterTodosOsMusculos() async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query{
        obterMusculos{
          id,
          descricao
        }
      }
      ''')
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterAnamnesePorAluno(int alunoId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($aluno: Int!){
        obterAnamnesePorAluno(alunoId:$aluno){
          id,
          objetivo,
          atividadeFisica,
          refeicoes,
          dieta,
          suplementacao,
          sono,
          fumante,
          bebidaAlcoolica,
          colesterol,
          alteracaoCardiaca,
          diabetes,
          hipertenso,
          pulmonar,
          medicamento,
          cirurgia,
          dores,
          problemaOrtopedico,
          observacoes
        }
      }
      '''),
      variables: {
        "aluno": alunoId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterAvaliacaoPorAluno(int alunoId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($aluno: Int!){
        obterAvaliacaoPorAluno(alunoId: $aluno){
          id,
          aluno{
            id,
            nome
          },
          objetivo,
          idate,
          data,
          altura,
          peso,
          peitoral,
          biceps,
          anteBraco,
          cintura,
          abdome,
          quadril,
          coxa,
          fotoFrente,
          fotoLado,
          fotoCostas,
        }
      }
      '''),
      variables: {
        "aluno": alunoId
      },
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterTodosExercicios(int professorId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($professor: Int!){
        obterExercicios(professorId:$professor){
          id,
          descricao,
          musculo{
            id,
            descricao
          },
          professor{
            id
          },
          urlImagem,
          urlVideo,
          instrucao,
          isVariacao
        }
      }
      '''),
      variables: {
        "professor": professorId
      }
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> obterDiasSemana() async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query{
        obterDiasSemana{
          id,
          dia
        }
      }
      ''')
    ));
    if(result.isLoading){
      print("Carregando...");
    }
    if (result.hasException) {
      throw result.exception!;
      //return null;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> salvarAluno(Aluno aluno) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($aluno: AlunoInput!){
          salvarAluno(aluno: $aluno){
            id
          }
        }
      '''),
      variables: {
        "aluno": {
          "id": aluno.id,
          "nome": aluno.nome,
          "cpf": aluno.cpf,
          "login": aluno.login,
          "senha": aluno.senha,
          "sexo": aluno.sexo,
          "email": aluno.email,
          "idade": aluno.idade,
          "personal": aluno.personal,
          "objetivo": aluno.objetivo
        }
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> salvarPersonal(Personal personal) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($personal: PersonalInput!){
          salvarPersonal(Personal: $personal){
            id
          }
        }
      '''),
      variables: {
        "personal": {
          "id": personal.id,
          "nome": personal.nome,
          "cpf": personal.cpf,
          "login": personal.login,
          "senha": personal.senha,
          "sexo": personal.sexo,
          "email": personal.email,
          "idade": personal.idade,
          "cref": personal.cref,
          "foto": personal.foto
        }
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> salvarCargaExercicioAluno(Carga carga) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($carga: CargaInput!){
          salvarCarga(carga:$carga){
            id
          }
        }
      '''),
      variables: {
        "carga": {
          "id": carga.id,
          "carga": carga.carga,
          "aluno": carga.aluno,
          "exercicio": carga.exercicio,
          "data": carga.data
        }
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> salvarAvaliacaoFisica(AvaliacaoFisica avaliacao) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($avaliacao: AvaliacaoFisicaInput!){
          salvarAvaliacao(avaliacao: $avaliacao){
            id
          }
        }
      '''),
      variables: {
        "avaliacao": {
          "id": avaliacao.id,
          "aluno": avaliacao.aluno,
          "objetivo": avaliacao.objetivo,
          "idate": avaliacao.idade,
          "data": avaliacao.data,
          "altura": avaliacao.altura,
          "peso": avaliacao.peso,
          "peitoral": avaliacao.peitoral,
          "biceps": avaliacao.biceps,
          "anteBraco": avaliacao.anteBraco,
          "cintura": avaliacao.cintura,
          "abdome": avaliacao.abdome,
          "quadril": avaliacao.quadril,
          "coxa": avaliacao.coxa,
          "fotoFrente": avaliacao.fotoFrente,
          "fotoLado": avaliacao.fotoLado,
          "fotoCostas": avaliacao.fotoCostas
        }
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> salvarVariacoesExercicio(VariacoesExercicio variacoes) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($variacao:VariacaoExercicioInput!){
          salvarVariacaoExercicio(variacaoExercicio:$variacao){
            id
          }
        }
      '''),
      variables: {
        "variacao": {
          "id": variacoes.id,
          "descricao": variacoes.descricao,
          "musculo": variacoes.musculo,
          "professor": variacoes.professor,
          "urlImagem": variacoes.urlImagem,
          "urlVideo": variacoes.urlVideo,
          "instrucao": variacoes.instrucao,
          "isVariacao": variacoes.isVariacao,
          "exercicio": variacoes.exercicio
        }
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> removerExercicios(int exercicioId) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($exercicioId: Int!){
          deletarExercicio(id: $exercicioId)
        }
      '''),
      variables: {
        "exercicioId": exercicioId
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> incluirExercicioTreino(Treino treino) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($treino: TreinoInput!){
          salvarTreino(Treino:$treino){
            id
          }
        }
      '''),
      variables: {
        "treino": {
          "id": treino.id,
          "nome": treino.nome,
          "exercicio": treino.exercicio,
          "aluno": treino.aluno,
          "repeticoes": treino.repeticoes,
          "velocidade": treino.velocidade,
          "descanso": treino.descanso,
          "musculoAlvo": treino.musculo,
          "diaSemana": treino.diaSemana,
          "series": treino.series,
          "variacaoExercicio": treino.variacaoExercicio
        }
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> novaAnamnese(Anamnese anamnese) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($anamnese: AnamneseInput!){
          salvarAnamnese(anamnese: $anamnese){
            id
          }
        }
      '''),
      variables: {
        "anamnese": {
          "id": anamnese.id,
          "aluno": anamnese.aluno,
          "objetivo": anamnese.objetivo,
          "atividadeFisica": anamnese.atividadeFisica,
          "refeicoes": anamnese.refeicoes,
          "dieta": anamnese.dieta,
          "suplementacao": anamnese.suplementacao,
          "sono": anamnese.sono,
          "fumante": anamnese.fumante,
          "bebidaAlcoolica": anamnese.bebidaAlcoolica,
          "colesterol": anamnese.colesterol,
          "alteracaoCardiaca": anamnese.alteracaoCardiaca,
          "diabetes": anamnese.diabetes,
          "hipertenso": anamnese.hipertenso,
          "pulmonar": anamnese.pulmonar,
          "medicamento": anamnese.medicamento,
          "cirurgia": anamnese.cirurgia,
          "dores": anamnese.dores,
          "problemaOrtopedico": anamnese.problemaOrtopedico,
          "observacoes": anamnese.observacoes
        }
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

  static Future<Map<String, dynamic>> salvarExercicio(Exercicio exercicio) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($exercicio: ExercicioInput!){
          salvarExercicio(exercicio: $exercicio){
            id
          }
        }
      '''),
      variables: {
        "exercicio": {
          "id": exercicio.id,
          "descricao": exercicio.nome,
          "musculo": exercicio.musculo,
          "professor": exercicio.professor,
          "urlImagem": exercicio.urlImagem,
          "urlVideo": exercicio.urlVideo,
          "instrucao": exercicio.instrucao
        }
      },
    ));
    if (result.hasException) {
      throw result.exception!;
    } else {
      return result.data!;
    }
  }

}







void main() async {
  // Graphql.clientes();

  //print(await Graphql.clientes());
}
