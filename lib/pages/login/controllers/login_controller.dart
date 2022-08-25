import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mcfitness/graphql/graphql.dart';
import 'package:mcfitness/model/usuario.dart';

class LoginController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<Usuario?> login(Usuario credentials) async {
    GraphQLClient client = Graphql.getClient();
    QueryResult result = await client.query(QueryOptions(
      document: gql(r'''
       query ($login: String!, $senha: String!) {
         usuario: validarLogin(login: $login, senha: $senha) {
           id
           pessoaFisica{
             id
             nome,
             apelido,
             email,
             cpf
           }
           entidadeGestora{
             id
           }
         }
       }
       '''),
      variables: {
        'login': credentials.login!,
        'senha': credentials.senha!,
      },
    ));

    if (result.hasException) {
      throw result.exception!;
    } else {
      if (result.data!['usuario']['id'] == '0') return null;
      return Usuario(
        id: result.data!['usuario']['id'],
        pessoaId: result.data!['usuario']['pessoaFisica']['id'],
      );
    }
  }

  Future<void> salvarCredenciais(String email) async {
    await storage.write(key: 'email', value: email);
    //await storage.write(key: 'password', value: password);
  }

  Future<Map<String, String>> carregarCredenciais() async {
    return await storage.readAll();
  }

  Future<void> apagarCredenciais() async {
    await storage.deleteAll();
  }
}