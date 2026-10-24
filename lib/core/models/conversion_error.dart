/// Códigos de erro das conversões.
///
/// INTRODUZIDO NA AUDITORIA DE 2026-10-17 (internacionalização, Fase 4).
///
/// Porque foi necessário
/// ---------------------
/// Antes, `PowerConverterService` e `Validators` devolviam frases em português
/// escritas directamente no código. Isso impedia a tradução: a camada de
/// cálculo não tem — e não deve ter — acesso ao `BuildContext` nem aos recursos
/// de localização, e passar-lhos tornaria a matemática dependente da interface
/// e muito mais difícil de testar.
///
/// Regra técnica aplicada
/// ----------------------
/// A camada de cálculo devolve um **código** estável e, quando necessário, um
/// argumento (tipicamente o símbolo da unidade). A tradução acontece só na
/// interface, em `ConversionErrorMessages`. Os códigos são identificadores
/// internos: **não são traduzidos** e não devem ser renomeados sem actualizar
/// o mapeamento e os testes.
///
/// Limitação conhecida
/// -------------------
/// `ConversionResult.errorMessage` continua a existir, com uma frase em
/// português, como recurso de diagnóstico para os testes e para registos de
/// erro. **Não é esse o texto apresentado ao utilizador** quando há
/// localização disponível. Ver `docs/GUIA_LOCALIZACAO.md`.
enum ConversionError {
  /// A entrada não é um número finito (NaN ou infinito).
  nonFiniteInput,

  /// Não foi introduzido nenhum valor.
  emptyInput,

  /// O texto introduzido não é um número válido.
  invalidNumber,

  /// O argumento de um logaritmo não é positivo. Usa `unitLabel`.
  nonPositiveForLog,

  /// Potência linear negativa, que não tem significado físico. Usa `unitLabel`.
  negativePower,

  /// A conversão relaciona potência e tensão mas falta a impedância.
  missingImpedance,

  /// A impedância introduzida é nula ou negativa.
  nonPositiveImpedance,

  /// Falta o valor de referência de uma conversão relativa em dB.
  missingReference,

  /// A potência de referência é nula ou negativa.
  nonPositiveReference,

  /// O valor está fora da gama representável em dupla precisão.
  /// Usa `unitLabel`.
  outOfRange,

  /// O resultado excederia a gama numérica representável.
  resultOutOfRange,

  /// A combinação de unidades não é suportada.
  unsupportedCombination,

  /// A referência não é compatível com as unidades escolhidas.
  incompatibleReference,

  /// Não foi possível concluir o cálculo com os valores dados.
  computationFailed,
}
