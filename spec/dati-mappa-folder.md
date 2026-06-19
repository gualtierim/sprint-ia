# Folder "Dati mappa" — allineamento al layout legacy

Mappatura del contenuto della collapse **Dati mappa** (`dati-mappa-folder`) sul JSP legacy
`datiMappa.do` (form `saveDatiMappa`).

Legenda obbligatorietà: `*` = obbligatorio **salvataggio**, `**` = obbligatorio **invio**. Il legacy
non definisce un blocco `validation-richiesta.xml` per `saveDatiMappa` (nessun vincolo di formato/required):
la pagina è essenzialmente cartografica.

Fonte legacy: JSP `sprintj/.../jsp/richiesta/datiMappa.jsp`.
Stato attuale: `sprintwcl/.../folders/dati-mappa-folder/`. Geometria già persistita reale
(`GET/PUT /richieste/{id}/geometria` su `GEO_PT_INTERVENTO` + `SPRINT_R_GEOMETRIA_RICHIESTA`).

---

## 1. Struttura target

Il JSP **non** è un form a campi: è una **mappa OpenLayers** con un punto editabile e una ricerca comune.
I soli dati persistiti sono la **geometria del punto** (X/Y UTM, comune ISTAT) e il flag georiferito.
Gli "indirizzi" (TOPE) e le "aree idrografiche" non compaiono in questo JSP ma sono previsti come
servizio esterno (deferred). La collapse Angular aggiunge un campo libero **note mappa** (non legacy,
già presente nel DTO).

### 1.1 Mappa / geolocalizzazione
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Coordinata X (UTM) | number | — | `pointX` → geometria punto | già persistita (`/geometria`) |
| Coordinata Y (UTM) | number | — | `pointY` → geometria punto | già persistita (`/geometria`) |
| Tipo geometria | readonly | — | `PT`/`LN`/`PG` | default `PT`; già gestito |
| Comune ISTAT | hidden | — | `codiceIstat` / `nomeComune` | gestito lato mappa (cambio comune) |
| Flag georiferito | hidden | — | `flagGeoriferito` | impostato dal client al move del punto |
| Cerca comune | autocomplete | — | LOTO (servizio esterno) | `suggestComuni` (solo `soloConRichieste`) |

### 1.2 Note (estensione collapse, non legacy)
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Note mappa | textarea | — | `noteMappa` (DTO) | campo libero della collapse |

### 1.3 Indirizzi / aree idrografiche (deferred)
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Indirizzo (TOPE) | autocomplete | — | servizio Toponomastica | **deferred** (vedi [integrazione-loto-tope.md](./integrazione-loto-tope.md)) |
| Aree idrografiche | select/identify | — | servizio cartografico esterno | **deferred** |

---

> **Implementazione (2026-06-19).** La geometria del punto era già persistita reale in fase precedente
> (`getGeometria`/`putGeometria` su `GEO_PT_INTERVENTO` + relazione, e `patchDatiMappa` →
> `updateGeometriaPunto`). In questa fase **non** è stata duplicata. I campi non-TOPE realmente
> persistibili del folder coincidono con la geometria già gestita (coord X/Y, tipo geometria) più il
> campo libero `noteMappa` del DTO. Indirizzi TOPE e aree idrografiche restano **deferred** (servizio
> esterno). Nessuna nuova colonna/migration necessaria.

## 2. Gap rispetto all'attuale

| # | Gap | Tipo |
|---|-----|------|
| M1 | Geometria punto (X/Y, tipo, comune, georiferito) | **fatto** (fase precedente, `/geometria` + `patchDatiMappa`) |
| M2 | Note mappa (campo libero collapse) | round-trip via DTO; **non** ha colonna dedicata legacy → non persistito su tabella reale |
| M3 | Cerca comune (autocomplete) | parziale: `suggestComuni` solo `soloConRichieste=true` (LOTO esterno non integrato) |
| M4 | Indirizzo TOPE | **deferred** — servizio esterno Toponomastica |
| M5 | Aree idrografiche | **deferred** — servizio cartografico esterno |

## 3. Note implementative

- La mappa OpenLayers del legacy non ha equivalente di campi-form da persistere oltre alla geometria:
  l'unico stato salvato è il **punto** (X/Y, comune ISTAT, flag georiferito), già coperto.
- `noteMappa` è un'estensione della collapse Angular: **non** esiste una colonna legacy dedicata in
  `datiMappa.do`, quindi resta un campo di round-trip (DTO) senza scrittura su tabella reale. Da
  decidere se introdurre una colonna (richiederebbe migration documentata) o spostare la nota su un
  campo esistente — al momento **non** persistito su DB per evitare colonne inventate.
- TOPE (indirizzi) e aree idrografiche dipendono da servizi esterni CSI (vedi
  [integrazione-loto-tope.md](./integrazione-loto-tope.md)): predisporre i controlli ma senza dati.
- Il cambio comune sulla mappa (spostamento punto su altra provincia/comune) è logica client del JSP
  legacy; lato BFF la geometria viene riscritta con il nuovo comune ISTAT al `PUT /geometria`.
</content>
