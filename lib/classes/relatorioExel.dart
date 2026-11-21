import 'dart:io';
import 'package:exel_dart/classes/relatorio.dart';
import 'package:excel/excel.dart';
import 'mesEnum.dart';
import 'relatorioMensalExel.dart';

class RelatorioExel extends Relatorio {
  final String nomeArquivo;

  late String produtoMaisVendido;
  int novaQuantidadeVendida = 0;
  int qtdMaiorVendedorVendas = 0;
  late String vendedorMaiorVendas;
  late String vendedorMenorVendas;
  int qtdMenorVendedorVendas = 999999;
  late String produtoMenosVendido;
  int qtdMenorProdutoVendido = 999999;

  late Map<Mes, RelatorioMensalExel> relatorioMes;
  Map<String, int> produtosGeral = {};
  Map<String, int> vendedoresGeral = {};

  RelatorioExel(this.nomeArquivo) {
    relatorioMes = {for (var mes in Mes.values) mes: RelatorioMensalExel()};
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
    }
    for (var prod in produtosGeral.keys) {
      int quantidade = produtosGeral[prod]!;
      if (quantidade > novaQuantidadeVendida) {
        novaQuantidadeVendida = quantidade;
        produtoMaisVendido = prod;
      }
    }
    for (var vend in vendedoresGeral.keys) {
      int quantidade = vendedoresGeral[vend]!;
      if (quantidade > qtdMaiorVendedorVendas) {
        qtdMaiorVendedorVendas = quantidade;
        vendedorMaiorVendas = vend;
      }
    }
    for (var prod in produtosGeral.keys) {
      int quantidade = produtosGeral[prod]!;
      if (quantidade < qtdMenorProdutoVendido) {
        qtdMenorProdutoVendido = quantidade;
        produtoMenosVendido = prod;
      }
    }
    for (var vend in vendedoresGeral.keys) {
      int quantidade = vendedoresGeral[vend]!;
      if (quantidade < qtdMenorVendedorVendas) {
        qtdMenorVendedorVendas = quantidade;
        vendedorMenorVendas = vend;
      }
    }
  }

  @override
  void printRelatorio() {
    double metaPadrao = 20000.00;
    double metaAtual = metaPadrao;
    print("\n\t========== RELATÓRIO GERAL DE EXEL==========");
    print("\n\tProduto mais vendido: $produtoMaisVendido");
    print("\tProduto menos vendido: $produtoMenosVendido");
    print(
        "\tVendedor com maior quantidade de vendas Totais: $vendedorMaiorVendas");

    print("\tVendedor com menor número de Vendas: $vendedorMenorVendas");

    print("\n\t========== RELATÓRIO MENSAL==========");
    print("\n");
    relatorioMes.forEach((mes, relatorio) {
      if (relatorio.quantidadeTotalVendida > 0) {
        print("\n\t\==========MÊS: ${mes.nome.toUpperCase()}==========");
        print("\n");
        print(
            "\tTotal  Unidades Vendidas: ${relatorio.quantidadeTotalVendida}un");
        print(
            "\tEstoque Total Registrado: ${relatorio.estoqueTotalAcumulado}un");
        print("\tLucro Mensal: R\$${relatorio.lucroMensal.toStringAsFixed(2)}");

        if (relatorio.lucroMensal >= metaAtual) {
          double metaAnterior = metaAtual;
          metaAtual = relatorio.lucroMensal;
          print(
              "\tStatus Meta Mensal = Batida com R\$${(relatorio.lucroMensal - metaAnterior).toStringAsFixed(2)} de vantagem");
        } else {
          metaAtual = metaPadrao;
          print(
              "\tStatus Meta Mensal = Não Batida por R\$${(metaAtual - relatorio.lucroMensal).toStringAsFixed(2)}. :(");
        }
        print("\n\t Categorias Vendidas no Mês:");
        print("\n");
        relatorio.categoriasVendidas.forEach((cat, qtd) {
          print("\t • $cat: $qtd un");
        });

        print("\n\t  Vendas por Vendedor:");
        print("\n");
        relatorio.vendasPorVendedor.forEach((vend, qtd) {
          print("\t• $vend: $qtd un");
        });
      }
    });
  }

  @override
  String gerarStringRelatorio() {
    StringBuffer buffer = StringBuffer();
    double metaPadrao = 20000.00;
    double metaAtual = metaPadrao;

    buffer.writeln("\n\t========== RELATÓRIO GERAL DE EXEL==========");
    buffer.writeln("\n\tProduto mais vendido: $produtoMaisVendido");
    buffer.writeln("\tProduto menos vendido: $produtoMenosVendido");
    buffer.writeln(
        "\tVendedor com maior quantidade de vendas Totais: $vendedorMaiorVendas");
    buffer
        .writeln("\tVendedor com menor número de Vendas: $vendedorMenorVendas");

    buffer.writeln("\n\t========== RELATÓRIO MENSAL==========");
    buffer.writeln("\n");

    relatorioMes.forEach((mes, relatorio) {
      if (relatorio.quantidadeTotalVendida > 0) {
        buffer
            .writeln("\n\t==========MÊS: ${mes.nome.toUpperCase()}==========");
        buffer.writeln("\n");
        buffer.writeln(
            "\tTotal  Unidades Vendidas: ${relatorio.quantidadeTotalVendida}un");
        buffer.writeln(
            "\tEstoque Total Registrado: ${relatorio.estoqueTotalAcumulado}un");
        buffer.writeln(
            "\tLucro Mensal: R\$${relatorio.lucroMensal.toStringAsFixed(2)}");

        if (relatorio.lucroMensal >= metaAtual) {
          double metaAnterior = metaAtual;
          metaAtual = relatorio.lucroMensal;
          buffer.writeln(
              "\tStatus Meta Mensal = Batida com R\$${(relatorio.lucroMensal - metaAnterior).toStringAsFixed(2)} de vantagem");
        } else {
          double metaAnterior = metaAtual;
          metaAtual = metaPadrao;
          buffer.writeln(
              "\tStatus Meta Mensal = Não Batida por R\$${(metaAnterior - relatorio.lucroMensal).toStringAsFixed(2)}. :(");
        }

        buffer.writeln("\n\t Categorias Vendidas no Mês:");
        buffer.writeln("\n");
        relatorio.categoriasVendidas.forEach((cat, qtd) {
          buffer.writeln("\t • $cat: $qtd un");
        });

        buffer.writeln("\n\t  Vendas por Vendedor:");
        buffer.writeln("\n");
        relatorio.vendasPorVendedor.forEach((vend, qtd) {
          buffer.writeln("\t• $vend: $qtd un");
        });
      }
    });

    return buffer.toString();
  }
}
