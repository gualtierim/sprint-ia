# Migrations Sprint

Script SQL versionati per lo schema PostgreSQL Sprint (`schema sprint`).

## Convenzione

```
V{nnn}__{descrizione}.sql
```

Esempi:

- `V001__baseline.sql` — schema iniziale (quando disponibile)
- `V002__add_colonna_codice_rendis.sql` — ALTER TABLE

## Regole

1. Non modificare migrations già applicate in ambienti condivisi.
2. Una modifica logica per file.
3. Commentare in testa lo scopo e le tabelle coinvolte.
4. Dopo ogni migration, aggiornare `../tables.md` e `../api-tables.md` se necessario.

Vedi la skill `.cursor/skills/schema/SKILL.md` per il workflow completo.
