---
name: backend
description: >-
  Convenzioni backend sprintbff (Spring Boot): conversioni Row/Entity → VO con
  MapStruct, struttura Manager, Lombok nel layer dati. Codice swagger-codegen
  (interfacce *Api, vo/*) non va mai modificato a mano. Usa quando si
  implementano o modificano Manager, mapper, DTO interni o logica BFF.
---

# Sprint — backend (sprintbff)

Regole per il layer applicativo in `sprintbff/`. Per API contract-first vedi [sprint-api](../sprint-api/SKILL.md); per schema DB vedi [schema](../schema/SKILL.md).

## MapStruct per le conversioni di tipo

Per tutte le conversioni di tipo prova ad usare **MapStruct** per evitare meno boilerplate nel codice.

| Da | A | Dove |
|----|---|------|
| `dao.model.*Row` / `*Entity` | `vo.*` (OpenAPI) | `@Mapper` in `api.mapper` |
| `vo.*` (request) | `dao.model.*Params` / `*Criteria` | `*PersistVoMapper` + `*PatchLookupHelper` per lookup FK |
| `vo.*` → `vo.*` (copy/proiezione) | `@Mapper` con `@Mapping(ignore = …)` |

**Non** usare MapStruct su file generati da OpenAPI (`vo/*.java` come target di `@Mapper` sì, come sorgente di interfacce generate no).

### Setup Maven

Dipendenze e annotation processor già in `pom.xml`:

- `org.mapstruct:mapstruct`
- `mapstruct-processor` + `lombok-mapstruct-binding` in `maven-compiler-plugin` → `annotationProcessorPaths`

### Convenzioni package

```
sprintbff/src/main/java/it/csi/sprint/sprintbff/
├── api/mapper/           # interfacce MapStruct (@Mapper componentModel = "spring")
│   ├── MappingFormatters.java        # metodi @Named condivisi (parse, format, flag, …)
│   └── *PatchLookupHelper.java       # lookup FK su dominio (@Named, @Component)
├── api/manager/          # orchestrazione, query DB, lookup, validazione
└── dao/model/            # Row/Entity/Params (Lombok)
```

Naming mapper: `{Dominio}VoMapper` per read (Row→VO), `{Dominio}PersistVoMapper` per write (VO→Params/Criteria).

### Esempio mapper persist

```java
@Mapper(componentModel = "spring", uses = {MappingFormatters.class, RichiestaPatchLookupHelper.class})
public interface RichiestaPersistVoMapper {

    @Mapping(target = "fkStato", source = "body.stato", qualifiedByName = "parseInteger")
    @Mapping(target = "flgDissestoPai", source = "body.flgDissestoPai", qualifiedByName = "parseFlg01ToDb")
    PatchDatiGeneraliParams toDatiGeneraliParams(int idRichiesta, String modUtente, DatiGeneraliDto body);
}
```

Lookup FK durante il map → metodi `@Named` in un `@Component` helper (es. `RichiestaPatchLookupHelper`), non nel Manager.

### Esempio mapper read

```java
@Mapper(componentModel = "spring", uses = MappingFormatters.class)
public interface RicercaVoMapper {

    @Mapping(target = "importoSommaUrgenza", source = "importoSommaUrgenza", qualifiedByName = "bigDecimalToDouble")
    CercaRichiestaItemRisultato toItemRichiesta(RicercaRichiestaRow row);

    List<CercaRichiestaItemRisultato> toItemRichieste(List<RicercaRichiestaRow> rows);
}
```

Conversioni non banali (formato date, lookup FK, aggregazioni, campi calcolati da più sorgenti) → metodo `@Named` in `MappingFormatters` o `@AfterMapping` nel mapper; **non** setter manuali nel Manager.

### Cosa resta nel Manager

- Chiamate MyBatis e gestione errori (`DaoSupport`)
- Validazione business e eccezioni (`ErroreGestitoException`, …)
- Composizione quando servono query aggiuntive (es. allegati da seconda SELECT, update condizionali post-map)
- Impostazione campi derivati dopo il map (`stato` come `LookupItem`, `readOnly`, …)

Il Manager **delega** le conversioni puramente strutturali al mapper iniettato:

```java
private final RichiestaDetailVoMapper richiestaDetailVoMapper;

private RichiestaDetailResponse toDetailResponse(RichiestaDetailRow row) {
    RichiestaDetailResponse detail = richiestaDetailVoMapper.toDetailResponse(row);
    detail.setStato(statoLookup(row));
    detail.setReadOnly(isReadOnlyStato(row.getStato()));
    detail.setAllegati(loadAllegati(row));
    return detail;
}
```

### Quando non usare MapStruct

- Mapping con side-effect o accesso DB nel mezzo della conversione
- Logica di validazione / branching business complesso
- Conversioni one-off di una riga senza riuso (valuta comunque `@Named` prima di setter inline)

## Codice generato da swagger-codegen — non toccare

**Tutto** il codice prodotto da `mvn generate-sources` (swagger-codegen) è **read-only**: non modificarlo, non aggiungere annotazioni, import o metodi a mano. Se serve un cambiamento, aggiornare `openapi.yaml` e rigenerare (skill [sprint-api](../sprint-api/SKILL.md)).

| Output generato | Package / percorso | Azione consentita |
|-----------------|-------------------|-------------------|
| Interfacce REST (`*Api.java`) | `api/` | Implementare in `api/impl/*ApiImpl.java` |
| Modelli VO/DTO (`*.java`) | `vo/` | Usarli come target MapStruct; non editarli |
| Qualsiasi altro file rigenerato da codegen | — | Mai editare a mano |

**Dove si scrive codice a mano** (protetto da `.swagger-codegen-ignore`):

- `api/impl/*ApiImpl.java` — implementazione endpoint
- `api/manager/*Manager.java` — logica di business
- `api/mapper/*VoMapper.java` — conversioni MapStruct
- `dao/model/*` — Row, Entity, Params

Errori comuni da evitare: `@Mapper` o Lombok su classi in `vo/`, fix puntuali in `*Api.java`, setter manuali su VO al posto di aggiornare lo schema OpenAPI.

## MyBatis — query solo in XML

Tutte le query SQL MyBatis vanno in file `.xml` sotto `src/main/resources/mapper/`, **mai** come annotazioni inline (`@Select`, `@Insert`, `@Update`, `@Delete`) nelle interfacce `dao.mapper`.

| Elemento | Percorso |
|----------|----------|
| Interfaccia | `dao/mapper/*Mapper.java` — solo firme + `@Param` |
| SQL | `resources/mapper/*Mapper.xml` — `namespace` = FQCN interfaccia, `id` = nome metodo |

Vedi regola `.cursor/rules/mybatis-xml.mdc` per esempi e checklist.

## Altri vincoli backend

- **Java 17** nel codice (`java.version=17`); JDK 25 ok in build/runtime
- **Lombok** su classi scritte a mano in `dao.model` (vedi skill `schema`)
- **Niente mock in-memory** nel BFF: DB reale o eccezione esplicita

## Checklist agente

- [ ] Le conversioni Row/Entity → VO passano da un `@Mapper` MapStruct?
- [ ] Le conversioni VO → Params/Criteria (persist/ricerca) passano da `*PersistVoMapper` o metodi dedicati nel `*VoMapper`?
- [ ] I formatter condivisi sono in `MappingFormatters` (`@Named`), non duplicati nei Manager?
- [ ] Il mapper è in `api.mapper` con `componentModel = "spring"`?
- [ ] Il Manager non contiene blocchi lunghi di `setXxx` per mapping 1:1?
- [ ] Non ho modificato file generati da swagger-codegen (`*Api.java`, `vo/*`, …)?
- [ ] Se serviva un nuovo campo o endpoint, ho aggiornato `openapi.yaml` e rigenerato?
- [ ] Non ho applicato MapStruct/Lombok a file generati da OpenAPI?
- [ ] Le query MyBatis sono in `resources/mapper/*.xml`, non in annotazioni Java?
- [ ] Il codice rispetta Java 17?

## Riferimenti

- Monorepo: [sprint](../sprint/SKILL.md)
- API: [sprint-api](../sprint-api/SKILL.md)
- Schema: [schema](../schema/SKILL.md)
