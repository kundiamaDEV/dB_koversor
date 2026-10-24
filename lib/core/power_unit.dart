enum UnitCategory {
  powerLinear,
  powerLogAbsolute,
  voltageLog,
  ratioLog,
}

enum PowerUnit {
  watt,
  milliwatt,
  db,
  dbm,
  // dBW acrescentado na auditoria de 2026-10-17 (defeito M2).
  // E uma unidade de potencia absoluta referenciada a 1 W, muito usada em
  // radiodifusao, enlaces de satelite e calculos de PIRE/EIRP.
  // Relacao com dBm: P_dBm = P_dBW + 30, porque 1 W = 1000 mW.
  dbw,
  dbu,
  dbv,
}

extension PowerUnitX on PowerUnit {
  String get label {
    switch (this) {
      case PowerUnit.watt:
        return 'W';
      case PowerUnit.milliwatt:
        return 'mW';
      case PowerUnit.db:
        return 'dB';
      case PowerUnit.dbm:
        return 'dBm';
      case PowerUnit.dbw:
        return 'dBW';
      case PowerUnit.dbu:
        return 'dBu';
      case PowerUnit.dbv:
        return 'dBV';
    }
  }

  String get description {
    switch (this) {
      case PowerUnit.watt:
        return 'Potência linear em watts.';
      case PowerUnit.milliwatt:
        return 'Potência linear em miliwatts.';
      case PowerUnit.db:
        return 'Relação logarítmica entre duas grandezas. '
            'Precisa de um valor de referência para dar um nível absoluto.';
      case PowerUnit.dbm:
        return 'Potência absoluta referenciada a 1 mW.';
      case PowerUnit.dbw:
        return 'Potência absoluta referenciada a 1 W. 0 dBW = 30 dBm.';
      case PowerUnit.dbu:
        return 'Nível de tensão referenciado a 0.775 V.';
      case PowerUnit.dbv:
        return 'Nível de tensão referenciado a 1 V.';
    }
  }

  UnitCategory get category {
    switch (this) {
      case PowerUnit.watt:
      case PowerUnit.milliwatt:
        return UnitCategory.powerLinear;
      case PowerUnit.dbm:
      case PowerUnit.dbw:
        return UnitCategory.powerLogAbsolute;
      case PowerUnit.dbu:
      case PowerUnit.dbv:
        return UnitCategory.voltageLog;
      case PowerUnit.db:
        return UnitCategory.ratioLog;
    }
  }

  bool get isPowerUnit =>
      this == PowerUnit.watt ||
      this == PowerUnit.milliwatt ||
      this == PowerUnit.dbm ||
      this == PowerUnit.dbw;

  bool get isVoltageLogUnit =>
      this == PowerUnit.dbu || this == PowerUnit.dbv;

  bool get isRatioUnit => this == PowerUnit.db;
}