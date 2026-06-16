---
name: sprint-api
description: >-
  Workflow contract-first per nuove API Sprint: definire prima OpenAPI in
  sprintbff/src/main/resources/static/api/openapi.yaml, poi rigenerare controller
  backend e servizi/modelli frontend. Usa quando si aggiungono o modificano API
  REST, endpoint, swagger, openapi, DTO o integrazione BFF-Angular.
---

# Sprint — API contract-first

Per ogni nuova API o modifica a un endpoint esistente, **partire sempre dallo Swagger/OpenAPI**. Il contratto è l'unica fonte di verità condivisa tra backend e frontend.

## Percorso obbligatorio del contratto

```
sprintbff/src/main/resources/static/api/openapi.yaml
```

Non creare file OpenAPI altrove. Non implementare endpoint a mano senza aver prima aggiornato questo file.

## Workflow obbligatorio

```
Task Progress:
- [ ] 1. Definire/aggiornare openapi.yaml
- [ ] 2. Rigenerare backend (interfacce API + VO)
- [ ] 3. Implementare la logica in *ApiImpl e Manager (se DB: migration + `schema/api-tables.md`, skill `schema`)
- [ ] 4. Rigenerare frontend (servizi + modelli)
- [ ] 5. Usare i servizi generati nei componenti Angular (UI con Angular Material, senza componenti custom)
```

### 1. Scrivere o modificare il contratto

Aprire `sprintbff/src/main/resources/static/api/openapi.yaml` e definire:

- `paths` — endpoint sotto `/api/v1` (il prefisso è in `JaxrsApplication`, non ripeterlo nei path)
- `operationId` — univoco, diventa nome di interfaccia/metodo generato
- `tags` — raggruppamento logico (es. `Test`)
- `components/schemas` — modelli condivisi (DTO/VO)
- `security` — di default `basicAuth` + header Iride lato runtime

**Convenzioni già in uso nel progetto:**

| Elemento | Convenzione |
|----------|-------------|
| Versione OpenAPI | `3.0.1` |
| Base URL dev | `http://localhost:8080/sprintbff/api/v1` |
| Risposta OK generica | `GenericResponse` |
| Errori | `Errore` con `code`, `errorMessage`, `fields` |
| Risposte standard | `400` → `Errore`, `403` → `Errore`, `default` → `Errore` |

**Esempio minimo di nuovo endpoint:**

```yaml
  /mio-modulo/azione:
    get:
      tags:
      - MioModulo
      summary: descrizione breve
      operationId: azione
      responses:
        "200":
          description: esito
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericResponse'
        "400":
          $ref: '#/components/responses/InvalidParameter'
        "403":
          $ref: '#/components/responses/Forbidden'
        default:
          description: errore generico
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Errore'
      security:
      - basicAuth: []
```

Aggiungere eventuali nuovi schemi in `components/schemas`.

### 2. Rigenerare il backend

Dalla directory `sprintbff/`:

```bash
./mvnw generate-sources
# oppure
mvn generate-sources
```

**Cosa viene generato** (non modificare a mano):

| Output | Package |
|--------|---------|
| Interfacce REST (`*Api.java`) | `it.csi.sprint.sprintbff.api` |
| Modelli (`*.java`) | `it.csi.sprint.sprintbff.vo` |

**Cosa si implementa a mano** (protetto da `.swagger-codegen-ignore`):

| File | Ruolo |
|------|-------|
| `api/impl/*ApiImpl.java` | Implementazione endpoint, delega ai Manager |
| `api/manager/*Manager.java` | Logica di business |
| `api/parent/ParentApi.java` | Helper condivisi |

Dopo la rigenerazione:

1. Creare o aggiornare `*ApiImpl` se è un endpoint nuovo
2. Creare o aggiornare il `*Manager` corrispondente
3. Verificare che compili: `./mvnw compile`

### 3. Rigenerare backend + frontend insieme

Dalla root del meta-repo:

```bash
./scripts/regenerate-api.sh
```

Lo script esegue in sequenza:
1. `mvn generate-sources` in `sprintbff`
2. `npm run generate-api` in `sprintwcl`

### 4. Rigenerare solo il frontend

Il frontend Angular (`sprintwcl`) usa `ng-openapi-gen` configurato in `ng-openapi-gen.json`, con input il contratto del BFF:

```
sprintbff/src/main/resources/static/api/openapi.yaml
```

Output generato in `sprintwcl/src/app/api/` (servizi, modelli, barrel `index.ts`).

```bash
cd sprintwcl
npm install
npm run generate-api
```

**Regola:** ad ogni modifica di `openapi.yaml`, rigenerare **sempre** sia backend che frontend prima di proseguire con l'implementazione UI o i test di integrazione.

### 5. Implementare la UI con Angular Material

Nei componenti di pagina (`sprintwcl`):

- Comporre l'interfaccia con componenti **Angular Material** (`mat-table`, `mat-form-field`, `mat-select`, `mat-dialog`, `mat-paginator`, `mat-toolbar`, ecc.).
- **Non** creare componenti UI custom (wrapper, input, tabelle, modali homemade) se Material offre già il widget adatto.
- I componenti Angular restano sottili: iniettano i servizi generati da `src/app/api/`, gestiscono stato e navigazione; lo styling passa dal tema Material, non da CSS ad hoc su widget reinventati.

### 6. Commit

1. Commit in `sprintbff` (contratto + impl/manager + eventuali VO generati)
2. Commit in `sprintwcl` (servizi/modelli rigenerati + componenti)
3. Aggiornare il puntatore submodule nel meta-repo se necessario

Vedi anche la skill [sprint](../sprint/SKILL.md) per le regole sui submodule.

## Cosa non fare

- Non aggiungere `@Path` o endpoint JAX-RS senza passare da `openapi.yaml`
- Non creare DTO Java o interfacce TypeScript a mano se esistono nel contratto
- Non modificare file generati (`*Api.java`, `vo/*.java`, servizi/modelli Angular generati)
- Non usare `sprintj` come riferimento per nuove API REST
- Non creare componenti UI custom al posto di Angular Material

## Checklist agente

Prima di proporre o implementare una nuova API:

- [ ] Ho aggiornato `sprintbff/src/main/resources/static/api/openapi.yaml`?
- [ ] Ho eseguito `mvn generate-sources` in `sprintbff`?
- [ ] Ho creato/aggiornato `*ApiImpl` e `*Manager` senza toccare le interfacce generate?
- [ ] Ho rigenerato con `./scripts/regenerate-api.sh` (o i singoli comandi backend/frontend)?
- [ ] I path nel contratto sono coerenti con `/api/v1`?
- [ ] La UI usa Angular Material, senza componenti custom ridondanti?
