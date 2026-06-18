# Inventario schema Sprint (PostgreSQL)

Estratto dal database **PGSITTST** (`schema sprint`, host `tst-domdb67.csi.it`) il 2026-06-18.
DDL completo in `migrations/V001__baseline.sql`.

**86 tabelle** + **26 viste** nello schema `sprint`.

## Transazionali (`sprint_t_`)

| Tabella | Colonne | Dominio |
|---------|---------|---------|
| `sprint_t_ric_generica` | 92 | Richieste generiche (entità centrale) |
| `sprint_t_ric_38_calamita` | 8 | Richieste legge 38 calamità |
| `sprint_t_ric_18_54_183` | 23 | Richieste legge 18/54/183 |
| `sprint_t_ric_183` | 32 | Richieste legge 183 |
| `sprint_t_evento` | 20 | Eventi |
| `sprint_t_allegato_ric` | 6 | Allegati richiesta |
| `sprint_t_allegato_evento` | 7 | Allegati evento |
| `sprint_t_analisi_rischio` | 6 | Analisi rischio |
| `sprint_t_area_idro` | 2 | Aree idrografiche |
| `sprint_t_appg_aggregazioni` | 6 | Tipi aggregazione territorio |
| `sprint_t_appg_settori` | 8 | Settori intervento |
| `sprint_t_lotto` | 9 | Lotti finanziamento |
| `sprint_t_stralcio` | 5 | Stralci |
| `sprint_t_centroide` | 4 | Centroidi comuni |
| `sprint_t_parametri` | 4 | Parametri di sistema |
| `sprint_t_map_group_layer` | 3 | Gruppi layer mappa |
| `sprint_t_map_layer` | 10 | Layer mappa |
| `sprint_t_map_layer_feature` | 4 | Feature layer mappa |

## Dominio / lookup (`sprint_d_`)

| Tabella | Colonne | Dominio |
|---------|---------|---------|
| `sprint_d_richiesta_generica` | 10 | Lookup richieste (stati, categorie, …) |
| `sprint_d_ric_183` | 6 | Lookup legge 183 |
| `sprint_d_ric_18_54_183` | 7 | Lookup legge 18/54/183 |
| `sprint_d_evento` | 6 | Lookup eventi (tipologia, stato, …) |
| `sprint_d_analisi_rischio` | 6 | Lookup analisi rischio |

## Storico (`sprint_s_`)

| Tabella | Colonne | Dominio |
|---------|---------|---------|
| `sprint_s_ric_generica` | 82 | Storico richieste generiche |
| `sprint_s_ric_38_calamita` | 8 | Storico richieste 38 |
| `sprint_s_ric_183` | 32 | Storico richieste 183 |
| `sprint_s_ric_18_54_183` | 23 | Storico richieste 18/54/183 |
| `sprint_s_evento` | 20 | Storico eventi |
| `sprint_s_lotto` | 9 | Storico lotti |
| `sprint_s_stralcio` | 5 | Storico stralci |
| `sprint_s_analisi_rischio` | 6 | Storico analisi rischio |

## Relazioni (`sprint_r_`)

| Tabella | Colonne | Dominio |
|---------|---------|---------|
| `sprint_r_ricgen_allegato` | 3 | Richiesta ↔ allegato |
| `sprint_r_ric_generica_comune` | 4 | Richiesta ↔ comune |
| `sprint_r_ric_generica_dinamica` | 2 | Campi dinamici richiesta |
| `sprint_r_geometria_richiesta` | 3 | Geometria richiesta |
| `sprint_r_evento_comune` | 4 | Evento ↔ comune |
| `sprint_r_area_idro_evento` | 3 | Evento ↔ area idrografica |
| `sprint_r_area_idro_ric_generic` | 3 | Richiesta ↔ area idrografica |
| `sprint_r_38_calamita` | 2 | Relazione padre/figlio richieste 38 |
| `sprint_r_18_54_183_dinamica` | 2 | Campi dinamici legge 18/54/183 |
| `sprint_r_analisi_dinamica` | 2 | Campi dinamici analisi rischio |
| `sprint_r_province_collegate` | 2 | Province collegate |

## Relazioni storico (`sprint_sr_`)

| Tabella | Colonne | Dominio |
|---------|---------|---------|
| `sprint_sr_evento_comune` | 4 | Storico evento ↔ comune |
| `sprint_sr_evento_ricgen` | 2 | Storico evento ↔ richiesta |
| `sprint_sr_area_idro_evento` | 3 | Storico evento ↔ area idrografica |
| `sprint_sr_area_idro_ric_generi` | 3 | Storico richiesta ↔ area idrografica |
| `sprint_sr_ric_generica_comune` | 4 | Storico richiesta ↔ comune |
| `sprint_sr_ric_generica_dinamic` | 2 | Storico campi dinamici |
| `sprint_sr_38_calamita` | 2 | Storico dati 38 calamità |
| `sprint_sr_18_54_183_dinamica` | 2 | Storico dinamica 18/54/183 |
| `sprint_sr_analisi_dinamica` | 2 | Storico analisi dinamica |

## Metadati legge/UI (`sprint_mtd_`)

| Tabella | Colonne | Dominio |
|---------|---------|---------|
| `sprint_mtd_legge` | 3 | Leggi |
| `sprint_mtd_folder` | 2 | Cartelle UI |
| `sprint_mtd_sezione` | 3 | Sezioni UI |
| `sprint_mtd_campo` | 4 | Campi UI |
| `sprint_mtd_tavola` | 2 | Tavole lookup |
| `sprint_mtd_config` | 4 | Configurazione |
| `sprint_mtd_oggetto` | 7 | Oggetti profilo |
| `sprint_mtd_criterio` | 7 | Criteri ricerca |
| `sprint_mtd_profilo_utente` | 2 | Profili utente |
| `sprint_mtd_utente` | 9 | Utenti |
| `sprint_mtd_analisi_rischio` | 7 | Metadati analisi rischio |
| `sprint_mtd_campo_ris_ricerca` | 7 | Campi risultato ricerca |
| `sprint_mtd_ricerca_pred_clob` | 6 | Ricerche predefinite (CLOB) |
| `sprint_mtd_ric_generica` | 6 | Metadati campi dinamici richiesta |
| `sprint_mtd_ric_18_54_183` | 6 | Metadati campi dinamici 18/54/183 |
| `sprint_mtd_r1_folderlegge` | 2 | Folder ↔ legge |
| `sprint_mtd_r2_sezionelegge` | 2 | Sezione ↔ legge |
| `sprint_mtd_r3_campo_sezlegge` | 3 | Campo ↔ sezione/legge |
| `sprint_mtd_r_ogg_prof` | 2 | Oggetto ↔ profilo |
| `sprint_mtd_r_campo_oggprof` | 4 | Campo ↔ oggetto/profilo |
| `sprint_mtd_r_criterio_oggprof` | 3 | Criterio ↔ oggetto/profilo |
| `sprint_mtd_r_campo_ricercapred` | 3 | Campo ↔ ricerca predefinita |
| `sprint_mtd_r_profilo_ricerca` | 2 | Profilo ↔ ricerca predefinita |

## Geometrie SDE (`geo_`)

| Tabella | Dominio |
|---------|---------|
| `geo_pt_evento` | Punto evento (EPSG:32632) |
| `geo_pl_evento` | Poligono evento |
| `geo_ln_evento` | Linea evento |
| `geo_pt_intervento` | Punto intervento |
| `geo_pl_intervento` | Poligono intervento |
| `geo_ln_intervento` | Linea intervento |

## Workflow e integrazioni

| Tabella | Dominio |
|---------|---------|
| `sprint_to_wf` | Export verso workflow |
| `wf_to_sprint` | Import da workflow |
| `batch_wf_log` | Log batch workflow |
| `sprint_w_comuni_evento` | Vista materializzata/work comuni evento |

## SDE interno

| Tabella | Dominio |
|---------|---------|
| `sde_logfiles` | Log sessioni SDE |
| `sde_logfile_data` | Dati log SDE |

## Viste (`vsde_`)

Viste per consultazione/inserimento geometrie e ricerche territoriali:

| Vista | Uso |
|-------|-----|
| `vsde_ric_38_strao_pt_tutte` | Comuni/province (ricerca richieste 38) |
| `vsde_ric_38_pt_consultazione` | Punti richiesta 38 consultazione |
| `vsde_ric_38_pt_inserimento` | Punti richiesta 38 inserimento |
| `vsde_ric_38_pt_storico` | Punti richiesta 38 storico |
| `vsde_ric_18_pt_*` | Richieste legge 18 (consultazione/inserimento/storico) |
| `vsde_ric_54_pt_*` | Richieste legge 54 |
| `vsde_ric_183_pt_*` | Richieste legge 183 |
| `vsde_ric_strao_pt_*` | Straordinari punti |
| `vsde_ric_strao_ln_*` | Straordinari linee |
| `vsde_ric_strao_pl_*` | Straordinari poligoni |
| `vsde_evento_pt/pl/ln_*` | Geometrie evento (corrente/storico) |

## Relazioni principali

```
sprint_t_ric_generica (PK: id_richiesta_generica)
  ├── sprint_t_ric_38_calamita (1:1, stessa PK)
  ├── sprint_t_ric_18_54_183 (1:1, stessa PK)
  ├── sprint_t_ric_183 (1:1, stessa PK)
  ├── sprint_t_lotto / sprint_t_stralcio (1:N)
  ├── sprint_r_ric_generica_comune (N:M comuni)
  ├── sprint_r_ricgen_allegato → sprint_t_allegato_ric
  └── sprint_r_geometria_richiesta → geo_pt/pl/ln_intervento

sprint_t_evento (PK: id_evento)
  ├── sprint_r_evento_comune
  ├── sprint_r_area_idro_evento → sprint_t_area_idro
  ├── sprint_t_allegato_evento
  └── geo_pt/pl/ln_evento

sprint_mtd_legge → sprint_mtd_r1/r2/r3_* (configurazione UI per legge)
sprint_d_* (lookup gerarchici, fk_padre → stessa tabella)
```
