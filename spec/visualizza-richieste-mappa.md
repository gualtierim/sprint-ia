# Visualizza tutte le richieste su mappa — analisi legacy e proposta

Analisi della funzione **«Visualizza tutte le richieste su mappa»** dei risultati di ricerca
richieste. Mappa il comportamento legacy JSP/Struts (`ricercaMappa.do`) sul nuovo stack
(`sprintbff` + `sprintwcl`) in modalità contract-first.

Fonti legacy (sola lettura):

| Artefatto | Percorso |
|-----------|----------|
| Pulsante toolbar | `sprintj/.../jsp/ricerca/include/pulsantiRicerca.jsp:62-69` (`mappaViewAll` → `ricercaMappa.do`, nuova scheda) |
| Action Struts | `sprintj/.../RicercaAction.java:2827-2875` (`ricercaMappa`) |
| Config Struts | `sprintj/.../WEB-INF/struts-config-ricerca.xml:16-24` (forward → `ricercaMappa.jsp`) |
| JSP mappa | `sprintj/.../jsp/ricerca/ricercaMappa.jsp` (OpenLayers + ol-ext, proj4) |
| GeoJSON server | `sprintj/.../JSONCreator.java` (`createJson`, CRS `EPSG:32632`) |
| Query coordinate | `sprintj/.../kml/dao/SQLSpatialDao.java:465-529` (`getByQueryRicerca` su `vsde_ric_38_strao_pt_tutte`, `co_x`/`co_y`) |

> **Nota.** Esistono in `pulsantiRicerca.jsp` altri due pulsanti «mappa» che scaricano un **KML**
> (`visualizzaMappa.do` = selezionate, `visualizzaTuttiMappa.do` = tutte). Sono download di file e
> **fuori scope** di questa spec, che migra solo la **vista cartografica** (`ricercaMappa.do`).

---

> **Implementazione (2026-06-19).** Realizzata end-to-end (MR1–MR6). **BE:** contratto
> `POST /richieste/cerca/geometrie` (`operationId: cercaRichiesteGeometrie`, body `CercaRichiesteRequest`,
> risposta `CercaRichiesteMappaRisultato { totale, troncato, items: RichiestaMappaItem[] }`);
> `RicercaManager.cercaRichiesteGeometrie` riusa i filtri di ricerca (`toCriteria`, offset 0, cap
> `MAX_PUNTI_MAPPA = 20.000`, flag `troncato` + warning) e la nuova query MyBatis
> `RicercaMapper.searchRichiesteMappa` (riuso `richiesteWhere` via subquery `id IN (...)`, filtro
> `co_x/co_y IS NOT NULL`, `LIMIT` senza `OFFSET`); `RicercaRichiestaRow` riusato come row;
> MapStruct `RicercaVoMapper.toItemMappa`/`toItemiMappa`; `RichiesteApiImpl.cercaRichiesteGeometrie`.
> Riga in `schema/api-tables.md`. Build `mvn compile` OK. **FE:** client rigenerato
> (`RichiesteService.cercaRichiesteGeometrie`, model `RichiestaMappaItem`/`CercaRichiesteMappaRisultato`);
> pulsante **«Visualizza tutte le richieste su mappa»** nella toolbar risultati
> (`visualizzaSuMappa()` → navigazione con filtri correnti via `router state`); nuova route lazy
> `ricerca/richieste-mappa` e componente `RicercaRichiesteMappaComponent` (OpenLayers, config/layer
> riusati da `richiesta-mappa.config.ts`/`.layers.ts`, marker colorati per stato §1.1, cluster, popup
> con link «Vai al dettaglio», `view.fit` sui punti, avviso se `troncato`). Build `ng build` OK.
> **Non fatto:** galleria immagini allegati nel popup (legacy `getImages`); pulsanti legacy di
> download KML (`visualizzaMappa.do`/`visualizzaTuttiMappa.do`) restano fuori scope.

---

## 1. Comportamento legacy

1. Il pulsante «Visualizza tutte le richieste su mappa» è nella toolbar dei risultati
   (`pulsantiRicerca.jsp`), mostrato **solo per la ricerca richieste** (non eventi). Apre la mappa in
   una **nuova scheda** (`ricercaMappa.do`).
2. `RicercaAction.ricercaMappa` recupera dalla sessione i **parametri di ricerca correnti**, forza
   `SKIP_KEY=0` e `UNTIL_KEY=count` (cioè **tutte** le righe, niente paginazione), ricostruisce la
   query e produce un **GeoJSON `FeatureCollection`** (CRS `EPSG:32632`) con un `Point` per richiesta.
   La mappa mostra **sempre l'intero result set della ricerca**, **non** le sole righe selezionate né
   la sola pagina visualizzata.
3. Le coordinate provengono da `co_x`/`co_y` della vista `vsde_ric_38_strao_pt_tutte` (già in UTM
   32N: nessuna conversione, nessun PostGIS in lettura). Filtro: solo le richieste del result set di
   ricerca.
4. Ogni punto è colorato **per stato** ed espone un **popup** con codice richiesta, comune,
   descrizione danno, stato, legge, data inserimento, importi e link **«Vai al dettaglio»**.

### 1.1 Colore marker per stato (legacy `JSONCreator`)

| Stato | Colore |
|-------|--------|
| In bozza / In verifica locale | rosso `#EA7060` |
| Inviato / In verifica centrale | giallo `#FAF36E` |
| Chiuso con finanziamento | verde `#87F887` |
| Chiuso | viola `#7655F2` |
| Semifinanziato | blu `#6080F4` |
| (altro / non mappato) | default grigio |

---

## 2. Stato attuale (nuovo stack)

- **sprintbff:** la ricerca è `POST /richieste/cerca` (`RicercaManager.cercaRichieste`) **paginata**
  su `vsde_ric_38_strao_pt_tutte`; la vista espone già `co_x`/`co_y`
  (`RicercaMapper.searchRichieste`, frammento filtri riusabile `richiesteWhere`). L'export CSV
  (`POST /richieste/cerca/export`) già esegue una query **non paginata** con **cap** riusando gli
  stessi filtri: precedente diretto per la mappa. **Manca** un endpoint che restituisca tutti i punti.
- **sprintwcl:** esiste già `RichiestaMappaComponent` (`pages/richiesta/mappa/`) con OpenLayers 10.9,
  proiezione `EPSG:32632`, layer WMS (`richiesta-mappa.layers.ts`), config (`richiesta-mappa.config.ts`),
  cluster GeoJSON, marker e popup — pensato per il **singolo** punto editabile. La pagina ricerca
  (`pages/ricerca/ricerca-richieste/`) ha toolbar, `filtriCorrenti()` e già i pulsanti Colonne / Export
  CSV / stampa massiva. **Manca** la pagina mappa multi-punto e il pulsante che la apre.
  L'item ricerca (`CercaRichiestaItemRisultato`) ha già `coX`/`coY`, ma **solo per la pagina corrente**:
  per mostrare *tutte* le richieste serve l'endpoint geometrie.

---

## 3. Proposta (contract-first)

### 3.1 Endpoint OpenAPI

`POST /richieste/cerca/geometrie` (`operationId: cercaRichiesteGeometrie`, tag `Richieste`).

- Body: riuso di `CercaRichiesteRequest` (stessi filtri della ricerca; `page`/`pageSize` ignorati).
- Risposta: `CercaRichiesteMappaRisultato { totale, troncato, items: RichiestaMappaItem[] }`.
- `RichiestaMappaItem`: subset orientato al popup mappa — `idRichiestaGenerica`, `codRichiesta`,
  `nomeLegge`, `stato`, `descrizioneProvincia`, `descrizioneComune`, `descrizioneDanno`,
  `importoSommaUrgenza`, `importoUrgente`, `importoDefinitivo`, `dataInserimento`, `coX`, `coY`
  (coordinate `EPSG:32632`).

Scelta di uno schema **dedicato e snello** (anziché riusare `CercaRichiestaItemRisultato` da 30 campi):
la mappa può contenere migliaia di punti, e servono solo i campi del popup + lo stato per il colore.

### 3.2 Backend (sprintbff)

- **`RicercaMapper.searchRichiesteMappa(criteria)`** + `<select id="searchRichiesteMappa">` in
  `RicercaMapper.xml`: riusa `<include refid="richiesteWhere"/>`, seleziona il subset di colonne nelle
  righe `RicercaRichiestaRow` (riuso del modello esistente, che ha già tutti questi campi),
  aggiunge `AND v.co_x IS NOT NULL AND v.co_y IS NOT NULL`, `ORDER BY v.id_richiesta_generica DESC`,
  `LIMIT #{limit}` (cap, **niente OFFSET**). Query solo in XML (regola `mybatis-xml.mdc`),
  parametri bindati (no concatenazione SQL come nel legacy).
- **`RicercaVoMapper.toItemMappa(RicercaRichiestaRow)` / `toItemiMappa(List<...>)`** (MapStruct):
  `RicercaRichiestaRow` → `RichiestaMappaItem` (`coX`/`coY`/importi `bigDecimalToDouble`,
  `dataInserimento` `localDateToDate`).
- **`RicercaManager.cercaRichiesteGeometrie(request)`**: `toCriteria(request, 0, MAX_PUNTI_MAPPA)`,
  esegue `searchRichiesteMappa`, costruisce `CercaRichiesteMappaRisultato` (set `troncato` se
  `size >= cap`, con `LOG.warn`). Cap di sicurezza dedicato (es. `MAX_PUNTI_MAPPA = 20_000`).
- **`RichiesteApiImpl.cercaRichiesteGeometrie`**: `Response.ok(...)` (il codegen raggruppa per primo
  segmento `/richieste`).
- Aggiornare `schema/api-tables.md` con la riga del nuovo endpoint (`VSDE_RIC_38_STRAO_PT_TUTTE`).

### 3.3 Frontend (sprintwcl)

- **Pulsante** «Visualizza tutte le richieste su mappa» (icona `map`) nella toolbar risultati della
  pagina ricerca, abilitato con `totaleRisultati() > 0`. Al click naviga alla nuova route passando i
  **filtri correnti** (`filtriCorrenti()`) via `router state`.
- **Nuova pagina/route** `ricerca/richieste-mappa` (`RicercaRichiesteMappaComponent`, lazy-loaded):
  - all'init legge i filtri dallo state e chiama
    `RichiesteService.cercaRichiesteGeometrie({ body: filtri })` (con `takeUntilDestroyed`);
  - rende una mappa **OpenLayers** riusando i moduli `richiesta-mappa.config.ts` (proiezione/extent/
    risoluzioni) e `richiesta-mappa.layers.ts` (layer WMS di sfondo);
  - disegna **un marker per punto** colorato per stato (tabella §1.1) con **cluster** quando i punti
    sono ravvicinati; al click **popup** con cod. richiesta, comune, stato, legge, data, importi e
    link **«Vai al dettaglio»** → `/richieste/{idRichiestaGenerica}`;
  - `view.fit` sull'estensione dei punti (fallback centro Piemonte se nessun punto).
  - UI con Angular Material; spinner globale via `loadingInterceptor`.

---

## 4. Gap rispetto all'attuale

| # | Gap | Tipo |
|---|-----|------|
| MR1 | Endpoint OpenAPI `POST /richieste/cerca/geometrie` (`CercaRichiesteMappaRisultato`) | BE (OpenAPI + controller) |
| MR2 | Query `searchRichiesteMappa` (no paginazione, cap, filtro coord. non nulle, riuso `richiesteWhere`) | BE (MyBatis) |
| MR3 | MapStruct `toItemMappa` (`RicercaRichiestaRow` → `RichiestaMappaItem`) + `RicercaManager.cercaRichiesteGeometrie` + `RichiesteApiImpl` | BE |
| MR4 | Riga in `schema/api-tables.md` | BE (doc) |
| MR5 | Pulsante toolbar «Visualizza su mappa» + navigazione con filtri correnti | FE |
| MR6 | Pagina/route `ricerca/richieste-mappa` (OpenLayers multi-punto, colore per stato, cluster, popup + link dettaglio) | FE |

---

## 5. Note implementative e assunzioni

- **Tutto il result set, non i selezionati**: parità col legacy — la mappa mostra tutte le richieste
  dei filtri correnti (con coordinata valorizzata), non le checkbox selezionate.
- **Coordinate**: `co_x`/`co_y` della vista sono già in `EPSG:32632`; nessuna trasformazione lato BFF.
  I punti senza coordinata sono esclusi a monte (SQL).
- **Cap di sicurezza**: il legacy non ha limite; nel nuovo stack si introduce un cap (con flag
  `troncato`) per evitare payload/render eccessivi.
- **Colore per stato**: replicato lato FE (tabella §1.1) sul campo `stato` (descrizione) dell'item.
- **Niente mock**: la query riusa la stessa vista/filtri della ricerca reale; nessun dato fittizio.
- **Allegati/immagini nel popup** (galleria legacy via `getImages`) **non** replicati in questa fase.
