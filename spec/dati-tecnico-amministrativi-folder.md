# Folder "Dati tecnico-amministrativi" — allineamento al layout legacy

Mappatura del contenuto della collapse **Dati tecnico-amministrativi** (`dati-tecnico-amministrativi-folder`)
sul JSP legacy `datiTecnicoAmministrativi.do` (form `saveDatiTecnicoAmministrativi`). Le sotto-sezioni
`<h4>` del legacy diventano i blocchi interni della collapse (convenzione di progetto). Legenda
obbligatorietà: `*` = obbligatorio **salvataggio**, `**` = obbligatorio **invio**.

> I marcatori `*`/`**` qui derivano dai **condizionali per legge** presenti nel JSP (`idLegge == ...`),
> **non** da `validation-richiesta.xml`: la action `/saveDatiTecnicoAmministrativi` non ha alcun
> `depends="required"`, ma solo `descrizione` maxlength 4000 e formato date su `dataInizioLavori` /
> `dataProgettazione` (vedi [validazione-richieste.md](./validazione-richieste.md) §2.3). L'obbligatorietà
> `**` reale è dunque **per legge** (38/54/183/straordinaria/sopralluogo), gestita lato legacy via JSP
> e visibilità DB (`SPRINT_MTD_*`), non via validator.

Fonte legacy: JSP `sprintj/.../jsp/richiesta/datiTecnicoAmministrativi.jsp` (1635 righe).
Stato attuale: `sprintwcl/.../folders/dati-tecnico-amministrativi-folder/` (5 sezioni, 16 campi flat).
DTO backend: `sprintbff/.../vo/DatiTecnicoAmministrativiDto.java` (16 campi `String`, tutti round-trip).
Endpoint: `GET`/`PATCH /richieste/{id}/dati-tecnico-amministrativi` (`openapi.yaml`).

---

## 1. Struttura target (8 sezioni)

Le sezioni 1.1–1.8 corrispondono ai blocchi `<h4>` del legacy nell'ordine in cui appaiono. Molte
sezioni/campi sono **condizionati per legge** (`isSectionVisible` / `isFieldVisible` / `isFolderVisible`):
indicato in Note. Il legacy distingue **VIEW** (readonly) da **EDIT**; qui rileva il solo EDIT.

### 1.1 Effetti del danno
*(sezione condizionata: `ID_SEZIONE_EFFETTO_DEL_DANNO`)*

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Condizioni di agibilità/abitabilità | textarea | — | `richiesta.condizioniAgibilita` | "in caso di danno a immobile" |
| Condizioni di percorribilità/transitabilità | textarea | — | `richiesta.condizioniPercorribilita` | "danno a strada di accesso o scalo ferroviario" |
| Condizioni di esercizio | textarea | — | `richiesta.condizioniEsercizio` | "danno a infrastruttura di rete tecnologica/impianto" |

### 1.2 Descrizione intervento
*(sezione condizionata: `ID_SEZIONE_DESCRIZIONE_INTERVENTO`)*

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Relazione descrittiva dell'intervento | textarea | `**` (38/54/183) | `richiesta.descrizioneIntervento` | maxlength **4000** (unico vincolo `validation-richiesta.xml`) |
| Motivo intervento | **select** | `*` (≠ sopralluogo) | lookup `FK_MOTIVO_INTERVENTO` | |
| Categoria intervento | **select** | `**` (≠ sopralluogo) | lookup `FK_TIPO_INTERVENTO` | (property legacy `tipoIntervento`) |
| Data inizio lavori (gg/mm/aaaa) | date | `**` (≠ sopralluogo) | `dataInizioLavori` | formato `dd/MM/yyyy` |
| Durata lavori (giorni) | text (int, maxlength 4) | `**` (≠ sopralluogo) | `durataLavori` | |
| Settore | **select** | `**` (183) | lookup `FK_SETTORE_INTERVENTO` | campo condizionato `ID_CAMPO_SETTORE_INTERVENTO` |
| Necessità intervento | textarea | — | `richiesta.sprintTRic1854183.necessitaIntervento` | campo condizionato `ID_CAMPO_NECESSITA_INTERVENTO` |
| Obiettivo da conseguire e risultati attesi | textarea | — | `richiesta.sprintTRic1854183.obiettivoIntervento` | campo condizionato `ID_CAMPO_OBIETTIVO_DA_CONSEGUIRE` |
| Effetti indotti sul bacino e sull'ambiente | textarea | — | `richiesta.sprintTRic1854183.effettiIntervento` | campo condizionato `ID_CAMPO_EFFETTI_INDOTTI_BACINO_AMBIENTE` |

#### 1.2.1 Opera prevalente *(blocco `<div class="area">`, campo condizionato `ID_CAMPO_TIPOLOGIA_OPERE`)*

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Macrotipologia | **select** | — | lookup `FK_MACRO_TIPO_OPERE_LIST` | onchange ricarica (`reloadDatiTecnicoAmministrativi.do`) → filtra Tipologia |
| Tipologia | **select** | `**` (54/183) | lookup `FK_TIPO_OPERE` (per macro) | dipende dalla macrotipologia |

### 1.3 Valutazione economica intervento

Campi tutti condizionati `isFieldVisible`. Per legge straordinaria nota: "almeno un campo tra
importo definitivo, urgente e somma urgenza"; se valorizzato somma urgenza → numero e data ordinanza.

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Importo richiesto | readonly (formattato) | — | `importoRichiesto` | nel legacy blocco `if(false)` → **non mostrato** |
| Importo urgente / lettera D | text valuta | `**` (straord./38) | `importoUrgente` | campo cond. `ID_CAMPO_IMPORTO_URGENTE` |
| Importo definitivo / lettera E | text valuta | `**` (straord./38) | `importoDefinitivo` | campo cond. `ID_CAMPO_IMPORTO_DEFINTIVO` |
| Importo somma urgenza / lettera B | text valuta | `**` (straord./38) | `importoSommaUrgenza` | campo cond. `ID_CAMPO_IMPORTO_SOMMA_URGENZA` |
| Numero e data ordinanza / Provvedimento | text (maxlength 100) | `**` (straord./38) | `nOrdinanzaSindacale` | campo cond. `ID_CAMPO_N_ORDINANZA_SINDACALE` |
| Data ordinanza | date | `**` (straord.) | `dataOrdinanza` | campo cond. `ID_CAMPO_DATA_ORDINANZA` |
| Provvedimento di Finanziamento | text / readonly | — | `richiesta.provvedimentoFinanziamento` | readonly per ruoli periferici; cond. `ID_CAMPO_PROVVEDIMENTO_FINANZIAMENTO` |
| Codici CUP | text | — | `richiesta.codiceCup` | |
| Codice RENDIS | text | — | `richiesta.codiceRendis` | |
| Codice ARCHIVIO OOPP | text | — | `richiesta.codiceArchivio` | editabile solo ruoli centrali/admin, altrimenti readonly |

#### 1.3.1 Lotti *(tabella, campo condizionato `ID_CAMPO_TABELLA_LOTTI`)*

Griglia editabile con righe Lotto: **N. lotto** (`*` int maxlen 2), **Importo** (`*` valuta),
**Priorità** (`*` int maxlen 2), **Anno** (`*` `yyyy`), **Progr. intervento**, **Provv. finanziamento**.
Required derivati da `validation-richiesta.xml` form `/inserisciLotto`. Azioni: inserisci / pulisci /
elimina (radio per riga). Mostra **Importo totale** e nota scala priorità PAI.

> **FATTO (CRUD Lotti).** Tabella + form lotti implementati nel folder tecnico-amministrativo,
> mirroring degli stralci. Endpoint REST: `GET/POST /richieste/{idRichiesta}/lotti`,
> `DELETE /richieste/{idRichiesta}/lotti/{idLotto}` (tag `Lotti`, modelli `LottoItem` /
> `CreaLottoRequest`). Persistenza reale su `sprint.sprint_t_lotto` (PK `id_lotto` da
> `seq_sprint_t_lotto`; colonne `n_lotto`, `importo`, `priorita`, `anno`, `fk_richiesta_generica`).
> Campi obbligatori (`nLotto`, `importo`, `priorita`, `anno`) validati lato BE con `ValidazioneException`
> (400) e lato FE con `Validators.required`. **Deferred**: colonne `progr_annuale` /
> `provvedimento_finanziamento`, totale importi e nota scala priorità PAI.

### 1.4 Soggetto richiedente

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Tipo ente | **select** | `**` (sempre) | lookup `TIPO_AGGR_ENTE` | onchange ricarica; readonly+hidden se utente provincia |
| Nome ente | **select** | `**` (38/straord./sopr./54/183) | lookup `NOME_ENTE` | |
| Altro ente | text | `**` (38/straord./sopr./54/183) | `richiesta.altroEnte` | |
| Codice fiscale ente | text (maxlength 16) | — | `richiesta.enteCodiceFiscale` | |
| Provincia | **select** | — | `ELENCO_PROVINCE_BY_REGIONE` | onchange ricarica → filtra Comune |
| Comune | **select** | — | `ELENCO_COMUNI_BY_PROVINCIA` | dipende da Provincia |
| Indirizzo | text | — | `richiesta.enteIndirizzo` | |

### 1.5 Anagrafica referente *(blocco `<div class="area">`)*

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Nome | text (maxlength 25) | — | `richiesta.referenteEnteNome` | |
| Cognome | text (maxlength 25) | — | `richiesta.referenteEnteCognome` | |
| Telefono | text (maxlength 15) | — | `richiesta.referenteEnteTelefono` | |

### 1.6 Amministrazione esecutrice

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Tipo ente | **select** | — | lookup `TIPO_AGGR_AMM_ESECUTRICE` | onchange ricarica → filtra Nome ente |
| Nome ente | **select** | `**` (54/183) | lookup `AMMINISTRAZIONE_ESECUTRICE` | dipende da Tipo ente |

### 1.7 Compilatore (soggetto che inserisce i dati della richiesta)

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Soggetto compilatore | readonly | — | `soggettoCompilatore` | testo |
| Settore | readonly | — | `richiesta.settoreCompilatore` | testo |
| Corelatore | text + autocomplete | — | `richiesta.corelatore` | suggest cognome (servizio esterno) |

### 1.8 Informazioni sulle fasi tecnico-amministrative
*(sezione condizionata: `ID_SEZIONE_INFORMAZIONI_FASI_TECNICO_AMM`)*

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Eventuale inserimento nella programmazione | **select** | — | lookup `FK_TIPO_PROGRAMMAZIONE` | campo cond. `ID_CAMPO_TIPO_PROGRAMMAZIONE` |
| Descrizione altro | text | — | `richiesta.sprintTRic1854183.descAltraProgrammazione` | campo cond. `ID_CAMPO_DESCRIZIONE_ALTRO` |
| Programma avviato | radio Sì/No | — | `richiesta.sprintTRic1854183.flgStatoProgramma` | campo cond. `ID_CAMPO_PROGRAMMA_AVVIATO` |

#### 1.8.1 Stato della progettazione *(blocco `<div class="area">`, campo condizionato `ID_CAMPO_STATO_PROGETTAZIONE`)*

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Progetto | **select** | — | lookup `FK_PROGETTAZIONE` | |
| Data | date | — | `dataProgettazione` | formato `dd/MM/yyyy` (`validation-richiesta.xml`) |
| Estremi di approvazione | text | — | `richiesta.sprintTRic1854183.progettazionePrelEstremi` | |

#### 1.8.2 Metadati fasi tecnico-amministrative (checklist)

Tabella iterata (`sezioniInfoFasiTecnicoAmministrative` × `sprintMtdRic1854183s`): righe a gruppi con
**multibox** (checkbox) per le metodologie/fasi (`ids`). Selezione multipla per sezione. Dinamica da DB.

> Legenda `**` per legge: `38`=L.38, `54`=L.54, `183`=L.183, `straord.`=straordinaria, `sopr.`=sopralluogo,
> `18`=L.18 (per L.18 il blocco `**` non è mostrato — vedi nota JSP righe 142-145).

---

> **Implementazione (2026-06-19).** Eseguito lo scope prioritario a build verdi (BE+FE OK).
> **FATTO:**
> - **T1** — `motivoIntervento` e `categoriaIntervento` ora **select** su lookup `FK_MOTIVO_INTERVENTO`
>   / `FK_TIPO_INTERVENTO`. Nuovi endpoint lookup `GET /motivi-intervento`, `GET /tipi-intervento`
>   (`LookupManager.findLookupByNomeColonna`, impl analoghe a `/tipi-dissesto`). Round-trip reale per
>   descrizione: il GET espone la descrizione, il PATCH risolve la FK via `RichiestaPatchLookupHelper`
>   (mapper persist già esistente).
> - **T10** — `statoProgettazione` ora **select** su lookup `FK_PROGETTAZIONE` (nuovo endpoint
>   `GET /stati-progettazione`). Round-trip reale via `updateProgettazione1854` (già esistente).
> - **Ristrutturazione folder** sulle sezioni legacy: Effetti del danno (1.1), Descrizione intervento
>   (1.2), Valutazione economica (1.3, parziale), Soggetto richiedente (1.4), Compilatore (1.7),
>   Informazioni fasi tecnico-amministrative (1.8, parziale — solo Stato progettazione). Rimossa la
>   sezione "Compilatore e fasi" flat.
> - **T12** — rimosso `dataSopralluogo` dal form/template di questa folder (non appartiene al legacy
>   qui). Per non azzerare la colonna ad ogni salvataggio, `updateTecnicoAmministrativi` ora usa
>   `COALESCE(#{dataSopralluogo}, data_sopralluogo)`.
> - **T15** (parziale) — marcatori `*`/`**` per-legge sui label (statici, derivati dalla tabella
>   legacy §1) + maxlength certi (`relazioneIntervento` 4000, `durataLavori` 4). Predisposto anche
>   l'aggancio metadati (`/richieste/metadati/{idLegge}` → `obbligatorioSalvataggio`) come dati-generali:
>   `idLegge` ora passato dal parent; i validator si attivano per i nomi campo eventualmente esposti.
> - Importo richiesto e Compilatore (nome/cognome) resi **readonly** (calcolati dal sistema).
>
> **DEFERRED (non mockato, richiede nuovi campi DTO / entità / metadati BE):**
> - **T2** Opera prevalente (Macro→Tipologia), **T3** importi urgente/definitivo/somma urgenza,
>   ordinanza+data, provvedimento finanziamento, RENDIS, ARCHIVIO OOPP,
>   **T5** Soggetto richiedente completo (select anagrafiche aggregati, Altro ente, CF, Provincia/Comune,
>   Indirizzo), **T6** Anagrafica referente, **T7** Amministrazione esecutrice, **T8** Settore/Corelatore
>   compilatore, **T9** Tipo programmazione/Descrizione altro/Programma avviato, **T11** checklist fasi
>   (`SPRINT_MTD_*`), **T13** Settore + Necessità/Obiettivo/Effetti intervento, **T14** visibilità per
>   legge di sezioni/campi, **T16** select dipendenti (Macro→Tipo opere, Provincia→Comune, Tipo→Nome ente).
> - **T15 residuo:** obbligatorietà `**` dei campi tecnico non ancora nei metadati BE (`MetadatiManager`
>   espone oggi solo i campi di dati-generali); i marcatori sono statici finché i metadati non li includono.
>
> **Stato gap:** T1 ✅ · T2 🟡(BE) · T3 🟡(BE) · T4 ✅ (CRUD Lotti) · T5 🟡(BE) · T6 ✅(BE) · T7 🟡(BE) · T8 ⏸️ · T9 ⏸️ · T10 ✅ ·
> T11 ⏸️ · T12 ✅ · T13 ⏸️ · T14 ✅(BE) · T15 🟡(parziale) · T16 ⏸️.
>
> **Persistenza scalari (fase round-trip DB).** I campi select/lookup di questa folder
> (`motivoIntervento`→`fk_motivo_intervento`, `categoriaIntervento`→`fk_tipo_intervento`,
> `statoProgettazione`→`fk_progettazione` su `sprint_t_ric_18_54_183`) e gli altri scalari
> (`agibilita/percorribilita/esercizio`, `relazioneIntervento`, `dataInizioLavori`, `durataLavori`,
> `codiceCup`, `nomeEnte`/`tipoEnte`→`altro_ente`, `nomeCompilatore`/`cognomeCompilatore`) sono **già
> persistiti realmente** (read+save) dalla fase precedente.
>
> ---
>
> ## Aggiornamento (2026-06-19, fase 2) — sotto-strutture tecnico-amm. + visibilità per legge
>
> **Sotto-strutture (read+save reali su `sprint_t_ric_generica`).** `DatiTecnicoAmministrativiDto`
> esteso in modo additivo (openapi rigenerato BE+FE). Mappatura campo DTO → colonna reale:
>
> | Blocco | Campo DTO | Colonna `sprint_t_ric_generica` | Note BE |
> |--------|-----------|----------------------------------|---------|
> | T5 Soggetto richiedente | `tipoEnte` (read da `fk_tipo_ente`) | `fk_tipo_ente` (varchar, codice aggregato) | select su `/tipi-ente`; nessun lookup numerico |
> | T5 | `altroEnte` | `altro_ente` | campo dedicato (read diretto) |
> | T5 | `enteCodiceFiscale` | `ente_codice_fiscale` (maxlen 16) | |
> | T5 | `enteComune` | `ente_comune` | |
> | T5 | `enteProvincia` | `ente_provincia` | |
> | T5 | `enteIndirizzo` | `ente_indirizzo` | |
> | T6 Anagrafica referente | `referenteNome` | `referente_ente_nome` (maxlen 25) | |
> | T6 | `referenteCognome` | `referente_ente_cognome` (maxlen 25) | |
> | T6 | `referenteTelefono` | `referente_ente_telefono` (maxlen 15) | |
> | T7 Amministrazione esecutrice | `tipoAmmEsecutrice` | `fk_tipo_amm_esecutrice` (varchar, codice aggregato) | select su `/tipi-amm-esecutrice` |
> | T7 | `altraAmmEsecutrice` | `altra_amm_esecutrice` | |
> | T2 Opera prevalente | `tipoOpere` | `fk_tipo_opere` (FK numerica, default 0 NOT NULL) | lookup `FK_TIPO_OPERE` via `/tipi-opere`; COALESCE in update |
> | T2/T1.2 | `descrizioneIntervento` (alias di `relazioneIntervento`) | `descrizione_intervento` | relazioneIntervento prevale |
> | T3 Valutazione economica estesa | `provvedimentoFinanziamento` | `provvedimento_finanziamento` | |
> | T3 | `importoPropostoEnte` | `importo_proposto_ente` (numeric 8,2) | |
> | T3 | `codiceRendis` | `codice_rendis` | |
> | T3 | `codiceArchivio` | `codice_archivio` (ARCHIVIO OOPP) | |
>
> Read: `RicercaMapper.findRichiestaById` (join `tipo_opere` su `sprint_d_richiesta_generica`,
> lettura `fk_tipo_ente`/`fk_tipo_amm_esecutrice` come codice grezzo per round-trip select).
> Mapping read in `RichiestaDetailVoMapper.toDatiTecnicoAmministrativi`; mapping write in
> `RichiestaPersistVoMapper.toTecnicoAmministrativiParams` (lookup `FK_TIPO_OPERE` in
> `RichiestaPatchLookupHelper`). Save: `RichiestaMapper.updateTecnicoAmministrativi` esteso.
> **Nuovi lookup**: `GET /tipi-opere` (FK_TIPO_OPERE), `GET /tipi-amm-esecutrice` (aggregati).
>
> **T14 Visibilità per legge — `LayoutManager` ora DB-backed** (era hardcoded). Folder e sezioni da
> `SPRINT_MTD_FOLDER`/`SPRINT_MTD_SEZIONE`; un folder/sezione/campo associato alla legge in
> `SPRINT_MTD_R1_FOLDERLEGGE`/`R2_SEZIONELEGGE`/`R3_CAMPO_SEZLEGGE` è **nascosto** per quella legge
> (parità legacy `findHidden*ByLegge`, semantica confermata su DB di test). `RichiestaLayoutResponse`
> arricchita con `hiddenFieldIds` (id campo) e nuovo `hiddenFieldNames` (NOME_CAMPO, es. `FK_TIPO_OPERE`,
> `FK_SETTORE_INTERVENTO`): il FE può nascondere sezioni/campi non pertinenti alla legge. Vedi
> [validazione-richieste.md](./validazione-richieste.md).
>
> **DEFERRED (FE/altro):** restyling componenti FE sui nuovi campi/select dipendenti (T16
> Provincia→Comune, Tipo→Nome ente con anagrafiche aggregati di dettaglio), T8 Compilatore
> (Settore/Corelatore), T9 Informazioni fasi (Tipo programmazione/Programma avviato su
> `sprint_t_ric_18_54_183`), T11 checklist fasi (`SPRINT_MTD_*`), T13 Settore + Necessità/Obiettivo/
> Effetti (`sprint_t_ric_18_54_183`). T2 select gerarchico Macro→Tipologia: BE espone la lista piatta
> `FK_TIPO_OPERE`; il filtro per macrotipologia resta lato FE/deferred.
>
> ---
>
> ## Aggiornamento (2026-06-19, fase 3 FE) — nuovi campi/blocchi resi visibili nel folder
>
> Esposti nel componente `dati-tecnico-amministrativi-folder` (solo FE; DTO/endpoint già generati)
> i campi additivi del `DatiTecnicoAmministrativiDto` esteso, mantenendo invariati i campi e il
> round-trip preesistenti. Tutti i controlli sono soggetti a `[readOnly]` via `form.disable()/enable()`
> e persistiti dal PATCH esistente tramite `form.getRawValue()`.
>
> **Blocchi/campi aggiunti al template+form:**
> - **1.2.1 Opera prevalente** (nuovo sotto-blocco) — `tipoOpere` **select** su lookup `FK_TIPO_OPERE`
>   (`RichiesteService.getTipiOpere()` → `LookupItem[]`, value = `descrizione` per round-trip).
> - **1.3 Valutazione economica** estesa — `importoPropostoEnte`, `provvedimentoFinanziamento`,
>   `codiceRendis`, `codiceArchivio` (ARCHIVIO OOPP) come input testo, accanto a `importoRichiesto`/`codiceCup`.
> - **1.4 Soggetto richiedente** completata — `altroEnte`, `enteCodiceFiscale` (maxlen 16),
>   `enteProvincia`, `enteComune`, `enteIndirizzo` come input testo (Tipo/Nome ente restano input,
>   select su anagrafiche aggregati ancora deferred T16).
> - **1.5 Anagrafica referente** (nuova sezione) — `referenteNome` (maxlen 25),
>   `referenteCognome` (maxlen 25), `referenteTelefono` (maxlen 15).
> - **1.6 Amministrazione esecutrice** (nuova sezione) — `tipoAmmEsecutrice` **select** su
>   `EntiService.getTipiAmmEsecutrice()` → `TipoEnteItem[]` (value = `idTipoaggr` codice aggregato,
>   label = `tipoAggr`); `altraAmmEsecutrice` input testo. Nome ente esecutrice dipendente: deferred.
>
> **Lookup caricati** in `loadLookups()` (constructor, con `takeUntilDestroyed`): `getTipiOpere()`,
> `getTipiAmmEsecutrice()` (inject `EntiService`). Nessun nuovo `@Input` aggiunto.
>
> **Stato gap aggiornato:** T2 🟢(FE, Tipologia visibile; Macro→filtro deferred) · T3 🟢(FE, RENDIS/
> ARCHIVIO/provv./importo proposto visibili; importi urgente/definitivo/somma urgenza+ordinanza deferred) ·
> T5 🟢(FE, Altro ente/CF/Provincia/Comune/Indirizzo visibili; select dipendenti deferred) ·
> T6 ✅(FE+BE) · T7 🟢(FE, Tipo + Altra amm.; Nome ente esecutrice deferred).
>
> **Assunzioni FE:** `tipoOpere` round-trip per descrizione (coerente con le altre select del folder);
> `tipoAmmEsecutrice` round-trip per codice aggregato (`idTipoaggr`), coerente con la lettura BE del
> `fk_tipo_amm_esecutrice` come codice grezzo. `descrizioneIntervento` (alias di `relazioneIntervento`)
> **non** esposto come campo separato per evitare doppio controllo sullo stesso dato (BE: relazione prevale).

## 2. Gap rispetto all'attuale

L'Angular attuale ha **5 sezioni** e **16 campi flat** (textarea/input semplici), mentre il legacy ha
**8 sezioni** + sotto-blocchi con select-lookup, griglia lotti, checklist dinamica e dipendenze
padre→figlio. Mappa dei campi attuali → legacy:
`agibilita/percorribilita/esercizio`→1.1; `relazioneIntervento/motivoIntervento/categoriaIntervento/dataInizioLavori/durataLavori`→1.2;
`importoRichiesto/codiceCup`→1.3 (parziale); `tipoEnte/nomeEnte`→1.4 (parziale);
`nomeCompilatore/cognomeCompilatore`→1.5/1.7 (ambiguo); `dataSopralluogo`→**non esiste nel legacy** di questa folder; `statoProgettazione`→1.8.1 (ma è una select, non testo).

| # | Gap | Tipo |
|---|-----|------|
| T1 | `motivoIntervento`, `categoriaIntervento` → **select** con lookup `FK_MOTIVO_INTERVENTO` / `FK_TIPO_INTERVENTO` (oggi input testo) | FE + BE (endpoint lookup) |
| T2 | Sezione **Opera prevalente** assente: Macrotipologia + Tipologia (select gerarchici `FK_MACRO_TIPO_OPERE_LIST` → `FK_TIPO_OPERE`) | FE + BE (lookup + filtro per macro) |
| T3 | **Valutazione economica** ridotta a 2 campi: mancano importo urgente/definitivo/somma urgenza, ordinanza+data, provvedimento finanziamento, Codice RENDIS, Codice ARCHIVIO OOPP | FE + DTO/BE |
| T4 | **Tabella Lotti** ✅ **FATTO**: griglia CRUD (N° lotto/Importo/Priorità/Anno) + form inserimento + elimina per riga. Endpoint `GET/POST /richieste/{id}/lotti`, `DELETE /richieste/{id}/lotti/{idLotto}`; persistenza reale su `sprint_t_lotto` (`seq_sprint_t_lotto`). **Deferred**: totale importi, nota scala priorità PAI, colonne `progr_annuale`/`provvedimento_finanziamento` | — |
| T5 | **Soggetto richiedente** incompleto: oggi `tipoEnte`/`nomeEnte` sono input; mancano Altro ente, CF ente, Provincia/Comune (select dipendenti), Indirizzo. Tipo/Nome ente → select lookup | FE + BE |
| T6 | **Anagrafica referente** assente (Nome/Cognome/Telefono referente ente) | FE + DTO/BE |
| T7 | **Amministrazione esecutrice** assente (Tipo ente + Nome ente select dipendenti) | FE + BE |
| T8 | **Compilatore**: oggi `nomeCompilatore`/`cognomeCompilatore` input liberi; legacy ha Soggetto/Settore **readonly** + Corelatore con autocomplete | FE (+ readonly da response) |
| T9 | **Informazioni fasi tecnico-amministrative** assenti: Tipo programmazione (select), Descrizione altro, Programma avviato (radio) | FE + DTO/BE |
| T10 | **Stato della progettazione**: oggi `statoProgettazione` è input; legacy = Progetto (select `FK_PROGETTAZIONE`) + Data + Estremi approvazione | FE + BE |
| T11 | **Checklist fasi** (multibox dinamici da `SPRINT_MTD_*`) assente | FE + BE (metadati) |
| T12 | `dataSopralluogo` nel DTO/FE **non appartiene** a questa folder nel legacy → **rimuovere** (o verificarne la provenienza) | FE + DTO |
| T13 | `Settore`, `Necessità/Obiettivo/Effetti intervento` (campi L.18/54/183) assenti | FE + DTO/BE |
| T14 | **Visibilità per legge** di sezioni/campi (`isSectionVisible`/`isFieldVisible`/`isFolderVisible`) non gestita: l'attuale mostra tutto a tutte le leggi | FE + BE (metadati visibilità) |
| T15 | Marcatori `*`/`**` (per-legge) sui label + maxlength (`descrizione` 4000, durata 4, CF 16, ecc.) assenti | FE (da metadati, vedi [validazione-richieste.md](./validazione-richieste.md)) |
| T16 | Select **dipendenti** (Macro→Tipo opere, Provincia→Comune, Tipo ente→Nome ente) non gestite | FE (reload client su `valueChanges`) |

> L'Angular attuale mostra **troppo poco**: i 16 campi flat coprono solo una frazione del legacy
> (mancano ~6 blocchi: Opera prevalente, Lotti, Anagrafica referente, Amministrazione esecutrice,
> Fasi tecnico-amministrative, Stato progettazione). Mostra inoltre **un campo di troppo**
> (`dataSopralluogo`, T12) non presente in questa folder legacy, e usa input liberi dove il legacy
> usa select su lookup (`motivoIntervento`, `categoriaIntervento`, `tipoEnte`, `nomeEnte`,
> `statoProgettazione`).

## 3. Note implementative

- **Obbligatorietà**: a differenza di *dati generali*, qui `validation-richiesta.xml` non impone
  alcun `required` su `/saveDatiTecnicoAmministrativi`; i `**` sono **condizionali per legge** nel JSP.
  L'allineamento `*`/`**` va guidato dai metadati `/richieste/metadati/{idLegge}`
  (`obbligatorioSalvataggio`/`obbligatorioInvio`) × visibilità per legge, come da
  [validazione-richieste.md](./validazione-richieste.md). I vincoli **certi** sono di formato/lunghezza:
  `descrizione` maxlength 4000, `durataLavori` int maxlen 4, `dataInizioLavori`/`dataProgettazione`
  formato `dd/MM/yyyy`, CF ente maxlen 16, campi lotto (`/inserisciLotto`).
- **Lookup**: le select vivono in `SPRINT_D_RICHIESTA_GENERICA` per `NOME_COLONNA`
  (`FK_MOTIVO_INTERVENTO`, `FK_TIPO_INTERVENTO`, `FK_SETTORE_INTERVENTO`, `FK_MACRO_TIPO_OPERE_LIST`,
  `FK_TIPO_OPERE`, `FK_TIPO_PROGRAMMAZIONE`, `FK_PROGETTAZIONE`) riusabili con
  `findLookupByNomeColonna` (già implementato, vedi [dati-generali-folder.md](./dati-generali-folder.md)).
  `TIPO_AGGR_ENTE`/`NOME_ENTE`/`TIPO_AGGR_AMM_ESECUTRICE`/`AMMINISTRAZIONE_ESECUTRICE` provengono dalle
  anagrafiche aggregati (non da `SPRINT_D_RICHIESTA_GENERICA`): richiedono endpoint dedicati.
- **Select dipendenti**: nel legacy ricaricano la pagina (`reloadDatiTecnicoAmministrativi.do`);
  in Angular si gestiscono lato client reagendo al `valueChanges` della select padre
  (Macro→Tipo opere, Provincia→Comune, Tipo ente→Nome ente).
- **Visibilità per legge** (T14): sezioni/campi sono mostrati condizionatamente
  (`isSectionVisible`/`isFieldVisible`/`isFolderVisible` su `SPRINT_MTD_*`). Predisporre i metadati
  di visibilità prima di completare la folder, altrimenti l'attuale espone campi non pertinenti.
- **DTO da estendere**: l'attuale `DatiTecnicoAmministrativiDto` (16 stringhe) è largamente insufficiente.
  Serve ristrutturarlo sui blocchi legacy (descrizione intervento, opera prevalente, valutazione
  economica + lotti, soggetto richiedente, referente, amministrazione esecutrice, compilatore, fasi,
  stato progettazione) con i campi/tipi corretti e gli id lookup, non solo `String`.
- **Lotti** (T4) e **checklist fasi** (T11) sono strutture **a collezione**: richiedono entità/endpoint
  dedicati (CRUD lotti; selezione multipla metodologie), non un semplice patch piatto.
