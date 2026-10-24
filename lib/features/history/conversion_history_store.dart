import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conversion_history_entry.dart';

/// Guarda e lê o histórico de conversões.
///
/// INTRODUZIDO NA AUDITORIA DE 2026-10-17 (defeito F1).
///
/// Armazenamento
/// -------------
/// Usa `shared_preferences`, que no Android escreve num ficheiro XML privado
/// da aplicação (`SharedPreferences`), acessível apenas a este pacote e
/// removido quando a aplicação é desinstalada. **Nada é enviado para fora do
/// dispositivo.** Esta é a única forma de persistência da aplicação e é o que
/// a Política de Privacidade e a declaração *Data safety* descrevem.
/// Ver `docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md`.
///
/// Porque não uma base de dados
/// ----------------------------
/// O histórico é uma lista curta e sem consultas: um ficheiro de preferências
/// basta e evita uma dependência maior com esquema e migrações.
///
/// Tolerância a falhas
/// -------------------
/// Nenhuma operação de histórico pode impedir a aplicação de funcionar: o
/// conversor tem de continuar a calcular mesmo que a gravação falhe (disco
/// cheio, permissões, plugin indisponível em testes). Por isso todos os
/// acessos ao armazenamento estão protegidos e as falhas são silenciadas em
/// produção, apenas registadas em modo de depuração.
class ConversionHistoryStore extends ChangeNotifier {
  /// Chave de armazenamento. A versão no nome permite mudar o formato no
  /// futuro sem ler registos antigos com um esquema diferente.
  static const String storageKey = 'conversion_history_v1';

  /// Número máximo de entradas conservadas.
  ///
  /// Limitar evita que o ficheiro cresça sem fim num uso intenso. 50 entradas
  /// cobrem bem a consulta recente, que é o objectivo do painel.
  static const int maxEntries = 50;

  final List<ConversionHistoryEntry> _entries = <ConversionHistoryEntry>[];

  bool _loaded = false;

  /// Entradas da mais recente para a mais antiga. Lista só de leitura.
  List<ConversionHistoryEntry> get entries => List.unmodifiable(_entries);

  /// `true` depois da primeira tentativa de leitura, mesmo que tenha falhado.
  bool get isLoaded => _loaded;

  bool get isEmpty => _entries.isEmpty;

  /// Lê o histórico gravado. Chamar uma vez no arranque do ecrã.
  Future<void> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final stored = preferences.getString(storageKey);

      _entries
        ..clear()
        ..addAll(ConversionHistoryEntry.decodeList(stored));
    } catch (error, stackTrace) {
      // Não propaga: um histórico ilegível não deve bloquear o conversor.
      _reportIgnored('leitura do histórico', error, stackTrace);
      _entries.clear();
    } finally {
      _loaded = true;
      notifyListeners();
    }
  }

  /// Registar uma conversão concluída com êxito.
  ///
  /// Ignora a entrada quando é igual à mais recente, para que a recalculação a
  /// cada tecla premida não produza registos repetidos.
  Future<void> add(ConversionHistoryEntry entry) async {
    if (!entry.inputValue.isFinite || !entry.outputValue.isFinite) return;

    if (_entries.isNotEmpty && _entries.first.hasSameConversionAs(entry)) {
      return;
    }

    _entries.insert(0, entry);

    if (_entries.length > maxEntries) {
      _entries.removeRange(maxEntries, _entries.length);
    }

    notifyListeners();
    await _persist();
  }

  /// Apaga todo o histórico, no ecrã e no dispositivo.
  Future<void> clear() async {
    _entries.clear();
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(storageKey);
    } catch (error, stackTrace) {
      _reportIgnored('eliminação do histórico', error, stackTrace);
    }
  }

  Future<void> _persist() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        storageKey,
        ConversionHistoryEntry.encodeList(_entries),
      );
    } catch (error, stackTrace) {
      // A entrada permanece visível na sessão corrente mesmo que a gravação
      // falhe; apenas não sobrevive ao reinício.
      _reportIgnored('gravação do histórico', error, stackTrace);
    }
  }

  void _reportIgnored(String operation, Object error, StackTrace stackTrace) {
    assert(() {
      debugPrint('dB Konversor: falha ignorada na $operation: $error');
      return true;
    }());
  }
}
