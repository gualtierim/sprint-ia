# sprint-ia

Meta-repository per lo sviluppo Sprint: skill Cursor, schema DB, script e specifiche.

I tre progetti applicativi sono **repository Git separati**, clonati nella stessa cartella:

| Cartella    | Stack        | Repository GitLab                                      |
|-------------|--------------|--------------------------------------------------------|
| `sprintbff` | Spring Boot  | `https://gitlab.csi.it/prodotti/sprint/sprintbff.git`  |
| `sprintwcl` | Angular      | `https://gitlab.csi.it/prodotti/sprint/sprintwcl.git`  |
| `sprintj`   | JSP legacy   | `https://gitlab.csi.it/prodotti/sprint/sprintj.git`    |

## Setup

Richiede accesso VPN/rete CSI e credenziali GitLab.

```bash
# con Personal Access Token (consigliato)
export GITLAB_TOKEN=glpat-...
./scripts/clone-repos.sh

# oppure clone interattivo (chiede username/password)
./scripts/clone-repos.sh
```

## Struttura

```
sprint-ia/          # questo meta-repo (config, skill, script)
├── schema/         # migrations SQL + mapping API→tabelle
├── sprintbff/      # backend Spring Boot — nuove API (git clone)
├── sprintwcl/      # frontend Angular (git clone)
└── sprintj/        # backend legacy JSP — SOLO LETTURA (git clone)
```

Commit e push vanno nei rispettivi repository (`sprintbff`, `sprintwcl`), non in `sprint-ia`.
