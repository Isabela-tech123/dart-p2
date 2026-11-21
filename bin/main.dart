import 'dart:io';

import 'package:exel_dart/classes/relatorio.dart';
import 'package:exel_dart/classes/relatorioCsv.dart';
import 'package:exel_dart/classes/relatorioExel.dart';

void main() {
  bool executando = true;

  Relatorio? relatorio;
  print(r'''
|=========================================|
____  _____   _             _                                                              
|_   \|_   _| (_)           (_)                          
  |   \ | |   __   _ .--.   __  _   __   .--.   _   __   
  | |\ \| |  [  | [ `.-. | [  |[ \ [  ]/ .'`\ \[ \ [  ]  
 _| |_\   |_  | |  | | | |  | | \ \/ / | \__. | > '  <   
|_____|\____|[___][___||__][___] \__/   '.__.' [__]`\_] 
|=========================================|
''');
  print("\tTerminal Intergrado - Loja Pet Ninivox - ");
  print("\n");
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
        relatorio.relatorioTxt('relatorio_csv.txt');
        print("\n");
        break;
      case '2':
        relatorio = RelatorioExel('registro_vendas_petshop.xlsx');
        relatorio.carregarDados();
        relatorio.printRelatorio();
        relatorio.relatorioTxt('relatorio_exel.txt');
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
