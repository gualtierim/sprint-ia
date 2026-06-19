---
name: schema
description: >-
  Schema database PostgreSQL Sprint e migrations SQL versionate in schema/migrations/.
  Usa quando si aggiungono o modificano tabelle, colonne, indici, vincoli, script DDL/DML,
  Flyway, accesso dati in sprintbff, o serve sapere quali tabelle usa un'API.
---

# Sprint — schema database

Il database Sprint è **PostgreSQL**. Lo schema condiviso tra legacy (`sprintj`, Oracle in produzione) e nuovo stack (`sprintbff`) vive nel meta-repo.

## Percorsi

```
schema/
├── migrations/          # script SQL versionati (Flyway-style)
├── tables.md            # inventario tabelle legacy
└── api-tables.md        # mapping endpoint REST → tabelle
```

Le migrations **non** vanno in `sprintbff/` né in `sprintj/`: solo in `schema/migrations/`.

## Convenzione migrations

Nome file: `V{versione}__{descrizione_snake_case}.sql`

| Regola | Esempio |
|--------|---------|
| Versione numerica crescente | `V001`, `V002`, `V010` |
| Separatore doppio underscore | `V003__add_codice_cup.sql` |
| Una modifica logica per file | non mischiare CREATE TABLE e ALTER nella stessa migration se evitabile |
| Idempotenza | preferire `CREATE TABLE` su schema vuoto; per ALTER usare controlli PostgreSQL se necessario (es. `IF NOT EXISTS`, blocchi `DO $$`) |
| Mai modificare file già applicati | creare una nuova migration |

Esempio:

```sql
-- V002__create_sprint_t_esempio.sql
CREATE TABLE sprint_t_esempio (
    id_esempio   BIGSERIAL       PRIMARY KEY,
    descrizione  VARCHAR(255),
    mod_data     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP NOT NULL,
    mod_utente   VARCHAR(100)    NOT NULL
);
```

Sintassi **PostgreSQL**: tipi nativi (`BIGSERIAL`, `VARCHAR`, `TIMESTAMP`), identificatori in minuscolo non quotati, niente `VARCHAR2`/`NUMBER`/`SYSDATE`.

## Workflow obbligatorio

```
Task Progress:
- [ ] 1. Verificare tabelle esistenti in schema/tables.md e sql.properties di sprintj
- [ ] 2. Scrivere migration in schema/migrations/
- [ ] 3. Aggiornare schema/tables.md se si aggiungono tabelle
- [ ] 4. Implementare accesso dati in sprintbff (*Manager / DAO) con **Lombok** e mapper MyBatis (SQL in `resources/mapper/*.xml`, mai `@Select` inline — regola `mybatis-xml`); conversioni Row/Entity → VO con **MapStruct** (skill `backend`); query derivate da `sprintj/.../sql.properties`; per elenchi tabellari usare `LIMIT`/`OFFSET` (o equivalente) in base a `page`/`pageSize`
- [ ] 5. Aggiornare schema/api-tables.md per ogni endpoint che tocca il DB
- [ ] 6. Aggiornare openapi.yaml e rigenerare (skill sprint-api)
```

## Mapping API → tabelle

Ogni endpoint in `sprintbff/src/main/resources/static/api/openapi.yaml` che accede al database deve essere documentato in `schema/api-tables.md`.

Formato riga:

```
| GET /test/ping | ping | — | nessuna |
| GET /richiesta/{id} | getRichiesta | RichiestaManager | SPRINT_T_RIC_GENERICA, SPRINT_D_RICHIESTA_GENERICA |
```

Colonne: path, operationId, Manager, tabelle (virgola-separate; `—` se nessuna).

**Paginazione:** se l'endpoint restituisce righe per una `mat-table`, il Manager deve applicare paginazione SQL e restituire anche il conteggio totale (non solo la pagina corrente).

**Niente mock:** le query nel BFF devono corrispondere alle properties SQL del legacy; in assenza di tabella/servizio, eccezione esplicita — non dati inventati.

## Accesso dati in sprintbff — Lombok

Per classi che mappano tabelle PostgreSQL (entity, row mapper, DTO interni al layer dati) usare **Lombok** invece di getter/setter manuali:

| Annotazione | Uso |
|-------------|-----|
| `@Getter` / `@Setter` | campi entity |
| `@Builder` | costruzione oggetti in Manager/DAO |
| `@NoArgsConstructor` / `@AllArgsConstructor` | requisiti framework (JPA, mapper) |
| `@RequiredArgsConstructor` | iniezione dipendenze nei Manager |

**Non** usare Lombok su file generati da OpenAPI (`vo/*.java`). Applicarlo solo a classi scritte a mano nel layer dati.

Per mappare `dao.model.*` → `vo.*` usare **MapStruct** in `api.mapper` (skill [backend](../backend/SKILL.md)), non blocchi di setter nei Manager.

## Interrogare il database

Quando serve verificare schema, dati o query direttamente su PostgreSQL, **leggere le credenziali** da:

```
sprintbff/src/main/resources/application-local.properties
```

Se esiste, `application-local-secrets.properties` (stessa cartella) **sovrascrive** URL, username e password.

Proprietà da usare:

| Proprietà | Uso |
|-----------|-----|
| `spring.datasource.url` | host, porta, database (formato JDBC) |
| `spring.datasource.username` | utente PostgreSQL |
| `spring.datasource.password` | password |

Esempio con `psql` (estrarre host, porta e database dall'URL JDBC `jdbc:postgresql://host:porta/nome_db`):

```bash
PGPASSWORD='<password>' psql -h <host> -p <porta> -U <username> -d <nome_db> -c "SELECT ..."
```

**Non** inventare credenziali né usare variabili d'ambiente generiche: usare sempre i valori del file di configurazione locale del BFF.

## Consultare il legacy

Per capire quali tabelle e query usa oggi una funzionalità:

```
sprintj/src/java/it/csi/sprint/integration/dao/*/impl/sql.properties
```

**Non modificare** `sprintj/`. Usarlo solo come riferimento per replicare la logica in `sprintbff`. Il legacy punta a Oracle: tradurre tipi e funzioni SQL in equivalenti PostgreSQL nelle migrations e nelle query del BFF.

## Prefissi tabelle

| Prefisso | Tipo | Esempio |
|----------|------|---------|
| `SPRINT_T_` | transazionale | `SPRINT_T_RIC_GENERICA` |
| `SPRINT_D_` | dominio / lookup | `SPRINT_D_RICHIESTA_GENERICA` |
| `SPRINT_S_` | storico | `SPRINT_S_RIC_GENERICA` |
| `SPRINT_SR_` | relazione storico | `SPRINT_SR_EVENTO_COMUNE` |
| `SPRINT_R_` | relazione | `SPRINT_R_RICGEN_ALLEGATO` |
| `SPRINT_MTD_` | metadati legge/UI | `SPRINT_MTD_LEGGE` |

## Checklist agente

- [ ] La migration è in `schema/migrations/` con nome `Vnnn__...sql`?
- [ ] Ho aggiornato `schema/tables.md` per nuove tabelle?
- [ ] Ho aggiornato `schema/api-tables.md` per ogni endpoint che legge/scrive DB?
- [ ] Le query in sprintbff riusano le stesse tabelle del legacy, senza duplicare schema?
- [ ] Le migrations usano sintassi PostgreSQL (non Oracle)?
- [ ] Le entity/DAO del layer dati usano Lombok?
- [ ] Non ho toccato file in `sprintj/`?
- [ ] Per query dirette al DB ho usato le credenziali da `application-local.properties`?
- [ ] Gli endpoint lista/tabella paginano in SQL (`LIMIT`/`OFFSET` + count) e non caricano tutto il result set?
- [ ] Le query sono allineate a `sprintj/.../sql.properties` (nessun mock)?
- [ ] Le query MyBatis sono in file XML (`resources/mapper/`), non in annotazioni Java?

## Riferimenti

- Inventario tabelle: [schema/tables.md](../../../schema/tables.md)
- Mapping API: [schema/api-tables.md](../../../schema/api-tables.md)
- Workflow API: [sprint-api](../sprint-api/SKILL.md)
- Monorepo: [sprint](../sprint/SKILL.md)
