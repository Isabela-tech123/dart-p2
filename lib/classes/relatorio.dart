import 'dart:io';
import 'package:path/path.dart' as p;

abstract class Relatorio {
  void carregarDados();

  void printRelatorio();

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
