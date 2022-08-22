class RemoverAcentos {
  // metodo para remover acentuacao
  static removerAcentos(String texto) {
    String comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    String semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";

    for (int interacao = 0; interacao < comAcentos.length; interacao++) {
      texto =
          texto.replaceAll(comAcentos[interacao].toString(), semAcentos[interacao].toString());
    }
    return texto;
  }
  static verificarCaracteresEspeciais(String texto) {
    if (texto.contains(RegExp('[^A-Za-z0-9]'))) {
      return true;
    } else {
      return false;
    }
  }
}
