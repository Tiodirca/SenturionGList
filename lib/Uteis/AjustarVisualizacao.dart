class AjustarVisualizacao {
//metodo para ajustar o tamanho do textField com base no tamanho da tela
  static ajustarTextField(double larguraTela) {
    double tamanho = 150;
    //verificando qual o tamanho da tela
    if (larguraTela <= 600) {
      tamanho = 190;
    } else {
      tamanho = 300;
    }
    return tamanho;
  }
}
