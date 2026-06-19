# Integrazione sistemi esterni CSI — LOTO (comuni) e Toponomastica (indirizzi)

Analisi per l'integrazione degli autocomplete **comuni** (`GET /comuni/suggest`) e
**indirizzi** (`GET /indirizzi/suggest`) con i servizi esterni CSI, oggi assenti nel nuovo
backend (`sprintbff`). Corrisponde alle voci **A5** e **A6** di
[api-da-implementare.md](./api-da-implementare.md).

> Stato attuale nel BFF: entrambi gli endpoint rispondono **HTTP 501**
> (`FunzionalitaNonImplementataException`). `suggestComuni` funziona solo con
> `soloConRichieste=true` (vista `VSDE_RIC_38_STRAO_PT_TUTTE`), non come autocomplete completo.

**Fonti legacy (sola lettura):**

| Artefatto | Percorso |
|-----------|----------|
| Helper LOTO | `sprintj/.../integration/papd/impl/LotoHelperImpl.java`, `ILotoHelper.java` |
| Helper Toponomastica | `sprintj/.../integration/papd/impl/ToponomasticaHelperImpl.java`, `IToponomasticaHelper.java` |
| Config endpoint PD | `sprintj/.../integration/papd/InfoPortaDelegataList.java` |
| Config XML PD LOTO | `sprintj/conf/application/loto/defpd_loto.xml` |
| Costanti / nomi property | `sprintj/.../util/Constants.java` (`PROP_LOTO_PORTA_DELEGATA_FILE`, `PROP_TOPONOMASTICA_TOPO_PORTA_DELEGATA_FILE`) |
| Uso applicativo | `RichiestaBean.java`, `CommonBean.java`, `RicercaVeloceComune.java` |

---

## 1. Cosa sono i due sistemi

| Endpoint BFF | Sistema CSI | Package client | Operazione legacy |
|--------------|-------------|----------------|-------------------|
| `GET /comuni/suggest` | **LOTO / Ginevra** | `it.csi.ginevra.loto.*` | `cercaComuni(nome, provincia)` |
| `GET /indirizzi/suggest` | **SITAD Toponomastica** (`tpnm`/`lmam`/`arcm`) — il PD LOTO espone anche `cercaVieComunaliByNome` | `it.csi.sitad.tpnm.entity.Via`, ecc. | `cercaVieByNome(token, idComune)` |

LOTO restituisce `Comune`; Toponomastica restituisce `Via`. Entrambi vanno mappati su `LookupItem`
(`codice`/`descrizione`) del contratto OpenAPI già esistente (nessuna modifica al contratto).

## 2. Come si integra il legacy (meccanismo)

1. **Porta Delegata CSI**: `it.csi.csi.porte.proxy.PDProxy.newInstance(InfoPortaDelegata)` crea
   uno **stub SOAP tipizzato** (es. `LotoSrv`) a partire da un file XML di configurazione
   (`defpd_loto.xml`) che descrive servizio, operazioni ed endpoint **per ambiente**.
2. **Autenticazione IRIDE2** propagata via plugin della Porta Delegata, storicamente legata a
   **WebLogic + JAAS** (`it.csi.csi.porte.ejb.jaas.weblogic.WeblogicJAASNativeClient`).
3. **Dipendenze = JAR client CSI interni**: `it.csi.csi.porte`, `it.csi.ginevra.loto.*`,
   `it.csi.sitad.tpnm/lmam/arcm`. **Non presenti** in questo checkout (`sprintj/lib` vuoto,
   `conf/application/tope` vuoto): da reperire dal repository CSI `repart.csi.it`.

Estratto `defpd_loto.xml` (operazioni esposte dal PD LOTO):

```xml
<service name="loto" public-interface-class="it.csi.ginevra.loto.interfacecsi.loto.LotoSrv" ...>
  <operation name="cercaVieComunaliByNome" type="synch-call"> ... </operation>
  <operation name="cercaViaComunaleById" type="synch-call"> ... </operation>
  ...
</service>
```

## 3. Perché è "da zero" nel nuovo stack

**Il BFF non usa la Porta Delegata.** Gestisce IRIDE via **header Shibboleth**
(`Shib-Iride-IdentitaDigitale`, vedi `IrideIdAdapterFilter`), non via SOAP/JAAS. Quindi:

- non c'è alcun plumbing PD/IRIDE2 riutilizzabile in `sprintbff`;
- i due endpoint REST in sé sono banali (mapping DTO→`LookupItem`, ApiImpl già cablato): **~1 g**;
- **il costo è tutto nel client di integrazione e nei prerequisiti CSI**, non nel codice BFF.

## 4. Scenari di integrazione e stima (sviluppo, a prerequisiti sbloccati)

| Scenario | Descrizione | Stima dev | Rischio |
|----------|-------------|-----------|---------|
| **C — facade REST moderno** | CSI espone LOTO/TOPE in REST → solo HTTP client + mapping | **2–4 g** | Basso *(da confermare che esista)* |
| **A — client SOAP moderno (CXF/JAX-WS)** ⭐ | Stub da WSDL, auth IRIDE via SOAP header, config per ambiente, timeout/errori, mapping | **6–9 g** | Medio — **consigliato** |
| **B — riuso framework PD legacy** | Portare `it.csi.csi.porte` + helper `papd` in Spring Boot | **4–16 g** | **Alto**: accoppiamento WebLogic/JAAS fuori da WebLogic |

A ciascuno aggiungere **~1 g** per i due endpoint, caching/debounce dei comuni e gestione
"servizio non disponibile".

### Headline

- **Caso realistico (Scenario A): ~1,5–2 settimane/uomo** per entrambi gli endpoint, una volta ottenuti accessi e WSDL.
- **Caso migliore (C): ~3–4 giorni.** **Caso peggiore (B che resiste): ~3 settimane.**

## 5. Prerequisiti CSI (lead time, non sviluppo — spesso il vincolo principale)

1. **JAR client / WSDL** di LOTO-Ginevra e SITAD Toponomastica dal repo CSI `repart.csi.it`.
2. **Config PD + endpoint e credenziali** per l'ambiente del BFF (test/prod).
3. **Contratto di propagazione identità IRIDE2** per chiamate servizio-servizio (il BFF ha il
   token IRIDE dall'header: capire cosa si aspetta il servizio esterno).
4. **Apertura di rete/firewall** dal runtime del BFF verso gli endpoint PD/servizio.
5. **Referente CSI** per LOTO (Ginevra) e per SITAD Toponomastica.

## 6. Raccomandazione e prossimo passo

1. **Chiedere a CSI se LOTO/Toponomastica sono esposti in REST moderno** (Scenario C): cambia il
   costo da settimane a giorni.
2. Se solo SOAP → **Scenario A** (client CXF Spring-native). **Evitare** lo Scenario B (framework
   PD legacy WebLogic).
3. **Scheletro proponibile subito** (sblocca poco e isola il rischio): definire le interfacce
   `LotoClient` / `ToponomasticaClient` nel BFF, iniettarle in `LookupManager`, e tenere
   l'implementazione reale dietro **feature-flag**; finché gli accessi non sono pronti
   `suggestComuni`/`suggestIndirizzi` continuano a rispondere 501 (nessun mock, da regola progetto).

```
LookupManager
  ├── LotoClient.cercaComuni(nome, provincia)        → List<LookupItem>
  └── ToponomasticaClient.cercaVie(testo, idComune)  → List<LookupItem>
        ▲ impl: CXF/JAX-WS (Scenario A) o HTTP REST (Scenario C), dietro feature-flag
```

## 7. Mapping endpoint → servizio (riferimento)

| Metodo | Path | operationId | Servizio esterno | Stato |
|--------|------|-------------|------------------|-------|
| GET | `/comuni/suggest` | `suggestComuni` | LOTO/Ginevra `cercaComuni` | 501 (parziale: `soloConRichieste=true` da DB) |
| GET | `/indirizzi/suggest` | `suggestIndirizzi` | SITAD Toponomastica `cercaVieByNome` | 501 |
</content>
