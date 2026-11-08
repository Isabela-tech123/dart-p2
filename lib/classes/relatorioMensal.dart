class RelatorioMensal {
  int quantidadeTotalVendida = 0;
  int estoqueTotalAcumulado = 0;

  Map<String, int> produtosVendidos = {};
  Map<String, int> categoriasVendidas = {};
  Map<String, int> vendasPorVendedor = {};

  void registrarVenda({
    required String produto,
    required String categoria,
    required String vendedor,
    required String canalVenda,
    required int quantidade,
    required int estoque,
    required double desconto,
    required double valorTotal,
    required double precoUnidade,
  }) {
    quantidadeTotalVendida += quantidade;
    estoqueTotalAcumulado += estoque;

    produtosVendidos[produto] = (produtosVendidos[produto] ?? 0) + quantidade;
    categoriasVendidas[categoria] =
        (categoriasVendidas[categoria] ?? 0) + quantidade;
    vendasPorVendedor[vendedor] =
        (vendasPorVendedor[vendedor] ?? 0) + quantidade;
  }
}
