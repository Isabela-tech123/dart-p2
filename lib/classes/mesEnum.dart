enum Mes {
  janeiro(1, "Janeiro"),
  fevereiro(2, "Fevereiro"),
  marco(3, "Março"),
  abril(4, "Abril"),
  maio(5, "Maio"),
  junho(6, "Junho"),
  julho(7, "Julho"),
  agosto(8, "Agosto"),
  setembro(9, "Setembro"),
  outubro(10, "Outubro"),
  novembro(11, "Novembro"),
  dezembro(12, "Dezembro");

  final int numero;
  final String nome;

  const Mes(this.numero, this.nome);

  static Mes fromStringData(String dataStr) {
    try {
      DateTime data = DateTime.parse(dataStr);
      return Mes.values.firstWhere((m) => m.numero == data.month);
    } catch (e) {
      return Mes.janeiro;
    }
  }
}
