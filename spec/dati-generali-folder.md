# Folder "Dati generali" — allineamento al layout legacy

Mappatura del contenuto della collapse **Dati generali** (`dati-generali-folder`) sul JSP legacy
`datiGenerali.do` (form `saveDatiGenerali`). Le sotto-sezioni `<h4>` del legacy diventano i blocchi
interni della collapse (convenzione di progetto). Legenda obbligatorietà: `*` = obbligatorio
**salvataggio**, `**` = obbligatorio **invio**.

Fonte legacy: JSP `sprintj/.../jsp/richiesta/datiGenerali.jsp` (HTML reso fornito dall'utente).
Stato attuale: `sprintwcl/.../folders/dati-generali-folder/`.

---

## 1. Struttura target (5 sezioni)

### 1.1 Dati generali
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| ID richiesta | readonly | — | es. `38/78_28_001_216418` | composito (legge_cat_prog_id) |
| Data inserimento richiesta | date | `*` | `dataInserimento` | gg/mm/aaaa |
| Evento associato | select | `*` | `eventi()` | id evento |
| Data ultima modifica | readonly | — | mod_data | |
| Utente ultima modifica | readonly | — | mod_utente | |
| Stato | **readonly testo** + hidden | `*` | `stato` | nel legacy è testo ("in bozza"), non editabile |

### 1.2 Dati protocollo
| Campo | Tipo | Obbl. | Note |
|-------|------|-------|------|
| Numero protocollo in uscita | text | — | `protocolloUscita` |
| Data protocollo in uscita | date | — | `dataProtocolloUscita` |

> ⚠️ Nel legacy gli altri campi (entrata, ricevimento, pratica W.F.R., lettera finanziamento)
> sono **commentati** → da **non mostrare**. Oggi il folder ne mostra troppi.

### 1.3 Localizzazione danno
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Provincia | readonly | — | da richiesta | es. TORINO |
| Comune | readonly | — | da richiesta | es. SAN CARLO CANAVESE |
| Località | text | `**` | `localita` | |
| Cerca indirizzo | text + bottone | — | TOPE | autocomplete indirizzi (servizio esterno, vedi [integrazione-loto-tope.md](./integrazione-loto-tope.md)) |
| Indirizzo | select | — | `addressTope` | popolato da TOPE |
| Indirizzo (se non in elenco) + civico | text + text | — | `altroIndirizzo`, `civico` | |
| Tipo Strada | **select** | — | lookup `FK_TIPO_STRADA` | oggi è input |
| Denominazione Strada / Chilometrica | text | — | `denominazioneStrada` | |
| Corso d'acqua | text | — | `corsoAcqua` | |

> ⚠️ Rimuovere da questa sezione **Fascia PAI** e **Dissesto PAI** (non presenti nel legacy qui).

### 1.4 Dissesto
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Dissesto ascrivibile a tipologie PAI | select No/Sì | `*` | `flgDissestoSensoPai` | 1=No, 2=Sì; onchange ricarica sezione |
| Tipo dissesto | **select** | `*` | lookup `FK_TIPO_DISSESTO` | oggi è input |
| Relazione tecnica | select | `*` | lookup `FLG_RILIEVO` | **nuovo** (1=effettuato, 2=da effettuare) |
| Dissesto presente su PAI/PRGC | select | `*` | lookup `FK_DISSESTO_PAI_PRGC` | **nuovo** |
| Descrizione del dissesto | textarea | `**` | `descrizioneDissesto` | |

### 1.5 Categoria e sottocategoria di danno
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Categoria | **select** | `*` | macro-categorie (`idMacroCategoria`) | onchange ricarica sottocategoria |
| Sottocategoria | **select** | `*` | sotto-categorie per macro (`idCategoria`) | dipende dalla macro |
| Codice | readonly | — | `codice` | es. "28 - opere idrauliche" |
| Oggetto dell'eventuale finanziamento | textarea | `*` | `descrizioneDanno` | **spostare qui** (oggi in 1.1) |
| Note | textarea | — | `note` | **spostare qui** (oggi in 1.1) |
| Sopralluogo + data | checkbox + date | `**` | `flgSopralluogo`, `dataSopralluogo` | **nuovo** |

---

> **Implementazione (2026-06-19).** Eseguito scope **D1–D8** (escluso TOPE/D9). Build BE+FE OK.
> Nuovi endpoint lookup (un endpoint per dominio): `/tipi-dissesto`, `/relazioni-tecniche`,
> `/dissesti-pai-prgc`, `/richieste/macro-categorie`, `/richieste/categorie/{idMacro}/sottocategorie`.
> Folder ristrutturato sulle 5 sezioni legacy: select con lookup, categorie gerarchiche
> (macro→sotto con reload client), Stato/Codice readonly, protocollo ridotto a uscita, Sopralluogo,
> nuovi campi DTO (`relazioneTecnica`, `dissestoPaiPrgc`, `flgSopralluogo`, `dataSopralluogo`),
> marcatori `*`/`**`. **Non fatto:** Provincia / Data-Utente ultima modifica readonly (campi non
> presenti nei DTO/response: richiedono aggiunta lato BE); TOPE (D9, servizio esterno); persistenza
> DB dei 4 nuovi campi (oggi round-trip via patch, mapping DB da completare).

## 2. Gap rispetto all'attuale

| # | Gap | Tipo |
|---|-----|------|
| D1 | Tipo Strada, Tipo dissesto → **select** con lookup | FE + (lookup BE esistente `findLookupByNomeColonna`) |
| D2 | Nuovi lookup **Relazione tecnica** (`FLG_RILIEVO`), **Dissesto PAI/PRGC** (`FK_DISSESTO_PAI_PRGC`), **Tipo dissesto** (`FK_TIPO_DISSESTO`) | BE: endpoint/i lookup + FE select |
| D3 | Categoria/Sottocategoria → select gerarchici (macro → figlie) con reload | BE: categorie per macro; FE |
| D4 | Campi readonly: ID richiesta composito, data/utente ultima modifica, Provincia, Comune, Codice | FE (+ dati da response) |
| D5 | Sezione protocollo ridotta a **uscita** (numero + data) | FE (rimozione campi) |
| D6 | Spostare Oggetto finanziamento + Note in sez. Categoria; rimuovere Fascia/Dissesto PAI da Localizzazione | FE |
| D7 | Sopralluogo (checkbox + data) | FE (+ campi DTO) |
| D8 | Marcatori `*` / `**` sui label secondo obbligatorietà | FE (da metadati, vedi [validazione-richieste.md](./validazione-richieste.md)) |
| D9 | Cerca indirizzo / Indirizzo TOPE | dipende da [integrazione-loto-tope.md](./integrazione-loto-tope.md) (servizio esterno) |

## 3. Note implementative

- I lookup `FK_TIPO_STRADA`, `FK_TIPO_DISSESTO`, `FLG_RILIEVO`, `FK_DISSESTO_PAI_PRGC` vivono già in
  `SPRINT_D_RICHIESTA_GENERICA` (per `NOME_COLONNA`): riusabili con `findLookupByNomeColonna`
  (già implementato). Servono i rispettivi endpoint OpenAPI o un endpoint lookup generico.
- Le select **dipendenti** (sottocategoria da macro; ricalcoli su `flgDissestoSensoPai`) nel legacy
  ricaricano la pagina (`reloadDatiGenerali.do`); in Angular si gestiscono lato client reagendo al
  `valueChanges` della select padre.
- Obbligatorietà (`*`/`**`) guidata dai metadati `/richieste/metadati/{idLegge}`
  (`obbligatorioSalvataggio` / `obbligatorioInvio`).
- I campi TOPE (Cerca indirizzo / Indirizzo) restano non funzionanti finché il servizio esterno non
  è integrato: predisporre i controlli ma senza dati.
</content>
