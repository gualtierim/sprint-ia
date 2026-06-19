# Mapping API → tabelle

Endpoint definiti in `sprintbff/src/main/resources/static/api/openapi.yaml`.

| Metodo | Path | operationId | Manager | Tabelle |
|--------|------|-------------|---------|---------|
| GET | `/test/ping` | `ping` | `TestManager` | — |
| GET | `/pagine/ricerca-richieste/init` | `getPaginaRicercaRichiesteInit` | `PagineManager` | — (aggregato) |
| GET | `/pagine/ricerca-eventi/init` | `getPaginaRicercaEventiInit` | `PagineManager` | — (aggregato) |
| GET | `/pagine/richiesta/{id}/init` | `getPaginaRichiestaInit` | `RichiesteManager`, `PagineManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` |
| GET | `/province` | `getProvince` | `LookupManager` | — (legacy hardcoded Piemonte) |
| GET | `/leggi` | `getLeggi` | `LookupManager` | `SPRINT_MTD_LEGGE` |
| GET | `/richieste/stati` | `getRichiesteStati` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` |
| GET | `/eventi` | `getEventi` | `LookupManager` | `SPRINT_T_EVENTO`, `SPRINT_R_EVENTO_COMUNE` (straordinario=false → `SPRINT_T_EVENTO` flg=0) |
| GET | `/tipi-ente` | `getTipiEnte` | `LookupManager` | `SPRINT_T_APPG_AGGREGAZIONI` |
| GET | `/tipi-amm-esecutrice` | `getTipiAmmEsecutrice` | `LookupManager` | `SPRINT_T_APPG_AGGREGAZIONI` (stessa anagrafica aggregati di tipi-ente; legacy `TIPO_AGGR_AMM_ESECUTRICE`) |
| GET | `/tipi-opere` | `getTipiOpere` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_TIPO_OPERE'; opera prevalente/tipologia) |
| GET | `/comuni/suggest` | `suggestComuni` | `LookupManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (soloConRichieste=true); `SPRINT_T_CENTROIDE` (soloConRichieste=false, anagrafica completa comuni per nuova richiesta) |
| GET | `/richieste/compilatori/suggest` | `suggestRichiesteCompilatori` | `LookupManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` |
| GET | `/indirizzi/suggest` | `suggestIndirizzi` | `LookupManager` | TOPE → non impl. |
| GET | `/tipi-strada` | `getTipiStrada` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_TIPO_STRADA') |
| GET | `/sedimi` | `getSedimi` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_SEDIME') |
| GET | `/richieste/categorie` | `getRichiesteCategorie` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_CATEGORIA', CODICE='CAT'; idLegge non filtra) |
| GET | `/richieste/macro-categorie` | `getRichiesteMacroCategorie` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (FK_CATEGORIA, CODICE='MC_2019') |
| GET | `/richieste/categorie/{idMacro}/sottocategorie` | `getRichiesteSottocategorie` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (FK_CATEGORIA, CODICE='CAT', FK_PADRE=idMacro) |
| GET | `/tipi-dissesto` | `getTipiDissesto` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_TIPO_DISSESTO') |
| GET | `/relazioni-tecniche` | `getRelazioniTecniche` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FLG_RILIEVO') |
| GET | `/dissesti-pai-prgc` | `getDissestiPaiPrgc` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_DISSESTO_PAI_PRGC') |
| GET | `/tassi-iva-lavori` | `getTassiIvaLavori` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_TASSO_IVA_LAVORI') |
| GET | `/tassi-iva-somme-disp` | `getTassiIvaSommeDisp` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_TASSO_IVA_SOMME_DISP') |
| GET | `/tipi-progetto` | `getTipiProgetto` | `LookupManager` | `SPRINT_D_RIC_18_54_183` (NOME_COLONNA='FK_TIPO_PROGETTO') |
| GET | `/programmi-triennali` | `getProgrammiTriennali` | `LookupManager` | `SPRINT_D_RIC_18_54_183` (NOME_COLONNA='FK_PROG_TRIENNALE_TRIENNIO') |
| GET | `/classi-vulnerabilita` | `getClassiVulnerabilita` | `LookupManager` | `SPRINT_D_ANALISI_RISCHIO` (NOME_COLONNA='FK_VULNERABILITA') |
| GET | `/valutazioni-danno` | `getValutazioniDanno` | `LookupManager` | `SPRINT_D_ANALISI_RISCHIO` (NOME_COLONNA='FK_VAL_DANNO') |
| GET | `/classi-rischio` | `getClassiRischio` | `LookupManager` | `SPRINT_D_ANALISI_RISCHIO` (NOME_COLONNA='FK_VAL_RISCHIO'; classe calcolata in sola lettura) |
| GET | `/pericolosita/frana-tipi` | `getPericolositaFranaTipi` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_FRANA_TIPO') |
| GET | `/pericolosita/frana-velocita` | `getPericolositaFranaVelocita` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_FRANA_VELOCITA') |
| GET | `/pericolosita/frana-stato-attivita` | `getPericolositaFranaStatoAttivita` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_FRANA_STATO_ATTIVITA') |
| GET | `/pericolosita/frana-distr-attivita` | `getPericolositaFranaDistrAttivita` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_FRANA_DISTR_ATTIVITA') |
| GET | `/pericolosita/frana-pres-interventi` | `getPericolositaFranaPresInterventi` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_FRANA_PRES_INTERVENTI') |
| GET | `/pericolosita/frana-pres-opere-negative` | `getPericolositaFranaPresOpereNegative` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_FRANA_PRES_OPERE_NEGATIVE') |
| GET | `/pericolosita/conoide-asprezza-melton` | `getPericolositaConoideAsprezzaMelton` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_CONOIDE_I_ASPREZZA_MELTON') |
| GET | `/pericolosita/conoide-diametro-interno` | `getPericolositaConoideDiametroInterno` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_CONOIDE_DIAMETRO_INTERNO') |
| GET | `/pericolosita/conoide-pendenza` | `getPericolositaConoidePendenza` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_CONOIDE_PENDENZA') |
| GET | `/pericolosita/conoide-ricorrenza` | `getPericolositaConoideRicorrenza` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_CONOIDE_RICORRENZA') |
| GET | `/pericolosita/conoide-pres-interventi` | `getPericolositaConoidePresInterventi` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_CONOIDE_PRES_INTERVENTI') |
| GET | `/pericolosita/conoide-pres-opere-negative` | `getPericolositaConoidePresOpereNegative` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_CONOIDE_PRES_OPERE_NEGATIVE') |
| GET | `/pericolosita/valanga-ricorrenza` | `getPericolositaValangaRicorrenza` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_VALANGA_RICORRENZA') |
| GET | `/pericolosita/valanga-volume` | `getPericolositaValangaVolume` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_VALANGA_VOLUME') |
| GET | `/pericolosita/valanga-pres-interventi` | `getPericolositaValangaPresInterventi` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_VALANGA_PRES_INTERVENTI') |
| GET | `/pericolosita/idro-tempo-ritorno` | `getPericolositaIdroTempoRitorno` | `LookupManager` | `SPRINT_D_RIC_183` (NOME_COLONNA='FK_IDRO_SUP_TR') |
| GET | `/richieste/metadati/{idLegge}` | `getRichiesteMetadatiByLegge` | `MetadatiManager` | `SPRINT_MTD_CAMPO`, `SPRINT_MTD_R3_CAMPO_SEZLEGGE` (visibilità per legge; obbligatorietà codificata) |
| POST | `/richieste/cerca` | `cercaRichieste` | `RicercaManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` |
| POST | `/richieste/cerca/geometrie` | `cercaRichiesteGeometrie` | `RicercaManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` |
| POST | `/richieste/cerca/export` | `esportaRichiesteCsv` | `RicercaManager` | `VSDE_RIC_38_STRAO_PT_TUTTE`, `SPRINT_MTD_CAMPO_RIS_RICERCA`, `SPRINT_MTD_R_CAMPO_OGGPROF`, `SPRINT_MTD_OGGETTO`, `SPRINT_MTD_PROFILO_UTENTE` |
| GET | `/richieste/colonne-risultato` | `getRichiesteColonneRisultato` | `RicercaManager` | `SPRINT_MTD_CAMPO_RIS_RICERCA`, `SPRINT_MTD_R_CAMPO_OGGPROF`, `SPRINT_MTD_OGGETTO`, `SPRINT_MTD_PROFILO_UTENTE` |
| POST | `/eventi/cerca` | `cercaEventi` | `RicercaManager` | `SPRINT_T_EVENTO`, `SPRINT_D_EVENTO`, `SPRINT_R_EVENTO_COMUNE`, `SPRINT_T_CENTROIDE` (nome comune), `SPRINT_T_AREA_IDRO`, `SPRINT_R_AREA_IDRO_EVENTO` (province: lista statica Piemonte) |
| POST | `/eventi/cerca/export` | `esportaEventiCsv` | `RicercaManager` | come `/eventi/cerca` (export intero result set in CSV, colonne fisse tabella a video) |
| POST | `/richieste` | `creaRichiesta` | `RichiesteManager` | `SEQ_SPRINT_T_RIC_GENERICA`, `SPRINT_T_RIC_GENERICA`, `SPRINT_R_RIC_GENERICA_COMUNE`, `GEO_PT_INTERVENTO`, `SPRINT_R_GEOMETRIA_RICHIESTA` (INSERT reali, @Transactional, stato Bozza); valida obbligatori oggetto/legge/comune → 400 |
| GET | `/richieste/{id}` | `getRichiesta` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE`; fallback `SPRINT_T_RIC_GENERICA` ⋈ `SPRINT_D_RICHIESTA_GENERICA` (`findRichiestaHeaderById`) quando la vista non aggancia la riga perché priva di geometria (Bozza non georiferita): header minimo, legge ricavata da `COD_RICHIESTA` |
| DELETE | `/richieste/{id}` | `eliminaRichiesta` | `RichiesteManager` | `SPRINT_T_ALLEGATO_RIC`, `SPRINT_R_RICGEN_ALLEGATO`, `SPRINT_T_RIC_GENERICA` (DELETE reali, @Transactional; solo stato Bozza → altrimenti 400; replica legacy eliminaRichieste, corretto bug multi-allegato) |
| GET | `/richieste/{id}/dati-mappa` | `getRichiestaDatiMappa` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/dati-generali` | `getRichiestaDatiGenerali` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/dati-tecnico-amministrativi` | `getRichiestaDatiTecnicoAmministrativi` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/dati-economici` | `getRichiestaDatiEconomici` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/valutazione-pericolosita` | `getRichiestaValutazionePericolosita` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE`, `SPRINT_T_RIC_183` (30 colonne frane/conoidi/valanghe/idro + hazard), `SPRINT_D_RIC_183` (descrizioni domini join) |
| GET | `/richieste/{id}/analisi-del-rischio` | `getRichiestaAnalisiDelRischio` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (FK + descrizioni), `SPRINT_MTD_ANALISI_RISCHIO` + `SPRINT_R_ANALISI_DINAMICA` (matrice elementi a rischio), `SPRINT_D_ANALISI_RISCHIO` (codice/descrizione per calcolo classe di rischio R4) |
| GET | `/richieste/{id}/layout` | `getRichiestaLayout` | `LayoutManager` | `SPRINT_MTD_FOLDER`, `SPRINT_MTD_SEZIONE` (struttura accordion), `SPRINT_MTD_R1_FOLDERLEGGE`, `SPRINT_MTD_R2_SEZIONELEGGE`, `SPRINT_MTD_R3_CAMPO_SEZLEGGE`, `SPRINT_MTD_CAMPO` (visibilità per legge: folder/sezione/campo associato a una legge = nascosto; parità legacy `findHidden*ByLegge`) |
| GET/PUT | `/richieste/{id}/geometria` | `get/putRichiestaGeometria` | `RichiesteManager` | `GEO_PT_INTERVENTO` (ST_X/ST_Y, ST_MakePoint SRID 32632), `SPRINT_R_GEOMETRIA_RICHIESTA` (read/write reali su DB, @Transactional su PUT) |
| PATCH | `/richieste/{id}/dati-*` | `patchRichiesta*` | `RichiesteManager` | `SPRINT_T_RIC_GENERICA`, `SPRINT_T_RIC_38_CALAMITA`, `GEO_PT_INTERVENTO`, `SPRINT_T_RIC_18_54_183`, `SPRINT_T_RIC_183`, `SPRINT_T_ANALISI_RISCHIO`, `SPRINT_R_ANALISI_DINAMICA` (matrice elementi a rischio: delete-all + insert, @Transactional; `fk_val_rischio` = classe calcolata R4), `SPRINT_T_STRALCIO` |
| PATCH | `/richieste/{id}/folders/{idFolder}` | `patchRichiestaFolder` | `RichiesteManager` | come sopra (delega ai patch per folder) |
| GET/DELETE | `/richieste/{id}/allegati`, `/allegati/{idAllegato}` | `getRichiestaAllegati`, `getRichiestaAllegatoById`, `deleteRichiestaAllegato` | `RichiesteManager` (`AllegatoMapper`) | `SPRINT_T_ALLEGATO_RIC`, `SPRINT_R_RICGEN_ALLEGATO` (lista/dettaglio/delete reali su DB) |
| POST | `/richieste/{id}/allegati` (JSON metadati) | `postRichiestaAllegato` | `RichiesteManager` | 501: blob `allegato_ric` NOT NULL → usare upload |
| POST | `/richieste/{id}/allegati/upload` | `uploadRichiestaAllegato` | `RichiesteManager` (`AllegatoMapper`) | `SPRINT_T_ALLEGATO_RIC` (insert metadati+blob, PK da `SEQ_SPRINT_T_ALLEGATO_TIC`), `SPRINT_R_RICGEN_ALLEGATO` |
| GET | `/richieste/{id}/allegati/{idAllegato}/contenuto` | `getRichiestaAllegatoContenuto` | `RichiesteManager` (`AllegatoMapper`) | `SPRINT_T_ALLEGATO_RIC` (download blob → octet-stream), `SPRINT_R_RICGEN_ALLEGATO` |
| GET | `/richieste/{id}/storico` | `getRichiestaStorico` | `RichiesteManager` → `StoricoManager` (`StoricoMapper`) | `SPRINT_S_RIC_GENERICA` ⋈ `SPRINT_D_RICHIESTA_GENERICA`, `SPRINT_S_RIC_38_CALAMITA`, `SPRINT_T_EVENTO`, `SPRINT_T_APPG_AGGREGAZIONI`, `SPRINT_S_LOTTO`, `SPRINT_S_ANALISI_RISCHIO`, `SPRINT_D_ANALISI_RISCHIO`, `SPRINT_SR_RIC_GENERICA_COMUNE`. findStorico per legge (Straordinaria/38/18/54/183), titoli+righe dinamici. Flag `hasStorico` su dettaglio = `count(*) SPRINT_S_RIC_GENERICA where fk_richiesta_generica` (legacy countStorico) |
| GET/POST/DELETE | `/richieste/{id}/stralci`, `/stralci/{idStralcio}` | `getRichiestaStralci`, `postRichiestaStralcio`, `deleteRichiestaStralcio` | `RichiesteManager` (`StralcioMapper`) | `SPRINT_T_STRALCIO` (CRUD reale, PK da `SEQ_SPRINT_T_STRALCIO`) |
| POST | `/richieste/{id}/invia` | `inviaRichiesta` | `RichiesteManager` (+ `MetadatiManager`) | legge dettaglio richiesta da DB; valida i campi `obbligatorioInvio` per legge (metadati: `SPRINT_MTD_CAMPO`, `SPRINT_MTD_R3_CAMPO_SEZLEGGE`). Nessuna transizione di stato qui |
| GET | `/utente/contesto` | `getUtenteContesto` | `UtenteManager` | `SPRINT_MTD_UTENTE`, `SPRINT_MTD_PROFILO_UTENTE` (se `sprint.utente.codFiscale` valorizzata; altrimenti sessione Iride) |

> Gli endpoint `/motore-ricerca/*` sono stati **rimossi dal contratto** (erano 501 e senza
> consumatori). Design conservato in [spec/motore-ricerca.md](../spec/motore-ricerca.md) per la fase 3.

## Legenda

- **—** = nessun accesso DB
- **non impl.** = endpoint risponde HTTP 501 con messaggio esplicito (nessun dato mock)
- **(in-memory)** = da migrare a persistenza DB (ancora da fare)
- **legacy hardcoded** = stesso comportamento del JSP (`RicercaTopeDAOImpl.findAllProvincie`)
