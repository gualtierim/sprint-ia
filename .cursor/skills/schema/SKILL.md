---
name: schema
description: >-
  Schema database Oracle Sprint e migrations SQL versionate in schema/migrations/.
  Usa quando si aggiungono o modificano tabelle, colonne, indici, vincoli, script DDL/DML,
  Flyway, accesso dati in sprintbff, o serve sapere quali tabelle usa un'API.
---

# Sprint — schema database

Il database Sprint è Oracle. Lo schema condiviso tra legacy (`sprintj`) e nuovo stack (`sprintbff`) vive nel meta-repo.

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
| Idempotenza | preferire `CREATE TABLE` su schema vuoto; per ALTER usare controlli Oracle se necessario |
| Mai modificare file già applicati | creare una nuova migration |

Esempio:

```sql
-- V002__create_sprint_t_esempio.sql
CREATE TABLE SPRINT_T_ESEMPIO (
    ID_ESEMPIO   NUMBER(19)      NOT NULL,
    DESCRIZIONE  VARCHAR2(255),
    MOD_DATA     DATE            DEFAULT SYSDATE NOT NULL,
    MOD_UTENTE   VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_SPRINT_T_ESEMPIO PRIMARY KEY (ID_ESEMPIO)
);
```

## Workflow obbligatorio

```
Task Progress:
- [ ] 1. Verificare tabelle esistenti in schema/tables.md e sql.properties di sprintj
- [ ] 2. Scrivere migration in schema/migrations/
- [ ] 3. Aggiornare schema/tables.md se si aggiungono tabelle
- [ ] 4. Implementare accesso dati in sprintbff (*Manager / DAO)
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

## Consultare il legacy

Per capire quali tabelle e query usa oggi una funzionalità:

```
sprintj/src/java/it/csi/sprint/integration/dao/*/impl/sql.properties
```

**Non modificare** `sprintj/`. Usarlo solo come riferimento per replicare la logica in `sprintbff`.

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
- [ ] Non ho toccato file in `sprintj/`?

## Riferimenti

- Inventario tabelle: [schema/tables.md](../../../schema/tables.md)
- Mapping API: [schema/api-tables.md](../../../schema/api-tables.md)
- Workflow API: [sprint-api](../sprint-api/SKILL.md)
- Monorepo: [sprint](../sprint/SKILL.md)
