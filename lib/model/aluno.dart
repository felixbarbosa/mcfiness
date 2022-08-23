class Aluno {
  int? id;
  String? nome;
  String? cpf;
  String? login;
  String? senha;
  String? sexo;
  String? email;
  int? idade;
  int? personal;
  int? objetivo;

  Aluno(
      {
        this.id,
        this.idade,
        this.personal,
        this.nome,
        this.cpf,
        this.email,
        this.login,
        this.senha,
        this.sexo,
        this.objetivo
      }
  );
}