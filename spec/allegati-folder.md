# Folder "Allegati" — allineamento al layout legacy

Mappatura del contenuto della collapse **Allegati** (`allegati-folder`) sui JSP legacy
`allegatiRichiesta.do` (archivio + form di upload inline) e `saveFileRichiesta.do`
(form di inserimento allegato a pagina intera). Il folder gestisce **una lista di file**
(tabella allegati) + un **form di upload** (file + descrizione). Legenda obbligatorietà:
`*` = obbligatorio **salvataggio**, `**` = obbligatorio **invio**.

Fonte legacy: JSP `sprintj/.../jsp/richiesta/allegatiRichiesta.jsp` e
`allegaFileRichiesta.jsp` (form `saveFileRichiesta`, `enctype="multipart/form-data"`).
Stato attuale: `sprintwcl/.../folders/allegati-folder/` — oggi **placeholder** con due sole
textarea (`noteAllegati`, `elencoAllegati`) e nessuna tabella né upload reale.

---

## 1. Struttura target (2 blocchi)

Le due viste legacy (archivio + inserimento) collassano in un unico folder con due blocchi:
**Lista allegati** (tabella read/azioni) e **Upload allegato** (form, visibile solo in modifica).

### 1.1 Lista allegati

Tabella `display:table` su `form.archivioAllegati` (sorgente DB:
`SPRINT_R_RICGEN_ALLEGATO` ⋈ `SPRINT_T_ALLEGATO_RIC`, ordinata per data inserimento desc).

| Campo (colonna) | Tipo | Obbl. | Sorgente | Note |
|-----------------|------|-------|----------|------|
| Descrizione | readonly | — | `descrizione` (`SPRINT_T_ALLEGATO_RIC.descrizione`) | varchar(2000) |
| Nome file | readonly | — | `nomeFile` (`nome_file`) | varchar(100) |
| Data inserimento | readonly | — | `dataInserimento` (`data_inserimento`) | formato `dd/MM/yyyy` |
| Download | bottone-immagine | — | `visualizzaAllegatoRichiesta.do?index=rowNum` | scarica il blob `allegato_ric` (bytea) |
| Elimina | bottone-immagine | — | `eliminaAllegatoRichiesta.do?index=rowNum` | **solo se `MODIFICA_RICHIESTA = true`** |

> ⚠️ Nel legacy l'azione **Elimina** è condizionata a `MODIFICA_RICHIESTA = true`
> (in sola lettura compare solo il Download). In Angular corrisponde a `readOnly()`.
>
> ⚠️ Le colonne **tipo allegato** e **dimensione** **non esistono** nel legacy né nella
> tabella DB: il DTO `AllegatoItem` espone `tipoAllegato`/`dimensione`, ma `tipoAllegato`
> è oggi mappato dal mapper sulla colonna `descrizione` e `dimensione` resta null (vedi §3).

### 1.2 Upload allegato

Form `saveFileRichiesta` (`multipart/form-data`), nel legacy mostrato **inline** sotto
l'archivio (solo in `MODIFICA_RICHIESTA = true`) e anche come pagina dedicata
`allegaFileRichiesta.jsp`. Campi:

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Allegato a | readonly | — | `richiesta.codRichiesta` | solo nella pagina dedicata; codice richiesta |
| Descrizione | textarea (3 righe) | `*` † | `allegato.descrizione` | required **commentato** nel legacy (vedi legenda) |
| Allegato (file) | file `<html:file>` | `*` † | `uploadFile` | required **commentato** nel legacy |

Azioni del form: **allega** / **conferma e prosegui** (submit upload), **annulla** (reset),
**indietro** (torna a `oldPathAction`).

> **† Obbligatorietà — required COMMENTATI nel legacy.** In `validation-richiesta.xml` le
> regole `required` per `uploadFile` e `allegato.descrizione` (form `/saveFileRichiesta`)
> esistono ma sono **dentro un blocco commentato** (`<!-- ... -->`), così come le regole
> `index required` di `/eliminaAllegatoRichiesta` e `/visualizzaAllegatoRichiesta`.
> Di fatto a runtime **nessun campo è validato come obbligatorio**. La nota JSP
> "I campi contrassegnati con l'asterisco sono obbligatori" è quindi orfana.
> → In fase di analisi si **propone** di ripristinare `*` su file + descrizione
> (intento originario), segnalando che nel legacy attivo non lo sono.

---

## 2. Gap rispetto all'attuale

L'attuale `allegati-folder` Angular **non implementa** né la lista né l'upload: ha solo
due textarea libere (`noteAllegati`, `elencoAllegati`) salvate via `PATCH /allegati`.
Gli endpoint REST esistono ma la lista/upload non sono cablati nel componente.

| # | Gap | Tipo | Stato FE |
|---|-----|------|----------|
| A1 | Componente è un placeholder (2 textarea): manca del tutto la **tabella allegati** | FE | Fatto — `mat-table` su `data.items` (textarea rimosse) |
| A2 | Manca il **form di upload** (file + descrizione) e il binding multipart | FE | Fatto FE — `input[type=file]` + descrizione/tipo → `uploadRichiestaAllegato` (octet-stream); persistenza deferred (501, vedi A6/A7) |
| A3 | Tabella: colonne **Descrizione, Nome file, Data inserimento** + azioni **Download/Elimina** | FE (consumo `GET /allegati`) | Fatto — colonne configurabili (popup + sessionStorage, `tableId=allegati`). Nota: "Data inserimento" bindata su `AllegatoItem.dataCaricamento` (il DTO generato non espone `dataInserimento`) |
| A4 | Azione **Elimina** condizionata a `readOnly()` (legacy `MODIFICA_RICHIESTA`) | FE | Fatto — Elimina e form upload nascosti se `readOnly()` |
| A5 | **Download** del file (blob `allegato_ric`): manca endpoint binario reale | BE | **FATTO BE** — `GET /allegati/{idAllegato}/contenuto` legge il blob da `SPRINT_T_ALLEGATO_RIC` (`AllegatoMapper.findContenuto`) e lo restituisce `application/octet-stream` con `Content-Disposition`. UI pronta (object URL/anchor/revoke) |
| A6 | **Upload reale del file**: scrittura blob | BE | **FATTO BE** — `POST /allegati/upload` (octet-stream + query param `nomeFile`/`descrizione`/`tipo`) inserisce metadati+blob su `SPRINT_T_ALLEGATO_RIC` (PK da `SEQ_SPRINT_T_ALLEGATO_TIC`) e la relazione su `SPRINT_R_RICGEN_ALLEGATO`. Nessuna simulazione |
| A7 | **Persistenza**: `DELETE`/`GET by id` ora scrivono/leggono su `SPRINT_T_ALLEGATO_RIC` / `SPRINT_R_RICGEN_ALLEGATO` | BE | **FATTO BE** — `getAllegatoById`/`deleteAllegato`/lista folder tutti su DB reale (`AllegatoMapper`). `POST` JSON metadati-only → **501** (blob NOT NULL, usare upload). Map `allegatiPerRichiesta` **rimossa** |
| A8 | `AllegatiDto` espone `elencoAllegati`/`noteAllegati`: **sostituire** con `items[]` come unica fonte | BE + FE | Fatto FE — il componente consuma solo `items[]`; le textarea `noteAllegati`/`elencoAllegati` non sono più cablate |
| A9 | `AllegatoItem` manca **`descrizione`**; `tipoAllegato` mappato impropriamente; `dimensione` mai valorizzata | BE (mapper/DTO) | **FATTO BE** — `descrizione` mappata; `tipoAllegato` ← `estensione`; `dimensione` = `octet_length(allegato_ric)` (byte) calcolata in SQL |
| A10 | `*` su file + descrizione secondo intento legacy (required oggi **commentati**) | FE + BE | Fatto FE (proposta) — `descrizione` con `Validators.required` e file obbligatorio lato form. **Fatto BE (2026-06-19)** — `uploadAllegato` ora valida file **e** descrizione: mancanti → `ValidazioneException` (400). Ripristina l'intento del legacy (`/saveFileRichiesta`, required commentati). Resta da confermare col committente |
| A11 | Nota informativa "caricare file troppo grandi può richiedere tempo" da riportare | FE | Fatto — nota sopra il form di upload |

---

## 3. Note implementative

- **Modello dati DB.** Il file binario è in `SPRINT_T_ALLEGATO_RIC.allegato_ric` (bytea,
  NOT NULL); metadati: `nome_file` (varchar 100, NOT NULL), `descrizione` (varchar 2000,
  nullable), `data_inserimento` (date, NOT NULL), `estensione` (varchar 50, NOT NULL).
  L'associazione alla richiesta è in `SPRINT_R_RICGEN_ALLEGATO`
  (`id_richiesta_generica`, `id_allegato_ric`, `data_inserimento`). La sequence è
  `seq_sprint_t_allegato_tic`. **Non esiste una lookup "tipo allegato"** nel legacy/DB:
  il campo `tipoAllegato` del DTO non ha sorgente reale → o si rimuove dalla UI o si
  introduce ex-novo un dominio (decisione aperta, vedi assunzioni).

- **Endpoint backend già definiti** (OpenAPI + controller + service Angular generati):
  - `GET  /richieste/{idRichiesta}/allegati` → `AllegatiDto` (lista da DB via
    `findAllegatiByRichiestaId`, ma appiattita in `elencoAllegati`).
  - `POST /richieste/{idRichiesta}/allegati` (JSON `CreaAllegatoRequest`) → **501**:
    `allegato_ric` è NOT NULL, non si può creare un allegato senza file. Usare l'upload.
  - `POST /richieste/{idRichiesta}/allegati/upload` → insert reale metadati+blob su
    `SPRINT_T_ALLEGATO_RIC` (PK `SEQ_SPRINT_T_ALLEGATO_TIC`) + relazione
    `SPRINT_R_RICGEN_ALLEGATO`. Restituisce `AllegatoItem`.
  - `GET  /richieste/{idRichiesta}/allegati/{idAllegato}` → `AllegatoItem` (metadati da DB
    via `AllegatoMapper.findAllegatoMeta`).
  - `GET  /richieste/{idRichiesta}/allegati/{idAllegato}/contenuto` → stream binario del
    blob (`AllegatoMapper.findContenuto`), `application/octet-stream`.
  - `DELETE /richieste/{idRichiesta}/allegati/{idAllegato}` → `GenericResponse`; elimina
    relazione (`SPRINT_R_RICGEN_ALLEGATO`) e record (`SPRINT_T_ALLEGATO_RIC`).
  - `PATCH /richieste/{idRichiesta}/allegati` → salva `noteAllegati`/`elencoAllegati`
    (l'unico usato oggi dal FE).

- **Endpoint/funzioni mancanti (BE):**
  1. Upload **multipart** reale (`POST` con `multipart/form-data`) che persista blob +
     metadati e crei la relazione richiesta↔allegato.
  2. **Download** binario (`GET .../allegati/{idAllegato}` con
     `application/octet-stream` / `Content-Disposition`) — oggi ritorna JSON metadati.
  3. Persistenza DB di `POST`/`DELETE` (sostituire le mappe in-memory di
     `RichiesteManager`).

- **Allineamento Angular ↔ legacy.** L'attuale FE **diverge** dal legacy: i concetti
  `noteAllegati`/`elencoAllegati` (textarea) non esistono nel JSP, che ha invece una
  tabella di file e un form di upload. Da rifare il componente per consumare gli endpoint
  `Allegati` (service `allegati` già generato in `sprintwcl/.../api/services/`,
  attualmente **non importato** dal componente, che usa solo `patchRichiestaAllegati`).

- **Obbligatorietà.** Coerentemente con [validazione-richieste.md](./validazione-richieste.md),
  i `*`/`**` vanno guidati da metadati; qui però il legacy attivo non valida nulla
  (required commentati): la proposta di marcare `*` file+descrizione è una scelta di
  analisi da confermare con il committente.

---

### Assunzioni / incertezze

- Il prompt cita un "tipo allegato da lookup": **non trovato** nel JSP né nello schema DB.
  Assunto come campo **non presente nel legacy**; `tipoAllegato` nel DTO è privo di
  sorgente reale. Da chiarire se introdurlo.
- `estensione` (DB) non è esposta in `AllegatoItem`; verosimilmente derivabile dal
  `nome_file`. Da decidere se mapparla esplicitamente.
- `dimensione` non è memorizzata in DB: andrebbe calcolata in upload (lunghezza blob)
  e persistita, oppure rimossa dalla UI.
</content>
</invoke>
