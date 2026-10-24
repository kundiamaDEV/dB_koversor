// Gera a tabela de exemplos numéricos usada na documentação.
//
// Todos os valores que aparecem em docs/MATRIZ_CONVERSOES.md e nos artigos de
// docs/content/ são produzidos por este script, a partir do código de produção
// real. Assim a documentação não contém números escritos à mão, que poderiam
// divergir silenciosamente da aplicação.
//
// Executar a partir da raiz do projecto:
//
//   dart run docs/evidence/gerar_exemplos.dart
//
// Verificação cruzada: cada linha traz também o valor calculado por uma forma
// fechada independente (a mesma estratégia dos testes), e a coluna "ok" fica a
// ERRO se as duas discordarem.

import 'dart:math' as math;

import 'package:db_konversor/core/power_unit.dart';
import 'package:db_konversor/features/converter/power_converter_service.dart';
import 'package:db_konversor/utils/math_utils.dart';

final service = PowerConverterService();

double log10(double v) => math.log(v) / math.ln10;

String run(
  double input,
  PowerUnit from,
  PowerUnit to, {
  double? impedance,
  double? reference,
  double? expected,
}) {
  final result = service.convert(
    inputValue: input,
    from: from,
    to: to,
    impedance: impedance,
    referenceValue: reference,
  );

  if (!result.isSuccess) {
    return '${_pad('$input ${from.label} -> ${to.label}', 28)} ERRO: '
        '${result.errorMessage}';
  }

  final value = result.value!;
  var status = '';

  if (expected != null) {
    final diff = (value - expected).abs();
    final tolerance = expected.abs() * 1e-9 + 1e-9;
    status = diff <= tolerance
        ? 'ok'
        : 'ERRO (esperado $expected, diferenca $diff)';
  }

  return '${_pad('$input ${from.label} -> ${to.label}', 28)}'
      '${_pad(MathUtils.formatResult(value), 16)}'
      '${_pad(value.toStringAsPrecision(12), 20)}$status';
}

String _pad(String text, int width) =>
    text.length >= width ? '$text ' : text.padRight(width);

void section(String title) {
  print('');
  print('--- $title ${'-' * (62 - title.length)}');
  print(
    '${_pad('conversao', 28)}${_pad('apresentado', 16)}'
    '${_pad('valor interno', 20)}verificacao',
  );
}

void main() {
  print('dB Konversor - exemplos numericos verificados');
  print('Gerado por docs/evidence/gerar_exemplos.dart');

  section('Potencia linear e dBm');
  print(run(0, PowerUnit.dbm, PowerUnit.milliwatt, expected: 1.0));
  print(run(10, PowerUnit.dbm, PowerUnit.milliwatt, expected: 10.0));
  print(run(20, PowerUnit.dbm, PowerUnit.milliwatt, expected: 100.0));
  print(run(30, PowerUnit.dbm, PowerUnit.watt, expected: 1.0));
  print(run(-30, PowerUnit.dbm, PowerUnit.milliwatt, expected: 0.001));
  print(run(1, PowerUnit.watt, PowerUnit.dbm, expected: 30.0));
  print(run(100, PowerUnit.milliwatt, PowerUnit.dbm, expected: 20.0));
  print(run(0.5, PowerUnit.watt, PowerUnit.dbm, expected: 26.98970004336));
  print(run(2, PowerUnit.milliwatt, PowerUnit.dbm, expected: 3.01029995664));

  section('dBW');
  print(run(0, PowerUnit.dbw, PowerUnit.watt, expected: 1.0));
  print(run(0, PowerUnit.dbw, PowerUnit.dbm, expected: 30.0));
  print(run(20, PowerUnit.dbw, PowerUnit.watt, expected: 100.0));
  print(run(50, PowerUnit.dbm, PowerUnit.dbw, expected: 20.0));
  print(run(-30, PowerUnit.dbw, PowerUnit.milliwatt, expected: 1.0));
  print(run(100, PowerUnit.watt, PowerUnit.dbw, expected: 20.0));
  print(run(5, PowerUnit.watt, PowerUnit.dbw, expected: 6.98970004336));

  section('Niveis de tensao dBu e dBV');
  print(run(0, PowerUnit.dbu, PowerUnit.dbv, expected: 20 * log10(0.775)));
  print(run(0, PowerUnit.dbv, PowerUnit.dbu, expected: 20 * log10(1 / 0.775)));
  print(run(4, PowerUnit.dbu, PowerUnit.dbv, expected: 4 + 20 * log10(0.775)));
  print(run(-10, PowerUnit.dbv, PowerUnit.dbu, expected: -10 + 20 * log10(1 / 0.775)));

  section('Potencia <-> tensao em 50 ohm (radiofrequencia)');
  for (final dbm in <double>[-120, -100, -90, -60, -30, 0, 20, 30, 43]) {
    final watts = math.pow(10, dbm / 10).toDouble() / 1000.0;
    print(
      run(
        dbm,
        PowerUnit.dbm,
        PowerUnit.dbv,
        impedance: 50,
        expected: 10 * log10(watts * 50),
      ),
    );
  }

  section('Potencia <-> tensao em 600 ohm (audio)');
  for (final dbm in <double>[-20, 0, 10]) {
    final watts = math.pow(10, dbm / 10).toDouble() / 1000.0;
    print(
      run(
        dbm,
        PowerUnit.dbm,
        PowerUnit.dbu,
        impedance: 600,
        expected: 10 * log10(watts * 600 / (0.775 * 0.775)),
      ),
    );
  }
  print(run(0, PowerUnit.dbu, PowerUnit.milliwatt, impedance: 600, expected: 0.775 * 0.775 / 600 * 1000));

  section('Tensao em 8 ohm (altifalantes)');
  for (final dbv in <double>[0, 10, 20]) {
    print(
      run(
        dbv,
        PowerUnit.dbv,
        PowerUnit.watt,
        impedance: 8,
        expected: math.pow(10, dbv / 10).toDouble() / 8,
      ),
    );
  }

  section('dB relativo com referencia');
  print(run(2, PowerUnit.watt, PowerUnit.db, reference: 1, expected: 3.01029995664));
  print(run(100, PowerUnit.milliwatt, PowerUnit.db, reference: 1, expected: 20.0));
  print(run(23, PowerUnit.dbm, PowerUnit.db, reference: 20, expected: 3.0));
  print(run(3, PowerUnit.db, PowerUnit.dbm, reference: 20, expected: 23.0));
  print(run(-3, PowerUnit.db, PowerUnit.watt, reference: 100, expected: 100 * math.pow(10, -0.3).toDouble()));

  section('Casos limite (devem falhar de forma explicita)');
  for (final c in <List<Object>>[
    [0.0, PowerUnit.milliwatt, PowerUnit.dbm],
    [-5.0, PowerUnit.watt, PowerUnit.dbm],
    [4000.0, PowerUnit.dbm, PowerUnit.watt],
    [-4000.0, PowerUnit.dbw, PowerUnit.watt],
  ]) {
    final r = service.convert(
      inputValue: c[0] as double,
      from: c[1] as PowerUnit,
      to: c[2] as PowerUnit,
    );
    print(
      '${_pad('${c[0]} ${(c[1] as PowerUnit).label} -> '
          '${(c[2] as PowerUnit).label}', 28)}'
      '${r.isSuccess ? "NAO FALHOU (problema)" : "rejeitado: ${r.error}"}',
    );
  }

  section('Formulas apresentadas ao utilizador');
  for (final c in <List<Object?>>[
    [10.0, PowerUnit.dbm, PowerUnit.watt, null],
    [1.0, PowerUnit.watt, PowerUnit.dbm, null],
    [0.0, PowerUnit.dbw, PowerUnit.dbm, null],
    [0.0, PowerUnit.dbm, PowerUnit.dbv, 50.0],
    [0.0, PowerUnit.dbv, PowerUnit.watt, 50.0],
    [0.0, PowerUnit.dbu, PowerUnit.dbv, null],
  ]) {
    final r = service.convert(
      inputValue: c[0] as double,
      from: c[1] as PowerUnit,
      to: c[2] as PowerUnit,
      impedance: c[3] as double?,
    );
    print(
      '${_pad('${(c[1] as PowerUnit).label} -> ${(c[2] as PowerUnit).label}', 28)}'
      '${r.formula}',
    );
  }
}
