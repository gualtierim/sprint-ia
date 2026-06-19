# Esportazione risultati ricerca richieste — analisi legacy e proposta

Analisi della funzione di **esportazione dei risultati di ricerca** delle richieste di
finanziamento. Mappa il comportamento del legacy JSP/Struts (pulsante «scarica in excel») sul nuovo
stack (`sprintbff` + `sprintwcl`) e propone come realizzarla in modalità contract-first.

Fonte legacy: pulsante in `sprintj/.../jsp/ricerca/include/pulsantiRicerca.jsp:81-89`
(`scaricaExcel.do`); action `RicercaAction.scaricaExcel`
(`sprintj/.../presentation/ricerca/action/controller/RicercaAction.java:995-1060`, mapping
`WEB-INF/struts-config-ricerca.xml:326-337`); generazione file con **JExcelApi (jxl)**
(`sprintj/.../util/jxl/FileExcel.java`, `WriteFile.java`, `HorizontalHeader.java`); header HTTP in
`FwkAction.sendExcel` (`.../presentation/action/controller/FwkAction.java:458-477`); dati da
`RicercaDAOImpl.avviaRicercaExcel` (`.../integration/dao/ricerca/impl/RicercaDAOImpl.java:1323-1404`).

> **Nota sul formato.** Il legacy **non** produce un CSV: genera un **`.xls` binario reale** (jxl)
> con MIME `application/vnd.ms-excel`. La richiesta dell'utente è un'esportazione **CSV**, quindi
> questa spec propone CSV "vero" (più semplice, nessuna dipendenza pesante tipo Apache POI) come
> output del nuovo stack, riusando le **stesse colonne profilo-dipendenti** e gli **stessi filtri**
> della ricerca. Resta documentato il comportamento `.xls` legacy per parità funzionale (contenuto).

Stato attuale (prima di questo intervento): **nessuna esportazione** (CSV/Excel) presente né in
`sprintbff` né in `sprintwcl`.

> **Implementazione (2026-06-19).** Realizzata end-to-end l'esportazione **CSV** (C1–C6). **BE:**
> contratto `POST /richieste/cerca/export` (`operationId: esportaRichiesteCsv`, body
> `CercaRichiesteRequest`, risposta binaria `text/csv` — primo CSV nel contratto), implementato in
> `RichiesteApiImpl` (`Response` con `Content-Disposition: attachment`); `RicercaManager.esportaRichiesteCsv`
> riusa le colonne profilo (`getColonneRisultatoRichieste`) e la query di ricerca `searchRichieste`
> senza paginazione (offset 0, cap `MAX_RIGHE_EXPORT = 50.000`, warning se troncato); nuovo
> `RichiesteCsvWriter` (separatore `;`, UTF-8 + BOM, quoting RFC 4180, importi `C` decimale italiano,
> date `D` `dd/MM/yyyy`, valori via getter Lombok su `RicercaRichiestaRow`) + record `ExportCsv`.
> **FE:** `RichiesteService` rigenerato (`responseType: 'blob'`, `accept: 'text/csv'`); pulsante
> **«Esporta CSV»** nella toolbar dei risultati (abilitato con `totaleRisultati() > 0`), invio dei
> filtri correnti (estratti in `filtriCorrenti()`, riusati anche da `eseguiRicerca`) e download blob
> (riuso `scaricaBlob`, filename da `Content-Disposition`, fallback `richieste.csv`). Build BE
> (`mvn compile`) + FE (`ng build`) OK. **Non fatto:** colonna allegati legacy (id 666, `HYPERLINK`)
> non replicata (vedi §5).

---

## 1. Esportazione legacy

Il pulsante «scarica in excel» è nella toolbar dei risultati di ricerca (`pulsantiRicerca.jsp`,
incluso da `risultatoRicerca.jsp`). Trigger: `doChangeAction('form', 'scaricaExcel.do', false)` — il
terzo parametro `false` indica che l'export **ignora le checkbox di selezione** e usa l'intera
ricerca.

| Aspetto | Comportamento legacy |
|---------|----------------------|
| Formato | `.xls` binario (JExcelApi/jxl), MIME `application/vnd.ms-excel` |
| Nome file | fisso `risultato_ricerca.xls` (`RicercaAction.java:1047`) |
| Header HTTP | `Content-Disposition: attachment; filename=risultato_ricerca.xls`, `Pragma: public`, `Cache-control: must-revalidate`, `Content-Length` |
| Righe esportate | **intero result set** dei filtri (query `queryExcel` **senza** wrapping `ROWNUM`), **non** la sola pagina visualizzata |
| Colonne | le stesse della tabella a video: metadate `SPRINT_MTD_CAMPO_RIS_RICERCA` per **profilo+oggetto** (`RicercaDAOImpl.findCampoMtdRisRicercaByProfiloAndOggetto`), ordinate per `ORDINE` |
| Colonne escluse | quelle con `FLG_PK = true` (chiavi tecniche) |
| Header colonne | descrizione in **MAIUSCOLO** in riga 0; dati da riga 1 |
| Date | celle data Excel formato `dd/MM/yyyy` (`decorator = D`) |
| Importi | celle **numeriche** double (`decorator = C`, `NumberFormats.FORMAT3`) |
| Allegati | colonna speciale `idCampoRisRicerca == 666`: celle `HYPERLINK(...)` verso `AllegatoController.img?idAllegato=...` |
| Limite righe | **nessun cap esplicito**; limite implicito del formato BIFF8 jxl (~65.536 righe) |
| Caso vuoto | `ApplicationException` "Attenzione! Non è possibile produrre il file: non sono presenti i dati." |

Flusso: `RicercaAction.scaricaExcel` → `RicercaBusinessDelegate.avviaRicercaExcel` → EJB
`RicercaBean.avviaRicercaExcel` → `RicercaDAOImpl.avviaRicercaExcel` (esegue `queryExcel` e itera
**tutte** le righe). La `queryExcel` è SQL Oracle costruita per concatenazione di stringhe da
metadata (alias/tabella/campo) — da tradurre in PostgreSQL nel nuovo stack.

---

## 2. Stato attuale (nuovo stack)

- **sprintbff**: nessun endpoint di export. La ricerca è `POST /richieste/cerca`
  (`cercaRichieste`, `RicercaManager.cercaRichieste`) con paginazione `page`/`pageSize` su vista
  `sprint.vsde_ric_38_strao_pt_tutte` (`RicercaMapper.searchRichieste` / `countRichieste`,
  `OFFSET`/`LIMIT`). Le colonne risultato per profilo arrivano da `GET /richieste/colonne-risultato`
  (`getRichiesteColonneRisultato`, schema `ColonnaRichiestaRisultato { field, label, decorator, ordine }`).
  Esiste già il pattern di **risposta binaria** per le stampe PDF (`getRichiestaStampa` →
  `Response.ok(byte[]).type("application/pdf").header("Content-Disposition", ...)` in
  `RichiesteApiImpl.java:392-403`).
- **sprintwcl**: nessun pulsante «Esporta» nella pagina ricerca
  (`src/app/pages/ricerca/ricerca-richieste/`). Esiste già il pattern di **download blob**:
  `scaricaBlob(blob, nomeFile)` (`ricerca-richieste.component.ts:511-518`) usato per la stampa
  massiva PDF, e le `fn`/service generate con `responseType: 'blob'` (`StampeService`).

In sintesi: l'export dei risultati è **interamente da realizzare**, ma riusa infrastruttura già
presente (colonne per profilo, filtri ricerca, pattern risposta binaria + download blob).

---

## 3. Proposta (contract-first, CSV)

Endpoint **orientato alla risorsa di dominio**, coerente con le spec esistenti, che riusa i **filtri
della ricerca** e le **colonne per profilo**.

### 3.1 Endpoint OpenAPI

```yaml
/richieste/cerca/export:
  post:
    tags: [Richieste]
    summary: Esporta in CSV i risultati della ricerca richieste
    description: >-
      Esporta in CSV l'intero result set dei filtri di ricerca (non la sola
      pagina). Le colonne sono quelle del profilo utente (come la tabella a
      video). I campi page/pageSize del body sono ignorati.
    operationId: esportaRichiesteCsv
    requestBody:
      required: true
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/CercaRichiesteRequest'   # riuso filtri ricerca
    responses:
      '200':
        description: File CSV dei risultati
        content:
          text/csv:
            schema:
              type: string
              format: binary
      '400': { $ref: '#/components/responses/InvalidParameter' }
      '403': { $ref: '#/components/responses/Forbidden' }
      default: { description: errore generico, content: { application/json: { schema: { $ref: '#/components/schemas/Errore' } } } }
    security:
      - basicAuth: []
```

Note:

- Riuso di `CercaRichiesteRequest` (stessi filtri di `cercaRichieste`); `page`/`pageSize` ignorati.
- Implementato in `RichiesteApiImpl` (il codegen raggruppa per primo segmento di path `/richieste`,
  come per la stampa massiva).
- `text/csv` è il **primo** content-type CSV nel contratto; lato FE sarà la prima `fn` con
  `responseType: 'blob'` + `accept: 'text/csv'`.

### 3.2 Backend (sprintbff)

- **`RicercaManager.esportaRichiesteCsv(request, httpRequest)`** → record `ExportCsv(nomeFile, byte[] contenuto)`:
  1. colonne = `getColonneRisultatoRichieste(httpRequest)` (riuso, profilo-dipendente, già esclude
     `FLG_PK` e decorator `X`);
  2. righe = nuova query **senza paginazione** ma con **cap di sicurezza** (vedi sotto), riusando
     i filtri `richiesteWhere` esistenti;
  3. serializzazione CSV in memoria (no dipendenze esterne).
- **Nuovo mapper**: `RicercaMapper.exportRichieste(criteria)` + `<select id="exportRichieste">` in
  `RicercaMapper.xml` che riusa `<include refid="richiesteWhere"/>` e `ORDER BY id_richiesta_generica DESC`,
  con `LIMIT #{maxRighe}` (cap). Le righe sono `RicercaRichiestaRow` (riuso del mapping ricerca).
- **CSV** (convenzioni pensate per Excel italiano):
  - separatore `;`, encoding **UTF-8 con BOM** (così Excel riconosce gli accenti);
  - quoting RFC 4180 (campo racchiuso in `"` se contiene `;`, `"`, newline; `"` raddoppiate);
  - terminatore riga `\r\n`;
  - header = `label` delle colonne (ordine = `ordine`);
  - formattazione per `decorator`: `C` → importo decimale italiano (virgola, 2 decimali);
    `D` → data `dd/MM/yyyy`; `S`/`L`/`TC`/`TP` e default → stringa.
  - i valori provengono dai campi di `CercaRichiestaItemRisultato`/`RicercaRichiestaRow` mappati per
    `field`; le colonne profilo non mappabili sulla vista quick-search sono già escluse a monte.
- **Cap righe**: introdurre un limite esplicito (es. `50.000`) — il legacy non lo ha ma rischia OOM
  su result set ampi. Se il cap viene raggiunto, loggare il troncamento.
- **Risposta**: `RichiesteApiImpl.esportaRichiesteCsv` →
  `Response.ok(contenuto).type("text/csv; charset=UTF-8").header("Content-Disposition", "attachment; filename=\"" + nomeFile + "\"")`.
  Nome file: `richieste.csv` (valutare suffisso data).

### 3.3 Frontend (sprintwcl)

- Pulsante **«Esporta CSV»** (icona `download` o `file_download`) nella toolbar tabella della pagina
  ricerca, **vicino a «Colonne»**, abilitato solo dopo una ricerca con risultati (`totaleRisultati() > 0`).
- Al click: chiamare `RichiesteService.esportaRichiesteCsv$Response({ body: <stessi filtri correnti> })`
  con `takeUntilDestroyed`, poi `scaricaBlob(blob, nomeFile)` (riuso esistente, filename da
  `Content-Disposition`, fallback `richieste.csv`).
- I filtri inviati sono **quelli correnti del form** (gli stessi di `eseguiRicerca`), **senza**
  `page`/`pageSize` significativi (export = tutto).
- Spinner globale (`loadingInterceptor`) già copre la chiamata; nessun overlay locale.

---

## 4. Gap rispetto all'attuale

| # | Gap | Tipo |
|---|-----|------|
| C1 | Endpoint OpenAPI `POST /richieste/cerca/export` con risposta `text/csv` (primo CSV nel contratto) | BE (OpenAPI + controller) |
| C2 | Query export **senza paginazione** + cap righe (`RicercaMapper.exportRichieste`, riuso `richiesteWhere`) | BE (MyBatis) |
| C3 | Serializzazione CSV (separatore `;`, UTF-8+BOM, quoting RFC 4180, decorator C/D/S) in `RicercaManager` | BE |
| C4 | `RichiesteApiImpl.esportaRichiesteCsv` → `Response` `text/csv` + `Content-Disposition` | BE |
| C5 | Pulsante «Esporta CSV» nella toolbar ricerca + download blob (riuso `scaricaBlob`) | FE |
| C6 | `fn`/service con `responseType: 'blob'` + `accept: 'text/csv'` (primo CSV nel FE) | FE |

---

## 5. Note implementative e assunzioni

- **Colonne = profilo utente**: l'export riusa esattamente `getColonneRisultatoRichieste`, quindi il
  CSV contiene le stesse colonne (e ordine) della tabella a video del profilo. Parità con il legacy,
  che usa le stesse metadate `SPRINT_MTD_CAMPO_RIS_RICERCA` sia per la griglia sia per l'export.
- **Allegati (id 666)**: la colonna allegati con `HYPERLINK` del legacy **non** è replicata in questa
  fase (la vista quick-search del nuovo stack non espone gli allegati nella riga risultato). Da
  valutare in seguito se richiesto.
- **CSV vs Excel**: scelta **CSV** su richiesta esplicita dell'utente. Se in futuro serve un `.xlsx`
  fedele al legacy (celle tipizzate, hyperlink), valutare Apache POI come dipendenza dedicata.
- **Selezione righe**: come nel legacy (`false`), l'export ignora le checkbox di selezione e usa
  tutti i risultati dei filtri.
- **Niente mock**: la query export riusa la stessa vista/where della ricerca reale; nessun dato
  fittizio.
