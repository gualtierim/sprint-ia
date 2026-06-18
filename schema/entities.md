# Mapping tabelle → entity Java (sprintbff)

Convenzione per classi Lombok in `it.csi.sprint.sprintbff.dao.model`.
MyBatis mappa automaticamente `snake_case` → `camelCase` (`map-underscore-to-camel-case=true`).

## Regole di naming

| Regola | Esempio |
|--------|---------|
| Rimuovere prefisso `sprint_` | `sprint_t_ric_generica` → `TRicGenerica` |
| PascalCase sui segmenti `_` | `sprint_mtd_r1_folderlegge` → `MtdR1Folderlegge` |
| Mantenere prefisso tipo (`T_`, `D_`, `S_`, `R_`, `Sr_`, `Mtd_`) | distingue transazionale / dominio / storico |
| Package unico | `it.csi.sprint.sprintbff.dao.model` |
| Annotazioni Lombok | `@Getter`, `@Setter`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor` |

## Mapping tipi PostgreSQL → Java

| PostgreSQL | Java |
|------------|------|
| `numeric`, `numeric(p,s)` | `BigDecimal` |
| `integer`, `smallint` | `Integer` |
| `bigint` | `Long` |
| `character varying`, `text` | `String` |
| `date` | `LocalDate` |
| `timestamp without time zone` | `LocalDateTime` |
| `bytea` | `byte[]` |
| `geometry(...)` | `String` o tipo dedicato PostGIS (fase 2) |

## Entity core (priorità implementazione)

| Tabella | Entity | PK | Note |
|---------|--------|-----|------|
| `sprint_t_ric_generica` | `TRicGenerica` | `idRichiestaGenerica` | 92 colonne; hub richieste |
| `sprint_t_evento` | `TEvento` | `idEvento` | Eventi calamitosi |
| `sprint_t_ric_38_calamita` | `TRic38Calamita` | `idRichiestaGenerica` | FK 1:1 su `TRicGenerica` |
| `sprint_t_ric_18_54_183` | `TRic18_54_183` | `idRichiestaGenerica` | Estensione legge 18/54/183 |
| `sprint_t_ric_183` | `TRic183` | `idRichiestaGenerica` | Estensione legge 183 |
| `sprint_d_richiesta_generica` | `DRichiestaGenerica` | `id` | Lookup gerarchico (stati, categorie) |
| `sprint_d_evento` | `DEvento` | `id` | Lookup tipologia/stato evento |
| `sprint_r_ric_generica_comune` | `RRicGenericaComune` | composita | Richiesta ↔ codice ISTAT |
| `sprint_r_evento_comune` | `REventoComune` | composita | Evento ↔ comune |
| `sprint_t_allegato_ric` | `TAllegatoRic` | `idAllegatoRic` | Blob in colonna `allegato_ric` |
| `sprint_mtd_legge` | `MtdLegge` | `idLegge` | Configurazione per legge |

## Mapping completo (86 tabelle)

| Tabella DB | Entity Java | Categoria |
|------------|-------------|-----------|
| `batch_wf_log` | `BatchWfLog` | Workflow |
| `geo_ln_evento` | `GeoLnEvento` | Geometria SDE |
| `geo_ln_intervento` | `GeoLnIntervento` | Geometria SDE |
| `geo_pl_evento` | `GeoPlEvento` | Geometria SDE |
| `geo_pl_intervento` | `GeoPlIntervento` | Geometria SDE |
| `geo_pt_evento` | `GeoPtEvento` | Geometria SDE |
| `geo_pt_intervento` | `GeoPtIntervento` | Geometria SDE |
| `sde_logfile_data` | `SdeLogfileData` | SDE interno |
| `sde_logfiles` | `SdeLogfiles` | SDE interno |
| `sprint_d_analisi_rischio` | `DAnalisiRischio` | Dominio |
| `sprint_d_evento` | `DEvento` | Dominio |
| `sprint_d_ric_183` | `DRic183` | Dominio |
| `sprint_d_ric_18_54_183` | `DRic18_54_183` | Dominio |
| `sprint_d_richiesta_generica` | `DRichiestaGenerica` | Dominio |
| `sprint_mtd_analisi_rischio` | `MtdAnalisiRischio` | Metadati |
| `sprint_mtd_campo` | `MtdCampo` | Metadati |
| `sprint_mtd_campo_ris_ricerca` | `MtdCampoRisRicerca` | Metadati |
| `sprint_mtd_config` | `MtdConfig` | Metadati |
| `sprint_mtd_criterio` | `MtdCriterio` | Metadati |
| `sprint_mtd_folder` | `MtdFolder` | Metadati |
| `sprint_mtd_legge` | `MtdLegge` | Metadati |
| `sprint_mtd_oggetto` | `MtdOggetto` | Metadati |
| `sprint_mtd_profilo_utente` | `MtdProfiloUtente` | Metadati |
| `sprint_mtd_r1_folderlegge` | `MtdR1Folderlegge` | Metadati relazione |
| `sprint_mtd_r2_sezionelegge` | `MtdR2Sezionelegge` | Metadati relazione |
| `sprint_mtd_r3_campo_sezlegge` | `MtdR3CampoSezlegge` | Metadati relazione |
| `sprint_mtd_r_campo_oggprof` | `MtdRCampoOggprof` | Metadati relazione |
| `sprint_mtd_r_campo_ricercapred` | `MtdRCampoRicercapred` | Metadati relazione |
| `sprint_mtd_r_criterio_oggprof` | `MtdRCriterioOggprof` | Metadati relazione |
| `sprint_mtd_r_ogg_prof` | `MtdROggProf` | Metadati relazione |
| `sprint_mtd_r_profilo_ricerca` | `MtdRProfiloRicerca` | Metadati relazione |
| `sprint_mtd_ric_18_54_183` | `MtdRic18_54_183` | Metadati |
| `sprint_mtd_ric_generica` | `MtdRicGenerica` | Metadati |
| `sprint_mtd_ricerca_pred_clob` | `MtdRicercaPredClob` | Metadati |
| `sprint_mtd_sezione` | `MtdSezione` | Metadati |
| `sprint_mtd_tavola` | `MtdTavola` | Metadati |
| `sprint_mtd_utente` | `MtdUtente` | Metadati |
| `sprint_r_18_54_183_dinamica` | `R18_54_183Dinamica` | Relazione |
| `sprint_r_38_calamita` | `R38Calamita` | Relazione |
| `sprint_r_analisi_dinamica` | `RAnalisiDinamica` | Relazione |
| `sprint_r_area_idro_evento` | `RAreaIdroEvento` | Relazione |
| `sprint_r_area_idro_ric_generic` | `RAreaIdroRicGeneric` | Relazione |
| `sprint_r_evento_comune` | `REventoComune` | Relazione |
| `sprint_r_geometria_richiesta` | `RGeometriaRichiesta` | Relazione |
| `sprint_r_province_collegate` | `RProvinceCollegate` | Relazione |
| `sprint_r_ric_generica_comune` | `RRicGenericaComune` | Relazione |
| `sprint_r_ric_generica_dinamica` | `RRicGenericaDinamica` | Relazione |
| `sprint_r_ricgen_allegato` | `RRicgenAllegato` | Relazione |
| `sprint_s_analisi_rischio` | `SAnalisiRischio` | Storico |
| `sprint_s_evento` | `SEvento` | Storico |
| `sprint_s_lotto` | `SLotto` | Storico |
| `sprint_s_ric_183` | `SRic183` | Storico |
| `sprint_s_ric_18_54_183` | `SRic18_54_183` | Storico |
| `sprint_s_ric_38_calamita` | `SRic38Calamita` | Storico |
| `sprint_s_ric_generica` | `SRicGenerica` | Storico |
| `sprint_s_stralcio` | `SStralcio` | Storico |
| `sprint_sr_18_54_183_dinamica` | `Sr18_54_183Dinamica` | Relazione storico |
| `sprint_sr_38_calamita` | `Sr38Calamita` | Relazione storico |
| `sprint_sr_analisi_dinamica` | `SrAnalisiDinamica` | Relazione storico |
| `sprint_sr_area_idro_evento` | `SrAreaIdroEvento` | Relazione storico |
| `sprint_sr_area_idro_ric_generi` | `SrAreaIdroRicGeneri` | Relazione storico |
| `sprint_sr_evento_comune` | `SrEventoComune` | Relazione storico |
| `sprint_sr_evento_ricgen` | `SrEventoRicgen` | Relazione storico |
| `sprint_sr_ric_generica_comune` | `SrRicGenericaComune` | Relazione storico |
| `sprint_sr_ric_generica_dinamic` | `SrRicGenericaDinamic` | Relazione storico |
| `sprint_t_allegato_evento` | `TAllegatoEvento` | Transazionale |
| `sprint_t_allegato_ric` | `TAllegatoRic` | Transazionale |
| `sprint_t_analisi_rischio` | `TAnalisiRischio` | Transazionale |
| `sprint_t_appg_aggregazioni` | `TAppgAggregazioni` | Transazionale |
| `sprint_t_appg_settori` | `TAppgSettori` | Transazionale |
| `sprint_t_area_idro` | `TAreaIdro` | Transazionale |
| `sprint_t_centroide` | `TCentroide` | Transazionale |
| `sprint_t_evento` | `TEvento` | Transazionale |
| `sprint_t_lotto` | `TLotto` | Transazionale |
| `sprint_t_map_group_layer` | `TMapGroupLayer` | Transazionale |
| `sprint_t_map_layer` | `TMapLayer` | Transazionale |
| `sprint_t_map_layer_feature` | `TMapLayerFeature` | Transazionale |
| `sprint_t_parametri` | `TParametri` | Transazionale |
| `sprint_t_ric_183` | `TRic183` | Transazionale |
| `sprint_t_ric_18_54_183` | `TRic18_54_183` | Transazionale |
| `sprint_t_ric_38_calamita` | `TRic38Calamita` | Transazionale |
| `sprint_t_ric_generica` | `TRicGenerica` | Transazionale |
| `sprint_t_stralcio` | `TStralcio` | Transazionale |
| `sprint_to_wf` | `ToWf` | Workflow |
| `sprint_w_comuni_evento` | `WComuniEvento` | Workflow |
| `wf_to_sprint` | `WfToSprint` | Workflow |

## Viste (read-only, no entity persistenti)

| Vista DB | DTO suggerito | Uso API |
|----------|---------------|---------|
| `vsde_ric_38_strao_pt_tutte` | `ComuneTerritorioDto` | suggest comuni, ricerca |
| `vsde_evento_pt` | `GeometriaEventoDto` | mappa eventi |
| `vsde_ric_strao_pt_consultazion` | `GeometriaRichiestaDto` | mappa richieste |

Le viste non hanno entity JPA/MyBatis persistenti: usare DTO di proiezione nei mapper XML.
