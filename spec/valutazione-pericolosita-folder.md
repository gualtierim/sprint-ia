# Folder "Valutazione pericolosità" — allineamento al layout legacy

Mappatura del contenuto della collapse **Valutazione pericolosità** (`valutazione-pericolosita-folder`)
sul JSP legacy `valutazionePericolosita.do` (form `saveValutazionePericolosita`). Le sotto-sezioni `<h4>`
del legacy diventano i blocchi interni della collapse (convenzione di progetto).

Legenda obbligatorietà: `*` = obbligatorio **salvataggio**, `**` = obbligatorio **invio**.
Per questo folder il legacy (`validation-richiesta.xml`, form `/saveValutazionePericolosita`) **non**
impone alcun `required`: i soli vincoli sono di **formato** (double/number/integer/date). Quindi nessun
campo è marcato `*`/`**`; i marcatori `(d)` = formato decimale, `(i)` = formato intero, `(D)` = data.

Fonte legacy: JSP `sprintj/.../jsp/richiesta/valutazionePericolosita.jsp`.
SQL legacy: `sprintj/.../dao/richiesta/impl/sql.properties` — `loadValutazionePericolosita`,
`updateValutazionePericolosita` (tabella `sprint_t_ric_183`); lookup `findLkRichiesta183ByNomeColonna`
(`select id, codice, descrizione from SPRINT_D_RIC_183 where NOME_COLONNA = ?`).
Stato attuale: `sprintwcl/.../folders/valutazione-pericolosita-folder/`.

---

## 1. Struttura target (5 sezioni)

Tutti i campi persistono su **`sprint.sprint_t_ric_183`** (PK `id_richiesta_generica`). I campi `fk_*`
sono FK verso **`sprint.sprint_d_ric_183`** (lookup per `nome_colonna`, **non** `sprint_d_richiesta_generica`).
Gli `*_hazard` sono **calcolati** dal motore legacy (read-only nel JSP, `<bean:write>`): nel BFF restano
read-only (round-trip) finché il motore hazard non è portato.

### 1.1 Dissesto idrogeologico: frane
| Campo | Tipo | Obbl. | Sorgente (colonna) | Note |
|-------|------|-------|--------------------|------|
| Tipologia della frana (Varnes semplificato) | select | — | `fk_frana_tipo` → `FK_FRANA_TIPO` | lookup D_RIC_183 |
| Velocità frana | select | — | `fk_frana_velocita` → `FK_FRANA_VELOCITA` | lookup D_RIC_183 |
| Superficie interessata (m2) | number `(d)` | — | `frana_superficie_mq` | numeric(9,2) |
| Volume | number `(d)` | — | `frana_superficie_mc` | numeric(9,2) **nuovo nel DTO** |
| Stato di attività | select | — | `fk_frana_stato_attivita` → `FK_FRANA_STATO_ATTIVITA` | **nuovo** |
| Distribuzione di attività nel tempo | select | — | `fk_frana_distr_attivita` → `FK_FRANA_DISTR_ATTIVITA` | **nuovo** |
| Presenza di interventi | select | — | `fk_frana_pres_interventi` → `FK_FRANA_PRES_INTERVENTI` | **nuovo** |
| Presenza di opere o strutture negative | select | — | `fk_frana_pres_opere_negative` → `FK_FRANA_PRES_OPERE_NEGATIVE` | **nuovo** |
| Hazard di pericolosità ottenuto | readonly | — | `frana_hazard` | calcolato (motore legacy) |

### 1.2 Dissesto idrogeologico: conoidi
| Campo | Tipo | Obbl. | Sorgente (colonna) | Note |
|-------|------|-------|--------------------|------|
| Superficie bacino (Ab) (km2) | number `(d)` | — | `conoide_sup_bacino` | numeric(9,2) |
| Superficie conoide (Ac) (km2) | number `(d)` | — | `conoide_sup_conoide` | numeric(9,2) **nuovo** |
| Indice di asprezza di Melton | select | — | `fk_conoide_i_asprezza_melton` → `FK_CONOIDE_I_ASPREZZA_MELTON` | **nuovo** |
| Diametro medio-massimo interno conoide (m3) | select | — | `fk_conoide_diametro_interno` → `FK_CONOIDE_DIAMETRO_INTERNO` | **nuovo** |
| Pendenza del conoide (°) | select | — | `fk_conoide_pendenza` → `FK_CONOIDE_PENDENZA` | **nuovo** |
| Ricorrenza del fenomeno (anni) | select | — | `fk_conoide_ricorrenza` → `FK_CONOIDE_RICORRENZA` | **nuovo** |
| Presenza di interventi | select | — | `fk_conoide_pres_interventi` → `FK_CONOIDE_PRES_INTERVENTI` | **nuovo** |
| Presenza di opere o strutture negative | select | — | `fk_conoide_pres_opere_negative` → `FK_CONOIDE_PRES_OPERE_NEGATIVE` | **nuovo** |
| Hazard di pericolosità ottenuto | readonly | — | `conoide_hazard` | calcolato |

### 1.3 Dissesto idrogeologico: valanghe
| Campo | Tipo | Obbl. | Sorgente (colonna) | Note |
|-------|------|-------|--------------------|------|
| Ricorrenza del fenomeno | select | — | `fk_valanga_ricorrenza` → `FK_VALANGA_RICORRENZA` | lookup D_RIC_183 |
| Volume della valanga | select | — | `fk_valanga_volume` → `FK_VALANGA_VOLUME` | **nuovo** |
| Presenza di interventi | select | — | `fk_valanga_pres_interventi` → `FK_VALANGA_PRES_INTERVENTI` | **nuovo** |
| Hazard di pericolosità ottenuto | readonly | — | `valanga_hazard` | calcolato |

### 1.4 Dissesto rete idrografica superficiale
| Campo | Tipo | Obbl. | Sorgente (colonna) | Note |
|-------|------|-------|--------------------|------|
| Superficie bacino sotteso dalla sezione (km2) | number `(d)` | — | `idro_sup_bacino_sez` | numeric(9,2) |

### 1.5 Valutazione evento di piena o pioggia critico per la rete idrografica
| Campo | Tipo | Obbl. | Sorgente (colonna) | Note |
|-------|------|-------|--------------------|------|
| Descrizione evento | text | — | `idro_sup_desc_evento` | varchar(1000) |
| Tempo di ritorno (anni) | select | — | `fk_idro_sup_tr` → `FK_IDRO_SUP_TR` | lookup D_RIC_183 |
| Portata (m3/s) | number `(d)` | — | `idro_sup_portata` | numeric(9,2) **nuovo** |
| Pioggia (mm/ora) | number `(i)` | — | `idro_sup_pioggia_mm_hh` | numeric(6,0) **nuovo** |
| Pioggia (mm/giorno) | number `(i)` | — | `idro_sup_pioggia_mm_gg` | numeric(9,0) **nuovo** |
| Data (gg/mm/aaaa) | date `(D)` | — | `idro_sup_data_evento` | date **nuovo** |
| Minimo franco arginale (m) | number `(i)` | — | `idro_sup_franco_arginale` | numeric(8,0) **nuovo** |
| Hazard di pericolosità ottenuto | readonly | — | `idro_sup_hazard` | calcolato |

---

> **Implementazione (2026-06-19).** Eseguita la persistenza reale **completa** dei 30 campi legacy di
> `sprint_t_ric_183` (READ nel dettaglio richiesta + SAVE in patch). DTO `ValutazionePericolositaDto`
> esteso in modo **additivo**: per ogni select aggiunto un campo `...Id` (Integer, id `SPRINT_D_RIC_183`)
> + `...Descrizione` (read-only); aggiunti i campi numerici/data mancanti
> (`volumeFrana`, `superficieConoide`, `portata`, `pioggiaMmHh`, `pioggiaMmGg`, `dataEvento`,
> `francoArginale`) e gli hazard read-only (`hazardFrana/Conoide/Valanga/Idro`). Persistenza via
> `updatePericolosita183` esteso a tutte le colonne. **Lookup** esposti come endpoint dedicati
> (un endpoint per dominio) basati su `findRic183LookupByNomeColonna`. Hazard restano **read-only**
> (motore di calcolo legacy non portato). I campi `string` legacy preesistenti
> (`tipologiaFrana`/`velocitaFrana`/`ricorrenzaValanga`/`tempoRitorno`/`descrizioneEvento`/
> `superficie*`) restano nel contratto per retrocompatibilità del FE attuale; la persistenza
> degli `fk_*` usa i nuovi `...Id`. **Non fatto:** calcolo hazard (motore pericolosità);
> riallineamento UI del componente FE (demandato all'agente FE).

> **Riallineamento FE (2026-06-19).** Componente `valutazione-pericolosita-folder` riorganizzato sulle
> 5 sezioni legacy (Frane, Conoidi, Valanghe, Rete idrografica/Evento di piena). Tutte le select sono
> ora **id-based** (`mat-select` su `...Id`, opzioni `+codice` → `descrizione`) sui 16 lookup
> `getPericolosita*` (caricati in `loadLookups()` con `takeUntilDestroyed`). Aggiunti i campi numerici
> (`type="number"`) e la data evento (input testo `gg/mm/aaaa`); descrizione evento come `textarea`.
> Gli hazard (`hazardFrana/Conoide/Valanga/Idro`) sono mostrati **read-only** solo se valorizzati.
> In `save()` il body invia gli `...Id` e ricalcola i `...Descrizione` via lookup; i campi testo/numerici
> vuoti sono normalizzati a `null`. `[readOnly]` disabilita l'intero form. Solo Angular Material.

## 2. Gap rispetto all'attuale

| # | Gap | Tipo | Stato |
|---|-----|------|-------|
| VP1 | Campi frana mancanti: volume (`mc`), stato attività, distr. attività, pres. interventi, pres. opere negative | BE (DTO + persist) + FE select | done (BE + FE) |
| VP2 | Campi conoide quasi tutti assenti: sup. conoide, asprezza Melton, diametro, pendenza, ricorrenza, pres. interventi, pres. opere negative | BE + FE | done (BE + FE) |
| VP3 | Campi valanga mancanti: volume, pres. interventi | BE + FE | done (BE + FE) |
| VP4 | Campi idro mancanti: portata, pioggia mm/h, pioggia mm/gg, data evento, franco arginale | BE + FE | done (BE + FE) |
| VP5 | Lookup pericolosità su tabella errata: il partial impl risolveva `FK_FRANA_*` su `SPRINT_D_RICHIESTA_GENERICA`; il legacy usa **`SPRINT_D_RIC_183`** | BE (bug fix) | done (BE) |
| VP6 | Select id-based: il legacy invia l'**id** del dominio (`<html:options property="id">`), non la descrizione | BE (campi `...Id`) + FE | done (BE + FE) |
| VP7 | Hazard read-only: 4 campi `*_hazard` calcolati dal motore legacy | BE (round-trip) — calcolo deferred | round-trip done; FE read-only done; calcolo deferred |
| VP8 | Endpoint lookup dedicati per i domini `SPRINT_D_RIC_183` | BE (OpenAPI + LookupManager) + FE | done (BE + FE) |

## 3. Note implementative

- I lookup `FK_FRANA_*`, `FK_CONOIDE_*`, `FK_VALANGA_*`, `FK_IDRO_SUP_TR` vivono in
  **`SPRINT_D_RIC_183`** (per `NOME_COLONNA`), distinta da `SPRINT_D_RICHIESTA_GENERICA`. Riusabili con
  il nuovo `findRic183LookupByNomeColonna` (parità con `findLkRichiesta183ByNomeColonna` legacy).
- Le select inviano l'**id** (`...Id` Integer); il persist scrive direttamente `fk_*` (nessun lookup
  per-descrizione richiesto in scrittura). In lettura si valorizza sia `...Id` che `...Descrizione`
  (join su `SPRINT_D_RIC_183`).
- Formati numerici dal legacy (`validation-richiesta.xml`): superfici/portata = decimale; pioggia e
  franco arginale = intero; data evento = data `gg/mm/aaaa`. Nessun campo `required`.
- Gli `*_hazard` sono calcolati dal motore di pericolosità legacy (non disponibile nel BFF): restano
  read-only e round-trip. Il calcolo è un **gap deferred** (VP7).
- `updatePericolosita183` usa `COALESCE` per gli `fk_*` (NOT NULL su DB) così da non azzerare i domini
  obbligatori quando il FE non invia ancora il valore; i campi numerici/testo/data sono aggiornati
  direttamente (nullable su DB).
</content>
