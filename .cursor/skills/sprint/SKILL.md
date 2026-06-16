---
name: sprint
description: >-
  Guida lo sviluppo del progetto Sprint diviso in tre repository (sprintbff,
  sprintwcl, sprintj) collegati come git submodule. Usa quando si lavora su
  Sprint, si aggiungono API, si modifica il frontend Angular, si consulta il
  legacy JSP, o si gestiscono i submodule.
---

# Sprint — monorepo a submodule

Meta-repository che orchestra tre progetti GitLab CSI.

## Struttura

```
sprint-ia/          # questo meta-repo (config, skill, script)
├── schema/         # migrations SQL + mapping API→tabelle
├── sprintbff/      # backend Spring Boot — nuove API
├── sprintwcl/      # frontend Angular (ultima versione)
└── sprintj/        # backend legacy JSP — SOLO LETTURA
```

| Submodule | Stack | Repository | Modificabile |
|-----------|-------|------------|--------------|
| `sprintbff` | Spring Boot | `https://gitlab.csi.it/prodotti/sprint/sprintbff.git` | Sì |
| `sprintwcl` | Angular | `https://gitlab.csi.it/prodotti/sprint/sprintwcl.git` | Sì |
| `sprintj` | Java/JSP legacy | `https://gitlab.csi.it/prodotti/sprint/sprintj` | **Mai** |

## Regole operative

### sprintbff — nuove API

- Tutte le nuove API REST vanno implementate qui (Spring Boot).
- **Contract-first:** definire prima `src/main/resources/static/api/openapi.yaml`, poi rigenerare backend e frontend. Vedi skill [sprint-api](../sprint-api/SKILL.md). Script unificato: `./scripts/regenerate-api.sh`.
- **Schema DB:** migrations in `schema/migrations/`, mapping API→tabelle in `schema/api-tables.md`. Vedi skill [schema](../schema/SKILL.md).
- Commit e push sul repository `sprintbff`, non sul meta-repo.
- Dopo il push, aggiorna il puntatore submodule nel meta-repo se necessario.

### sprintwcl — nuovo frontend

- Frontend Angular 22 con ultima versione del framework.
- **UI con Angular Material:** usare i componenti `@angular/material` (tabelle, form, dialog, snackbar, toolbar, ecc.) e il theming Material. Non introdurre librerie UI alternative.
- **Evitare componenti custom:** non creare wrapper o componenti riutilizzabili “da zero” se esiste un equivalente Material (es. `mat-table`, `mat-form-field`, `mat-dialog`, `mat-button`). I componenti Angular servono solo per orchestrare pagine/feature (routing, chiamate API, binding dati), non per reinventare widget UI.
- Consuma le API di `sprintbff`.
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
./scripts/init-submodules.sh

# oppure clone interattivo dal terminale (chiede username/password)
./scripts/init-submodules.sh
```

## Comandi submodule utili

```bash
# stato
git submodule status

# aggiorna sprintbff e sprintwcl all'ultimo commit remoto
git submodule update --remote sprintbff sprintwcl

# sprintj resta bloccato (update = none in .gitmodules)
```

## Workflow commit

1. Lavora nel submodule corretto (`sprintbff` o `sprintwcl`).
2. Commit e push **nel repository del submodule**.
3. Torna al meta-repo e, se serve, registra il nuovo SHA del submodule:

```bash
cd /path/to/sprint-ia
git add sprintbff   # o sprintwcl
git commit -m "chore: aggiorna sprintbff a <descrizione>"
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

- [ ] Ho identificato il submodule corretto?
- [ ] Sto evitando qualsiasi modifica in `sprintj/`?
- [ ] Le nuove API vanno in `sprintbff`, non nel legacy?
- [ ] Per nuove API ho seguito il workflow contract-first (skill `sprint-api`)?
- [ ] Se l'API tocca il DB: migration in `schema/migrations/` e riga in `schema/api-tables.md` (skill `schema`)?
- [ ] Il frontend usa `sprintwcl` e punta alle API di `sprintbff`?
- [ ] L'UI usa componenti Angular Material, senza componenti custom dove esiste un equivalente Material?
