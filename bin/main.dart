import 'dart:io';

import 'package:exel_dart/classes/relatorio.dart';
import 'package:exel_dart/classes/relatorioCsv.dart';
import 'package:exel_dart/classes/relatorioExel.dart';

void main() {
  print("Escolha qual o tipo de arquivo para análise:"
      "\n 1) - Relatório CSV"
      "\n 2) - Relatório Exel"
      "\n 3) - Nenhum | Sair");
  stdout.write("Opção: ");

  String opcao = stdin.readLineSync() ?? '1';

  Relatorio? relatorio;

  switch (opcao) {
    case '1':
      relatorio = RelatorioCsv('vendas_gatos.csv');
      break;
    case '2':
      relatorio = RelatorioExel('petshop.xlsx');
      break;
    case '3':
      print('\nSaindo...');
      return;
    default:
      print('\n Opção inválida, tente novamente.');
      return;
  }

  relatorio.carregarDados();
  relatorio.printRelatorio();
}
