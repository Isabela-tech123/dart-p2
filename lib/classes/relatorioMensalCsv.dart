class RelatorioMensalCsv {
  int quantidadeTotalVendida = 0;
  int totalAnimais = 0;
  double faturamentoTotal = 0.0;
  double precoMedio = 0.0;
  double porcentagemPedigree = 0;
  int comPedigree = 0;

  Map<String, int> vendasPorRaca = {};
  Map<String, int> quantidadePorPagamento = {};
  Map<String, int> vendasPorEstado = {};

  void registrarVenda({
    required String raca,
    required String porte,
    required String pedigree,
    required String formaPagamento,
    required String estado,
    required int quantidade,
    required double precoUnitario,
    required String canalVenda,
  }) {
    quantidadeTotalVendida += quantidade;
    faturamentoTotal += quantidade * precoUnitario;
    totalAnimais += quantidade;

    vendasPorRaca[raca] = (vendasPorRaca[raca] ?? 0) + quantidade;
    quantidadePorPagamento[formaPagamento] =
        (quantidadePorPagamento[formaPagamento] ?? 0) + quantidade;
    vendasPorEstado[estado] = (vendasPorEstado[estado] ?? 0) + quantidade;

    if (pedigree.trim().toLowerCase() == 'sim') {
      comPedigree += quantidade;
    }

    precoMedio = faturamentoTotal / totalAnimais;
    porcentagemPedigree = (comPedigree / totalAnimais) * 100;
  }
}
