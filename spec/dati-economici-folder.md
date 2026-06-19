# Folder "Dati economici" — allineamento al layout legacy

Mappatura del contenuto della collapse **Dati economici** (`dati-economici-folder`) sul JSP legacy
`datiEconomici.do` (form `saveDatiEconomici`). Le sotto-sezioni `<h4>` del legacy diventano i blocchi
interni della collapse (convenzione di progetto). Legenda obbligatorietà: `*` = obbligatorio
**salvataggio**, `**` = obbligatorio **invio**.

Fonte legacy: JSP `sprintj/.../jsp/richiesta/datiEconomici.jsp` (form `saveDatiEconomici`, azioni
`reloadDatiEconomici.do`, `inserisciStralcio.do`, `eliminaStralcio.do`, `cleanStralcio.do`).
Validazione: `sprintj/.../WEB-INF/validation-richiesta.xml` (form `/saveDatiEconomici`,
`/inserisciStralcio`, `/eliminaStralcio`; il `/inserisciLotto` vive nel folder tecnico-amministrativo).
Stato attuale: `sprintwcl/.../folders/dati-economici-folder/`.

> ⚠️ Molte sezioni/campi del legacy sono condizionati a `isSectionVisible` / `isFieldVisible` (metadati
> di visibilità per legge/configurazione) e a `idLegge` (38 / 54 / 183). Il folder attuale Angular è una
> bozza con soli 10 campi piatti e **non riproduce** né il quadro economico completo né lotti/stralci.

---

## 1. Struttura target (4 sezioni + tabella stralci)

### 1.1 Quadro economico (`ID_SEZIONE_QUADRO_ECONOMICO`)
Tabella verticale 2 colonne. Le righe di importo ricaricano la pagina (`reloadDatiEconomici.do`) per
ricalcolare IVA e totali (campi calcolati `bean:write`, non editabili).

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Lotto | **select** | `**` | `richiesta.NLotto` ← `LOTTI_ASSOCIATI` | visibile solo se `ID_CAMPO_N_LOTTO` visibile; opzioni dai lotti inseriti nel folder tecnico-amm. |
| a) Lavori | currency | — | `costiLavori` | onblur ⇒ `reloadDatiEconomici.do` |
| Tasso IVA sui lavori | select | — | `tassoIva` ← `ELENCO_IVA` | onchange ⇒ reload |
| b) IVA sui lavori | readonly (calc.) | — | `ivaCostiLavori` | calcolato |
| c) Somme a disposizione | readonly (calc.) | — | `sommeADisposizione` | calcolato (c1+c2+c3+c4) |
| c1) Spese generali e tecniche | currency | — | `speseGenTecn` | onblur ⇒ reload |
| c2) Indagine e prove | currency | — | `costiProve` | onblur ⇒ reload |
| c3) Onorari per la sicurezza (D.lgs. 494/1996) | currency | — | `spese49496` | solo se `ID_CAMPO_ONORARI_SICUREZZA` visibile |
| c4) Incentivo per la progettazione (D.lgs. 163/2006) | currency | — | `incentivoProg1632006` | solo se `ID_CAMPO_INCENTIVO_PROGETTAZIONE` visibile |
| Tasso IVA su somme a disposizione | select | — | `tassoIvaDisp` ← `ELENCO_IVA_DISP` | onchange ⇒ reload |
| d) IVA su somme a disposizione | readonly (calc.) | — | `ivaSommeADisposizione` | calcolato |
| e) Espropri | currency | — | `costiEspropri` | onblur ⇒ reload |
| f) Arrotondamenti, imprevisti | currency (anche neg.) | — | `costiImprevisti` | `isCurrencyNegative`; onblur ⇒ reload |
| Totale (a+b+c+d+e+f) | readonly (calc.) | — | `totale` | calcolato |
| Eventuali altri finanziamenti | currency | — | `altriFinanz` | onblur (no reload) |

> Nota legge: per `idLegge` 38 / 54 / 183 il JSP mostra l'avviso "Il conto economico deve essere
> valorizzato per l'invio della richiesta" → l'intero quadro economico è di fatto obbligatorio all'invio
> per queste leggi (vincolo applicativo, non da `validation-richiesta.xml`).

### 1.2 Piano finanziario (`ID_SEZIONE_PIANO_FINANZIARIO`)
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Anno ultimo finanziamento ricevuto | text (max 8) | — | `annoUltimoFinanziamento` | solo se `ID_CAMPO_ANNO_ULTIMO_FINANZIAMENTO` visibile |

#### Richiesta di finanziamento sulle annualità (`ID_SEZIONE_RICHIESTA_FINANZ_ANNUALITA`)
Tabella 3 righe (Anno + Importo), anni hardcoded `2006/2007/2008` nel legacy → da rendere dinamici.

| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Anno (1/2/3) | select | — | `finanziamentoAnno1/2/3` | opzioni anno (oggi statiche) |
| Importo (1/2/3) | currency | — | `finanziamentoImportoAnno1/2/3` | |

### 1.3 Progetto generale (`ID_SEZIONE_PROGETTO_GENERALE`)
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Progetto di riferimento per l'intervento | select | — | `tipoProgetto` ← `TIPO_PROGETTO` | |
| Importo | currency (max 11) | — | `importoProgettoGenerale` | |
| Anno | text (max 4) | — | `annoProgetto` | `date,integer` pattern `yyyy` (unico vincolo di `/saveDatiEconomici`) |
| Legge di finanziamento | text | — | `richiesta.sprintTRic1854183.LFinProg` | |

### 1.4 Stralci eseguiti o finanziati (`ID_SEZIONE_STRALCI_ESEG_FINANZ`)
Form di **inserimento riga** (bottoni `inserisci` ⇒ `inserisciStralcio.do`, `pulisci` ⇒ `cleanStralcio.do`)
+ tabella elenco con radio + bottone `elimina` (⇒ `eliminaStralcio.do`). Sorgente elenco: `form.stralci`
(entity `sprint_t_stralcio` / `TStralcio`).

Form inserimento stralcio (validazione `/inserisciStralcio`):
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Importo | currency (max 11) | `*` (`required`) | `importoStralcio` | |
| Anno | text | `*` (`required,date,integer` pattern `yyyy`) | `annoStralcio` | |
| Legge di finanziamento | text | `*` (`required`) | `stralcio.LFin` | |

Tabella elenco stralci (colonne): radio selezione, **Importo** (`importo`), **Anno** (`anno`),
**Legge di finanziamento** (`LFin`). Se vuota: "Nessuno stralcio presente in archivio".

#### Programma triennale (campo `ID_CAMPO_PROGRAMMA_TRIENNALE`)
| Campo | Tipo | Obbl. | Sorgente | Note |
|-------|------|-------|----------|------|
| Programma triennale - Triennio | select | — | `programmaTriennale` ← `PROGRAMMI_TRIENNALI` | solo se campo visibile |

### (1.5) W.F.R. Dati Economici — **commentata nel legacy**
Blocco `<h4>W.F.R. Dati Economici</h4>` (`noteEc`, `importoA` Importo assegnato, `importoC` Importo a
consuntivo) è interamente **commentato** (`<!-- ... 71862 -->`) e riservato a ruoli centrali → **da non
mostrare**. Il folder Angular attuale espone invece un campo `noteEc` libero che qui **non va** mostrato.

---

## 2. Gap rispetto all'attuale

Il folder Angular attuale (`dati-economici-folder.component.*`) è una bozza con 10 campi piatti
(`importoLavori`, `ivaLavori`, `sommeDisposizione`, `espropri`, `annoUltimoFinanziamento`, `finAnno1`,
`finImporto1`, `progettoRiferimento`, `stralcioImporto`, `noteEc`) su 3 sezioni semplificate e
**non** riproduce lotto, IVA calcolata, totali, annualità multiple, stralci come tabella, programma
triennale. Tutti i gap sotto sono **proposti**.

| # | Gap | Tipo |
|---|-----|------|
| E1 | Sezione **Quadro economico** completa: voci a)–f), c1–c4, due tassi IVA (lavori / somme disp.), campi calcolati (IVA, somme, totale), altri finanziamenti | FE + BE (DTO: aggiungere `speseGenTecn`, `costiProve`, `spese49496`, `incentivoProg1632006`, `costiImprevisti`, `altriFinanz`, `tassoIvaLavori`, `tassoIvaSommeDisp` e i calcolati) — **FE done**: form `quadro` con tutte le voci, select sui due tassi, calcolati readonly. |
| E2 | **Ricalcolo** IVA/somme/totale on-change | FE (calcolo client; il legacy ricaricava via `reloadDatiEconomici.do`) — **FE done**: `computed()` su `valueChanges` del quadro; aliquota dedotta dalla descrizione del lookup IVA. |
| E3 | Campo **Lotto** come select da `LOTTI_ASSOCIATI` (lotti inseriti nel folder tecnico-amm.); `**` invio se `ID_CAMPO_N_LOTTO` attivo | FE + BE (lista lotti associati alla richiesta) — **FE done**: `mat-select` `nLotto` popolata dai lotti reali via `LottiService.getRichiestaLotti({ idRichiesta })` (caricati nell'effect su `idRichiesta` con `takeUntilDestroyed`, signal `lotti`). Opzioni con label/valore = `nLotto` (round-trip DTO invariato; `getRawValue` preserva il valore anche a select disabilitata). La select resta disabilitata in readOnly o quando non ci sono lotti, con hint "Nessun lotto associato". CRUD lotti resta nel folder tecnico-amministrativo (`GET/POST /richieste/{id}/lotti`, `sprint_t_lotto`). |
| E4 | Lookup **Tassi IVA** (`ELENCO_IVA`, `ELENCO_IVA_DISP`) e **Tipo progetto** (`TIPO_PROGETTO`), **Programma triennale** (`PROGRAMMI_TRIENNALI`) | BE: endpoint/i lookup + FE select — **FE done**: caricati in `loadLookups()` (`getTassiIvaLavori/SommeDisp/getTipiProgetto/getProgrammiTriennali`) con `takeUntilDestroyed`. |
| E5 | **Annualità multiple** (3 righe Anno/Importo) al posto del singolo `finAnno1/finImporto1`; anni dinamici (no `2006/2007/2008` hardcoded) | FE + BE (DTO: `finanziamentoAnno1..3`, `finanziamentoImporto1..3`) — **FE done**: `FormArray` annualità (anno/importo) con righe dinamiche aggiungi/rimuovi, bind a `annualita[]`. |
| E6 | Sezione **Progetto generale**: `tipoProgetto`, `importoProgettoGenerale`, `annoProgetto`, `LFinProg` | FE + BE (DTO/persistenza) — **FE done**: form `progettoGenerale` con select tipo progetto + importo/anno/legge. |
| E7 | **Stralci** come sotto-struttura: form inserimento riga (Importo/Anno/Legge, tutti `required`) + tabella elenco + elimina; sostituisce l'attuale singolo `stralcioImporto` | FE (mat-table + form) + BE (CRUD stralci) — **FE+BE done**: BE CRUD reale su `sprint_t_stralcio` (`GET/POST/DELETE /richieste/{id}/stralci`, validazione importo/anno/legge). FE: lista caricata da `StralciService.getRichiestaStralci` all'init; form inserimento (`stralcioForm` con `Validators.required` su importo/anno/legge) → `postRichiestaStralcio`, reset+reload on success, messaggio su 400; colonna azioni con elimina (`deleteRichiestaStralcio` + conferma) reload lista; tutte le subscription `takeUntilDestroyed`. |
| E8 | **Programma triennale** (select) condizionato a `ID_CAMPO_PROGRAMMA_TRIENNALE` | FE + BE (DTO + lookup) — **FE done** (select sempre visibile): condizione di visibilità `ID_CAMPO_PROGRAMMA_TRIENNALE` deferred (vedi E10). |
| E9 | **Rimuovere** campo `noteEc` (W.F.R.) dal folder: blocco commentato/riservato nel legacy | FE — **FE done**: `noteEc` non più presente nel folder. |
| E10 | **Visibilità condizionale** di sezioni/campi (metadati per legge + `idLegge` 38/54/183) e avviso "conto economico obbligatorio per l'invio" | FE (da metadati) + BE — **deferred**: predisposto `@Input() idLegge` opzionale, logica visibilità non implementata. |
| E11 | Marcatori `*` / `**` sui label (Lotto `**`; campi stralcio `*` nel sotto-form) | FE (da metadati) — **deferred**: dipende da metadati/CRUD stralci. |
| E12 | **Modalità VIEW/readonly**: nel legacy gli importi in VIEW sono solo `bean:write` formattati; mappare su `readOnly()` del folder | FE — **FE done**: `applyReadOnly()` disabilita tutti i gruppi e il `FormArray`; calcolati sempre disabled. |

## 3. Note implementative

- **Sotto-strutture (lotti / stralci).** Solo gli **stralci** si inseriscono in questo folder
  (`inserisciStralcio.do` / `eliminaStralcio.do`, entity `sprint_t_stralcio` / `TStralcio`). Il **lotto**
  qui è solo una **select** popolata da `LOTTI_ASSOCIATI`: l'inserimento dei lotti (`/inserisciLotto`,
  `sprint_t_lotto` / `TLotto`, campi `NLotto`, `importoLotto`, `prioritaLotto`, `annoLotto` tutti
  `required`) avviene nel folder **dati tecnico-amministrativi** (`datiTecnicoAmministrativi.jsp`,
  sezione "Valutazione economica intervento"). **FATTO:** il CRUD lotti è ora implementato come
  mat-table editabile nel folder tecnico-amministrativo (endpoint `GET/POST /richieste/{id}/lotti`,
  `DELETE /richieste/{id}/lotti/{idLotto}`, `LottoItem`/`CreaLottoRequest`, persistenza su
  `sprint_t_lotto` con `seq_sprint_t_lotto`), mirroring del CRUD stralci. In Angular conviene una
  mat-table editabile per gli stralci (riga di inserimento + elenco con eliminazione), allineata alla
  convenzione [table-columns](../.cursor/skills/table-columns/SKILL.md) dove pertinente.
- **Obbligatorietà.** `validation-richiesta.xml` impone come `required` solo i 3 campi del sotto-form
  stralcio (`importoStralcio`, `annoStralcio`, `stralcio.LFin`) e, su `/saveDatiEconomici`, il solo
  vincolo di formato `date,integer` su `annoProgetto` (nessun `required`). Il "conto economico
  obbligatorio per l'invio" (leggi 38/54/183) è un vincolo **applicativo** lato JSP, non dichiarato in
  validation. I marcatori `*`/`**` vanno guidati dai metadati `/richieste/metadati/{idLegge}`
  (`obbligatorioSalvataggio` / `obbligatorioInvio`), vedi [validazione-richieste.md](./validazione-richieste.md).
- **Campi calcolati.** IVA lavori, somme a disposizione, IVA somme, totale sono **derivati** (nel legacy
  ricalcolati via reload server). In Angular: calcolo lato client su `valueChanges`; tenerli readonly.
- **DTO/endpoint BE.** L'attuale `DatiEconomiciDto` (10 stringhe) e `PatchDatiEconomiciParams` coprono
  solo una frazione dei campi. `PatchDatiEconomiciParams` ha già `costiLavori`, `speseGenTecn`,
  `costiEspropri`, `fkTassoIvaLavori`, `fkTassoIvaSommeDisp`, `noteEc`, `annoUltimoFin`, `annoProg`,
  `importoProg`, `stralcioImporto`, `provvedimentoFinanziamento` → il DTO va esteso e riallineato a
  questi (rigenerando da OpenAPI, mai a mano: vedi skill `sprint-api`). Mancano del tutto: voci c2/c3/c4,
  imprevisti, altri finanziamenti, annualità multiple, progetto generale, programma triennale, e il CRUD
  stralci.
- **Lookup.** Tassi IVA (`ELENCO_IVA`, `ELENCO_IVA_DISP`), tipo progetto (`TIPO_PROGETTO`), programmi
  triennali (`PROGRAMMI_TRIENNALI`) erano collezioni di sessione nel legacy → servono endpoint lookup
  dedicati o un endpoint lookup generico (coerente con l'approccio già usato in `dati-generali`).

## 4. Stato persistenza BE (round-trip DB)

Campi scalari ora persistiti realmente (read nel dettaglio + save via patch folder 3), mappati alle
colonne esistenti:

| Campo DTO | Colonna DB | Tabella | Note |
|-----------|-----------|---------|------|
| `costiLavori` | `costi_lavori` | `sprint_t_ric_generica` | prevale su alias legacy `importoLavori` |
| `tassoIvaLavori` | `fk_tasso_iva_lavori` | `sprint_t_ric_generica` | lookup codice → id (`findIvaLookupIdByCodice`), prevale su `ivaLavori` |
| `speseGenTecn` | `spese_gen_tecn` | `sprint_t_ric_generica` | |
| `costiProve` | `costi_prove` | `sprint_t_ric_generica` | |
| `spese49496` | `spese_494_96` | `sprint_t_ric_generica` | |
| `incentivoProg1632006` | `incentivo_prog_163_2006` | `sprint_t_ric_generica` | |
| `tassoIvaSommeDisp` | `fk_tasso_iva_somme_disp` | `sprint_t_ric_generica` | lookup codice → id |
| `costiEspropri` | `costi_espropri` | `sprint_t_ric_generica` | prevale su alias `espropri` |
| `costiImprevisti` | `costi_imprevisti` | `sprint_t_ric_generica` | |
| `altriFinanz` | `altri_finanz` | `sprint_t_ric_generica` | |
| `nLotto` | `n_lotto` | `sprint_t_ric_generica` | numerico; solo select del lotto (CRUD lotti deferred) |
| `tipoProgetto` | `fk_tipo_progetto` | `sprint_t_ric_18_54_183` | lookup descrizione `FK_TIPO_PROGETTO` → id |
| `importoProgettoGenerale` | `importo_prog` | `sprint_t_ric_18_54_183` | E6 progetto generale |
| `annoProgetto` | `anno_prog` | `sprint_t_ric_18_54_183` | E6 progetto generale |
| `leggeFinProgetto` | `l_fin_prog` | `sprint_t_ric_18_54_183` | E6 progetto generale |
| `finAnno1` | `finanziamento_anno_1` | `sprint_t_ric_18_54_183` | E5 prima annualità (corretto: prima puntava a `anno_prog`) |
| `finImporto1` | `finanziamento_importo_anno_1` | `sprint_t_ric_18_54_183` | E5 prima annualità (corretto: prima puntava a `importo_prog`) |

**Deferred (nessuna colonna scalare dedicata / fuori fase):**
- `ivaCostiLavori`, `sommeADisposizione`, `ivaSommeADisposizione`, `totale`: **calcolati/readonly**, non
  persistiti (derivati lato FE; il legacy li ricalcolava server-side). Nessuna colonna dedicata.
- `programmaTriennale`: lookup `FK_PROG_TRIENNALE_TRIENNIO` (`sprint_t_ric_18_54_183`) presente, ma la
  select FE è ancora condizionata (E8/E10) → persistenza **deferred** in questa fase.
- `annualita[]` (E5 multi-riga): **lista**, fuori fase (solo la prima annualità è persistita).

**FATTO FE+BE — Stralci (E7 CRUD) persistiti su DB reale e cablati a UI:**
- Lettura: `GET /richieste/{id}/stralci` e campo `stralci[]` del `DatiEconomiciDto` popolati da
  `SPRINT_T_STRALCIO` (`StralcioMapper.findStralciByRichiesta`), colonne `id_stralcio`, `importo`,
  `anno`, `l_fin`.
- Inserimento: `POST /richieste/{id}/stralci` (`CreaStralcioRequest` con `importo`/`anno`/
  `leggeFinanziamento` tutti obbligatori → `ValidazioneException` se mancanti/non validi); PK da
  `SEQ_SPRINT_T_STRALCIO`.
- Eliminazione: `DELETE /richieste/{id}/stralci/{idStralcio}` (delete su `SPRINT_T_STRALCIO`).
- Mapper MapStruct `StralcioVoMapper` (Row→`StralcioItem`); `StralcioMapper` MyBatis (XML).
- FE (`dati-economici-folder.component`): la `mat-table` stralci ora ha come sorgente la lista caricata
  da `StralciService.getRichiestaStralci` in un `effect` su `idRichiesta` (non più lo snapshot DTO), così
  riflette il DB e si aggiorna dopo create/delete. Form inserimento (`stralcioForm`, visibile solo se
  `!readOnly()`) con `Validators.required` su importo/anno/legge → `postRichiestaStralcio`; on success
  reset form + reload lista; su HTTP 400 messaggio di validazione via snackbar senza rompere la UI.
  Colonna "azioni" con bottone elimina (solo se `!readOnly()`) → conferma `window.confirm` →
  `deleteRichiestaStralcio` → reload. Tutte le subscription con `takeUntilDestroyed`.
</content>
</invoke>
