# Motore di ricerca avanzata — design (fase 3, rimosso dal contratto)

Documento di **conservazione del design** del motore di ricerca avanzata legacy.

> **Stato: rimosso dal contratto OpenAPI il 2026-06-19.** Gli 8 endpoint `/motore-ricerca/*`
> erano presenti in `openapi.yaml` ma **non implementati** (tutti HTTP 501) e **senza alcun
> consumatore** (nel frontend esistevano solo come servizi generati, mai usati da una pagina).
> Per coerenza con il principio contract-first (il contratto deve riflettere ciò che esiste)
> sono stati eliminati. Questo documento conserva il design per re-introdurli in **fase 3**.

Riferimento gap analysis: [api-da-implementare.md](./api-da-implementare.md) (voci A7–A13).

**Fonti legacy (sola lettura):**

| Artefatto | Percorso |
|-----------|----------|
| DTO motore ricerca | `sprintj/.../dto/ricerca/MotoreRicercaDTO.java`, `ItemMotoreRicercaDTO.java` |
| DAO ricerca | `sprintj/.../integration/dao/ricerca/` (+ `impl/sql.properties`) |
| Metadati (dominio) | `SPRINT_D_RICHIESTA_GENERICA` (`NOME_COLONNA` in `FK_CAMPO_RIS_RICERCA`, `FK_DESCR_CAMPO_RIS_RICERCA`) e tabelle `SPRINT_MTD_*` |

---

## 1. Cosa faceva (modello a metadati)

Il motore di ricerca avanzata è un **query builder dinamico guidato da metadati**, per profilo
utente:

1. l'utente sceglie un **oggetto** ricercabile (es. richieste, eventi);
2. il sistema espone i **criteri** filtrabili per quell'oggetto e i relativi **valori** ammessi;
3. l'utente compone N **condizioni** (criterio + operatore + valore, con connettori AND/OR);
4. il sistema esegue la query e restituisce righe paginate, con **campi-risultato** (colonne)
   anch'essi definiti dai metadati;
5. esistono **ricerche predefinite** salvate, eseguibili direttamente.

## 2. Endpoint rimossi (da re-introdurre in fase 3)

| Metodo | Path | operationId | Scopo |
|--------|------|-------------|-------|
| GET | `/motore-ricerca/oggetti` | `getMotoreRicercaOggetti` | Oggetti ricercabili per profilo |
| GET | `/motore-ricerca/predefinite` | `getMotoreRicercaPredefinite` | Ricerche salvate per profilo |
| GET | `/motore-ricerca/oggetti/{idOggetto}/criteri` | `getMotoreRicercaCriteriByOggetto` | Criteri filtrabili dell'oggetto |
| GET | `/motore-ricerca/oggetti/{idOggetto}/campi-risultato` | `getMotoreRicercaCampiRisultatoByOggetto` | Colonne risultato dell'oggetto |
| GET | `/motore-ricerca/criteri/{idCriterio}/valori` | `getMotoreRicercaValoriByCriterio` | Valori ammessi per un criterio |
| POST | `/motore-ricerca/esecuzione` | `eseguiMotoreRicerca` | Esegue una ricerca composta |
| POST | `/motore-ricerca/predefinite/{id}/esecuzione` | `eseguiMotoreRicercaPredefinita` | Esegue una ricerca salvata |

## 3. Schemi rimossi

Modelli eliminati da `components/schemas` (solo motore-ricerca):

- `OggettoRicercaItem` — `idOggetto`, `alias`, `tipoOggetto`, `legge?`, `stato?`
- `RicercaPredefinitaItem` — `idRicercaPred`, `titoloRicerca`, `tipoOggetto`
- `CriterioRicercaItem` — `idCriterio`, `nome`, `tipo?`
- `CampoRisultatoItem` — `idCampo`, `nome`, `ordine?`
- `MotoreRicercaCondizione` — `idCriterio`, `operatore` (`= <> < > <= >=`), `valore`, `connettore` (`AND`/`OR`)
- `MotoreRicercaEsecuzioneRequest` — `idOggetto`, `condizioni[]`, `page`, `pageSize`

> ⚠️ **Conservati** perché condivisi con la ricerca eventi (`POST /eventi/cerca`):
> `CercaRisultatoPage` e `CercaItemRisultato`. La risposta dell'esecuzione motore-ricerca
> riusava `CercaRisultatoPage`: alla re-introduzione si può continuare a riusarlo.

## 4. Stima re-introduzione (fase 3)

**8–15 giorni/uomo** (vedi A7–A13 in [api-da-implementare.md](./api-da-implementare.md)): è la
voce più pesante perché richiede il motore di esecuzione con query builder dinamico su
metadati. Va trattata come mini-progetto a sé (metadati + esecuzione + UI dedicata).

## 5. Come re-introdurli (workflow contract-first)

1. Ripristinare in `openapi.yaml` i 7 path e i 6 schemi sopra (riusando `CercaRisultatoPage`).
2. `mvn -s ~/.m2/settings-manu.xml generate-sources` → rigenera `MotoreRicercaApi` + VO.
3. Implementare `MotoreRicercaApiImpl` + `MotoreRicercaManager` su query reali dai metadati
   (no mock; query MyBatis in XML, vedi regola `mybatis-xml`).
4. `./scripts/regenerate-api.sh` per rigenerare anche i servizi Angular.
5. Realizzare la pagina di ricerca avanzata in `sprintwcl` (Angular Material).
</content>
