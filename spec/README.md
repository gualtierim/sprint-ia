# Spec funzionali Sprint

Analisi delle pagine legacy e proposta API REST per la migrazione verso `sprintbff` + `sprintwcl`.

| Documento | Pagina legacy | Stato |
|-----------|---------------|-------|
| [ricerca-do.md](./ricerca-do.md) | `ricerca.do` — motore di ricerca | Bozza |
| [creazione-richiesta.md](./creazione-richiesta.md) | `nuovaRichiesta.do` + wizard folder 0–5 + allegati | Bozza |
| [api-da-implementare.md](./api-da-implementare.md) | Gap analysis API non implementate + stima effort | Bozza |
| [integrazione-loto-tope.md](./integrazione-loto-tope.md) | Integrazione esterni CSI: LOTO (comuni) + Toponomastica (indirizzi) | Bozza |
| [motore-ricerca.md](./motore-ricerca.md) | Motore di ricerca avanzata — design conservato (rimosso dal contratto, fase 3) | Bozza |
| [validazione-richieste.md](./validazione-richieste.md) | Campi obbligatori richieste — validazione backend + frontend (stato e gap) | Bozza |
| [dati-generali-folder.md](./dati-generali-folder.md) | Folder "Dati generali" — allineamento layout/campi al JSP legacy | Bozza |
| [dati-tecnico-amministrativi-folder.md](./dati-tecnico-amministrativi-folder.md) | Folder "Dati tecnico-amministrativi" — allineamento layout/campi al JSP legacy | Bozza |
| [dati-economici-folder.md](./dati-economici-folder.md) | Folder "Dati economici" — quadro economico, annualità, stralci vs JSP legacy | Bozza |
| [dati-mappa-folder.md](./dati-mappa-folder.md) | Folder "Dati mappa" — geometria punto + ricerca comune; TOPE/aree idro deferred | Bozza |
| [valutazione-pericolosita-folder.md](./valutazione-pericolosita-folder.md) | Folder "Valutazione pericolosità" — frane/conoidi/valanghe/idro su SPRINT_T_RIC_183 vs JSP legacy | Bozza |
| [analisi-del-rischio-folder.md](./analisi-del-rischio-folder.md) | Folder "Analisi del rischio" — elementi a rischio, vulnerabilità, classe di rischio vs JSP legacy | Bozza |
| [allegati-folder.md](./allegati-folder.md) | Folder "Allegati" — lista + upload file vs JSP legacy | Bozza |
| [storico-folder.md](./storico-folder.md) | Folder "Storico" — `storicoRichiesta.jsp` (archivio storico richiesta), tabella read-only + condizione di visibilità | Bozza |
| [stampa-richiesta.md](./stampa-richiesta.md) | Funzione di Stampa — `pulsantiStampe.jsp` / `StampeAction` (lettere PDF) | Bozza |
| [esportazione-csv-richieste.md](./esportazione-csv-richieste.md) | Esportazione risultati ricerca — `pulsantiRicerca.jsp` / `RicercaAction.scaricaExcel` (export, proposta CSV) | Bozza |
| [visualizza-richieste-mappa.md](./visualizza-richieste-mappa.md) | Visualizza tutte le richieste su mappa — `pulsantiRicerca.jsp` / `RicercaAction.ricercaMappa` (mappa OpenLayers risultati ricerca) | Bozza |

Ogni spec descrive:

1. Entità coinvolte e tabelle Oracle
2. Flusso legacy (Struts/JSP)
3. Bozza endpoint OpenAPI orientati alla **risorsa di dominio** (senza prefisso `/ricerca`), da aggiungere in `sprintbff/src/main/resources/static/api/openapi.yaml`
