# Comment convertir des dBm en watts (avec exemples résolus)

**Thème :** conversion d'unités de puissance · **Niveau :** débutant à intermédiaire
**Dernière révision :** 2026-10-17
**Version originale :** [`../01_dBm_to_Watts.md`](../01_dBm_to_Watts.md)

---

## Le problème

La fiche technique indique une puissance de sortie d'émetteur de **43 dBm**.
La spécification de l'alimentation que vous vérifiez est en watts. Le
formulaire de relevé de site demande des watts. Alors : combien de watts font
43 dBm ?

Le cas se présente constamment — fiches techniques de radios, notices
d'amplificateurs, limites réglementaires et rapports d'essai mélangent les
deux unités sans précaution, et se tromper d'un facteur dix est facile.

---

## La formule

Le dBm est un **niveau de puissance référencé à 1 milliwatt**. Par définition :

```
P_dBm = 10 × log₁₀(P_mW)
```

En inversant, on obtient la conversion cherchée :

```
P_mW = 10^(P_dBm / 10)

P_W  = 10^(P_dBm / 10) / 1000
```

Deux remarques avant d'appliquer la formule :

1. **Le facteur est 10, pas 20.** Le facteur 20 concerne les rapports de
   tension et de courant, car la puissance est proportionnelle au carré de la
   tension. Utiliser 20 ici double le résultat en dB.
2. **Le dBm est absolu, pas relatif.** Contrairement au dB simple, le dBm
   désigne une puissance précise, car sa référence (1 mW) est fixée par
   définition.

---

## Exemple résolu : 43 dBm en watts

**Étape 1 — Diviser par 10.**

```
43 / 10 = 4,3
```

**Étape 2 — Élever 10 à cette puissance. Le résultat est en milliwatts.**

```
P_mW = 10^4,3 = 19 952,6 mW
```

**Étape 3 — Diviser par 1000 pour obtenir des watts.**

```
P_W = 19 952,6 / 1000 = 19,9526 W
```

**Réponse : 43 dBm ≈ 19,95 W**, soit environ 20 watts.

### Interprétation

43 dBm est un niveau de puissance typique au port d'un amplificateur de
puissance de station de base macro. Le repère mental utile est « environ
20 W » : si l'on vous annonce qu'une radio de secteur fonctionne à 43 dBm,
imaginez un équipement de 20 W, et non de 2 W ou de 200 W.

---

## Tableau de référence

Toutes les valeurs ci-dessous ont été produites par le moteur de conversion de
dB Konversor et vérifiées par comparaison avec une forme fermée établie de
manière indépendante. La sortie de vérification se trouve dans
[`../../evidence/exemplos_verificados.txt`](../../evidence/exemplos_verificados.txt).

| dBm | Milliwatts | Watts | Contexte typique |
|---|---|---|---|
| −100 dBm | 1 × 10⁻¹⁰ mW | 1 × 10⁻¹³ W | Proche de la limite de sensibilité d'un récepteur mobile |
| −70 dBm | 1 × 10⁻⁷ mW | 1 × 10⁻¹⁰ W | Signal Wi-Fi exploitable |
| −30 dBm | 0,001 mW | 1 µW | Signal reçu fort |
| 0 dBm | 1 mW | 0,001 W | Le point de référence, par définition |
| 13 dBm | 19,9526 mW | 0,02 W | Bluetooth classe 1 |
| 20 dBm | 100 mW | 0,1 W | Émetteur d'un client Wi-Fi |
| 23 dBm | 199,526 mW | 0,2 W | Liaison montante d'un téléphone mobile |
| 30 dBm | 1000 mW | 1 W | Exactement 1 watt |
| 37 dBm | 5011,87 mW | 5,01187 W | Émetteur de petite cellule |
| 43 dBm | 19 952,6 mW | 19,9526 W | Secteur de station de base macro |
| 50 dBm | 100 000 mW | 100 W | Émetteur de forte puissance |

### Les deux repères à mémoriser

| Repère | Pourquoi c'est utile |
|---|---|
| **0 dBm = 1 mW** | C'est la définition. Tout le reste en découle |
| **30 dBm = 1 W** | Car 10·log₁₀(1000) = 30 exactement |

Avec ces deux repères, plus la règle **+10 dB = ×10** et **+3 dB ≈ ×2**, vous
estimez la plupart des conversions de tête :

```
43 dBm = 30 dBm + 10 dB + 3 dB
       ≈ 1 W × 10 × 2
       ≈ 20 W        (valeur exacte : 19,95 W)
```

Cette estimation mentale se situe à moins de 0,25 % de la valeur exacte.

---

## Erreurs fréquentes

| Erreur | Conséquence | Comment l'éviter |
|---|---|---|
| Utiliser `20 × log₁₀` au lieu de `10 × log₁₀` | La valeur en dB double. 100 mW devient « 40 dBm » au lieu de 20 dBm | Le facteur 20 concerne la **tension**, jamais la puissance |
| Oublier la division par 1000 des mW aux W | Résultat 1000 fois trop grand | Le dBm se réfère à un **milli**watt |
| Traiter le dBm comme un rapport | « Le gain est de 20 dBm » n'a aucun sens | Le gain s'exprime en **dB** ; la puissance absolue en dBm |
| Additionner des valeurs en dBm pour additionner des puissances | 20 dBm + 20 dBm ≠ 40 dBm | Deux puissances égales se combinent en **+3 dB**, soit 23,0103 dBm |
| Arrondir 3,0103 dB à 3 dB dans une longue chaîne | L'erreur s'accumule sur de nombreux étages | Acceptable pour une estimation mentale ; utiliser la valeur exacte dans un rapport |

---

## Où cela s'applique en pratique

- **Bilans de liaison.** La puissance reçue se calcule en dBm, et l'on ne
  convertit en watts que si une spécification d'équipement l'exige.
- **Conformité réglementaire.** Les limites de puissance d'émission sont
  publiées en watts ou en dBm de PIRE, et il faut comparer ce qui est
  comparable.
- **Dimensionnement de l'alimentation.** La sortie RF d'un amplificateur en
  dBm, convertie en watts, donne la puissance de sortie ; combinée au
  rendement, elle donne la consommation en courant continu.
- **Mesures en laboratoire.** Les analyseurs de spectre affichent des dBm ; de
  nombreux wattmètres affichent des watts.

---

## Le faire sans erreur de calcul

Dans l'application **dB Konversor** : saisissez la valeur, réglez l'unité
d'entrée sur `dBm` et celle de sortie sur `W`. Le résultat s'affiche au fur et
à mesure de la saisie, et le panneau de formule montre la chaîne complète
appliquée :

```
mW = 10^(dBm / 10)  |  W = mW / 1000
```

Voir les deux étapes compte lorsqu'on apprend : c'est la différence entre
obtenir un nombre et comprendre d'où il vient. L'application fonctionne hors
ligne et n'exige aucun compte.

---

## Vérifier par vous-même

Toutes les valeurs de cet article sont reproductibles :

```powershell
dart run docs/evidence/gerar_exemplos.dart
```

Ce script exécute le code de conversion de production et compare chaque
résultat à une forme fermée établie indépendamment ; les nombres présentés ici
n'ont donc pas été recopiés à la main.

---

## Références et lectures complémentaires

- **Définition du dBm :** IEEE Std 100, *The Authoritative Dictionary of IEEE
  Standards Terms* — le dBm comme puissance référencée à 1 mW.
- Les **recommandations de l'UIT-R** utilisent abondamment les dBm et les dBW
  pour la puissance d'émission et l'intensité de champ ; voir la série V de
  l'UIT-R sur la terminologie et les unités.
- [`../03_dBm_vs_dBW.md`](../03_dBm_vs_dBW.md) — dBm et dBW (anglais)
- [`../02_Watts_to_dBm.md`](../02_Watts_to_dBm.md) — la conversion inverse (anglais)
- [`../06_power_levels_and_impedance.md`](../06_power_levels_and_impedance.md) — puissance et impédance (anglais)
- [`../../MATRIZ_CONVERSOES.md`](../../MATRIZ_CONVERSOES.md) — toutes les conversions
  prises en charge, avec leurs conditions de validité

> **Note sur les exemples.** Toutes les valeurs numériques présentées sont des
> *exemples de calcul*, obtenus à partir des formules indiquées. Il ne s'agit
> pas de mesures de terrain, et aucune donnée d'opérateur, résultat de
> laboratoire d'essai ou statistique de réseau n'est revendiqué. Les contextes
> indiqués dans le tableau (« typique d'une station de base macro ») servent de
> repère d'ordre de grandeur et ne constituent pas la spécification d'un
> produit particulier.
