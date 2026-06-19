---
name: table-columns
description: >-
  Convenzione frontend Sprint per tabelle Angular Material: l'utente deve poter
  scegliere quali colonne visualizzare tramite popup, con preferenze salvate in
  sessionStorage prefissate per pagina. Usa quando si creano o modificano mat-table,
  colonne tabella, dialog configurazione colonne, o persistenza visibilità colonne.
---

# Sprint — colonne tabella configurabili

Ogni tabella dati (`mat-table`) in `sprintwcl` deve permettere all'utente di **scegliere quali colonne visualizzare**. La configurazione avviene tramite **popup** (`mat-dialog`) e viene **persistita in `sessionStorage`** con chiave prefissata dalla **pagina corrente** (route Angular).

## Stile visivo

Tutte le `mat-table` usano lo stile globale in `src/app/core/table-columns/mat-table.scss` (importato da `styles.scss`):

- **Header**: sfondo blu (`--mat-sys-primary`), testo bianco (`--mat-sys-on-primary`), font-weight 500.
- **Righe dati**: alternate bianco (`--mat-sys-surface`) e grigio chiaro (`--mat-sys-surface-container-low`).
- **Hover riga**: leggero highlight primary.

Non duplicare questi stili nei componenti; eventuali regole locali devono limitarsi a larghezza colonne e layout.

## Colonne ridimensionabili

Ogni `mat-table` dati deve essere **resizable** tramite la direttiva condivisa `sprintMatTableResizable`:

```html
<table
  mat-table
  sprintMatTableResizable
  [resizableTableId]="tableId"
  [resizableExclude]="['azioni']"
  [dataSource]="rows()"
>
```

| Input | Obbligatorio | Descrizione |
|-------|--------------|-------------|
| `resizableTableId` | sì | Stesso `tableId` usato per visibilità colonne |
| `resizablePageKey` | no | Default: path route corrente (come `pageKey`) |
| `resizableMinWidth` | no | Larghezza minima colonna in px (default `56`) |
| `resizableExclude` | no | Colonne senza handle (es. `azioni`) |
| `resizableColumnDefs` | no | Definizioni colonne per override `initialWidth` |

Le larghezze sono persistite in `sessionStorage` con chiave:

```
{pageKey}:table-column-widths:{tableId}
```

Valore JSON: oggetto `{ field: widthPx }`, es. `{ "codRichiesta": 140, "stato": 96 }`.

L'utente trascina il bordo destro dell'header per ridimensionare. Le larghezze salvate si ripristinano al reload della pagina (stessa sessione).

**Larghezza iniziale:** se non c'è una larghezza salvata, viene calcolata automaticamente dal titolo colonna (testo header + padding) in modo che il label sia visibile. Opzionalmente `TableColumnDef.initialWidth` (px) o input `resizableColumnDefs` per override espliciti. Le default non vengono salvate in `sessionStorage` finché l'utente non ridimensiona manualmente.

Implementazione: `mat-table-resizable.directive.ts` + `table-column-widths.storage.ts` in `src/app/core/table-columns/`.

## Regola obbligatoria

- Ogni `mat-table` con colonne dati deve esporre un pulsante «Colonne» (icona `view_column` o equivalente Material) che apre il popup.
- L'utente può mostrare/nascondere colonne singolarmente; almeno **una colonna dati** deve restare visibile.
- Colonne funzionali fisse (es. checkbox selezione, azioni) vanno marcate `hideable: false` e restano sempre in `displayedColumns`.
- Senza configurazione salvata: tutte le colonne `hideable: true` sono visibili (default).
- La persistenza è **solo sessione** (`sessionStorage`), non `localStorage`.

## Chiave sessionStorage

Formato:

```
{pageKey}:table-columns:{tableId}
```

| Parte | Valore |
|-------|--------|
| `pageKey` | Path della route attiva **senza** slash iniziale (es. `ricerca/richieste`, `ricerca/eventi`) |
| `tableId` | Identificativo stabile della tabella nella pagina (es. `risultati`, `allegati`) — obbligatorio se la pagina ha più tabelle |

Esempi:

- `ricerca/richieste:table-columns:risultati`
- `ricerca/eventi:table-columns:risultati`

Valore JSON: array ordinato di `field` visibili, es. `["codRichiesta","stato","enteRichiedente"]`.

## Implementazione condivisa (`src/app/core/table-columns/`)

Centralizzare logica e UI riutilizzabile:

```
sprintwcl/src/app/core/table-columns/
├── table-column-def.ts          # tipo TableColumnDef
├── table-columns.storage.ts     # read/write sessionStorage visibilità
├── table-column-widths.storage.ts # read/write sessionStorage larghezze
├── mat-table-resizable.directive.ts
├── mat-table.scss               # stile header/righe alternate + resize handle
├── table-columns-dialog.component.ts
└── table-columns.service.ts     # openDialog + merge visibilità
```

### `TableColumnDef`

```typescript
export interface TableColumnDef<T = string> {
  field: T;
  label: string;
  hideable?: boolean; // default true; false = sempre visibile
  initialWidth?: number; // px; default: calcolato dal label
}
```

### Storage

```typescript
const buildKey = (pageKey: string, tableId: string) =>
  `${pageKey}:table-columns:${tableId}`;

export function loadVisibleFields(pageKey: string, tableId: string): string[] | null {
  const raw = sessionStorage.getItem(buildKey(pageKey, tableId));
  if (!raw) return null;
  try {
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : null;
  } catch {
    return null;
  }
}

export function saveVisibleFields(pageKey: string, tableId: string, fields: string[]): void {
  sessionStorage.setItem(buildKey(pageKey, tableId), JSON.stringify(fields));
}
```

`pageKey` si ricava da `Router.url` (primo segmento path senza query/hash), es.:

```typescript
const pageKey = this.router.url.split('?')[0].replace(/^\//, '');
```

### Popup (`mat-dialog`)

Il dialog riceve tutte le colonne e lo stato corrente; mostra una lista di `mat-checkbox` (solo colonne `hideable !== false`). Azioni:

- **Applica** — salva in `sessionStorage` e chiude restituendo i `field` selezionati
- **Annulla** — chiude senza modifiche
- **Ripristina predefinito** — tutte le colonne `hideable` visibili, salva e chiude

Usare `MatDialog`, `MatCheckboxModule`, `MatDialogModule`, `MatButtonModule`. Non creare overlay custom.

### Servizio

`TableColumnsService.openPicker(...)` apre il dialog e restituisce `Observable<string[] | undefined>` (`undefined` = annulla).

## Integrazione in una pagina

Workflow nel componente che ospita la tabella:

```
Task Progress:
- [ ] 1. Definire `TableColumnDef[]` (tutte le colonne con label)
- [ ] 2. Impostare `tableId` stabile e derivare `pageKey` dalla route
- [ ] 3. All'init: caricare visibilità da sessionStorage → `displayedColumns`
- [ ] 4. Template: `*matHeaderRowDef` / `*matRowDef` usano `displayedColumns()`, non l'elenco completo
- [ ] 5. Pulsante «Colonne» sopra la tabella → `openPicker` → aggiorna `displayedColumns` e salva
- [ ] 6. Direttiva `sprintMatTableResizable` con `[resizableTableId]="tableId"`
```

Esempio (semplificato):

```typescript
readonly tableId = 'risultati';
readonly allColumns: TableColumnDef<keyof CercaRichiestaItemRisultato>[] = COLONNE_RICERCA_RICHIESTE;
readonly displayedColumns = signal<string[]>([]);

ngOnInit(): void {
  const pageKey = this.router.url.split('?')[0].replace(/^\//, '');
  const saved = loadVisibleFields(pageKey, this.tableId);
  this.displayedColumns.set(
    resolveDisplayedColumns(this.allColumns, saved),
  );
}

apriConfigurazioneColonne(): void {
  const pageKey = this.router.url.split('?')[0].replace(/^\//, '');
  this.tableColumnsService
    .openPicker(this.allColumns, this.displayedColumns())
    .pipe(takeUntilDestroyed(this.destroyRef))
    .subscribe((fields) => {
      if (!fields) return;
      this.displayedColumns.set(fields);
      saveVisibleFields(pageKey, this.tableId, fields);
    });
}
```

`resolveDisplayedColumns`: se `saved` è valido, interseca con colonne note + aggiunge sempre quelle non hideable; altrimenti tutte le hideable + fisse.

Template — pulsante e binding colonne:

```html
<button mat-stroked-button type="button" (click)="apriConfigurazioneColonne()">
  <mat-icon>view_column</mat-icon>
  Colonne
</button>

<tr mat-header-row *matHeaderRowDef="displayedColumns()"></tr>
<tr mat-row *matRowDef="let row; columns: displayedColumns()"></tr>
```

Definire `ng-container [matColumnDef]` per **tutte** le colonne possibili; `displayedColumns` controlla quali righe header/cell vengono renderizzate.

## Checklist agente

Prima di considerare completa una tabella:

- [ ] C'è il pulsante che apre il popup configurazione colonne?
- [ ] Il popup usa `mat-dialog` con checkbox per ogni colonna nascondibile?
- [ ] La chiave `sessionStorage` usa `{pageKey}:table-columns:{tableId}`?
- [ ] `pageKey` deriva dalla route corrente (senza `/` iniziale)?
- [ ] All'apertura pagina si ripristina la configurazione salvata?
- [ ] Colonne funzionali (selezione, azioni) sono sempre visibili (`hideable: false`)?
- [ ] `displayedColumns` è usato in `matHeaderRowDef` / `matRowDef`, non l'array completo fisso?
- [ ] Logica condivisa in `src/app/core/table-columns/` (non duplicata per pagina)?
- [ ] Nessuno stile header/righe alternate duplicato localmente (gestito da `mat-table.scss`)?
- [ ] La tabella ha `sprintMatTableResizable` e `[resizableTableId]`?

## Relazioni

- Paginazione backend: skill [sprint](../sprint/SKILL.md) (`mat-paginator` → API `page`/`pageSize`)
- HTTP: regola `.cursor/rules/frontend-http.mdc` (`takeUntilDestroyed` sulle subscribe)
