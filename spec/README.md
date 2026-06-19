# Spec funzionali Sprint

Analisi delle pagine legacy e proposta API REST per la migrazione verso `sprintbff` + `sprintwcl`.

| Documento | Pagina legacy | Stato |
|-----------|---------------|-------|
| [ricerca-do.md](./ricerca-do.md) | `ricerca.do` — motore di ricerca | Bozza |
| [creazione-richiesta.md](./creazione-richiesta.md) | `nuovaRichiesta.do` + wizard folder 0–5 + allegati | Bozza |
| [api-da-implementare.md](./api-da-implementare.md) | Gap analysis API non implementate + stima effort | Bozza |
| [integrazione-loto-tope.md](./integrazione-loto-tope.md) | Integrazione esterni CSI: LOTO (comuni) + Toponomastica (indirizzi) | Bozza |
| [motore-ricerca.md](./motore-ricerca.md) | Motore di ricerca avanzata — design conservato (rimosso dal contratto, fase 3) | Bozza |

Ogni spec descrive:

1. Entità coinvolte e tabelle Oracle
2. Flusso legacy (Struts/JSP)
3. Bozza endpoint OpenAPI orientati alla **risorsa di dominio** (senza prefisso `/ricerca`), da aggiungere in `sprintbff/src/main/resources/static/api/openapi.yaml`
