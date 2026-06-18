---
name: sprint
description: >-
  Guida lo sviluppo del progetto Sprint diviso in tre repository (sprintbff,
  sprintwcl, sprintj) clonati accanto al meta-repo sprint-ia. Usa quando si
  lavora su Sprint, si aggiungono API, si modifica il frontend Angular, si
  consulta il legacy JSP, o si gestisce il setup locale.
---

# Sprint — meta-repo con repository separati

Meta-repository che orchestra tre progetti GitLab CSI, clonati localmente con `./scripts/clone-repos.sh`.

## Struttura

```
sprint-ia/          # questo meta-repo (config, skill, script)
├── schema/         # migrations SQL + mapping API→tabelle
├── sprintbff/      # backend Spring Boot — nuove API
├── sprintwcl/      # frontend Angular (ultima versione)
└── sprintj/        # backend legacy JSP — SOLO LETTURA
```

| Cartella    | Stack        | Repository | Modificabile |
|-------------|--------------|------------|--------------|
| `sprintbff` | Spring Boot  | `https://gitlab.csi.it/prodotti/sprint/sprintbff.git` | Sì |
| `sprintwcl` | Angular      | `https://gitlab.csi.it/prodotti/sprint/sprintwcl.git` | Sì |
| `sprintj`   | Java/JSP legacy | `https://gitlab.csi.it/prodotti/sprint/sprintj` | **Mai** |

## Regole operative

### sprintbff — nuove API

- **Java:** JDK **25** per build e runtime (`sprintbff/.java-version`), ma il codice usa solo feature **Java 17** (`java.version=17` in `pom.xml`, `--release 17`). Non introdurre sintassi o API di Java 18+ (record migliorati, pattern matching avanzato, string templates, ecc.).
- Tutte le nuove API REST vanno implementate qui (Spring Boot).
- **Niente mock/stub in-memory nel BFF:** ogni endpoint legge dal DB PostgreSQL (MyBatis, query da `sprintj/.../sql.properties`) oppure lancia un'eccezione parlante (`FunzionalitaNonImplementataException`, `ErroreGestitoException`). Mai restituire dati fittizi.
- **Contract-first:** definire prima `src/main/resources/static/api/openapi.yaml`, poi rigenerare backend e frontend. Vedi skill [sprint-api](../sprint-api/SKILL.md). Script unificato: `./scripts/regenerate-api.sh`.
- **Schema DB:** PostgreSQL, migrations in `schema/migrations/`, mapping API→tabelle in `schema/api-tables.md`, entity/DAO con Lombok. Vedi skill [schema](../schema/SKILL.md).
- **Conversioni Row/Entity → VO:** usare **MapStruct** (`api.mapper`), non setter manuali nei Manager. Vedi skill [backend](../backend/SKILL.md).
- Commit e push sul repository `sprintbff`, non sul meta-repo.

### sprintwcl — nuovo frontend

- Frontend Angular 22 con ultima versione del framework.
- **UI con Angular Material:** usare i componenti `@angular/material` (tabelle, form, dialog, snackbar, toolbar, ecc.) e il theming Material. Non introdurre librerie UI alternative.
- **Evitare componenti custom:** non creare wrapper o componenti riutilizzabili “da zero” se esiste un equivalente Material (es. `mat-table`, `mat-form-field`, `mat-dialog`, `mat-button`). I componenti Angular servono solo per orchestrare pagine/feature (routing, chiamate API, binding dati), non per reinventare widget UI.
- **Paginazione tabelle (backend):** ogni tabella dati (`mat-table`) che mostra risultati da API deve usare `mat-paginator` collegato a parametri `page` / `pageSize` dell'endpoint e al conteggio totale in risposta. A ogni cambio pagina o page size si richiama il backend. Non caricare l'intero dataset e paginare lato client.
- **Colonne tabella configurabili:** ogni `mat-table` deve permettere all'utente di scegliere quali colonne visualizzare tramite popup (`mat-dialog`), con preferenze in `sessionStorage` prefissate per pagina. Vedi skill [table-columns](../table-columns/SKILL.md).
- **Colonne tabella configurabili:** ogni `mat-table` deve permettere all'utente di scegliere quali colonne visualizzare tramite popup (`mat-dialog`), con preferenze in `sessionStorage` prefissate per pagina. Vedi skill [table-columns](../table-columns/SKILL.md).
- Consuma le API di `sprintbff`.
- **HTTP nei componenti:** ogni `.subscribe()` su chiamate API deve usare `takeUntilDestroyed` (vedi regola `.cursor/rules/frontend-http.mdc`).
- **Loading globale:** lo spinner a pagina intera è gestito da `loadingInterceptor` in `src/app/core/loading/`; non duplicare overlay locali per le stesse richieste.
- Commit e push sul repository `sprintwcl`.

### sprintj — legacy (sola consultazione)

- **Non modificare mai** file in `sprintj/`.
- **Non fare commit** dentro `sprintj/`.
- **Non fare push** da `sprintj/`.
- Usare solo per capire comportamento esistente, endpoint legacy, JSP e logica di business storica.
- Se serve replicare una funzionalità, implementarla in `sprintbff` + `sprintwcl`.

## Setup iniziale

Richiede accesso VPN/rete CSI e credenziali GitLab.

```bash
# con Personal Access Token (consigliato, funziona anche da Cursor)
export GITLAB_TOKEN=glpat-...
./scripts/clone-repos.sh

# oppure clone interattivo dal terminale (chiede username/password)
./scripts/clone-repos.sh
```

**Maven (sprintbff):** il plugin CSI `csi-java-swagger3-codegen` è nel repository interno CSI. `scripts/dev.sh` e `scripts/regenerate-api.sh` usano `~/.m2/settings-manu.xml` quando disponibile. Il `pom.xml` di `sprintbff` non va modificato per questo.

## Workflow commit

1. Lavora nel repository corretto (`sprintbff` o `sprintwcl`).
2. Commit e push **nel repository del progetto** (`git -C sprintbff ...` o aprendo quella cartella in Cursor).

```bash
cd sprintwcl
git add .
git commit -m "feat: ..."
git push
```

## Dove implementare cosa

| Richiesta | Repository |
|-----------|------------|
| Nuova API REST | `sprintbff` |
| Nuova pagina / componente UI | `sprintwcl` |
| Capire come funziona oggi il legacy | `sprintj` (solo lettura) |
| Bug nel nuovo stack | `sprintbff` o `sprintwcl` |
| Bug nel sistema legacy in produzione | **non** in `sprintj` — valutare migrazione verso `sprintbff` |

## Checklist agente

Prima di modificare codice:

- [ ] Su `sprintbff`: sto usando solo feature Java 17 (JDK 25 ok, niente API/sintassi post-17)?
- [ ] Ho identificato il repository corretto (`sprintbff` o `sprintwcl`)?
- [ ] Sto evitando qualsiasi modifica in `sprintj/`?
- [ ] Le nuove API vanno in `sprintbff`, non nel legacy?
- [ ] Per nuove API ho seguito il workflow contract-first (skill `sprint-api`)?
- [ ] Se l'API tocca il DB: migration PostgreSQL in `schema/migrations/`, riga in `schema/api-tables.md`, Lombok nel layer dati (skill `schema`)?
- [ ] Il frontend usa `sprintwcl` e punta alle API di `sprintbff`?
- [ ] L'UI usa componenti Angular Material, senza componenti custom dove esiste un equivalente Material?
- [ ] Le tabelle dati usano paginazione backend (`mat-paginator` → API con `page`/`pageSize`)?
- [ ] Le tabelle dati espongono configurazione colonne via popup e `sessionStorage` (skill `table-columns`)?
- [ ] Le tabelle dati espongono configurazione colonne via popup e `sessionStorage` (skill `table-columns`)?
- [ ] Il BFF non usa mock/stub in-memory: solo query DB reali o eccezione esplicita?
- [ ] Le conversioni di tipo nel BFF usano MapStruct (skill `backend`)?
