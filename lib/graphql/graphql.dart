import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mcfitness/model/aluno.dart';
import 'package:mcfitness/model/exercicio.dart';
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
            urlImagem
          },
          series,
          repeticoes,
          descanso,
          velocidade,
          variacaoExercicio{
            id,
            descricao
          },
          instrucao
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

  static Future<Map<String, dynamic>> treinoPorAlunoPorDia(int alunoId, int dia) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($alunoId: Int!, $diaSemanaId: Int!){
        obterTreinoAlunoPorDia(alunoId:$alunoId, diaSemanaId: $diaSemanaId){
          exercicio{
            descricao,
            urlImagem
          },
          series,
          repeticoes,
          descanso,
          velocidade,
          variacaoExercicio{
            id,
            descricao
          },
          instrucao
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
          objetivo{
            id
          }
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

  static Future<Map<String, dynamic>> exerciciosPorMusculo(int musculoId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($musculoId: Int!){
        obterExerciciosPorMusculo(musculoId:$musculoId){
          id,
          descricao,
          musculo{
            id,
            descricao
          },
          professor{
            id
          },
          urlImagem
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

  static Future<Map<String, dynamic>> obterVariacoesExercicio(int exercicioId) async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query($exercicioId: Int!){
        obterVariacoes(exercicioId:$exercicioId){
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
        "exercicioId": exercicioId
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

  static Future<Map<String, dynamic>> obterTodosExercicios() async {
    GraphQLClient client = getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
      query{
        obterExercicios{
          id,
          descricao,
          musculo{
            id,
            descricao
          },
          professor{
            id
          },
          urlImagem
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

  static Future<Map<String, dynamic>> salvarVariacoesExercicio(VariacoesExercicio variacoes) async {
    GraphQLClient client = getClient();

    QueryResult result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation($variacoes: VariacoesExerciciosInput!){
          salvarVariacoesExercicios(variacoesExercicios: $variacoes){
            id
          }
        }
      '''),
      variables: {
        "variacoes": {
          "id": variacoes.id,
          "descricao": variacoes.descricao,
          "musculo": variacoes.musculo,
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
          "instrucao": treino.instrucao,
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
          "urlImagem": exercicio.urlImagem
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
