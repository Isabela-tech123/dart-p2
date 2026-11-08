import 'dart:io';
import 'package:exel_dart/classes/relatorio.dart';

class RelatorioCsv extends Relatorio {
  final String nomeArquivo;

  int quantidadeTotalVendida = 0;
  int totalAnimais = 0;
  double faturamentoTotal = 0.0;
  double precoMedio = 0.0;
  double porcentagemPedigree = 0;
  int comPedigree = 0;

  Map<String, int> vendasPorRaca = {};
  Map<String, int> quantidadePorPagamento = {};
  Map<String, int> vendasPorEstado = {};

  RelatorioCsv(this.nomeArquivo);

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

  @override
  void carregarDados() {
    File? arquivo = obterArquivo(nomeArquivo);
    if (arquivo == null) return;

    List<String> linhas = arquivo.readAsLinesSync();
    List<String> linhasDados = linhas.skip(1).toList();

    for (String linha in linhasDados) {
      if (linha.trim().isNotEmpty) {
        List<String> dados = linha.split(';');

        String raca = dados[1];
        String porte = dados[2];
        String pedigree = dados[3];
        int quantidade = int.parse(dados[4]);
        double precoUnitario = double.parse(dados[5]);
        String canalVenda = dados[6];
        String formaPagamento = dados[7];
        String estado = dados[8];

        registrarVenda(
          raca: raca,
          porte: porte,
          pedigree: pedigree,
          formaPagamento: formaPagamento,
          estado: estado,
          quantidade: quantidade,
          precoUnitario: precoUnitario,
          canalVenda: canalVenda,
        );
      }
    }
  }

  @override
  void printRelatorio() {
    print("\n\t========== RELATÓRIO GERAL DE CSV==========");
    print(
      "\n\tFaturamento total registrado: R\$ ${faturamentoTotal.toStringAsFixed(2).replaceAll('.', ',')}",
    );
    print(
      "\tPreco médio registrado : R\$ ${precoMedio.toStringAsFixed(2).replaceAll('.', ',')} ",
    );
    print("\tTotal de animais vendidos: ${totalAnimais} animais");
    print(
      "\tPorcentagem de animais com pedigree: ${porcentagemPedigree.toStringAsFixed(1)}%",
    );
    print('\n\t===============================================\n');
    print('\n\t=== VENDAS POR RAÇA ===');
    print("\n");
    vendasPorRaca.forEach((raca, qtd) => print('\t$raca: $qtd vendidas'));
    print('\n\t=== VENDAS POR ESTADO ===');
    print("\n");
    vendasPorEstado.forEach((estado, qtd) => print('\t$estado: $qtd vendidas'));
  }
}
