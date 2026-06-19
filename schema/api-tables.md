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
| GET | `/comuni/suggest` | `suggestComuni` | `LookupManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (soloConRichieste); LOTO → non impl. |
| GET | `/richieste/compilatori/suggest` | `suggestRichiesteCompilatori` | `LookupManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` |
| GET | `/indirizzi/suggest` | `suggestIndirizzi` | `LookupManager` | TOPE → non impl. |
| GET | `/tipi-strada` | `getTipiStrada` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_TIPO_STRADA') |
| GET | `/sedimi` | `getSedimi` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_SEDIME') |
| GET | `/richieste/categorie` | `getRichiesteCategorie` | `LookupManager` | `SPRINT_D_RICHIESTA_GENERICA` (NOME_COLONNA='FK_CATEGORIA', CODICE='CAT'; idLegge non filtra) |
| GET | `/richieste/metadati/{idLegge}` | `getRichiesteMetadatiByLegge` | `MetadatiManager` | non impl. |
| POST | `/richieste/cerca` | `cercaRichieste` | `RicercaManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` |
| GET | `/richieste/colonne-risultato` | `getRichiesteColonneRisultato` | `RicercaManager` | `SPRINT_MTD_CAMPO_RIS_RICERCA`, `SPRINT_MTD_R_CAMPO_OGGPROF`, `SPRINT_MTD_OGGETTO`, `SPRINT_MTD_PROFILO_UTENTE` |
| POST | `/eventi/cerca` | `cercaEventi` | `RicercaManager` | `SPRINT_T_EVENTO`, `SPRINT_D_EVENTO`, `SPRINT_R_EVENTO_COMUNE`, `SPRINT_T_AREA_IDRO`, `SPRINT_R_AREA_IDRO_EVENTO` |
| POST | `/richieste` | `creaRichiesta` | `RichiesteManager` | `SPRINT_T_RIC_GENERICA` (in-memory) |
| GET | `/richieste/{id}` | `getRichiesta` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB; creazione ancora in-memory) |
| GET | `/richieste/{id}/dati-mappa` | `getRichiestaDatiMappa` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/dati-generali` | `getRichiestaDatiGenerali` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/dati-tecnico-amministrativi` | `getRichiestaDatiTecnicoAmministrativi` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/dati-economici` | `getRichiestaDatiEconomici` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/valutazione-pericolosita` | `getRichiestaValutazionePericolosita` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/analisi-del-rischio` | `getRichiestaAnalisiDelRischio` | `RichiesteManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (fallback DB) |
| GET | `/richieste/{id}/layout` | `getRichiestaLayout` | `LayoutManager` | non impl. |
| GET/PUT | `/richieste/{id}/geometria` | `get/putRichiestaGeometria` | `RichiesteManager` | `SPRINT_R_GEOMETRIA_RICHIESTA` (in-memory) |
| PATCH | `/richieste/{id}/dati-*` | `patchRichiesta*` | `RichiesteManager` | `SPRINT_T_RIC_GENERICA`, `SPRINT_T_RIC_38_CALAMITA`, `GEO_PT_INTERVENTO`, `SPRINT_T_RIC_18_54_183`, `SPRINT_T_RIC_183`, `SPRINT_T_ANALISI_RISCHIO`, `SPRINT_T_STRALCIO` |
| PATCH | `/richieste/{id}/folders/{idFolder}` | `patchRichiestaFolder` | `RichiesteManager` | come sopra (delega ai patch per folder) |
| GET/POST/DELETE | `/richieste/{id}/allegati*` | `*RichiestaAllegat*` | `RichiesteManager` | `SPRINT_T_ALLEGATO_RIC`, `SPRINT_R_RICGEN_ALLEGATO` (GET folder da DB); creazione in-memory |
| POST | `/richieste/{id}/invia` | `inviaRichiesta` | `RichiesteManager` | `SPRINT_T_RIC_GENERICA` (in-memory) |
| GET | `/utente/contesto` | `getUtenteContesto` | `UtenteManager` | `SPRINT_MTD_UTENTE`, `SPRINT_MTD_PROFILO_UTENTE` (se `sprint.utente.codFiscale` valorizzata; altrimenti sessione Iride) |
| GET | `/motore-ricerca/*` | `*` | `MotoreRicercaManager` | non impl. (fase 3) |

## Legenda

- **—** = nessun accesso DB
- **non impl.** = endpoint risponde HTTP 501 con messaggio esplicito (nessun dato mock)
- **(in-memory)** = da migrare a persistenza DB (ancora da fare)
- **legacy hardcoded** = stesso comportamento del JSP (`RicercaTopeDAOImpl.findAllProvincie`)
