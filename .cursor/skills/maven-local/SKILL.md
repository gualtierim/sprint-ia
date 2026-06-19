---
name: maven-local
description: >-
  Configura Maven e JDK per lo sviluppo locale Sprint su macOS (utente
  mariogualtieri). Usa quando esegui comandi mvn/mvnw, compile, generate-sources,
  spring-boot:run, test o build su sprintbff, o quando serve il repository CSI
  interno via settings Maven personalizzati.
---

# Maven locale — sprintbff

## Regola obbligatoria (utente `mariogualtieri`)

Prima di **ogni** comando Maven (`mvn`, `./mvnw`) eseguito dall'agente:

1. **Settings Maven:** sempre `-s ~/.m2/settings-manu.xml`  
   Necessario per il plugin CSI `csi-java-swagger3-codegen` nel repository interno CSI.

2. **JAVA_HOME:** JDK **25** (Amazon Corretto)  
   ```bash
   export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-25.jdk/Contents/Home
   export PATH="${JAVA_HOME}/bin:${PATH}"
   ```

Non eseguire `mvn` senza questi due vincoli. Il codice di `sprintbff` compila con `--release 17`, ma il **toolchain di build** deve restare su JDK 25.

## Comandi tipici

```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-25.jdk/Contents/Home
export PATH="${JAVA_HOME}/bin:${PATH}"

cd sprintbff
mvn -s ~/.m2/settings-manu.xml compile
mvn -s ~/.m2/settings-manu.xml generate-sources
mvn -s ~/.m2/settings-manu.xml spring-boot:run -DskipTests
```

Con wrapper:

```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-25.jdk/Contents/Home
export PATH="${JAVA_HOME}/bin:${PATH}"

cd sprintbff
./mvnw -s ~/.m2/settings-manu.xml generate-sources
```

## Script di progetto (preferiti)

Usare gli script quando possibile: applicano già settings e Java corretti.

| Script | Uso |
|--------|-----|
| `./scripts/regenerate-api.sh` | Rigenera backend + frontend da `openapi.yaml` |
| `./scripts/dev.sh` | Avvio completo BFF + frontend |
| `./scripts/run-bff.sh` | Solo BFF (`spring-boot:run`) |

`scripts/dev.sh` e `scripts/regenerate-api.sh` impostano `-s ~/.m2/settings-manu.xml` se `USER=mariogualtieri`.

## Verifica rapida

```bash
java -version    # deve indicare Corretto 25
mvn -v           # deve usare lo stesso JDK 25
```

Se `settings-manu.xml` manca, segnalare all'utente: senza quel file la codegen CSI fallisce.

## Checklist agente

- [ ] Ho esportato `JAVA_HOME` su Corretto 25?
- [ ] Ogni `mvn`/`mvnw` include `-s ~/.m2/settings-manu.xml`?
- [ ] Sto lavorando in `sprintbff/` (o `-f sprintbff/pom.xml`)?
- [ ] Preferisco `./scripts/regenerate-api.sh` o `./scripts/dev.sh` quando applicabile?
