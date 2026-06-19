# Folder "Analisi del rischio" — allineamento al layout legacy

Mappatura del contenuto della collapse **Analisi del rischio** (`analisi-del-rischio-folder`) sul JSP
legacy `analisiDelRischio.do` (form `saveAnalisiDelRischio`). Le sotto-sezioni `<h4>` del legacy
diventano i blocchi interni della collapse (convenzione di progetto). Legenda obbligatorietà: `*` =
obbligatorio **salvataggio**, `**` = obbligatorio **invio**.

Fonte legacy: JSP `sprintj/.../jsp/richiesta/analisiDelRischio.jsp` (form `saveAnalisiDelRischio`,
action `dettaglioAnalisiDelRischio.do`).
Stato attuale: `sprintwcl/.../folders/analisi-del-rischio-folder/` (4 sezioni rese come **textarea /
input testo libero**, senza lookup né struttura). DTO BFF `AnalisiDelRischioDto` con 4 stringhe
(`elementiRischio`, `classeVulnerabilita`, `valutazioneDanno`, `valutazioneRischio`).

> **Relazione con "Valutazione pericolosità".** Nel legacy `analisiDelRischio` e
> `valutazionePericolosita` sono **due folder distinti** (constants `ID_FOLDER_ANALISI_DEL_RISCHIO` e
> `ID_FOLDER_VALUTAZIONE_PERICOLOSITA`), entrambi visibili dalla wizard bar della richiesta.
> `valutazionePericolosita.jsp` contiene il calcolo idrogeologico (frane / conoidi / valanghe / rete
> idrografica → hazard) ed è un'**altra folder**, fuori scope di questo documento. Il legame è
> indiretto: l'hazard di pericolosità concorre, insieme alla vulnerabilità e alla valutazione del
> danno, alla determinazione della **Classe di rischio** mostrata (sola lettura) nella sezione 1.4
> di *Analisi del rischio*. **Questo documento copre solo la folder "Analisi del rischio".**

---

## 1. Struttura target (4 sezioni)

### 1.1 Elementi a rischio
Nel legacy **non** è un testo libero: è una **matrice di checkbox** (`html:multibox property="ids"`)
raggruppata per sezione. Itera su `sezioniElementiARischio`; ogni sezione (`descrizione`, reso come
`<th rowspan>`) contiene N elementi `sprintMtdAnalisiRischios` (`idMtd` → valore del checkbox,
`descrizione` → label). Il `onclick` ricarica la folder (`reloadAnalisiDelRischio.do`).

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Sezione elemento a rischio | readonly (intestazione gruppo) | — | `sezioniElementiARischio[].descrizione` | raggruppamento |
| Elemento a rischio (selezione) | **checkbox multipli** | — | `sprintMtdAnalisiRischios[].idMtd` / `.descrizione` | metadati `SPRINT_MTD_ANALISI_RISCHIO`; salvati su `ids` |

> ⚠️ Oggi l'Angular rende questa sezione come **una sola textarea libera** (`elementiRischio`): diverge
> dal legacy (perdita della struttura sezione→elementi e della multi-selezione).

### 1.2 Classe di vulnerabilità
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Classi di vulnerabilità | **select** | — | `classiDiVulnerabilita` su collection `SESSION_ELEMENT_CLASSI_VULNERABILITA` | onchange ricarica (`reloadAnalisiDelRischio.do`); persiste su `fk_vulnerabilita` |

> ⚠️ Oggi è un **input di testo libero** (`classeVulnerabilita`): deve diventare una **select** con lookup.

### 1.3 Valutazione del danno
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Valutazione del danno | **select** | — | `valutazioneDelDanno` su collection `SESSION_ELEMENT_VALUTAZIONE_DANNO` | onchange ricarica; persiste su `fk_val_danno` |

> ⚠️ Oggi è una **textarea libera** (`valutazioneDanno`): deve diventare una **select** con lookup.

### 1.4 Valutazioni del rischio
Sezione **condizionata** (`isValutazioneRischioVisilble`): visibile solo per leggi 38 / straordinaria
/ sopralluogo con ruoli centrali (OOPP, Difesa Suolo, Amministratore) **oppure** per leggi 54 / 183.
È **sola lettura**: la Classe di rischio è calcolata, non scelta dall'utente.

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Classe di rischio | **readonly testo** | — | `classeDiRischio.descrizione` | calcolata (deriva da vulnerabilità + danno + hazard pericolosità) |
| Definizione della classe | readonly | — | `classeDiRischio.descrizione` | **commentato** nel legacy → non mostrare |

> ⚠️ Oggi l'Angular rende questa sezione come **textarea libera editabile** (`valutazioneRischio`):
> diverge dal legacy, dove è **readonly e calcolata** e **non sempre visibile** (gating per
> legge/ruolo).

**Nota generale di intestazione (legge 38/54/183):** il legacy mostra *"L'analisi del rischio deve
essere valorizzata per l'invio della richiesta."* → riportare come hint/`**` di obbligatorietà invio
sulla collapse per quelle leggi.

---

## 2. Gap rispetto all'attuale

| # | Gap | Tipo |
|---|-----|------|
| R1 | "Elementi a rischio": da **textarea libera** a **matrice di checkbox** sezione→elementi (multi-selezione) | FE + BE **done**: struttura DTO `sezioniElementiRischio` (sezioni con elementi + flag selezionato) popolata da `SPRINT_MTD_ANALISI_RISCHIO` (sezioni = `fk_padre IS NULL`, elementi = figli) con flag da `SPRINT_R_ANALISI_DINAMICA` |
| R2 | "Classe di vulnerabilità": da **input testo** a **select** con lookup | FE + BE: endpoint lookup classi vulnerabilità (oggi `SESSION_ELEMENT_CLASSI_VULNERABILITA`) |
| R3 | "Valutazione del danno": da **textarea** a **select** con lookup | FE + BE: endpoint lookup valutazione danno (oggi `SESSION_ELEMENT_VALUTAZIONE_DANNO`) |
| R4 | "Valutazioni del rischio" → **Classe di rischio readonly calcolata** (oggi textarea editabile) | FE (readonly) + BE **done**: formula `r = v + d + e` replicata dal legacy `RichiestaBean.reloadAnalisiDelRischio` (`AnalisiRischioCalculator`); classe calcolata in lettura e persistita come `fk_val_rischio` in salvataggio |
| R5 | Gating sezione 1.4 per **legge + ruolo** (38/straord./sopralluogo + ruoli centrali, oppure 54/183) | FE (visibilità condizionata) + BE: esporre flag visibilità o dati legge/ruolo |
| R6 | DTO a 4 stringhe libere non rappresenta lookup né struttura: i 3 campi select dovrebbero round-trippare come **id/descrizione** anziché stringa | BE (DTO/mapper) + FE |
| R7 | Hint obbligatorietà invio ("analisi del rischio da valorizzare") per leggi 38/54/183 + marcatori `*`/`**` | FE (da metadati, vedi [validazione-richieste.md](./validazione-richieste.md)) |
| R8 | Persistenza DB dei valori selezionati su `sprint_t_analisi_rischio` (`fk_vulnerabilita`, `fk_val_danno`, `fk_val_rischio`) e degli elementi a rischio (relazione MTD) | BE **done**: FK scalari su `sprint_t_analisi_rischio`; matrice elementi sincronizzata su `sprint_r_analisi_dinamica` (delete-all + insert, transazionale) e riletta nel detail |

## 3. Note implementative

- **Validazione legacy.** In `validation-richiesta.xml` la form `/saveAnalisiDelRischio` **non
  esiste**: nessun vincolo `required` né di formato sui campi di questa folder. Vincoli di formato
  (double/integer/date) sono presenti solo su `/saveValutazionePericolosita` (altra folder). Quindi
  per "Analisi del rischio" l'obbligatorietà è di sola **logica di invio** (hint legge 38/54/183),
  non di salvataggio. I marcatori `*`/`**` vanno presi dai metadati
  `/richieste/metadati/{idLegge}`.
- **Sorgenti lookup.** Le select di vulnerabilità e valutazione danno nel legacy vengono da
  collection in sessione (`SESSION_ELEMENT_CLASSI_VULNERABILITA`, `SESSION_ELEMENT_VALUTAZIONE_DANNO`).
  Lato DB i valori vivono nella tabella lookup `sprint_d_analisi_rischio` (vedi
  `findAnalisiRischioLookupId` in `RichiestaMapper.xml`). Servono endpoint lookup dedicati (o un
  lookup generico) per popolare le select Angular.
- **Persistenza.** Lo stato attuale già round-trippa via patch
  (`patchRichiestaAnalisiDelRischio`); il backend risolve la **descrizione testuale → id** lookup su
  `sprint_d_analisi_rischio` e aggiorna `sprint_t_analisi_rischio`
  (`updateAnalisiRischio38`: `fk_vulnerabilita`, `fk_val_danno`, `fk_val_rischio`). Passando a
  select con id/descrizione (R6) il mapping diventa diretto sull'id, più robusto del match testuale.
- **Elementi a rischio (R1).** Richiede una struttura nuova: lista di sezioni
  (`SPRINT_MTD_ANALISI_RISCHIO`) con elementi selezionabili e flag di selezione corrente; nel legacy
  ogni cambio checkbox ricarica la folder, in Angular si gestisce lato client.
- **Classe di rischio (R4/R5).** È un **valore calcolato readonly**, non un input: la response detail
  deve esporre `classeDiRischio` (descrizione) e un flag di visibilità (o i dati legge/ruolo per
  derivarlo lato FE). Le select dipendenti (ricalcolo della classe al cambio di
  vulnerabilità/danno) nel legacy ricaricano via `reloadAnalisiDelRischio.do`; in Angular reagire ai
  `valueChanges`.
- **Fuori scope.** `valutazionePericolosita.jsp` (frane/conoidi/valanghe/rete idrografica → hazard) è
  una folder separata con propria spec; qui è citata solo per la dipendenza logica sulla Classe di
  rischio.

## 4. Stato implementazione FE (`analisi-del-rischio-folder.component`)

Ristrutturato il componente Angular su `AnalisiDelRischioDto` esteso (campi id/descrizione +
`sezioniElementiRischio`). UI solo Angular Material, `takeUntilDestroyed` su tutte le subscribe,
nessuno spinner locale.

| Gap | Stato FE | Note |
|-----|----------|------|
| R1 Elementi a rischio (matrice checkbox sezione→elementi) | **FE done / BE done** | Render da `sezioniElementiRischio` con `mat-checkbox`; stato in signal locale, ricomposto nel patch. BE: read da `SPRINT_MTD_ANALISI_RISCHIO` + flag da `SPRINT_R_ANALISI_DINAMICA`; save delete-all + insert (vedi R8). |
| R2 Classe di vulnerabilità (select) | **FE done / BE done** | `mat-select` su `getClassiVulnerabilita()`, bind su `classeVulnerabilitaId`. BE: id→`fk_vulnerabilita` (`sprint_t_analisi_rischio`); read `classeVulnerabilitaId` + `classeVulnerabilitaDescrizione`. |
| R3 Valutazione del danno (select) | **FE done / BE done** | `mat-select` su `getValutazioniDanno()`, bind su `valutazioneDannoId`. BE: id→`fk_val_danno`; read `valutazioneDannoId` + `valutazioneDannoDescrizione`. |
| R4 Classe di rischio readonly calcolata | **FE done / BE done** | Campo readonly, mostra `classeRischioDescrizione`. BE: formula `r = v + d + e` replicata dal legacy (`AnalisiRischioCalculator`), classe ricalcolata in lettura (prevale sul valore salvato) e persistita come `fk_val_rischio` in salvataggio. Dettaglio formula sotto. |
| R5 Gating sezione 1.4 per legge/ruolo | **deferred** | La sezione è sempre visibile; manca un flag di visibilità (o dati legge/ruolo) dalla response detail. Quando disponibile, condizionare con `@if`. |
| R6 Round-trip id/descrizione | **FE done / BE done** | Il patch invia gli id; BE risolve id (prevale) o lookup descrizione e li rilegge nel detail. I tre FK (`fk_vulnerabilita/fk_val_danno/fk_val_rischio`) fanno round-trip reale. |
| R7 Hint obbligatorietà invio + marcatori `*`/`**` | **deferred** | Non ancora collegato ai metadati `/richieste/metadati/{idLegge}` (come fa `dati-generali-folder`). Da aggiungere quando si definisce il gating legge. |
| R8 Persistenza DB matrice elementi a rischio | **BE done** | Matrice `sezioniElementiRischio` letta da `sprint_mtd_analisi_rischio` (+ flag da `sprint_r_analisi_dinamica`) e salvata con delete-all + insert su `sprint_r_analisi_dinamica` (transazionale, `@Transactional` su `patchAnalisiDelRischio`). I tre FK scalari restano su `sprint_t_analisi_rischio`. |

**Assunzioni FE.** I lookup (`getClassiVulnerabilita/getValutazioniDanno/getClassiRischio`)
restituiscono `LookupItem {codice, descrizione}` con `codice` stringa numerica: il FE fa il cast a
number per allinearlo agli id del DTO. `getClassiRischio()` è caricata ma non usata in una select
(la classe è readonly/calcolata); resta disponibile per usi futuri/etichette.

## 5. Formula classe di rischio (R4) — replicata dal legacy

Fonte: `sprintj/.../business/session/richiesta/RichiestaBean.reloadAnalisiDelRischio`. Implementata
in BFF da `AnalisiRischioCalculator` (chiamata sia in lettura, dove **prevale** sul valore salvato,
sia in salvataggio, dove il risultato è persistito su `fk_val_rischio`).

Formula: **`r = v + d + e`**
- `v` = `CODICE` numerico di `sprint_d_analisi_rischio` della **classe di vulnerabilità** selezionata
  (`Integer.parseInt(codice)`).
- `d` = `CODICE` numerico di `sprint_d_analisi_rischio` della **valutazione del danno** selezionata.
- `e` = `max(e1, e2, e3, e4)` calcolato dagli `ID_MTD` degli elementi a rischio selezionati
  (`sprint_r_analisi_dinamica`), secondo i raggruppamenti legacy:
  - **e1** = 1 se selezionato uno tra `8/9/10`.
  - **e2** (voci `11/12/13/14/33`): 3 se tutte le 5 o le prime 4 (`11+12+13+14`); 2 per voce singola
    o qualunque altra combinazione tra le 5; 0 altrimenti.
  - **e3** (voci `15..23` + `34`): 4 se una delle terne legacy
    (`15+16+17`, `15+17+18`, `15+16+19`, `15+17+19`, `15+16+18`, `17+18+19`); 3 per qualunque altra
    presenza di `15/16/17/18/19/20/21/34/22/23`; 0 altrimenti.
  - **e4** (voci `24..32`): 4 se presente una qualsiasi; 0 altrimenti.

Mappatura `r` → **id** classe di rischio in `sprint_d_analisi_rischio`:
`r ≤ 3 → 12`, `3 < r ≤ 7 → 13`, `7 < r ≤ 11 → 14`, `11 < r ≤ 13 → 15`, altrimenti **nessuna classe**.
Se manca vulnerabilità o danno, oppure nessun elemento è selezionato, la classe **non è
determinata** (legacy `id = 0`): in lettura resta il valore già persistito (`fk_val_rischio`), in
salvataggio non viene sovrascritto.

> **Dipendenza dai dati di dominio.** Gli `ID_MTD` letterali (`8`..`34`) e gli id classe di rischio
> (`12`..`15`) sono valori di **seed** di `SPRINT_MTD_ANALISI_RISCHIO` / `SPRINT_D_ANALISI_RISCHIO`,
> identici al legacy. Vanno verificati sul DB reale a runtime (il calcolo dipende dal `CODICE`
> numerico di vulnerabilità/danno e dagli `id_mtd` corretti). La baseline DDL non contiene il seed.

> **Ramo 38/calamità.** Read e save della matrice (e dei FK) usano `fk_richiesta_generica_38cal`,
> coerentemente con l'implementazione scalare già presente (`countAnalisiRischio38`,
> `updateAnalisiRischio38`, join detail). Il ramo `fk_richiesta_generica_1854` (leggi 18/54/183) non
> è ancora gestito nel BFF per questa folder: limitazione preesistente, non introdotta qui.
