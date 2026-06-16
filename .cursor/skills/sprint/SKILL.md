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

- Tutte le nuove API REST vanno implementate qui (Spring Boot).
- **Contract-first:** definire prima `src/main/resources/static/api/openapi.yaml`, poi rigenerare backend e frontend. Vedi skill [sprint-api](../sprint-api/SKILL.md). Script unificato: `./scripts/regenerate-api.sh`.
- **Schema DB:** migrations in `schema/migrations/`, mapping API→tabelle in `schema/api-tables.md`. Vedi skill [schema](../schema/SKILL.md).
- Commit e push sul repository `sprintbff`, non sul meta-repo.

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
./scripts/clone-repos.sh

# oppure clone interattivo dal terminale (chiede username/password)
./scripts/clone-repos.sh
```

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

- [ ] Ho identificato il repository corretto (`sprintbff` o `sprintwcl`)?
- [ ] Sto evitando qualsiasi modifica in `sprintj/`?
- [ ] Le nuove API vanno in `sprintbff`, non nel legacy?
- [ ] Per nuove API ho seguito il workflow contract-first (skill `sprint-api`)?
- [ ] Se l'API tocca il DB: migration in `schema/migrations/` e riga in `schema/api-tables.md` (skill `schema`)?
- [ ] Il frontend usa `sprintwcl` e punta alle API di `sprintbff`?
- [ ] L'UI usa componenti Angular Material, senza componenti custom dove esiste un equivalente Material?
