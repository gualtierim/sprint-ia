# Inventario tabelle Sprint (Oracle)

Elenco ricavato dalle query in `sprintj/src/java/it/csi/sprint/integration/dao/*/impl/sql.properties`.
Schema gestito dalle migrations in `schema/migrations/`.

## Transazionali (`SPRINT_T_`)

| Tabella | Dominio |
|---------|---------|
| `SPRINT_T_RIC_GENERICA` | Richieste generiche |
| `SPRINT_T_RIC_38_CALAMITA` | Richieste legge 38 calamità |
| `SPRINT_T_RIC_18_54_183` | Richieste legge 18/54/183 |
| `SPRINT_T_RIC_183` | Richieste legge 183 |
| `SPRINT_T_EVENTO` | Eventi |
| `SPRINT_T_ALLEGATO_RIC` | Allegati richiesta |
| `SPRINT_T_ALLEGATO_EVENTO` | Allegati evento |
| `SPRINT_T_AREA_IDRO` | Aree idrografiche |
| `SPRINT_T_APPG_AGGREGAZIONI` | Tipi aggregazione |

## Dominio / lookup (`SPRINT_D_`)

| Tabella | Dominio |
|---------|---------|
| `SPRINT_D_RICHIESTA_GENERICA` | Lookup richieste (stati, categorie, …) |
| `SPRINT_D_RIC_183` | Lookup legge 183 |
| `SPRINT_D_EVENTO` | Lookup eventi (tipologia, stato, …) |
| `SPRINT_D_ANALISI_RISCHIO` | Lookup analisi rischio |

## Storico (`SPRINT_S_`)

| Tabella | Dominio |
|---------|---------|
| `SPRINT_S_RIC_GENERICA` | Storico richieste generiche |
| `SPRINT_S_RIC_38_CALAMITA` | Storico richieste 38 |
| `SPRINT_S_RIC_183` | Storico richieste 183 |
| `SPRINT_S_RIC_18_54_183` | Storico richieste 18/54/183 |
| `SPRINT_S_EVENTO` | Storico eventi |
| `SPRINT_S_LOTTO` | Storico lotti |
| `SPRINT_S_STRALCIO` | Storico stralci |
| `SPRINT_S_ANALISI_RISCHIO` | Storico analisi rischio |

## Relazioni (`SPRINT_R_`)

| Tabella | Dominio |
|---------|---------|
| `SPRINT_R_RICGEN_ALLEGATO` | Richiesta ↔ allegato |
| `SPRINT_R_RIC_GENERICA_COMUNE` | Richiesta ↔ comune |
| `SPRINT_R_RIC_GENERICA_DINAMICA` | Campi dinamici richiesta |
| `SPRINT_R_GEOMETRIA_RICHIESTA` | Geometria richiesta |
| `SPRINT_R_EVENTO_COMUNE` | Evento ↔ comune |

## Relazioni storico (`SPRINT_SR_`)

| Tabella | Dominio |
|---------|---------|
| `SPRINT_SR_EVENTO_COMUNE` | Storico evento ↔ comune |
| `SPRINT_SR_EVENTO_RICGEN` | Storico evento ↔ richiesta |
| `SPRINT_SR_AREA_IDRO_EVENTO` | Storico evento ↔ area idrografica |
| `SPRINT_SR_AREA_IDRO_RIC_GENERI` | Storico richiesta ↔ area idrografica |
| `SPRINT_SR_RIC_GENERICA_COMUNE` | Storico richiesta ↔ comune |
| `SPRINT_SR_RIC_GENERICA_DINAMIC` | Storico campi dinamici |
| `SPRINT_SR_38_CALAMITA` | Storico dati 38 calamità |
| `SPRINT_SR_18_54_183_DINAMICA` | Storico dinamica 18/54/183 |
| `SPRINT_SR_ANALISI_DINAMICA` | Storico analisi dinamica |

## Metadati legge/UI (`SPRINT_MTD_`)

| Tabella | Dominio |
|---------|---------|
| `SPRINT_MTD_LEGGE` | Leggi |
| `SPRINT_MTD_FOLDER` | Cartelle UI |
| `SPRINT_MTD_SEZIONE` | Sezioni UI |
| `SPRINT_MTD_CAMPO` | Campi UI |
| `SPRINT_MTD_CONFIG` | Configurazione |
| `SPRINT_MTD_R1_FOLDERLEGGE` | Folder ↔ legge |
| `SPRINT_MTD_R2_SEZIONELEGGE` | Sezione ↔ legge |
| `SPRINT_MTD_R3_CAMPO_SEZLEGGE` | Campo ↔ sezione/legge |

## Viste esterne

| Oggetto | Note |
|---------|------|
| `VSDE_RIC_38_STRAO_PT_TUTTE` | Vista comuni/province (ricerca) |
