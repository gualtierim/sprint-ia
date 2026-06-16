# Spec funzionali Sprint

Analisi delle pagine legacy e proposta API REST per la migrazione verso `sprintbff` + `sprintwcl`.

| Documento | Pagina legacy | Stato |
|-----------|---------------|-------|
| [ricerca-do.md](./ricerca-do.md) | `ricerca.do` — motore di ricerca | Bozza |

Ogni spec descrive:

1. Entità coinvolte e tabelle Oracle
2. Flusso legacy (Struts/JSP)
3. Bozza endpoint OpenAPI orientati alla **risorsa di dominio** (senza prefisso `/ricerca`), da aggiungere in `sprintbff/src/main/resources/static/api/openapi.yaml`
