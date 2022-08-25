class User {
  String? nome;
  String? email;
  String? password;
  String? versao;
  bool credentialSaved;

  User(
    {
      this.nome, 
      this.email, 
      this.password,
      this.versao = '',
      this.credentialSaved = false
    }
  );
}
