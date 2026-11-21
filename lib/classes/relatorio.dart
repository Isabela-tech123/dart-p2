import 'dart:io';
import 'package:path/path.dart' as p;

abstract class Relatorio {
  void carregarDados();
  String gerarStringRelatorio();

  void printRelatorio() {
    print(gerarStringRelatorio());
  }

  void relatorioTxt(String nomeArquivo) {
    String? pastaUsuario =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

    if (pastaUsuario == null) {
      print("Não foi possível localizar a pasta do usuário.");
      return;
    }

    String caminhoDownloads = p.join(pastaUsuario, 'Downloads', nomeArquivo);

    File(caminhoDownloads).writeAsStringSync(gerarStringRelatorio());
    print("Relatório salvo com sucesso em: $caminhoDownloads");
  }

  File? obterArquivo(String nomeArquivo) {
    String path = p.join(Directory.current.path, 'lib', nomeArquivo);
    File arquivo = File(path);

    if (!arquivo.existsSync()) {
      print(
          "Caminho inválido | arquivo '$nomeArquivo' não encontrado em: $path");
      return null;
    }

    return arquivo;
  }
}
