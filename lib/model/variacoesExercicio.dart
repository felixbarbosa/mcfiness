class VariacoesExercicio {
  int? id;
  String? descricao;
  int? exercicio;
  int? musculo;
  int? professor;
  String? urlImagem;
  String? urlVideo;
  String? instrucao;
  int? isVariacao;

  VariacoesExercicio(
      {
        this.id,
        this.musculo,
        this.descricao,
        this.exercicio,
        this.instrucao,
        this.isVariacao,
        this.professor,
        this.urlImagem,
        this.urlVideo
      }
  );
}