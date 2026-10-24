import 'dart:math' as math;
double handRolled(double value) {
  if (value < 0) return double.nan;
  if (value == 0) return 0;
  double guess = value / 2;
  if (guess == 0) return 0;
  for (int i = 0; i < 20; i++) { guess = 0.5 * (guess + value / guess); }
  return guess;
}
double log10(double v) => math.log(v) / math.ln10;
void main() {
  const r = 50.0;
  print('dBm     V(correct)      V(app)          dBV(correct)  dBV(app)   erro_dB');
  for (final dbm in [-130.0,-120.0,-110.0,-100.0,-90.0,-80.0,-70.0,-60.0,-50.0,-40.0,-30.0,-20.0,-10.0,0.0,10.0,20.0,30.0,40.0,50.0,60.0,80.0,100.0]) {
    final mw = math.pow(10, dbm / 10).toDouble();
    final w = mw / 1000.0;
    final vr = math.sqrt(w * r), vh = handRolled(w * r);
    final dr = 20 * log10(vr), dh = 20 * log10(vh);
    final flag = (dh - dr).abs() > 0.01 ? '  <== ERRO' : '';
    print('${dbm.toStringAsFixed(0).padLeft(5)}  ${vr.toStringAsExponential(4).padRight(15)} ${vh.toStringAsExponential(4).padRight(15)} ${dr.toStringAsFixed(3).padLeft(10)} ${dh.toStringAsFixed(3).padLeft(11)} ${(dh-dr).toStringAsFixed(3).padLeft(9)}$flag');
  }
}
