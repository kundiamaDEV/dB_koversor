# Privacy Policy — dB Konversor

**Last updated:** 17 October 2026
**Application:** dB Konversor
**Google Play identifier:** `ao.kundiama.dbkonversor`
**Data controller:** KUNDIAMA Tecnologia e Inovação

---

## 1. In short

dB Konversor is a decibel conversion calculator. **We do not collect any of
your personal data.** The app creates no account, asks for no personal
information, shows no advertising and sends no data to servers — in the
published version it does not even hold permission to access the internet.

The only information the app stores is your conversion history, which stays
**on your device only** and which you can delete whenever you want.

This policy was written from a technical audit of the application's source
code; the audit report is available in
[`RELATORIO_AUDITORIA_PRIVACIDADE.md`](RELATORIO_AUDITORIA_PRIVACIDADE.md).

---

## 2. Data we do not collect

The app does **not** request, generate or transmit:

- name, email address or phone number;
- user account, password or credentials;
- location, not even approximate;
- contacts, photos, files, camera or microphone;
- device or advertising identifiers;
- usage data, analytics or crash reports.

The app contains **no** advertising, **no** usage analytics, **no** trackers,
**no** push notifications and **no** in-app purchases.

---

## 3. Data stored on your device

So that you can review the conversions you have made, the app keeps a **local
history**:

| What is stored | Example |
|---|---|
| The value you entered | `30` |
| The input unit | `dBm` |
| The calculated result | `1` |
| The output unit | `W` |
| The date and time of the conversion | `2026-10-17T14:32:00Z` |

Characteristics of this storage:

- It lives in the app's **private data area** on your device. Android isolates
  this area: other apps cannot read it.
- It **never leaves the device.** It is not sent to KUNDIAMA or to any third
  party. We have no access to it.
- It holds at most **50 conversions**; older entries are discarded
  automatically.
- It contains **nothing** that identifies you: only numbers and unit symbols.

---

## 4. Retention and deletion

The history is kept until you delete it. You have two ways to remove it:

1. **Inside the app:** open the history (clock icon button) and choose
   *Clear*. You are asked to confirm, and deletion is immediate and permanent.
2. **By uninstalling the app:** Android deletes all of the app's private data,
   including the history.

Because we store no data on our systems, there is no retention period on our
side: there is nothing to retain.

---

## 5. Permissions

The published version of the app requests **no Android system permission** —
no internet access, no location, no storage, nothing.

The only permission present in the package is
`ao.kundiama.dbkonversor.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`, created
automatically by the Android libraries as an **internal security** measure: it
prevents other apps from communicating with this app's internal components. It
grants access to none of your data.

Because the app does not hold the internet permission, Android itself
**prevents** any attempt to send data. That is an operating-system guarantee,
not merely a promise from us.

---

## 6. Third-party services

The app integrates **no** third-party data-collecting services: there is no
Firebase, no Google Analytics, no Crashlytics, no AdMob and no equivalent SDK.
The only library with native code is the one that stores local preferences on
your device (`shared_preferences`), and it does not use the network.

**With one important and honest caveat:** the app is distributed through
**Google Play**. Google collects its own data relating to installation,
account and device, under Google's policies, and that is outside our control.
If you downloaded the app from Google Play, [Google's Privacy
Policy](https://policies.google.com/privacy) also applies.

---

## 7. Use by minors

The app is a technical calculation tool, suitable for secondary and
university students. Because it collects no personal data, it processes no
information about minors or about any other group of users.

---

## 8. Your rights

Data protection law — including the General Data Protection Regulation (GDPR)
in the European Union — gives you rights of access, rectification, erasure,
restriction of processing, portability and objection regarding your personal
data.

In the case of this app, **we hold no personal data of yours on our systems**.
Therefore:

- there is no information for us to show, correct or delete on our side;
- the only data the app stores is under your **direct control**, on your
  device, and you can delete it at any time (section 4);
- we do not build profiles, we make no automated decisions about users, and we
  share no data, because we have none.

If you have questions about exercising these rights, use the contact details
in section 10.

---

## 9. Security

Because there is no data transmission, there is no risk of interception in
transit. The history stored on the device is protected by **Android's
application sandboxing**, which prevents access by other apps.

Please note that the security of data on your device also depends on the
device itself: if it is rooted, if you install apps from untrusted sources, or
if you share it without screen protection, those guarantees can be bypassed by
anyone with physical access or elevated privileges.

---

## 10. Contact

For any question about this policy or about privacy in the app:

- **Organisation:** KUNDIAMA Tecnologia e Inovação
- **Email:** diassilua.simao@gmail.com
- **Phone:** 945560400 / 952142799

These are the same contact details shown on the app's **Help** screen. Phone
numbers are Angolan (country code +244).

---

## 11. Changes to this policy

If data handling changes in a future version — for example if the app starts
communicating with a server, including advertising, or using analytics tools —
this policy will be updated **before** that version is published, and the date
at the top of this document will be changed.

Substantial changes will be noted in the release notes on Google Play.

---

## 12. Where to find this policy

| Location | Note |
|---|---|
| **Inside the app** | Side menu → *Privacy Policy*. Available without an internet connection, in all five app languages. |
| **Project repository** | This document and its translations, under `docs/privacy/` |
| **Public URL** | **PENDING.** Google Play requires an accessible public URL. It has not been published yet; it must be added here and in the Play Console as soon as it exists. |

> **Transparency note:** the public URL that Google Play requires **does not
> yet exist**. This document does not invent one. Publishing it is an external
> action that must be carried out by the owner; the procedure is described in
> [`GUIA_DATA_SAFETY.md`](GUIA_DATA_SAFETY.md).
