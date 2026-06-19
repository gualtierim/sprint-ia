# Funzione di Stampa — analisi legacy e proposta

Analisi della funzione di **Stampa** delle richieste di finanziamento. Mappa il comportamento del
legacy JSP/Struts sulla situazione del nuovo stack (`sprintbff` + `sprintwcl`) e propone come
realizzarla in modalità contract-first. **Questo è un documento di analisi/proposta**: nulla di
quanto descritto nella sezione "Proposta" è ancora implementato.

Fonte legacy: pulsanti in `sprintj/.../jsp/richiesta/include/pulsantiStampe.jsp`; action
`sprintj/.../presentation/stampe/action/controller/StampeAction.java` (mapping
`WEB-INF/struts-config-stampe.xml`); logica BE in
`sprintj/.../business/session/stampa/StampaBean.java` (delegate `StampaBusinessDelegate`); motore di
generazione `sprintj/.../util/stylereport/GeneraStampa.java` + template InetSoft `.srt`.
Stato attuale: nessuna funzione di stampa/export/PDF presente né in `sprintbff` né in `sprintwcl`.

> **Implementazione (2026-06-19) — slice verticale.** Realizzata la stampa **singola** end-to-end
> con approccio (A). **Fatto:** contratto OpenAPI `GET /richieste/{idRichiesta}/stampe` (stampe
> disponibili, schema `StampaDisponibileItem`) e `GET /richieste/{idRichiesta}/stampe/{tipoStampa}`
> con risposta binaria `application/pdf` (S1, S6 — primo binario nel contratto); BE: `StampaManager`
> (abilitazione da stato/legge riusando `RichiesteManager.getRichiesta`, nessun dato fittizio),
> `StampaPdfGenerator` con **OpenPDF** (dipendenza Maven `com.github.librepdf:openpdf`, S2 — scelta
> da validare col team), metodi in `RichiesteApiImpl` (`Response` PDF con `Content-Disposition`,
> `403` via `UtenteNonAbilitatoException`, `400` via `ValidazioneException`, `404`); FE: `StampeService`
> rigenerato, pulsante/menu **Stampa** in `richiesta-detail` con download blob (object URL + anchor,
> `responseType: 'blob'` — primo caso nel FE, S7/S8). Build BE (`mvn compile`) + FE (`ng build`) OK.

> **Aggiornamento (2026-06-19) — stampa completa (non più "lite").** Riprodotti fedelmente i layout
> legacy e introdotte le query dedicate. **Fatto:** **S3** — `StampaPdfGenerator` riscritto con i
> testi letterali dei template `.srt` (`GeneraStampa.setLettera*`): la lettera di trasmissione si
> differenzia per legge (L.38 → `lettera38`, L.54/L.183 → `letteraDS`, straordinaria →
> `letteraStraordinaria`), più `letteraMancanzProgPreliminare` e `letteraIntegrazDocumentazione`
> (oggetto, corpo, elenco documentazione, chiusura, firma, blocco sede/recapiti). **S4** — nuovo
> mapper MyBatis `StampaMapper.findInfoLetteraStampa` (file XML dedicato) su `sprint_t_ric_generica`
> con join `sprint_t_ric_38_calamita` (importi/ordinanza), `sprint_t_appg_settori` (settore
> firmatario via `cod_infopersona`: denominazione/indirizzo/Tel./Fax./E-mail) e `sprint_t_evento`
> (cod evento + `rif_legge_apertura` per la straordinaria); VO `StampaLetteraRow`. **S5 (parziale)**
> — visibilità riscritta su **codice legge** reale (da `sprint_mtd_legge` via `LookupManager`, stabile
> tra ambienti) + stato; sostituita l'euristica `nomeLegge.contains("54")`. Build BE (`mvn compile`) OK.
> **Non fatto / da rifinire:** **classificazione lettera** (`FK_CLASSIFICAZIONE_LETTERA`) — assente
> nello schema nuovo, cella "Classificazione:" lasciata vuota per L.38/straordinaria; **ente
> richiedente** reso come "Comune di <descrizione_comune>" (manca toponomastica completa / tipo ente
> aggregazione); parte **ruolo/provincia/aggregazione** delle regole di visibilità (S5) non
> replicabile (ruolo = stringa libera, provincia utente = mock) → TODO.

> **Aggiornamento (2026-06-19) — stampa massiva (S9, BE).** Aggiunto endpoint
> `POST /richieste/stampe/lettera-trasmissione` (`operationId: stampaLetteraTrasmissioneMassiva`,
> schema request `StampaMassivaRequest { idRichieste: number[] }`, risposta binaria
> `application/pdf`, tag `Stampe`; implementato in `RichiesteApiImpl` perché il codegen raggruppa per
> primo segmento di path `/richieste`). BE: `StampaManager.getStampaMassiva(List<Integer>)` filtra le
> richieste ammesse alla lettera di trasmissione (riuso `isLetteraTrasmissioneAmmessa`), salta le
> inesistenti/non ammesse, e con nessuna ammessa lancia `ValidazioneException` (→ 400);
> `StampaPdfGenerator.generaLettereTrasmissione(List<StampaLetteraTrasmissione>)` produce un unico PDF
> con tabella riepilogo (`elencoRichieste.srt`: Codice richiesta / Comune / Oggetto / Importo) seguita
> da una lettera di trasmissione per richiesta (una per pagina, stesso layout per legge della stampa
> singola). Nuovo record `StampaLetteraTrasmissione` (detail + dati lettera + codice legge). FE:
> `StampeService` + `fn` rigenerati (`responseType: 'blob'`, `accept: 'application/pdf'`); il pulsante
> nei risultati di ricerca è a carico dell'agente FE. Build BE (`mvn compile`) + FE (`ng build`) OK.

> **Aggiornamento (2026-06-19) — stampa massiva (S9, FE done).** Implementato il pulsante **Stampa
> lettera di trasmissione** nei risultati della pagina ricerca richieste
> (`sprintwcl/src/app/pages/ricerca/ricerca-richieste/`): selezione multipla via `mat-checkbox` per
> riga + checkbox "seleziona tutto" nell'header (con stato `indeterminate`); gli id selezionati sono
> tenuti in un `signal<Set<number>>` (id da `idRichiestaGenerica`, stringa nel modello → `Number()`).
> Il pulsante (toolbar tabella) è abilitato solo con almeno una selezione; al click chiama
> `StampeService.stampaLetteraTrasmissioneMassiva$Response({ body: { idRichieste } })` con
> `takeUntilDestroyed` e scarica il Blob (object URL + anchor + `revokeObjectURL`, filename da
> `Content-Disposition`, fallback `lettera-trasmissione.pdf`). Errore **400** (nessuna richiesta
> ammessa) gestito con snackbar dedicata senza rompere la UI; nessuno spinner locale (interceptor
> globale). La selezione viene azzerata su nuova ricerca e su Annulla. La colonna `seleziona` è
> non-hideable (sempre presente, esclusa dal picker colonne).

> **Aggiornamento (2026-06-19) — fedeltà 1:1 lettera di trasmissione L.38.** `StampaPdfGenerator`
> riallineato pixel-per-pixel al PDF legacy di riferimento (`LT_38_78_28_001_216418_19-06-2026.pdf`,
> motore InetSoft Style Report). Confronto iterativo renderizzando entrambi i PDF a 150 dpi e
> misurando differenza pixel + posizioni testo (`pdftoppm`/`pdftohtml`): risultato finale **~2,3%**
> di differenza media, residuo dovuto al solo anti-aliasing dei glifi (rasterizzazione diversa tra
> InetSoft e OpenPDF sugli stessi font Times standard); tutte le righe entro **±2pt**, testo / font /
> interlinea / a-capo coincidenti. **Correzioni applicate (solo `StampaPdfGenerator.java`):**
> - **Formato pagina**: `Letter` (612×792), non A4 — il legacy genera Letter pur dichiarando A4 nel
>   template `.srt` (`PageSize.LETTER`).
> - **Bande fisse** (page event `IntestazioneLogo`): **logo centrato** in testata (prima era a
>   destra); per la L.38 **intestazione settore** (denominazione corsivo sottolineato + e-mail,
>   centrate sotto il logo) in banda testata e **recapiti settore** (`tableIndSedeDec`) in banda
>   footer a posizione fissa. La `lettera38` non disegnava affatto l'intestazione settore in alto e
>   rendeva una "firma" settore errata a metà pagina: rimossa. Le altre lettere (DS / preliminare /
>   integrazioni) restano a flusso inline (banda solo-logo).
> - **Font**: `OGGETTO:` reso in **Times normale** (il PDF di riferimento non contiene font bold);
>   intestazione settore in **Times-Italic** sottolineato (non bold-italic).
> - **Layout**: corpo con **rientro prima riga** (tab 0,5"); **destinatario** allineato a sinistra a
>   x≈412pt (non a destra); colonna etichetta `OGGETTO` a 65pt con celle no-wrap e passo righe 15pt;
>   conteggi righe vuote / spaziature allineati ai `NewlineElement` del template.
> - **Spaziatura tipografica** (lo scarto principale rispetto al default OpenPDF): tracking caratteri
>   `CHAR_SPACING=0.8pt` (`Chunk.setCharacterSpacing`) e word-spacing — assente come API nel testo a
>   flusso OpenPDF — emulata allargando i soli chunk-spazio via `setHorizontalScaling` (`WORD_SCALE=1.3`
>   generico, `WORD_SCALE_CORPO=1.7` per il corpo, marcatamente più spaziato/giustificato nel legacy).
> - La stessa testata/calce per-lettera è gestita anche nella stampa massiva (banda attivata per
>   lettera quando il codice legge è `38`). Build BE (`mvn compile`) OK.
> **Nota:** i valori di tracking/word-scale sono calibrati a confronto col riferimento e centralizzati
> in costanti in cima a `StampaPdfGenerator`. La fedeltà è di layout/font ed è indipendente dai dati
> (che arrivano da `StampaMapper`: per la richiesta di esempio `cod_richiesta` = `38/78_28_001_216418`).

---

## 1. Stampe legacy

Le stampe sono pulsanti renderizzati condizionatamente nella toolbar `opzioniForm` della richiesta,
in base a **legge** (`idLegge`), **stato** (`idStato`), **ruolo** utente e provincia/aggregazione
(`countRichiestaByProvincia`, `tipoEnteAggregazione`). Tutte producono un **PDF** generato lato BE
con il motore **InetSoft Style Report** (template `.srt` in
`sprintj/.../util/stylereport/`), restituito in streaming come `application/pdf` con
`Content-Disposition: attachment`.

| Stampa | Pulsante / URL legacy | Contenuto | Formato | Note |
|--------|-----------------------|-----------|---------|------|
| Lettera di trasmissione | `stampa1` → `stampaLetteraTrasmissione.do` | Lettera di trasmissione della richiesta all'ente competente; template per legge: `lettera38.srt` (L.38), `letteraDS.srt` (L.54/183), `letteraStraordinaria.srt` (straordinaria) | PDF | Visibile se `idLegge != 18`, stato **Bozza** o **In verifica locale**, ruolo periferico base/gestore (con richieste in provincia o `tipoEnteAggregazione==3`) **oppure** amministratore (escluse L.18 e sopralluogo). Dati da `findInfoLetteraTrasmissione38` / `...54e183` / `...Straordinaria` |
| Richiesta progetto preliminare | `stampa2` → `stampaRichiestaPreliminare.do` | Lettera di richiesta del progetto preliminare mancante; template `letteraMancanzProgPreliminare.srt` | PDF | Visibile solo per **L.54 / L.183**, stato diverso da Chiuso / Chiuso con finanziamento, ruoli periferici (con richieste in provincia) o centrali OO.PP. / amministratore. Dati da `findInfoLetteraRichProgettPreliminare` |
| Richiesta integrazioni | `stampa3` → `stampaRichiestaIntegrazioni.do` | Lettera di richiesta integrazione documentazione; template `letteraIntegrazDocumentazione.srt` | PDF | Stesse condizioni di visibilità di "Richiesta progetto preliminare" (`visualizzaAltreStampe`). Dati da `findInfoLetteraRichiestaIntegrazioni` |
| Lettera trasmissione massiva (da ricerca) | `RicercaAction.stampaLetteraTrasmissioneRicerca` | Stessa lettera di trasmissione ma su **più richieste selezionate** nei risultati di ricerca (array `SprintTRicGenerica[]`); usa anche `elencoRichieste.srt` per la tabella riepilogo | PDF | Non è nella toolbar della richiesta ma nei risultati di ricerca; stesso motore (`StampaBusinessDelegate.stampaLetteraTrasmissione(dto, arrayRichieste, fec)`). Citata qui per completezza; check stato Bozza via `checkStampaLetteraTrasmissione` |

Caratteristiche comuni del flusso legacy:

- Trigger FE: `doChangeAction('form', '<azione>.do', true)` → submit del form di sessione → `StampeAction`.
- L'action recupera `idRichiesta` (da request o da `RichiestaForm`) e `idLegge` (da sessione),
  invoca il delegate, riceve `byte[]` (`dto.getElement("pdfOut")`) e lo scrive sull'`OutputStream`
  della response con header `application/pdf` + `attachment; filename=<nomeFile>.pdf`.
- Il BE: carica il template `.srt` (`GeneraStampa.createStampa`), recupera i dati con i DAO
  `IStampaDAO` (`findInfoLettera*`) + toponomastica (comuni/province via `getToponomasticaHelper`)
  + descrizione tipo ente aggregazione, popola gli elementi del template (`GeneraStampa.setLettera*`)
  e genera il PDF (`GeneraStampa.generaPdfStampa`).

> Nota tecnologica: il legacy **non usa Jasper/JasperReports**. Il motore è **InetSoft Style
> Report** (`inetsoft.report.*`), con template proprietari `.srt` versionati nel sorgente. Questa
> dipendenza non è riproponibile tale e quale nel nuovo stack (vedi Proposta).

---

## 2. Stato attuale (nuovo stack)

- **sprintbff**: nessun endpoint di stampa/report/PDF. Nessuna dipendenza di generazione documenti
  (no Jasper, no InetSoft, no librerie PDF). Esiste l'endpoint
  `GET /richieste/{idRichiesta}/allegati/{idAllegato}` ("Dettaglio/download allegato") ma **restituisce
  JSON** (`AllegatoItem`), non un binario: quindi **non esiste ancora** un pattern di risposta
  binaria (`application/pdf` / `application/octet-stream`) nel contratto OpenAPI.
- **sprintwcl**: nessun pulsante/funzione di stampa nelle folder della richiesta
  (`src/app/pages/richiesta/folders/...`). L'infrastruttura HTTP generata supporta già
  `responseType: 'blob'` (`src/app/api/request-builder.ts`), ma **nessuna** `fn` la usa: tutte le
  chiamate attuali sono `responseType: 'json'`. Manca quindi sia l'endpoint sia il pulsante e la
  logica di download del blob.
- **Condizioni di visibilità**: la logica legacy (legge/stato/ruolo/provincia) non è replicata. Il
  nuovo stack ha già il contesto utente (`UtenteContestoResponse`) e i metadati richiesta, ma le
  regole specifiche di abilitazione delle stampe non esistono.

In sintesi: la funzione di stampa è **interamente da realizzare** su entrambi i lati.

---

## 3. Proposta

Approccio **contract-first** (OpenAPI in `sprintbff/src/main/resources/static/api/openapi.yaml`,
poi rigenerazione controller BE + servizi/modelli FE), endpoint **orientati alla risorsa di dominio**
(`/richieste/{idRichiesta}/...`) coerenti con le spec esistenti.

### 3.1 Endpoint OpenAPI proposti

Due possibili modellazioni; si propone la **(A)** (un endpoint parametrico per tipo stampa) come
soluzione primaria, più semplice da estendere a nuove stampe.

**(A) Endpoint unico parametrico**

```yaml
/richieste/{idRichiesta}/stampe/{tipoStampa}:
  get:
    tags: [Stampe]
    summary: Genera e scarica una stampa PDF della richiesta
    operationId: getRichiestaStampa
    parameters:
      - $ref: '#/components/parameters/IdRichiesta'
      - name: tipoStampa
        in: path
        required: true
        schema:
          type: string
          enum: [LETTERA_TRASMISSIONE, RICHIESTA_PRELIMINARE, RICHIESTA_INTEGRAZIONI]
    responses:
      '200':
        description: PDF della stampa
        content:
          application/pdf:
            schema:
              type: string
              format: binary
      '400': { $ref: '#/components/responses/InvalidParameter' }
      '403': { $ref: '#/components/responses/Forbidden' }   # stampa non ammessa per stato/ruolo/legge
      '404': { description: Richiesta non trovata, content: { application/json: { schema: { $ref: '#/components/schemas/Errore' } } } }
      default: { description: errore generico, content: { application/json: { schema: { $ref: '#/components/schemas/Errore' } } } }
    security:
      - basicAuth: []
```

**(B) Endpoint dedicati** (in alternativa, una operazione per stampa, più esplicita ma più verbosa):
`GET /richieste/{idRichiesta}/stampe/lettera-trasmissione`,
`.../richiesta-preliminare`, `.../richiesta-integrazioni` — tutti con risposta `application/pdf`.

Endpoint complementare consigliato per pilotare l'abilitazione dei pulsanti lato FE senza
duplicare la logica:

```yaml
/richieste/{idRichiesta}/stampe:
  get:
    summary: Stampe disponibili per la richiesta (in base a legge/stato/ruolo)
    operationId: getRichiestaStampeDisponibili
    responses:
      '200':
        description: Elenco stampe abilitate
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  tipoStampa: { type: string }   # LETTERA_TRASMISSIONE | ...
                  etichetta:  { type: string }   # "stampa lettera trasmissione"
```

### 3.2 Generazione PDF lato BE (sprintbff)

- **Non riusare InetSoft**: i template `.srt` sono legati al motore proprietario legacy. Si propone
  di rigenerare i layout con una libreria standard. Opzioni:
  - **OpenPDF / iText** (composizione programmatica) — controllo fine, nessun template esterno.
  - **JasperReports** (template `.jrxml` riprogettati) — adatto se si vogliono layout manutenibili
    da non-sviluppatori. Comporta nuova dipendenza e ridisegno dei template.
  - **HTML → PDF** (Thymeleaf + Flying Saucer / openhtmltopdf) — riusa competenze web, layout in
    HTML/CSS; buon compromesso per lettere testuali come queste.
  - Si raccomanda **HTML→PDF** (o OpenPDF) viste le stampe attuali (lettere prevalentemente
    testuali con intestazioni settore/ente, comuni/province, oggetto richiesta).
- **Struttura backend** (convenzioni `backend` skill): nuovo `StampaManager` che orchestra il
  recupero dati (riuso dei mapper MyBatis esistenti per richiesta/comuni/lookup; nuove query in file
  XML dedicato per i dati specifici delle lettere — analoghi a `findInfoLettera*`), un componente
  `StampaPdfGenerator` per il rendering, e un controller generato da OpenAPI che restituisce
  `ResponseEntity<byte[]>` / `Resource` con `Content-Type: application/pdf` e
  `Content-Disposition: attachment; filename=...`.
- **Autorizzazione**: portare nel BE le condizioni legacy (legge/stato/ruolo/provincia-aggregazione).
  Se la stampa non è ammessa → `403` (mappato su `Forbidden`). Il check stato "solo Bozza" della
  lettera di trasmissione (`checkStampaLetteraTrasmissione`) diventa una validazione server-side.

### 3.3 Integrazione FE (sprintwcl)

- Aggiungere un pulsante / menu **"Stampa"** nella pagina richiesta
  (`src/app/pages/richiesta/richiesta-detail/...`), abilitato in base a
  `getRichiestaStampeDisponibili` (o a contesto utente + stato già disponibili lato FE).
- Riusare il pattern **download blob** dell'infrastruttura generata: la `fn` deve usare
  `rb.build({ responseType: 'blob', accept: 'application/pdf' })` (oggi tutte le `fn` usano
  `'json'`; sarà la prima a usare `'blob'`). Sul `next` del blob: creare un object URL
  (`URL.createObjectURL`) e forzare il download (anchor con `download=<nomeFile>.pdf`), poi
  `revokeObjectURL`.
- Rispettare la convenzione HTTP FE (`.cursor/rules/frontend-http.mdc`): subscription con
  `takeUntilDestroyed(this.destroyRef)`; lo spinner globale (`loadingInterceptor`) copre già la
  chiamata, non aggiungere spinner locali.

---

## 4. Gap rispetto all'attuale

| # | Gap | Tipo |
|---|-----|------|
| S1 | Endpoint OpenAPI stampa `GET /richieste/{idRichiesta}/stampe/{tipoStampa}` con risposta `application/pdf` (primo binario nel contratto) | BE (OpenAPI + controller) |
| S2 | Motore generazione PDF: scelta libreria (HTML→PDF / OpenPDF / Jasper) e nuova dipendenza Maven; **non** si riusa InetSoft `.srt` | BE |
| S3 | ✅ **Fatto** — `StampaPdfGenerator` con i testi letterali dei template: trasmissione (per legge 38 / 54-183 / straordinaria), progetto preliminare, integrazioni | BE (template) |
| S4 | ✅ **Fatto** (parziale) — `StampaMapper.findInfoLetteraStampa` per i dati delle lettere (protocollo, importi 38, compilatore/corelatore, settore firmatario, evento). Manca toponomastica completa province + classificazione lettera (assente nello schema) | BE (MyBatis) |
| S5 | ⚠️ **Parziale** — visibilità su **codice legge** reale + stato (no più euristica stringa); manca la parte ruolo/provincia-aggregazione (non replicabile: ruolo stringa, provincia mock) | BE |
| S6 | Endpoint `GET /richieste/{idRichiesta}/stampe` (stampe disponibili) per pilotare i pulsanti FE | BE |
| S7 | Pulsante/menu "Stampa" nella pagina richiesta con abilitazione condizionata | FE |
| S8 | `fn` API con `responseType: 'blob'` + download blob (object URL + anchor) — primo caso nel FE | FE |
| S9 | ✅ **Fatto (BE)** — stampa **massiva** lettera trasmissione da risultati di ricerca: endpoint `POST /richieste/stampe/lettera-trasmissione` (`operationId: stampaLetteraTrasmissioneMassiva`, body `StampaMassivaRequest { idRichieste: number[] }`, risposta `application/pdf`). Genera un unico PDF con tabella riepilogo (`elencoRichieste.srt`: Codice richiesta / Comune / Oggetto / Importo) + una lettera di trasmissione per richiesta ammessa, ciascuna su nuova pagina. Richieste inesistenti/non ammesse escluse; nessuna ammessa → 400 `ValidazioneException`. `fn`/service FE rigenerati (`responseType: 'blob'`). ✅ **FE done** — selezione multipla (`mat-checkbox` riga + seleziona-tutto), `signal<Set<number>>`, pulsante toolbar abilitato con selezione, download blob (object URL + anchor + revoke), 400 → snackbar | BE (fatto) + FE (fatto) |

---

## 5. Note implementative

- **InetSoft è una dipendenza legacy non portabile**: i template `.srt` e le API `inetsoft.report.*`
  vanno considerati solo come *specifica del contenuto* (quali campi compaiono nella lettera), non
  come base di riuso. Ispezionare i `.srt` e i metodi `GeneraStampa.setLettera*` per ricavare
  l'elenco esatto dei campi/segnaposto da riprodurre.
- **Sorgenti dati**: i metodi DAO legacy `findInfoLetteraTrasmissione38`,
  `findInfoLetteraTrasmissione54e183`, `findInfoLetteraTrasmissioneStraordinaria`,
  `findInfoLetteraRichProgettPreliminare`, `findInfoLetteraRichiestaIntegrazioni` indicano le tabelle
  e i join necessari; vanno tradotti in query MyBatis (solo in file XML, mai annotazioni inline —
  `.cursor/rules/mybatis-xml.mdc`). Includono toponomastica (elenco comuni/province della richiesta)
  e descrizione tipo ente aggregazione.
- **Classificazione lettera**: per L.38 e straordinaria il legacy recupera una classificazione
  protocollo (`FK_CLASSIFICAZIONE_LETTERA`) da inserire nella lettera; riusabile come lookup.
- **Naming/risorsa**: mantenere il prefisso di dominio `/richieste/{idRichiesta}/...` senza prefisso
  `/stampa` a livello applicativo (coerente con le altre spec). Tag OpenAPI `Stampe`.
- **Risposta binaria**: definire bene `Content-Disposition` e `filename` (oggi il legacy usa
  `nomeFile` calcolato lato BE). Valutare se header `inline` (apertura nel browser) o `attachment`
  (download): il legacy usa `attachment`.
- **Fase 2 (massiva)**: la stampa multipla da ricerca (`stampaLetteraTrasmissioneRicerca`) richiede
  un endpoint che accetti una lista di id richiesta e produca un unico PDF con tabella riepilogo
  (`elencoRichieste.srt`); rinviabile a dopo la stampa singola.

### Assunzioni / incertezze

- Si **assume** che tutte le stampe siano PDF (confermato dal codice: `application/pdf`,
  `pdfOut` byte[]); non risultano export Excel/Word per la richiesta (i commenti
  `application/vnd.ms-excel` nel legacy sono codice morto).
- Le **etichette** esatte sono quelle dei pulsanti JSP ("stampa lettera trasmissione", "stampa
  richiesta prog. preliminare", "stampa richiesta integrazioni").
- La scelta della libreria PDF (S2) è una **proposta**, da validare con il team in base a
  manutenibilità dei layout e dipendenze ammesse.
- Le condizioni di visibilità sono ricostruite da `pulsantiStampe.jsp` (costanti `ID_LEGGE_*`,
  `ID_STATO_RICHIESTA_*`, ruoli): vanno verificate rispetto alle regole di business attuali prima
  dell'implementazione.
