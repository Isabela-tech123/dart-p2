import 'dart:io';
import 'package:exel_dart/classes/relatorio.dart';
import 'package:excel/excel.dart';
import 'mesEnum.dart';
import 'relatorioMensal.dart';

class RelatorioExel extends Relatorio {
  final String nomeArquivo;

  late String produtoMaisVendido;
  int novaQuantidadeVendida = 0;
  late String vendedorMaiorVendas;
  late String vendedorMenorVendas;
  int qtdMenorVendedorVendas = 999999;
  late String produtoMenosVendido;
  int qtdMenorProdutoVendido = 999999;

  late Map<Mes, RelatorioMensal> relatorioMes;
  Map<String, int> produtosGeral = {};
  Map<String, int> vendedoresGeral = {};

  RelatorioExel(this.nomeArquivo) {
    relatorioMes = {for (var mes in Mes.values) mes: RelatorioMensal()};
  }

  @override
  void carregarDados() {
    File? arquivo = obterArquivo(nomeArquivo);
    if (arquivo == null) return;

    var bytes = arquivo.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var planilha = excel.tables[excel.tables.keys.first]!;

    for (int i = 1; i < planilha.rows.length; i++) {
      var linha = planilha.rows[i];

      String dataStr = linha[1]?.value?.toString() ?? '';
      String produto = linha[2]!.value.toString();
      String categoria = linha[3]!.value.toString();
      double precoUnidade = double.parse(linha[4]!.value.toString());
      int quantidade_vendida = int.parse(linha[5]!.value.toString());
      double desconto = double.parse(linha[6]!.value.toString());
      double valorTotal = double.parse(linha[7]!.value.toString());
      int estoque = int.parse(linha[8]!.value.toString());
      String vendedor = linha[9]!.value.toString();
      String canalVenda = linha[10]!.value.toString();

      if (produto.isEmpty) continue;

      Mes mesAtual = Mes.fromStringData(dataStr);

      relatorioMes[mesAtual]!.registrarVenda(
        produto: produto,
        categoria: categoria,
        vendedor: vendedor,
        quantidade: quantidade_vendida,
        estoque: estoque,
        precoUnidade: precoUnidade,
        desconto: desconto,
        valorTotal: valorTotal,
        canalVenda: canalVenda,
      );

      produtosGeral[produto] =
          (produtosGeral[produto] ?? 0) + quantidade_vendida;
      vendedoresGeral[vendedor] =
          (vendedoresGeral[vendedor] ?? 0) + quantidade_vendida;

      if (quantidade_vendida > novaQuantidadeVendida) {
        novaQuantidadeVendida = quantidade_vendida;
        produtoMaisVendido = produto;
        vendedorMaiorVendas = vendedor;
      }
      for (var prod in produtosGeral.keys) {
        int quantidade = produtosGeral[prod]!;
        if (quantidade < qtdMenorProdutoVendido) {
          qtdMenorProdutoVendido = quantidade;
          produtoMenosVendido = produto;
        }
      }
      for (var vend in vendedoresGeral.keys) {
        int quantidade = vendedoresGeral[vend]!;
        if (quantidade < qtdMenorVendedorVendas) {
          qtdMenorVendedorVendas = quantidade;
          vendedorMenorVendas = vendedor;
        }
      }
    }
  }

  @override
  void printRelatorio() {
    print("\n\t========== RELATÓRIO GERAL DE EXEL==========");
    print("\n\tProduto mais vendido: ${produtoMaisVendido}");
    print(
        "\tVendedor com maior quantidade de vendas Totais: ${vendedorMaiorVendas}");
    print("\tProduto menos vendido: $produtoMenosVendido");
    print("\tVendedor com menor número de Vendas: $vendedorMenorVendas");

    print("\n\t========== RELATÓRIO MENSAL==========");
    print("\n");
    relatorioMes.forEach((mes, dados) {
      if (dados.quantidadeTotalVendida > 0) {
        print("\n\t\==========MÊS: ${mes.nome.toUpperCase()}==========");
        print("\n");
        print("\tTotal  Unidades Vendidas: ${dados.quantidadeTotalVendida}un");
        print("\tEstoque Total Registrado: ${dados.estoqueTotalAcumulado}un");

        print("\n\t Categorias Vendidas no Mês:");
        print("\n");
        dados.categoriasVendidas.forEach((cat, qtd) {
          print("\t • $cat: $qtd un");
        });

        print("\n\t  Vendas por Vendedor:");
        print("\n");
        dados.vendasPorVendedor.forEach((vend, qtd) {
          print("\t• $vend: $qtd un");
        });
      }
    });
  }
}
