class Constantes {
  static const alturaNavigationBar = 130.0;
  static const tamanhoLetraDescritivas = 20.0;
  static const double larguraBotoesBarraNavegacao = 140.0;
  static const double alturaBotoesNavegacao = 40.0;
  static const tamanhoIconeBotoesNavegacao = 30.0;

  // constantes de rotas
  static const rotaTelaInicial = "/telaInicial";
  static const rotaTelaCadastroPessoas = "/telaCadastroPessoas";
  static const rotaTelaCadastroLocalTrabalho = "/telaCadastroLocalTrabalho";
  static const rotaTelaSelecaoDias = "/selecaoDias";
  static const rotaTelaSelecaoPeriodo = "/selecaoIntervalo";
  static const rotaTelaListagem = "/telaListagem";
  static const rotaTelaGerarEscala = "/telaGerarEscala";
  static const rotaTelaSelecaoEscala = "/telaSelecaoEscala";
  static const rotaTelaEdicao = "/telaEdicao";
  static const rotaTelaSplashScreen = "/telaSplashScreen";
  static const rotaTelaConfiguracoes = "/telaConfiguracoes";

  // constantes de parametros passados de uma tela para outra
  static const parametroGenero = "generoParametro";
  static const parametroListaPessoas = "listaPessoas";
  static const parametroListaLocal = "listaLocal";
  static const parametroListaDias = "listaDias";
  static const parametroListaPeriodo = "listaPeriodo";
  static const parametroEdicaoCadNomeTabela = "nomeTabela";
  static const parametroEdicaoCadIdItem = "idItem";
  static const parametroEdicaoCadCamposBanco = "parametroEdicaoCadCamposBanco";

  // constantes para referenciar no share preferences
  static const primeiroHorarioSemana = "primeiroHorarioSemana";
  static const segundoHorarioSemana = "segundoHorarioSemana";
  static const primeiroHorarioFinalSemana = "primeiroHorarioFinalSemana";
  static const segundoHorarioFinalSemana = "segundoHorarioFinalSemana";

  //constantes com os horarios padroes de troca de escala
  static const horarioPrimeiroSemanaPadrao = "18:45";
  static const horarioSegundoSemanaPadrao = "19:45";
  static const horarioPrimeiroFinalSemanaPadrao = "18:00";
  static const horarioSegundoFinalSemanaPadrao = "19:00";

  // constantes usadas na tela de edicao e cadastro de item manual
  static const horarioMudado = "horarioMudado";
  static const telaCadastroItem = "cadastro";
  static const telaEdicaoItem = "edicao";

  static const parametroCampoVazio = "definir";

  // constantes dos icones exibidos na barra de navegacao
  static const tipoIconeHome = "home";
  static const tipoIconeLista = "lista";
  static const tipoIconeConfiguracao = "configuracao";

  // constantes recuparar valor share preferences
  static const recuperarValorSemana = "duranteSemana";
  static const recuperarValorFinalSemana = "duranteFinalSemana";

  // constantes usadas no banco de dados
  static const bancoNomeBanco = "escalas";
  static const bancoTabelaPessoa = "pessoas";
  static const bancoTabelaLocalTrabalho = "localTrabalho";
  static const columnId = "id";
  static const columnPessoaNome = "nome";
  static const columnPessoaGenero = "genero";
  static const columnLocal = "local";

  // string usadas no banco de dados
  static String localData = "Data";
  static String localHoraTroca = "Horario de Troca";
  static String localUniforme = "Uniforme";
  static String localServirCeia = "Servir_Santa_Ceia";

  static String localExcluir = "Excluir";
  static String localEditar = "Editar";
}
