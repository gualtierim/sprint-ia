# API non ancora implementate — gap analysis e stima

Analisi dello stato di implementazione del **nuovo backend** (`sprintbff`) rispetto al
contratto `sprintbff/src/main/resources/static/api/openapi.yaml`, con stima dell'effort
residuo per portare ogni endpoint a piena implementazione su DB PostgreSQL.

> Aggiornato al 2026-06-19. Fonte di verità: codice in `sprintbff/.../api/manager/` e
> contratto OpenAPI. Riferimenti legacy in `sprintj/` (sola lettura).

## Metodo e criterio di "implementato"

Un endpoint è considerato **completo** quando legge/scrive sul DB reale (MyBatis, query
derivate da `sprintj/.../sql.properties`) o quando replica fedelmente il comportamento
legacy. Per le regole di progetto (`/commands/sprint-api`, `/commands/schema`) **non sono
accettati** dati mock/hardcoded né stato in-memory: questi casi rientrano nel gap.

Stato rilevato, tre tipologie di gap:

- **501** — il Manager lancia `FunzionalitaNonImplementataException` (nessun dato restituito).
- **MOCK** — l'endpoint risponde 200 ma con dati **hardcoded** nel codice (viola la regola "niente mock"): va ricondotto a DB/metadati legacy.
- **IN-MEMORY** — l'endpoint funziona ma persiste in `ConcurrentHashMap`, perde i dati al riavvio: va portato su DB.

Gli endpoint **non elencati** qui (`/test/ping`, `/leggi`, `/province`, `/richieste/stati`,
`/tipi-ente`, `/richieste/cerca`, `/eventi/cerca`, GET `/richieste/{id}` e GET dei folder,
PATCH dei folder su richieste già a DB, `/utente/contesto`, `suggestCompilatori`,
`/pagine/*/init`, geometria GET) sono già implementati su DB e fuori scope.

---

## A. Endpoint che rispondono 501 (funzionalità assente)

> **Aggiornamento implementazione (2026-06-19):** A1–A4 **implementati** su DB (`LookupManager` +
> query MyBatis in `LookupMapper`), nessuna modifica al contratto OpenAPI (restituiscono già
> `LookupItem`). Build `mvn compile` OK su JDK 25. Query validate sul DB di test PGSITTST.

| # | Endpoint | Manager | Cosa manca | Tabelle / dipendenza | Complessità | Stima |
|---|----------|---------|------------|----------------------|-------------|-------|
| A1 ✅ | `GET /tipi-strada` | `LookupManager.getTipiStrada` | ~~lookup tipi strada~~ **fatto** | `SPRINT_D_RICHIESTA_GENERICA` (FK_TIPO_STRADA) | Bassa | ~~0,5 g~~ |
| A2 ✅ | `GET /sedimi` | `LookupManager.getSedimi` | ~~lookup sedimi~~ **fatto** | `SPRINT_D_RICHIESTA_GENERICA` (FK_SEDIME) | Bassa | ~~0,5 g~~ |
| A3 ✅ | `GET /richieste/categorie` | `LookupManager.getCategorie` | ~~categorie danno~~ **fatto** (lista piatta CAT; idLegge non filtra, come legacy) | `SPRINT_D_RICHIESTA_GENERICA` (FK_CATEGORIA) | Bassa/Media | ~~1 g~~ |
| A4 ✅ | `GET /eventi` (non straordinari) | `LookupManager.getEventi` | ~~ramo `straordinario=false`~~ **fatto** (flg=0; null→straordinari, parità legacy) | `SPRINT_T_EVENTO` | Bassa | ~~0,5 g~~ |
| A5 | `GET /comuni/suggest` (LOTO) | `LookupManager.suggestComuni` | autocomplete comuni completo via servizio **LOTO** (oggi solo `soloConRichieste=true`) | servizio esterno LOTO | Media/Alta* | **2–3 g** |
| A6 | `GET /indirizzi/suggest` | `LookupManager.suggestIndirizzi` | autocomplete indirizzi via servizio **TOPE** | servizio esterno TOPE (`RicercaTopeDAO`) | Media/Alta* | **2–3 g** |
| A7–A13 | `/motore-ricerca/*` (7 endpoint) | — | **rimossi dal contratto** (erano 501, senza consumatori) | — | — | re-introduzione fase 3: **8–15 g** |

\* A5/A6 dipendono da **servizi esterni CSI** (LOTO, TOPE): la stima vale se il servizio è
raggiungibile e documentato. Se richiede convenzioni/credenziali/onboarding rete, l'effort
e i tempi possono crescere (rischio esterno, non di codice). **Analisi dedicata, scenari di
integrazione e prerequisiti: [integrazione-loto-tope.md](./integrazione-loto-tope.md).**

**Note motore ricerca (fase 3):** è la voce più pesante. Gli endpoint `/motore-ricerca/*` sono
stati **rimossi dal contratto** (erano 501 e senza consumatori) — design conservato in
[motore-ricerca.md](./motore-ricerca.md). Il legacy lo modella con `MotoreRicercaDTO` /
`ItemMotoreRicercaDTO`: oggetti → criteri → campi risultato e un costruttore di query dinamico
con paginazione. Va trattato come **mini-progetto a sé** (metadati + esecuzione + UI dedicata).

---

## B. Endpoint con dati hardcoded (MOCK — da ricondurre a DB)

Rispondono 200 ma con valori scritti nel codice: vanno alimentati dai metadati legge legacy
(`RichiestaDAOImpl.findHiddenFolderByLegge`, `findHiddenSectionByLegge`,
`findHiddenFieldByLegge` e tabelle `SPRINT_MTD_*`).

| # | Endpoint | Manager | Cosa manca | Complessità | Stima |
|---|----------|---------|------------|-------------|-------|
| B1 | `GET /richieste/{id}/layout` | `LayoutManager.getLayoutForLegge` | layout folder/sezioni e visibilità hardcoded → da metadati legge | Media | **2–3 g** |
| B2 | `GET /richieste/metadati/{idLegge}` | `MetadatiManager.getMetadatiByLegge` | campi e obbligatorietà hardcoded → da metadati legge | Media | **2 g** |

> B1 e B2 condividono la stessa fonte dati (metadati visibilità/obbligatorietà per legge):
> se affrontate insieme c'è riuso → **3–4 g** complessivi anziché 4–5.

---

## C. Flussi in-memory (da persistere su DB)

Il `RichiesteManager` mantiene richieste, geometrie e allegati in `ConcurrentHashMap`
(`richieste`, `geometrie`, `allegatiPerRichiesta`). Lettura/PATCH hanno già fallback DB per
richieste esistenti, ma **la creazione e gli allegati non toccano il DB**.

| # | Endpoint | Cosa manca | Tabelle target | Complessità | Stima |
|---|----------|------------|----------------|-------------|-------|
| C1 | `POST /richieste` (`creaRichiesta`) | INSERT bozza reale: generica + tabella specifica per legge, associazione evento, geometria punto su centroide comune | `SPRINT_T_RIC_GENERICA`, `SPRINT_T_RIC_38_CALAMITA`/`…_183`/`…_18_54_183`, `SPRINT_R_GEOMETRIA_RICHIESTA` | Alta | **3–5 g** |
| C2 | `POST /richieste/{id}/invia` (`inviaRichiesta`) | validazione completa (oggi solo 2 campi) + transizione stato + eventuale protocollo, su DB | `SPRINT_T_RIC_GENERICA` + metadati obbligatorietà (B2) | Media/Alta | **2–4 g** |
| C3 | `GET/POST/DELETE /richieste/{id}/allegati*` (`postAllegato`, `deleteAllegato`, `getAllegatoById`, `patchAllegati`) | CRUD reale + **storage file** (upload/download contenuto, non solo metadati) | `SPRINT_T_ALLEGATO_RIC`, `SPRINT_R_RICGEN_ALLEGATO` + storage | Media/Alta | **2–3 g** |
| C4 | `PUT /richieste/{id}/geometria` (`putGeometria`) | ramo in-memory per richieste appena create; dopo C1 va sempre su DB | `SPRINT_R_GEOMETRIA_RICHIESTA` | Bassa | **0,5 g** (con C1) |

> C1 è il prerequisito degli altri: senza creazione persistente, `putGeometria` e gli
> allegati su nuove richieste restano volatili. Conviene affrontare C1 → C4 → C3 → C2 in sequenza.

---

## Riepilogo stima

| Gruppo | Voci | Stima (giorni/uomo) |
|--------|------|----------------------|
| A1–A4 — lookup mancanti | 4 | **2,5 g** |
| A5–A6 — autocomplete servizi esterni (LOTO/TOPE) | 2 | **4–6 g** (rischio esterno) |
| A7–A13 — motore di ricerca avanzata | rimossi dal contratto | re-introduzione fase 3: **8–15 g** |
| B1–B2 — layout/metadati da DB | 2 | **3–4 g** |
| C1–C4 — persistenza creazione/invio/allegati | 4 aree | **7–12 g** |
| **Totale** | | **≈ 25–40 giorni/uomo** |

### Lettura rapida

- **Quick win (≈ 1 settimana):** A1, A2, A3, A4, C4 e l'avvio di B1/B2 — sblocco lookup e layout reali con poco rischio.
- **Core funzionale (≈ 2 settimane):** C1–C3 (persistenza vera di creazione, invio, allegati) → il flusso "nuova richiesta" smette di essere volatile. Vedi [creazione-richiesta.md](./creazione-richiesta.md).
- **Mini-progetto a parte (≈ 2–3 settimane):** motore di ricerca avanzata (A7–A13).
- **Dipendenze esterne (variabile):** LOTO/TOPE — pianificare presto la verifica di accesso ai servizi CSI, è l'incognita maggiore.

### Assunzioni della stima

- Sviluppatore che conosce lo stack (Spring Boot + MyBatis + MapStruct, workflow contract-first già rodato).
- 1 giorno/uomo ≈ sviluppo + migration `schema/migrations/` + aggiornamento `schema/api-tables.md` + test di base. **Esclusi** UI Angular, code review, QA end-to-end.
- Le query sono derivabili dal legacy (`sql.properties`); dove la tabella PostgreSQL non esiste ancora va aggiunta la migration (incluso nella stima dei lookup).
- Le voci con servizi esterni (A5/A6) hanno la varianza più alta: la stima copre l'integrazione, non eventuale onboarding/rete/credenziali.
</content>
</invoke>
