# Folder "Storico" — allineamento al layout legacy

Mappatura del contenuto della collapse **Storico** (`storico-folder`) sul legacy
`storicoRichiesta.jsp` (pagina **"Archivio storico richiesta"**). Il folder gestisce **una sola
tabella read-only**: la cronologia degli snapshot della richiesta (una riga per ogni modifica / cambio
di stato). Come per `allegati-folder`, è una collapse del dettaglio richiesta; a differenza degli altri
folder **non ha form di edit** ed è **interamente read-only**.

> **Convenzione (richiesta dal committente): lo Storico è un folder come `allegati-folder`**, non un
> pulsante/pagina a sé. Nel legacy era un pulsante "visualizza storico" (`pulsantiView.jsp`) che apriva
> la pagina `storicoRichiesta.jsp`; nel nuovo stack quel contenuto diventa la collapse `storico-folder`.

> **Linea guida: nel dubbio si copia la logica del legacy così com'è.** Colonne, query e condizione di
> visibilità ricalcano 1:1 il JSP/DAO legacy; gli scostamenti tecnici (Oracle→PostgreSQL, resa
> non-HTML) sono elencati e marcati.

> ⚠️ Non confondere con lo **"Storico ricerche"** (`/visualizzaStorico` → `StoricoAction` →
> `elencoStorico.jsp`): è la cronologia delle ricerche dell'utente, **un'altra feature**, non questa.

Fonte legacy (percorsi sotto `sprintj/`):
- Pagina/tabella: `.../jsp/richiesta/storicoRichiesta.jsp:35-73` (`<h3>Archivio storico richiesta</h3>`).
- Pulsante d'accesso (legacy): `.../jsp/richiesta/include/pulsantiView.jsp:49-59`
  (`<nested:equal name="VISUALIZZA_STORICO" value="true">`).
- Visibilità: `.../jsp/richiesta/include/defineVariable.jsp:32,57-79,159-164`.
- Flusso: `struts-config-richiesta.xml:1062-1072` → `RichiestaAction.visualizzaStoricoRichiesta` →
  `RichiestaBusinessDelegate.visualizzaStorico` → `RichiestaBean.visualizzaStorico:3945` →
  `getStoricoRichiestaDAO(idLegge).findStorico(...)` (riga 3959).
- DAO per legge: `DAOFactory.getStoricoRichiestaDAO(idLegge)` (`DAOFactory.java:235-255`).
- Conteggio/colonne base: `StoricoRichiestaDAOImpl.java` (`countStorico`, `getColumnNames:1231-1257`).

Stato attuale: `sprintwcl/.../folders/storico-folder/` — **da creare** (collapse non presente nel
dettaglio nuovo).

---

## 1. Struttura target (1 blocco)

### 1.1 Tabella storico

Unica tabella `mat-table` read-only sulla lista di righe restituita dal backend (sorgente DB:
`SPRINT_S_RIC_GENERICA` ⋈ decodifiche, vedi §3 e [Appendice A](#appendice-a--query-sql-verbatim)).
Come `allegati-folder`, colonne **configurabili** (popup + sessionStorage, `tableId=storico`).

**Le colonne cambiano per legge** (come nel legacy, DAO concreto via
`DAOFactory.getStoricoRichiestaDAO(idLegge)`). Colonne comuni a tutte: **DATA MODIFICA** (`MOD_DATA`),
**UTENTE MODIFICA** (`MOD_UTENTE`), **STATO**, **CODICE** (non esiste un campo "note"). Set per legge:

| Legge | DAO / property | Colonne (oltre a `ID_STORICO_RICHIESTA`, scartato) |
|-------|----------------|-----------------------------------------------------|
| Straordinaria | `StoricoRichiestaLeggeStraordinariaDAOImpl.findStorico` (`sql.properties:197`) | ID RICHIESTA, DATA MODIFICA, UTENTE MODIFICA, STATO, CODICE, SOGGETTO RICHIEDENTE, COMUNE LOCALIZZAZIONE, PROVINCIA, EVENTO COLLEGATO, OGGETTO, IMPORTO URGENTE, IMPORTO DEFINITIVO, IMPORTO RICHIESTO |
| 38 | `StoricoRichiestaLegge38DAOImpl.findStorico` (`sql.properties:199`) | come Straordinaria |
| 18 | `StoricoRichiestaLegge18DAOImpl.findStorico` (`sql.properties:201`) | ID RICHIESTA, DATA MODIFICA, UTENTE MODIFICA, STATO, CODICE, SOGGETTO RICHIEDENTE, COMUNE LOCALIZZAZIONE, PROVINCIA, TIPO INTERVENTO, OGGETTO, IMPORTO RICHIESTO |
| 54 | `StoricoRichiestaLegge54DAOImpl.findStorico` (`sql.properties:203`) | ID RICHIESTA, DATA MODIFICA, UTENTE MODIFICA, STATO, CODICE, SOGGETTO RICHIEDENTE, COMUNE LOCALIZZAZIONE, PROVINCIA, TIPOLOGIA OPERE PREVALENTI, TIPO INTERVENTO, OGGETTO, IMPORTO TOTALE, N° LOTTO, IMPORTO RICHIESTO |
| 183 | `StoricoRichiestaLegge183DAOImpl.findStorico` (`sql.properties:205`) | come 54 + CLASSE RISCHIO |

> Nel legacy header e righe sono **dinamici** (`storicoRichiesta.jsp` itera `titoliColonne` e
> `elencoStorico`, una Collection di `Object[]`). I titoli sono gli **alias** delle query, calcolati da
> `getColumnNames` che **scarta la prima colonna** (`ID_STORICO_RICHIESTA`). Le query verbatim sono in
> [Appendice A](#appendice-a--query-sql-verbatim): vanno portate 1:1 su PostgreSQL mantenendo **ordine
> e alias** delle colonne.

### Mapping ResultSet → riga (da copiare, `StoricoRichiestaLegge54DAOImpl.findStorico:240-255`)

```java
int idStorico = rs.getInt(1);              // prima colonna = ID_STORICO_RICHIESTA, NON salvata
Object[] row = new Object[length];          // length = titoliColonne.length (numColonne-1)
for (int i = 0; i < length; i++) {
    if (i == 6)                             // posizione "COMUNE LOCALIZZAZIONE" (in SELECT è '')
        row[i] = super.findComuniByStoricoRichiesta(idStorico);
    else
        row[i] = rs.getString(i + 2);      // si parte dalla 2ª colonna (la 1ª id è scartata)
}
```

Comportamenti legacy **da preservare**: scarto della prima colonna `ID_STORICO_RICHIESTA` (serve solo a
derivare i comuni); cella di indice **`i == 6`** ("COMUNE LOCALIZZAZIONE", in SELECT `''`) popolata con
`findComuniByStoricoRichiesta(idStorico)`; valori "vuoti" che nel legacy sono la stringa **`&nbsp;`** →
mappare a vuoto/null in presentazione.

---

## 2. Visibilità del folder (quando mostrarlo) — **copia esatta del legacy**

Come l'azione "Elimina" di `allegati-folder` è condizionata a `MODIFICA_RICHIESTA`, qui **l'intera
collapse** è condizionata al legacy `VISUALIZZA_STORICO`. La regola
(`defineVariable.jsp`, default `false` a riga 77):

```jsp
// defineVariable.jsp:159-164
// controllo visualizzazione dello storico
if(countStorico.intValue() > 0){
%>
        <bean:define id="VISUALIZZA_STORICO" value="true" toScope="page" type="java.lang.String"/>
<%
}
```

`countStorico` viene da `RichiestaBean.java:769-770` con la query `StoricoRichiestaDAOImpl.countStorico`:

```sql
select count(*) from SPRINT_S_RIC_GENERICA where FK_RICHIESTA_GENERICA = ?
```

**Regola da replicare 1:1:** il folder "Storico" è visibile **se e solo se** esiste almeno uno
snapshot (`count(*) ... > 0`). Non dipende da uno stato specifico né dal ruolo.

**Dipendenza dallo stato (indiretta, come nel legacy):**
- richiesta in **bozza mai modificata** → `countStorico = 0` → **folder non mostrato**;
- dopo la prima modifica / transizione di stato (che scrive uno snapshot in `SPRINT_S_RIC_GENERICA`,
  `RichiestaBean` righe 2999, 3185: `getStoricoRichiestaDAO().save(dtoStorico, fec)`)
  → `countStorico > 0` → **folder visibile** a tutti.

> Nel nuovo stack: esporre nel VO di dettaglio un flag **`hasStorico`** = `count(*) ... where
> fk_richiesta_generica = ?` e rendere la collapse `storico-folder` **visibile solo se
> `hasStorico === true`**. Replicare anche il **lato scrittura** (snapshot ad ogni
> modifica/transizione), altrimenti `hasStorico` resta sempre falso e il folder non compare mai.

---

## 3. Tabelle Oracle coinvolte

- **`SPRINT_S_RIC_GENERICA`** (alias `storico`): tabella **snapshot/storico** della richiesta
  (prefisso `S_` = storico vs `T_` = corrente). Campi: `ID_STORICO_RICHIESTA`, `FK_RICHIESTA_GENERICA`,
  `MOD_DATA`, `MOD_UTENTE`, `FK_STATO`, `FK_CODICE`, `COD_RICHIESTA`, importi (`COSTI_LAVORI`,
  `SPESE_GEN_TECN`, `COSTI_PROVE`, `COSTI_ESPROPRI`, `COSTI_IMPREVISTI`, `ALTRI_FINANZ`,
  `FK_TASSO_IVA_LAVORI`, `FK_TASSO_IVA_SOMME_DISP`), `N_LOTTO`, `FK_TIPO_OPERE`, `FK_TIPO_INTERVENTO`,
  `FK_TIPO_ENTE`, `FK_TOPE_ENTE_RICHIEDENTE`, `DESCRIZIONE_DANNO`.
- `SPRINT_D_RICHIESTA_GENERICA` — decodifiche (stato, codice, tipo opere, tipo intervento, tasso IVA).
- `SPRINT_S_RIC_38_CALAMITA` — storico dati legge 38 (evento, `IMPORTO_URGENTE`, `IMPORTO_DEFINITIVO`).
- `SPRINT_S_LOTTO` — importi lotti (leggi 54/183), join su `FK_STORICO_RICHIESTA`.
- `SPRINT_S_ANALISI_RISCHIO` + `SPRINT_D_ANALISI_RISCHIO` — classe rischio (legge 183).
- `SPRINT_T_EVENTO`, `SPRINT_T_APPG_AGGREGAZIONI`.
- Comuni: via `findComuniByStoricoRichiesta(idStorico)` (`IStoricoRichiestaDAO.java:22`).

---

## 4. Gap rispetto all'attuale

L'attuale dettaglio Angular **non ha** il folder Storico.

| # | Gap | Tipo | Stato FE |
|---|-----|------|----------|
| S1 | Collapse **`storico-folder` assente**: crearla sul modello di `allegati-folder` (read-only, una tabella) | FE | Da fare |
| S2 | Flag **`hasStorico`** (`count(*) ... where fk_richiesta_generica = ?`) nel VO di dettaglio per pilotare la visibilità della collapse (legacy `VISUALIZZA_STORICO`) | BE | Da fare |
| S3 | Endpoint `GET /richieste/{id}/storico` che, in base alla **legge**, esegue la `findStorico` corrispondente (Appendice A) **portata 1:1 da Oracle a PostgreSQL** e restituisce titoli colonna + righe | BE | Da fare |
| S4 | Replicare lo **scarto della prima colonna** (`ID_STORICO_RICHIESTA`) e il **caso comuni** (cella indice 6 ← comuni dello storico) | BE | Da fare |
| S5 | Tabella con **colonne configurabili** (popup + sessionStorage, `tableId=storico`) come `allegati-folder` | FE | Da fare |
| S6 | Mappare `&nbsp;` → vuoto/null in presentazione; importi formattati come legacy | BE/FE | Da fare |
| S7 | Collapse visibile **solo se `hasStorico === true`**; nessuna azione di edit/elimina (read-only) | FE | Da fare |
| S8 | **Lato scrittura**: salvare lo snapshot in `SPRINT_S_RIC_GENERICA` ad ogni modifica/transizione (come `save(dtoStorico)` legacy) | BE | Da fare |

---

## 5. Note implementative

- Mapping degli alias SQL → tabelle PostgreSQL del nuovo schema con la skill `schema`.
- **Differenze Oracle → PostgreSQL** nel port 1:1 (Appendice A): `decode(x,0,'…',y)` → `CASE`/`coalesce`
  (18/Straordinaria/38 già usano `case`/`coalesce`); `nvl` → `coalesce`; outer join `(+)` (54/183) →
  `LEFT OUTER JOIN`; `to_number(D.CODICE)` → cast equivalente; nelle 54/183 gli escape `.properties`
  (`\=`, `\t`, `°`) diventano `=`, tab, `°` (alias `N° LOTTO`).
- L'**IMPORTO RICHIESTO** è **calcolato** in ogni query (sottoquery IVA lavori / somme a disposizione):
  replicare la formula identica, non sostituirla con un campo. L'**IMPORTO TOTALE** (54/183) è
  `sum(IMPORTO)` su `SPRINT_S_LOTTO` per lo storico.
- Folder **sola lettura**: a differenza di `allegati-folder` non ha né form né azioni di riga.
- Obbligatorietà `*`/`**`: non applicabile (vista read-only).

---

## Appendice A — Query SQL verbatim

Da `sprintj/.../integration/dao/richiesta/impl/sql.properties` (testo originale, con gli escape del
file `.properties`). **Portare 1:1 su PostgreSQL** mantenendo ordine e alias delle colonne.

**`StoricoRichiestaDAOImpl.countStorico` (riga 163)** — usata per la visibilità:
```sql
select count(*) from SPRINT_S_RIC_GENERICA where FK_RICHIESTA_GENERICA = ?
```

**`StoricoRichiestaLeggeStraordinariaDAOImpl.findStorico` (riga 197):**
```sql
select storico.ID_STORICO_RICHIESTA, storico.COD_RICHIESTA "ID RICHIESTA", to_char(storico.MOD_DATA, 'dd/mm/yyyy') "DATA MODIFICA", storico.MOD_UTENTE "UTENTE MODIFICA", case when dStato.ID = 0 then '&nbsp;' else dStato.DESCRIZIONE end "STATO", case when dCodice.ID = 0 then '&nbsp;' else dCodice.DESCRIZIONE end "CODICE", storico.FK_TIPO_ENTE || '-' || storico.FK_TOPE_ENTE_RICHIEDENTE "SOGGETTO RICHIEDENTE", '' "COMUNE LOCALIZZAZIONE", '' "PROVINCIA", coalesce(e.DESCRIZIONE, '&nbsp;') "EVENTO COLLEGATO", coalesce(storico.DESCRIZIONE_DANNO, '&nbsp;') "OGGETTO", coalesce(c.IMPORTO_URGENTE, '0') "IMPORTO URGENTE", coalesce(c.IMPORTO_DEFINITIVO, '0') "IMPORTO DEFINITIVO", ( select ( S.COSTI_LAVORI + (S.COSTI_LAVORI * coalesce(( select to_number (d.CODICE) from SPRINT_S_RIC_GENERICA S, SPRINT_D_RICHIESTA_GENERICA D where S.FK_TASSO_IVA_LAVORI = D.id and S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA), 0)/ 100) ) + ( S.SPESE_GEN_TECN + S.COSTI_PROVE + S.COSTI_ESPROPRI + S.COSTI_IMPREVISTI ) + ( S.SPESE_GEN_TECN + S.COSTI_PROVE ) * coalesce(( select to_number(D.CODICE) from SPRINT_S_RIC_GENERICA S, SPRINT_D_RICHIESTA_GENERICA D where S.FK_TASSO_IVA_SOMME_DISP = D.id and S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA), 0)/ 100 - (S.ALTRI_FINANZ) from SPRINT_S_RIC_GENERICA S where S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA ) "IMPORTO RICHIESTO" from SPRINT_S_RIC_GENERICA storico inner join SPRINT_D_RICHIESTA_GENERICA dStato on storico.FK_STATO = dStato.ID inner join SPRINT_D_RICHIESTA_GENERICA dCodice on storico.FK_CODICE = dCodice.ID inner join SPRINT_S_RIC_38_CALAMITA c on storico.ID_STORICO_RICHIESTA = c.ID_STORICO_RICHIESTA inner join SPRINT_T_EVENTO e on c.FK_EVENTO = e.ID_EVENTO left outer join SPRINT_T_APPG_AGGREGAZIONI g on g.ID_TIPOAGGR = storico.FK_TOPE_ENTE_RICHIEDENTE where storico.FK_RICHIESTA_GENERICA = ?
```

**`StoricoRichiestaLegge38DAOImpl.findStorico` (riga 199):** identica alla Straordinaria (termina con
uno spazio dopo l'ultimo `?` nell'originale).

**`StoricoRichiestaLegge18DAOImpl.findStorico` (riga 201):**
```sql
SELECT storico.ID_STORICO_RICHIESTA, storico.COD_RICHIESTA "ID RICHIESTA", to_char(storico.MOD_DATA, 'dd/mm/yyyy') "DATA MODIFICA", storico.MOD_UTENTE "UTENTE MODIFICA", case when dStato.ID = 0 then '' else dStato.DESCRIZIONE end "STATO", case when dCodice.ID = 0 then '' else dCodice.DESCRIZIONE end "CODICE", storico.FK_TIPO_ENTE || '-' || storico.FK_TOPE_ENTE_RICHIEDENTE "SOGGETTO RICHIEDENTE", '' "COMUNE LOCALIZZAZIONE", '' "PROVINCIA", case when tipoIntervento.ID = 0 then '&nbsp;' else tipoIntervento.DESCRIZIONE end "TIPO INTERVENTO", storico.DESCRIZIONE_DANNO "OGGETTO", ( SELECT ( S.COSTI_LAVORI + (S.COSTI_LAVORI * coalesce(( SELECT to_number(d.CODICE) FROM SPRINT_S_RIC_GENERICA S, SPRINT_D_RICHIESTA_GENERICA D WHERE S.FK_TASSO_IVA_LAVORI = D.id AND S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA), 0)/ 100) ) + ( S.SPESE_GEN_TECN + S.COSTI_PROVE + S.COSTI_ESPROPRI + S.COSTI_IMPREVISTI ) + ( S.SPESE_GEN_TECN + S.COSTI_PROVE ) * coalesce(( SELECT to_number(D.CODICE) FROM SPRINT_S_RIC_GENERICA S, SPRINT_D_RICHIESTA_GENERICA D WHERE S.FK_TASSO_IVA_SOMME_DISP = D.id AND S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA), 0)/ 100 - (S.ALTRI_FINANZ) FROM SPRINT_S_RIC_GENERICA S WHERE S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA ) "IMPORTO RICHIESTO" FROM SPRINT_S_RIC_GENERICA storico inner join SPRINT_D_RICHIESTA_GENERICA dStato on storico.FK_STATO = dStato.ID inner join SPRINT_D_RICHIESTA_GENERICA dCodice on storico.FK_CODICE = dCodice.ID inner join SPRINT_D_RICHIESTA_GENERICA tipoIntervento on storico.FK_TIPO_INTERVENTO = tipoIntervento.ID left outer join SPRINT_T_APPG_AGGREGAZIONI g on g.ID_TIPOAGGR = storico.FK_TOPE_ENTE_RICHIEDENTE WHERE storico.FK_RICHIESTA_GENERICA = ?
```

**`StoricoRichiestaLegge54DAOImpl.findStorico` (riga 203)** — escape `.properties` risolti
(`\=`→`=`, `\t`→tab, `°`):
```sql
SELECT storico.ID_STORICO_RICHIESTA, storico.COD_RICHIESTA "ID RICHIESTA", to_char(storico.MOD_DATA,'dd/mm/yyyy') "DATA MODIFICA", storico.MOD_UTENTE "UTENTE MODIFICA", decode(dStato.ID,0,'',dStato.DESCRIZIONE) "STATO", decode(dCodice.ID,0,'',dCodice.DESCRIZIONE) "CODICE", storico.FK_TIPO_ENTE || '-' || storico.FK_TOPE_ENTE_RICHIEDENTE "SOGGETTO RICHIEDENTE", '' "COMUNE LOCALIZZAZIONE", '' "PROVINCIA", decode(tipoOpere.ID,0,'&nbsp;',tipoOpere.DESCRIZIONE) "TIPOLOGIA OPERE PREVALENTI", decode(tipoIntervento.ID,0,'&nbsp;',tipoIntervento.DESCRIZIONE) "TIPO INTERVENTO", storico.DESCRIZIONE_DANNO "OGGETTO", nvl((select sum(lotto.IMPORTO) from sprint_s_lotto lotto where lotto.FK_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA),0) "IMPORTO TOTALE", decode(storico.N_LOTTO,0,'&nbsp;',null,'&nbsp;',storico.N_LOTTO) "N° LOTTO", (select ( S.COSTI_LAVORI + (S.COSTI_LAVORI * nvl((select d.CODICE from SPRINT_S_RIC_GENERICA S, SPRINT_D_RICHIESTA_GENERICA D where S.FK_TASSO_IVA_LAVORI = D.id and S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA),0)/100) ) + ( S.SPESE_GEN_TECN + S.COSTI_PROVE + S.COSTI_ESPROPRI + S.COSTI_IMPREVISTI ) + ( S.SPESE_GEN_TECN + S.COSTI_PROVE  ) * nvl((select D.CODICE from SPRINT_S_RIC_GENERICA S, SPRINT_D_RICHIESTA_GENERICA D where S.FK_TASSO_IVA_SOMME_DISP = D.id and S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA),0)/100 - (S.ALTRI_FINANZ) from SPRINT_S_RIC_GENERICA S where S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA   ) "IMPORTO RICHIESTO" FROM SPRINT_S_RIC_GENERICA storico, SPRINT_D_RICHIESTA_GENERICA dStato, SPRINT_D_RICHIESTA_GENERICA dCodice, SPRINT_D_RICHIESTA_GENERICA tipoOpere, SPRINT_D_RICHIESTA_GENERICA tipoIntervento, SPRINT_T_APPG_AGGREGAZIONI g, SPRINT_S_ANALISI_RISCHIO rischio WHERE storico.FK_RICHIESTA_GENERICA = ? and storico.FK_STATO = dStato.ID and storico.FK_CODICE = dCodice.ID and storico.FK_TIPO_OPERE = tipoOpere.ID and storico.FK_TIPO_INTERVENTO = tipoIntervento.ID and storico.FK_TOPE_ENTE_RICHIEDENTE = g.ID_TIPOAGGR(+) and storico.ID_STORICO_RICHIESTA = rischio.FK_STORICO_RICHIESTA_1854(+)
```

**`StoricoRichiestaLegge183DAOImpl.findStorico` (riga 205)** — come la 54 + `CLASSE RISCHIO`:
```sql
SELECT storico.ID_STORICO_RICHIESTA, storico.COD_RICHIESTA "ID RICHIESTA", to_char(storico.MOD_DATA,'dd/mm/yyyy') "DATA MODIFICA", storico.MOD_UTENTE "UTENTE MODIFICA", decode(dStato.ID,0,'',dStato.DESCRIZIONE) "STATO", decode(dCodice.ID,0,'',dCodice.DESCRIZIONE) "CODICE", storico.FK_TIPO_ENTE || '-' || storico.FK_TOPE_ENTE_RICHIEDENTE "SOGGETTO RICHIEDENTE", '' "COMUNE LOCALIZZAZIONE", '' "PROVINCIA", decode(tipoOpere.ID,0,'&nbsp;',tipoOpere.DESCRIZIONE) "TIPOLOGIA OPERE PREVALENTI", decode(tipoIntervento.ID,0,'&nbsp;',tipoIntervento.DESCRIZIONE) "TIPO INTERVENTO", storico.DESCRIZIONE_DANNO "OGGETTO", nvl((select sum(lotto.IMPORTO) from sprint_s_lotto lotto where lotto.FK_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA),0) "IMPORTO TOTALE", decode(storico.N_LOTTO,0,'&nbsp;',null,'&nbsp;',storico.N_LOTTO) "N° LOTTO", (select ( S.COSTI_LAVORI + (S.COSTI_LAVORI * nvl((select d.CODICE from SPRINT_S_RIC_GENERICA S, SPRINT_D_RICHIESTA_GENERICA D where S.FK_TASSO_IVA_LAVORI = D.id and S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA),0)/100) ) + ( S.SPESE_GEN_TECN + S.COSTI_PROVE + S.COSTI_ESPROPRI + S.COSTI_IMPREVISTI ) + ( S.SPESE_GEN_TECN + S.COSTI_PROVE  ) * nvl((select D.CODICE from SPRINT_S_RIC_GENERICA S, SPRINT_D_RICHIESTA_GENERICA D where S.FK_TASSO_IVA_SOMME_DISP = D.id and S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA),0)/100 - (S.ALTRI_FINANZ) from SPRINT_S_RIC_GENERICA S where S.ID_STORICO_RICHIESTA = storico.ID_STORICO_RICHIESTA   ) "IMPORTO RICHIESTO", NVL(dRischio.DESCRIZIONE ,'&nbsp;')"CLASSE RISCHIO" FROM SPRINT_S_RIC_GENERICA storico, SPRINT_D_RICHIESTA_GENERICA dStato, SPRINT_D_RICHIESTA_GENERICA dCodice, SPRINT_D_RICHIESTA_GENERICA tipoOpere, SPRINT_D_RICHIESTA_GENERICA tipoIntervento, SPRINT_T_APPG_AGGREGAZIONI g, SPRINT_S_ANALISI_RISCHIO rischio, SPRINT_D_ANALISI_RISCHIO dRischio WHERE storico.FK_RICHIESTA_GENERICA = ? and storico.FK_STATO = dStato.ID and storico.FK_CODICE = dCodice.ID and storico.FK_TIPO_OPERE = tipoOpere.ID and storico.FK_TIPO_INTERVENTO = tipoIntervento.ID and storico.FK_TOPE_ENTE_RICHIEDENTE = g.ID_TIPOAGGR(+) and storico.ID_STORICO_RICHIESTA = rischio.FK_STORICO_RICHIESTA_1854(+) and rischio.FK_VAL_RISCHIO = dRischio.ID(+)
```
