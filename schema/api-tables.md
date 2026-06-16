# Mapping API → tabelle

Endpoint definiti in `sprintbff/src/main/resources/static/api/openapi.yaml`.

Aggiornare questa tabella ogni volta che un endpoint accede al database.

| Metodo | Path | operationId | Manager | Tabelle |
|--------|------|-------------|---------|---------|
| GET | `/test/ping` | `ping` | `TestManager` | — (nessun accesso DB) |
| GET | `/pagine/ricerca/init` | `getPaginaRicercaInit` | `PagineManager` | — (stub; futuro: lookup multi-tabella) |
| GET | `/comuni/suggest` | `suggestComuni` | `PagineManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (stub) |
| GET | `/richieste/compilatori/suggest` | `suggestRichiesteCompilatori` | `PagineManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (stub) |
| POST | `/richieste/cerca` | `cercaRichieste` | `RicercaManager` | `VSDE_RIC_38_STRAO_PT_TUTTE` (stub) |
| POST | `/eventi/cerca` | `cercaEventi` | `RicercaManager` | `SPRINT_T_EVENTO`, … (stub) |

## Legenda

- **—** = endpoint senza accesso al database
- Tabelle in maiuscolo, separate da virgola se multiple
- Per nuove API: aggiungere una riga prima del commit
