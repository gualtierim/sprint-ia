---
name: backend
description: >-
  Convenzioni backend sprintbff (Spring Boot): conversioni Row/Entity → VO con
  MapStruct, struttura Manager, Lombok nel layer dati. Codice swagger-codegen
  non va mai modificato a mano. Usa quando si implementano o modificano Manager,
  mapper, DTO interni o logica BFF.
---

# Sprint — backend (sprintbff)

Regole per il layer applicativo in `sprintbff/`. Per API contract-first vedi skill `sprint-api`; per schema DB vedi skill `schema`.

## MapStruct per le conversioni di tipo

Per tutte le conversioni di tipo prova ad usare **MapStruct** per evitare meno boilerplate nel codice.

Vedi `.cursor/skills/backend/SKILL.md` per convenzioni, esempi e checklist complete.
