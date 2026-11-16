import 'dart:io';

import 'package:exel_dart/classes/relatorio.dart';
import 'package:exel_dart/classes/relatorioCsv.dart';
import 'package:exel_dart/classes/relatorioExel.dart';

void main() {
  bool executando = true;

  Relatorio? relatorio;
  while (executando) {
    print("Escolha qual o tipo de arquivo para análise:"
        "\n 1) - Relatório CSV"
        "\n 2) - Relatório Exel"
        "\n 3) - Nenhum | Sair");
    stdout.write("Opção: ");

    String opcao = stdin.readLineSync() ?? '1';
    switch (opcao) {
      case '1':
        relatorio = RelatorioCsv('vendas_gatos.csv');
        relatorio.carregarDados();
        relatorio.printRelatorio();
        print("\n");
        break;
      case '2':
        relatorio = RelatorioExel('petshop.xlsx');
        relatorio.carregarDados();
        relatorio.printRelatorio();
        print("\n");
        break;
      case '3':
        executando = false;
        print('\nSaindo...');
        break;

      default:
        print('\n Opção inválida, tente novamente.');
        break;
    }
  }
}
