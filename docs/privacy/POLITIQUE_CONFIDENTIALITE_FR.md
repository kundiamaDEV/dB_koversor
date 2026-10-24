# Politique de confidentialité — dB Konversor

**Dernière mise à jour :** 17 octobre 2026
**Application :** dB Konversor
**Identifiant Google Play :** `ao.kundiama.dbkonversor`
**Responsable du traitement :** KUNDIAMA Tecnologia e Inovação

---

## 1. En résumé

dB Konversor est une calculatrice de conversion de décibels. **Nous ne
collectons aucune de vos données personnelles.** L'application ne crée aucun
compte, ne demande aucune information personnelle, n'affiche aucune publicité
et n'envoie aucune donnée à des serveurs — dans la version publiée, elle ne
dispose même pas de l'autorisation d'accéder à Internet.

La seule information que l'application enregistre est votre historique de
conversions, qui reste **uniquement sur votre appareil** et que vous pouvez
supprimer à tout moment.

Cette politique a été rédigée à partir d'un audit technique du code source de
l'application, dont le rapport est disponible dans
[`RELATORIO_AUDITORIA_PRIVACIDADE.md`](RELATORIO_AUDITORIA_PRIVACIDADE.md).

---

## 2. Données que nous ne collectons pas

L'application ne demande, ne génère et ne transmet **pas** :

- nom, adresse e-mail ou numéro de téléphone ;
- compte utilisateur, mot de passe ou identifiants de connexion ;
- localisation, même approximative ;
- contacts, photos, fichiers, caméra ou microphone ;
- identifiants d'appareil ou de publicité ;
- données d'utilisation, statistiques ou rapports d'erreur.

L'application ne contient **aucune** publicité, **aucun** outil d'analyse
d'utilisation, **aucun** traceur, **aucune** notification push et **aucun**
achat intégré.

---

## 3. Données enregistrées sur votre appareil

Pour que vous puissiez consulter les conversions effectuées, l'application
conserve un **historique local** :

| Ce qui est enregistré | Exemple |
|---|---|
| La valeur saisie | `30` |
| L'unité d'entrée | `dBm` |
| Le résultat calculé | `1` |
| L'unité de sortie | `W` |
| La date et l'heure de la conversion | `2026-10-17T14:32:00Z` |

Caractéristiques de cet enregistrement :

- Il se trouve dans la **zone de données privées** de l'application, sur votre
  appareil. Android isole cette zone : les autres applications ne peuvent pas
  la lire.
- Il **ne quitte jamais l'appareil.** Il n'est transmis ni à KUNDIAMA ni à des
  tiers. Nous n'y avons pas accès.
- Il conserve au maximum **50 conversions** ; les plus anciennes sont
  supprimées automatiquement.
- Il ne contient **rien** qui vous identifie : uniquement des nombres et des
  symboles d'unités.

---

## 4. Conservation et suppression

L'historique est conservé jusqu'à ce que vous le supprimiez. Vous disposez de
deux moyens :

1. **Dans l'application :** ouvrez l'historique (bouton avec l'icône
   d'horloge) et choisissez *Effacer*. Une confirmation est demandée, et la
   suppression est immédiate et définitive.
2. **En désinstallant l'application :** Android supprime toutes les données
   privées de l'application, y compris l'historique.

Comme nous n'enregistrons aucune donnée sur nos systèmes, il n'existe aucune
durée de conservation de notre côté : il n'y a rien à conserver.

---

## 5. Autorisations

La version publiée de l'application ne demande **aucune autorisation** du
système Android — ni accès à Internet, ni localisation, ni stockage, ni aucune
autre.

La seule autorisation présente dans le paquet est
`ao.kundiama.dbkonversor.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`, créée
automatiquement par les bibliothèques Android comme mesure de **sécurité
interne** : elle empêche d'autres applications de communiquer avec les
composants internes de celle-ci. Elle ne donne accès à aucune de vos données.

Comme l'application ne dispose pas de l'autorisation d'accès à Internet,
Android lui-même **empêche** toute tentative d'envoi de données. Il s'agit
d'une garantie du système d'exploitation, et non d'une simple promesse de
notre part.

---

## 6. Services tiers

L'application n'intègre **aucun** service tiers collectant des données : ni
Firebase, ni Google Analytics, ni Crashlytics, ni AdMob, ni aucun SDK
équivalent. La seule bibliothèque comportant du code natif est celle qui
enregistre les préférences locales sur votre appareil
(`shared_preferences`), et elle n'utilise pas le réseau.

**Avec une réserve importante, par souci d'honnêteté :** l'application est
distribuée via **Google Play**. Google collecte ses propres données relatives
à l'installation, au compte et à l'appareil, conformément à ses politiques, ce
qui échappe à notre contrôle. Si vous avez téléchargé l'application sur Google
Play, la [Politique de confidentialité de
Google](https://policies.google.com/privacy) s'applique également.

---

## 7. Utilisation par des mineurs

L'application est un outil de calcul technique, adapté aux élèves du secondaire
et aux étudiants. Comme elle ne collecte aucune donnée personnelle, elle ne
traite aucune information concernant des mineurs ni aucun autre groupe
d'utilisateurs.

---

## 8. Vos droits

La législation sur la protection des données — notamment le Règlement général
sur la protection des données (RGPD) dans l'Union européenne — vous accorde des
droits d'accès, de rectification, d'effacement, de limitation du traitement, de
portabilité et d'opposition concernant vos données personnelles.

Dans le cas de cette application, **nous ne détenons aucune donnée personnelle
vous concernant sur nos systèmes**. Par conséquent :

- il n'existe de notre côté aucune information à vous communiquer, à corriger
  ou à supprimer ;
- les seules données enregistrées par l'application sont sous votre **contrôle
  direct**, sur votre appareil, et vous pouvez les supprimer à tout moment
  (section 4) ;
- nous n'établissons aucun profil, nous ne prenons aucune décision automatisée
  concernant les utilisateurs et nous ne partageons aucune donnée, puisque nous
  n'en possédons aucune.

Pour toute question sur l'exercice de ces droits, utilisez les coordonnées de
la section 10.

---

## 9. Sécurité

Comme il n'y a aucune transmission de données, il n'existe aucun risque
d'interception en transit. L'historique enregistré sur l'appareil est protégé
par le **cloisonnement des applications Android**, qui empêche l'accès par
d'autres applications.

Notez que la sécurité des données sur votre appareil dépend aussi de
l'appareil lui-même : s'il est débridé (*root*), si vous installez des
applications de sources non fiables ou si vous le partagez sans protection
d'écran, ces garanties peuvent être contournées par toute personne disposant
d'un accès physique ou de privilèges élevés.

---

## 10. Contact

Pour toute question concernant cette politique ou la confidentialité dans
l'application :

- **Organisation :** KUNDIAMA Tecnologia e Inovação
- **E-mail :** diassilua.simao@gmail.com
- **Téléphone :** 945560400 / 952142799

Ce sont les mêmes coordonnées que celles affichées dans l'écran **Aide** de
l'application. Les numéros de téléphone sont angolais (indicatif +244).

---

## 11. Modifications de cette politique

Si le traitement des données change dans une version future — par exemple si
l'application se met à communiquer avec un serveur, à inclure de la publicité
ou à utiliser des outils d'analyse — cette politique sera mise à jour **avant**
la publication de cette version, et la date figurant en haut du document sera
modifiée.

Les modifications substantielles seront signalées dans les notes de version
sur Google Play.

---

## 12. Où consulter cette politique

| Emplacement | Remarque |
|---|---|
| **Dans l'application** | Menu latéral → *Politique de confidentialité*. Disponible sans connexion Internet, dans les cinq langues de l'application. |
| **Dépôt du projet** | Ce document et ses traductions, dans `docs/privacy/` |
| **URL publique** | **EN ATTENTE.** Google Play exige une URL publique accessible. Elle n'a pas encore été publiée ; elle devra être ajoutée ici et dans la Play Console dès qu'elle existera. |

> **Note de transparence :** l'URL publique exigée par Google Play **n'existe
> pas encore**. Ce document n'en invente aucune. Sa publication est une action
> externe qui doit être effectuée par le propriétaire ; la procédure est
> décrite dans [`GUIA_DATA_SAFETY.md`](GUIA_DATA_SAFETY.md).
