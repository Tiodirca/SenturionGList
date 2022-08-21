class Textos {
  // botoes
  static String btnCadastrar = "Cadastrar";
  static String btnCooperador = "Cooperadores";
  static String btnCooperadoras = "Cooperadoras";
  static String btnGerar = "Criar Escala";
  static String btnGerarPDF = "Gerar PDF";
  static String btnUsarEscala = "Usar Escala";
  static String btnAtualizar = "Atualizar";
  static String btnConfigHoraTroca = "Horário troca de turno";

  static String nomeApp = "Senturion G List";

  // TELA INICIAL
  static String legSelecaoTipoEscala =
      "Selecione qual tipo de escala deseja criar";

  // TELA CADASTRO PESSOAS E CADASTRO DE LOCAL DE TRABALHO
  static String nomeTelaCadastroPessoas = "Cadastro/Lista de pessoas";
  static String nomeTelaCadastroLocalTrabalho =
      "Cadastro/Lista local de trabalho";
  static String descricaoCadastroPessoas =
      "Digite o nome da pessoa que deseja adicionar a lista";
  static String descricaoCadastroLocalTrabalho =
      "Digite o nome dos locais de trabalho que deseja adicionar a lista";
  static String labelTextCadPessoa = "Nome da pessoa";
  static String labelTextCadLocalTrabalho = "Nome do local";
  static String descricaoCadastroLocalOpcoesAdicionais =
      "Deseja adicionar campos com inserção manual ?";

  // TELA SELECAO DIAS
  static String nomeTelaSelecaoDias = "Seleção dias da semana";
  static String descricaoTelaSelecaoDias =
      "Selecione os dias da semana que haverá trabalho. somente os dias "
      "selecionados nesta tela serão listados na proxima etapa";

  // TELA SELECAO PERIODO
  static String nomeTelaSelecaoPeriodo = "Seleção periodo/tempo de Trabalho";
  static String descricaoTelaSelecaoPeriodo =
      "Selecione um periodo de quantos dias haverá trabalho. "
      "começando pela data inicial e terminando com a data final";
  static String labelDataInicial = "Data Inicial";
  static String labelDataFinal = "Data Final";
  static String descricaoListaSelecaoPeriodo =
      "Confira abaixo os dias que irão compor a escala com base na data inicial e "
      " data final, serão listados somente os dias da semana selecionados na etapa anterior";

  // TELA GERAR ESCALA
  static String nomeTelaGerarEscala = "Gerar escala";
  static String decricaoTelaGerarEscala =
      "Defina um nome para a escala que irá ser gerada";

  // TELA GERAR ESCALA CONFIG ESCALA
  static String descricaoNomesConjuntos =
      "Agrupar pessoas para quando ser gerado a escala "
      "elas estarem juntas na mesma data";
  static String selecaoNomePessoas = "Selecione o nome das pessoas";
  static String selecaoNomeDiasSemana = "Selecione os dias";
  static String labelNomeEscala = "Nome da escala";

  // TELA SELECAO ESCALA
  static String nomeTelaSelecaoEscala = "Seleção de escala";
  static String descricaoTelaSelecaoEscala =
      "Utilize a lista abaixo e selecione uma escala para poder visualiza-la";
  static String legListaEscala =
      "Utilize a lista abaixo para selecionar uma escala";
  static String txtEscalaSelecionada = "Escala selecionada:";
  static String txtSemEscala = "Não foi encontrada nenhuma"
      " escala na base de dados. por favor crie uma";

  // TELA LISTAGEM
  static String nomeTelaListagem = "Lista de escala";
  static String decricaoTelaListagem =
      "Aqui você pode conferir a escala gerada. revise-a antes de "
      "gerar o arquivo em PDF,se necessario edite ou adicione itens conforme precisar";
  static String telaListagemOpcoes = "Opções de item";

  // TELA EDICAO
  static String nomeTelaEdicao = "Edição de item";
  static String descricaoTelaEdicao =
      "Utilize os campos abaixo para editar os itens";

  // TELA EDICAO
  static String nomeTelaCadastroItem = "Cadastro de item";
  static String descricaoTelaCadastroItem =
      "Utilize os campos abaixo para cadastrar um novo item na escala gerada";

  //TELA CONFIGURACOES
  static String nomeTelaConfiguracoes = "Configurações";
  static String descriacaoTelaConfiguracoes = "Selecione uma das opções";

  //CONFIGURACAO HORARIO TROCA TURNO
  static String horarioInicialSemana = "1° Horário Semana";
  static String horarioFinalSemana = "2° Horário Semana";
  static String horarioInicialFinalSemana = "1° Horário Final de Semana";
  static String horarioFinalFinalSemana = "2° Horário Final de Semana";
  static String descricaoConfigHorarioTrocaTurno =
      "Clique encima de uma das opções para selecionar um novo horário";

  // GERAIS
  static String txtListaVazia = "Sua lista esta vazia";
  static String legLista = "Selecione um ou mais itens da lista abaixo";
  static String txtTipoEscala = "Escala de ";
  static String txtTelaCarregamento = "Aguarde Carregando";

  // ALERTS
  static String legAlertExclusao = "Deseja realmente excluir este item ?";
  static String legAlertOpcoes = "Selecione uma opção";

  // ERROS E SUCESSO
  static String erroTextFieldVazio = "Preencha o campo antes";
  static String erroSemIntervalo =
      "Defina um periodo de dias que terá a escala";
  static String erroGerarEscalaTabelaExistente =
      "Defina outro nome para a escala. já existe uma escala este nome na base de dados";
  static String erroNomeExiste =
      "Adicione outro nome. pois o mesmo ja existe na base de dados";
  static String erroSemSelecaoCheck =
      "Selecione pelo menos um item da lista. clicando encima dos nomes";
  static String erroExclusaoItemListagem =
      "A escala não pode ficar vazia. adicione"
      " pelo menos um outro item. para que possa excluir este";
  static String sucessoAddBanco = "Sucesso ao adicionar item a base de dados";
  static String sucessoExluirItemBanco =
      "Sucesso ao excluir item da base de dados";
  static String sucessoAtualizarItem =
      "Sucesso ao atualizar dado na base de dados";
  static String sucessoAtualizarHorario = "Horário atualizado com sucesso";

  // DIAS DA SEMANA
  static String diaSegunda = "segunda-feira";
  static String diaTerca = "terça-feira";
  static String diaQuarta = "quarta-feira";
  static String diaQuinta = "quinta-feira";
  static String diaSexta = "sexta-feira";
  static String diaSabado = "sábado";
  static String diaDomingo = "domingo";


  static String pdfEscalaGerada = "Escala gerada por Senturion G List";
  static String pdfRodape = "\"Quem sua mão ao arado já pois, constante precisa ser\"";
}
