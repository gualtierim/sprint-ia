# Validazione campi obbligatori — richieste di finanziamento

Analisi dei **campi obbligatori** nei form di **inserimento** e **modifica** delle richieste di
finanziamento, con la validazione **lato backend** (`sprintbff`) e **lato frontend** (`sprintwcl`),
confrontati con il comportamento **legacy** (autoritativo). Propedeutico all'allineamento della
validazione.

> **Implementazione (2026-06-19).** Scelto l'approccio **ibrido**: obbligatorietà *codificata* (dal
> `validation-richiesta.xml`) **×** visibilità *per legge dal DB* (`SPRINT_MTD_*`, un campo nascosto
> per la legge non è obbligatorio). Il DB **non** contiene un flag di obbligatorietà. Fatti:
> **G1** (validazione creazione backend → 400 con `fields`), **B2** (`getMetadatiByLegge` ora reale,
> DB-backed), **G4** (frontend *dati generali* applica i validator guidati dai metadati). Build BE+FE OK.

Collegata a: [creazione-richiesta.md](./creazione-richiesta.md), [api-da-implementare.md](./api-da-implementare.md).

**Fonti:**

| Livello | Artefatto |
|---------|-----------|
| Legacy (autoritativo) | `sprintj/.../WEB-INF/validation-richiesta.xml` (Apache Commons Validator) |
| Backend invio | `sprintbff/.../api/manager/RichiesteManager.java` → `inviaRichiesta` |
| Backend creazione | `RichiesteManager.creaRichiesta` |
| Backend metadati | `RichiesteManager`/`MetadatiManager.getMetadatiByLegge` + VO `CampoMetadatoItem`, `InvioValidazioneResponse` |
| Frontend creazione | `sprintwcl/.../pages/richiesta/nuova-richiesta/nuova-richiesta.component.ts` |
| Frontend wizard | `sprintwcl/.../pages/richiesta/folders/*` + `richiesta-detail.component.ts` |

---

## 1. Riepilogo (TL;DR)

| Ambito | Legacy | Backend nuovo | Frontend nuovo |
|--------|--------|---------------|----------------|
| **Creazione** (oggetto, legge, comune) | obbligatori | ❌ nessuna validazione | ✅ validator reattivi |
| **Dati generali** (macrocategoria, categoria, stato, data inserimento) | obbligatori | ❌ | ❌ (ngModel senza `required`) |
| **Invio** | validazione completa per legge | ✅ campi `obbligatorioInvio` per legge (driven dai metadati) | ❌ non gestito |
| **Metadati obbligatorietà** | da DB per legge | ✅ codificata × visibilità DB, 4 folder (G/T-A/Eco/Rischio) | ⚠️ consumati su dati generali |

**Conclusione:** oggi è validata **solo la creazione lato frontend**. Il wizard di modifica non
ha validazione di obbligatorietà né lato FE né lato BE; l'invio controlla solo 2 campi; i metadati
di obbligatorietà esistono ma sono finti e inutilizzati.

---

## 2. Legacy — campi obbligatori (autoritativo)

Da `validation-richiesta.xml` (`depends="required"`):

### 2.1 Creazione bozza — `/saveNuovaRichesta`
| Campo | Vincolo |
|-------|---------|
| `richiesta.descrizioneDanno` | required (Oggetto) |
| `idLeggeRichiesta` | required (Legge) |
| `idSuggestComune` | required (Comune) |
| `idEventoStraordinario` | required *(commentato nel legacy: condizionale per legge evento)* |

### 2.2 Dati generali — `/saveDatiGenerali`
| Campo | Vincolo |
|-------|---------|
| `dataInserimentoUtente` | required + date `dd/MM/yyyy` |
| `richiesta.descrizioneDanno` | required (Oggetto) |
| `idMacroCategoria` | required |
| `idCategoria` / `...FkCategoria.id` | required (Categoria) |
| `stato` | required |
| `note` | maxlength 1000 |
| `dataProtocollo*`, `dataPraticaWFR`, `dataSopralluogo`, `dataLetteraComunicazioneFinanziamento`, `dataRicevimentoProtocollo` | formato date (non obbligatori) |

Reload dati generali (`/reloadDatiGenerali`): `idMacroCategoria` required.
Ricerca indirizzo (`/cercaIndirizzoDatiGenerali`): `tokenAddress` required + minlength 3.

### 2.3 Dati tecnico-amministrativi — `/saveDatiTecnicoAmministrativi`
Nessun `required`; solo `descrizione` maxlength 4000 e validazioni di formato date.

### 2.4 Dati economici
- `/saveDatiEconomici`: `annoProgetto` solo formato `yyyy` (non obbligatorio).
- **Lotto** `/inserisciLotto`: `NLotto`, `importoLotto`, `prioritaLotto`, `annoLotto` required.
- **Stralcio** `/inserisciStralcio`: `importoStralcio`, `annoStralcio`, `stralcio.LFin` (Legge) required.

### 2.5 Valutazione pericolosità — `/saveValutazionePericolosita`
Nessun `required`; solo validazioni di formato (double/number/integer/date) con limiti su interi/decimali.

### 2.6 Analisi del rischio / Allegati
- Analisi del rischio: nessuna regola in `validation-richiesta.xml`.
- Allegati: le regole `uploadFile`/`descrizione` required sono **commentate** nel legacy.

> Nota: l'obbligatorietà legacy è anche **modulata per legge** (visibilità folder/sezioni/campi via
> `findHiddenFolderByLegge`/`findHiddenSectionByLegge`/`findHiddenFieldByLegge`): un campo nascosto
> per una legge non è obbligatorio. Vedi B1/B2 in [api-da-implementare.md](./api-da-implementare.md).

---

## 3. Backend nuovo (`sprintbff`) — stato attuale

### 3.1 Creazione — `creaRichiesta` (POST `/richieste`)
**Nessuna validazione** di obbligatorietà: costruisce l'oggetto in-memory dai dati ricevuti.
La validazione dei campi minimi è affidata solo allo schema OpenAPI (`required` nel `CreaRichiestaRequest`, se presente).

### 3.2 Invio — `inviaRichiesta` (POST `/richieste/{id}/invia`)
**G2 fatto (2026-06-19).** `inviaRichiesta` non valida più 2 campi hardcoded: itera **tutti** i campi
con `obbligatorioInvio = true` restituiti da `MetadatiManager.getMetadatiByLegge(idLegge)` per la
legge della richiesta e verifica il valore reale letto dal DB (dettaglio + folder dati generali).
Restituisce `InvioValidazioneResponse { valid, errori[] }`. Fonte di obbligatorietà = i metadati
(obbligatorietà codificata × visibilità DB per legge), quindi un campo nascosto per la legge non
genera errore. Campi controllati all'invio (per dati generali, default legge):
| Campo | Sorgente valore | Messaggio |
|-------|-----------------|-----------|
| `descrizioneDanno` | `detail.descrizioneDanno` / `datiGenerali.descrizioneDanno` | "Oggetto finanziamento obbligatorio" |
| `idLegge` | `detail.idLegge` | "Legge obbligatoria" |
| `idComune` | `detail.idComune` | "Comune obbligatorio" |
| `dataInserimento` | `datiGenerali.dataInserimento` | "Data inserimento obbligatoria" |
| `idMacroCategoria` | `datiGenerali.idMacroCategoria` | "Categoria obbligatoria" |
| `categoria` | `datiGenerali.categoria` | "Sottocategoria obbligatoria" |
| `stato` | `detail.stato.codice` / `datiGenerali.stato` | "Stato obbligatorio" |
| `idEvento` (solo legge 5) | `datiGenerali.idEvento` | "Evento associato obbligatorio" |

I campi metadato delle altre folder (economici/lotto-stralcio, tecnico-amm., analisi rischio)
hanno sorgente non presente sul `RichiestaDetailResponse`: non bloccano oggi l'invio (default
non-vuoto); restano disponibili al FE per i marcatori. Da estendere a runtime quando le folder
saranno popolate sul dettaglio.

### 3.3 Metadati obbligatorietà — `getMetadatiByLegge` (GET `/richieste/metadati/{idLegge}`)
Espone `CampoMetadatoItem { idCampo, nome, obbligatorioSalvataggio, obbligatorioInvio }` con
obbligatorietà **codificata** (da `validation-richiesta.xml`) × **visibilità per legge dal DB**
(`SPRINT_MTD_CAMPO`/`SPRINT_MTD_R3_CAMPO_SEZLEGGE` via `findHiddenCampiByLegge`): un campo nascosto
per la legge → non obbligatorio. **Esteso (2026-06-19)** oltre dati generali alle 3 folder
richieste, così che il FE applichi i marcatori `*`/`**`:

| Folder | Campi esposti | Obbligatorietà | Visibilità (NOME_CAMPO) |
|--------|---------------|----------------|-------------------------|
| Dati generali (1) | descrizioneDanno, idLegge, idComune, dataInserimento, idMacroCategoria, categoria, stato, idEvento | obbl. (idEvento solo legge 5) | DESCRIZIONE_DANNO, FK_TOPE_COMUNE, DATA_INSERIMENTO_UTENTE, FK_CATEGORIA, FK_STATO, FK_EVENTO |
| Tecnico-amministrativi (2) | relazioneIntervento, statoProgettazione, categoriaIntervento | non obbl. (legacy: solo maxlength/formato) | DESCRIZIONE, STATO_PROGRAMMA, FK_TIPO_PROGRAMMAZIONE |
| Economici (3) | lottoNumero/Importo/Priorita/Anno, stralcioImporto/Anno/LeggeFinanziamento, annoProgetto, programmaTriennale | lotto+stralcio obbl. (legacy `/inserisciLotto`, `/inserisciStralcio`); annoProgetto/programma non obbl. | SPRINT_T_LOTTO (lotto), ANNO_ULTIMO_FIN, FK_PROG_TRIENNALE_TRIENNIO |
| Analisi del rischio (5) | elementiRischio, classeVulnerabilita | non obbl. (legacy: nessuna regola) | DESCRIZIONE |

> Il DB metadati **non** ha un flag di obbligatorietà (verificato: nessuna colonna `obblig*` in
> `sprint_mtd_*`); l'obbligatorietà resta codificata, la visibilità è reale dal DB.

### 3.4 PATCH folder
I `patchDati*` non applicano validazione di obbligatorietà (salvano ciò che ricevono).

---

## 4. Frontend nuovo (`sprintwcl`) — stato attuale

### 4.1 Creazione — `nuova-richiesta.component.ts` (reactive form)
| Campo | Validator |
|-------|-----------|
| `descrizioneDanno` | `required` + `maxLength(1000)` |
| `idLegge` | `required` |
| `comuneTesto` | `required` |
| `idComune` | `required` |
| `note` | `maxLength(1000)` |

`submit()`: se `form.invalid` → `markAllAsTouched()` e blocca l'invio. ✅ Coerente col legacy `/saveNuovaRichesta`.

### 4.2 Wizard di modifica — folder `dati-*`
- Usano **template-driven `ngModel`** **senza** `Validators.required` né attributo `required`.
- **Nessuna validazione** di obbligatorietà su dati generali (macrocategoria/categoria/stato/data), economici, ecc.
- I **metadati** di obbligatorietà (`/richieste/metadati/{idLegge}`) **non sono consumati**.
- `richiesta-detail.component.ts` non implementa un flusso di validazione pre-invio.

---

## 5. Gap e proposta di allineamento (da concordare)

| # | Gap | Proposta | Stato |
|---|-----|----------|-------|
| G1 | Backend creazione non valida i campi minimi | In `creaRichiesta`: validare oggetto, legge, comune (parità `/saveNuovaRichesta`) → 400 `Errore` con `fields` | ✅ fatto (`ValidazioneException`→400) |
| G2 | Invio valida solo 2 campi | Estendere `inviaRichiesta` ai campi `obbligatorioInvio` reali (almeno: oggetto, legge, comune, categoria, stato) | ✅ fatto (driven dai metadati per legge) |
| G3 | Metadati obbligatorietà hardcoded e inutilizzati | `getMetadatiByLegge` ora reale: obbligatorietà codificata × visibilità DB per legge | ✅ fatto (B2) |
| G4 | Frontend wizard senza validazione | Validator guidati dai metadati nel folder *dati generali*; save bloccato se invalido | ✅ fatto (dati generali) · ⏳ altri folder |
| G5 | Obbligatorietà per legge non gestita | Visibilità per legge dal DB (campo nascosto → non obbligatorio) | ✅ fatto (in `MetadatiManager`) |

> **Aggiornamento (2026-06-19) — visibilità folder/sezioni/campi per legge (B1/B2/G5 estesa).**
> `LayoutManager` (`GET /richieste/{id}/layout`) non è più hardcoded: legge da DB la struttura
> dell'accordion (`SPRINT_MTD_FOLDER`, `SPRINT_MTD_SEZIONE`) e modula la visibilità per legge tramite
> le relazioni `SPRINT_MTD_R1_FOLDERLEGGE` / `R2_SEZIONELEGGE` / `R3_CAMPO_SEZLEGGE`. Semantica
> confermata sul DB di test: l'associazione folder/sezione/campo↔legge significa **nascosto** per quella
> legge (parità legacy `findHiddenFolderByLegge`/`findHiddenSectionByLegge`/`findHiddenFieldByLegge`,
> coerente con `MetadatiManager.findHiddenCampiByLegge`). `RichiestaLayoutResponse` ora espone, oltre a
> `folders[].visible` / `sections[].visible`, anche `hiddenFieldIds` (id campo) e `hiddenFieldNames`
> (NOME_CAMPO) per consentire al FE di nascondere campi puntuali non pertinenti alla legge. La
> visibilità per legge resta coerente con l'obbligatorietà: un campo nascosto non è obbligatorio.

### Ordine consigliato per "procedere"
1. **G1** — validazione creazione lato backend (rapido, isolato, parità legacy).
2. **G4 (dati generali)** — validatori frontend sui campi obbligatori del folder dati generali.
3. **G2** — estendere la validazione di invio backend.
4. **G3/G5** — metadati da DB + obbligatorietà per legge (dipende da B1/B2).

> Decisione aperta da concordare prima di implementare: **dove vive la verità** dell'obbligatorietà —
> regole esplicite nel codice (semplice, veloce) **oppure** metadati per legge da DB (fedele al legacy,
> ma richiede B1/B2). Raccomandazione: partire con regole esplicite (G1/G2/G4) e migrare ai metadati
> con la fase B.
</content>
