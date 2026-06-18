-- V001__baseline.sql
-- Schema baseline Sprint estratto da PostgreSQL PGSITTST (schema sprint).
-- Fonte: pg_dump --schema-only su tst-domdb67.csi.it, 2026-06-18.
-- Include: CREATE SCHEMA, tabelle, sequence, indici, vincoli PK/FK, viste SDE.
-- Non modificare: per evoluzioni usare V002__*.sql

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);

--
-- Name: sprint; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA sprint;


SET default_tablespace = '';

--
-- Name: batch_wf_log; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.batch_wf_log (
    tipo character varying(3),
    c1 character varying(100),
    c2 character varying(100),
    procedura character varying(40),
    operazione character varying(50),
    tabella character varying(40),
    oracle_err character varying(120),
    data_err date,
    c3 character varying(100),
    data_elab date
);


--
-- Name: geo_ln_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.geo_ln_evento (
    id_ln_evento numeric(8,0) NOT NULL,
    geometria public.geometry(LineString,32632) NOT NULL
);


--
-- Name: geo_ln_intervento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.geo_ln_intervento (
    id_ln_intervento numeric(8,0) NOT NULL,
    fk_legge numeric(6,0) NOT NULL,
    geometria public.geometry(LineString,32632) NOT NULL
);


--
-- Name: geo_pl_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.geo_pl_evento (
    id_pl_evento numeric(8,0) NOT NULL,
    geometria public.geometry(Polygon,32632) NOT NULL
);


--
-- Name: geo_pl_intervento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.geo_pl_intervento (
    id_pl_intervento numeric(8,0) NOT NULL,
    fk_legge numeric(6,0) NOT NULL,
    geometria public.geometry(Polygon,32632) NOT NULL
);


--
-- Name: geo_pt_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.geo_pt_evento (
    id_pt_evento numeric(8,0) NOT NULL,
    geometria public.geometry(Point,32632) NOT NULL
);


--
-- Name: geo_pt_intervento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.geo_pt_intervento (
    id_pt_intervento numeric(8,0) NOT NULL,
    fk_legge numeric(6,0) NOT NULL,
    geometria public.geometry(Point,32632) NOT NULL
);


--
-- Name: sde_logfile_data; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sde_logfile_data (
    logfile_data_id numeric NOT NULL,
    sde_row_id numeric NOT NULL
);


--
-- Name: sde_logfile_lid_gen; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.sde_logfile_lid_gen
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sde_logfiles; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sde_logfiles (
    logfile_name character varying(256) NOT NULL,
    logfile_id numeric NOT NULL,
    logfile_data_id numeric NOT NULL,
    registration_id numeric NOT NULL,
    flags numeric NOT NULL,
    session_tag numeric NOT NULL
);


--
-- Name: seq_geo_ln_evento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_geo_ln_evento
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_geo_ln_intervento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_geo_ln_intervento
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_geo_pl_evento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_geo_pl_evento
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_geo_pl_intervento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_geo_pl_intervento
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_geo_pt_evento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_geo_pt_evento
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_geo_pt_intervento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_geo_pt_intervento
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_s_analisi_rischio; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_s_analisi_rischio
    START WITH 213696
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_s_evento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_s_evento
    START WITH 200219
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_s_lotto; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_s_lotto
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_s_ric_generica; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_s_ric_generica
    START WITH 213696
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_s_stralcio; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_s_stralcio
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_allegato_evento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_allegato_evento
    START WITH 200035
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_allegato_tic; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_allegato_tic
    START WITH 220500
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_analisi_rischio; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_analisi_rischio
    START WITH 211244
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_area_idro; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_area_idro
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_evento; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_evento
    START WITH 202733
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_lotto; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_lotto
    START WITH 200003
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_progr_annuale; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_progr_annuale
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_ric_generica; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_ric_generica
    START WITH 212305
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_t_stralcio; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_t_stralcio
    START WITH 200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_sprint_to_wf; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_sprint_to_wf
    START WITH 865
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seq_wf_to_sprint; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.seq_wf_to_sprint
    START WITH 570
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_d_analisi_rischio; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_d_analisi_rischio (
    id numeric(6,0) NOT NULL,
    nome_colonna character varying(50),
    codice character varying(25),
    descrizione character varying(255),
    flg_obsoleto numeric(1,0) DEFAULT 0,
    ordine numeric(2,0),
    CONSTRAINT dom_011922 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_d_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_d_evento (
    id numeric(6,0) NOT NULL,
    nome_colonna character varying(50),
    codice character varying(25),
    descrizione character varying(255),
    flg_obsoleto numeric(1,0) DEFAULT 0,
    ordine numeric(2,0),
    CONSTRAINT dom_011923 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_d_ric_183; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_d_ric_183 (
    id numeric(6,0) NOT NULL,
    nome_colonna character varying(50),
    codice character varying(25),
    descrizione character varying(255),
    flg_obsoleto numeric(1,0) DEFAULT 0,
    ordine numeric(2,0),
    CONSTRAINT dom_011925 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_d_ric_18_54_183; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_d_ric_18_54_183 (
    id numeric(6,0) NOT NULL,
    nome_colonna character varying(50),
    codice character varying(25),
    descrizione character varying(255),
    flg_obsoleto numeric(1,0) DEFAULT 0,
    ordine numeric(2,0),
    categoria numeric(6,0),
    CONSTRAINT dom_011924 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_d_richiesta_generica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_d_richiesta_generica (
    id numeric(6,0) NOT NULL,
    fk_padre numeric(6,0),
    fk_padre_2 numeric(6,0),
    nome_colonna character varying(50),
    codice character varying(25),
    descrizione character varying(500),
    flg_obsoleto numeric(1,0) DEFAULT 0,
    ordine numeric(2,0),
    tipologia character varying(1),
    descrizione_tipologia character varying(40),
    CONSTRAINT dom_011926 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_mtd_analisi_rischio; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_analisi_rischio (
    id_mtd numeric(6,0) NOT NULL,
    fk_padre numeric(6,0),
    nome_colonna character varying(50),
    codice character varying(25),
    descrizione character varying(255),
    flg_obsoleto numeric(1,0) DEFAULT 0,
    ordine numeric(2,0),
    CONSTRAINT dom_011927 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_mtd_campo; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_campo (
    id_campo numeric(6,0) NOT NULL,
    fk_tavola numeric(6,0) NOT NULL,
    nome_campo character varying(30) NOT NULL,
    alias character varying(50)
);


--
-- Name: sprint_mtd_campo_ris_ricerca; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_campo_ris_ricerca (
    id_campo_ris_ricerca numeric(6,0) NOT NULL,
    descrizione character varying(255),
    tabella character varying(255),
    campo character varying(2000),
    decorator character varying(2),
    alias character varying(255),
    flg_pk numeric(1,0) DEFAULT 0 NOT NULL,
    CONSTRAINT dom_011928 CHECK ((flg_pk = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_mtd_config; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_config (
    id numeric(6,0) NOT NULL,
    tipo character varying(50),
    descrizione character varying(255),
    valore character varying(25)
);


--
-- Name: sprint_mtd_criterio; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_criterio (
    id_criterio numeric(6,0) NOT NULL,
    descrizione character varying(255),
    tabella character varying(255),
    campo character varying(255),
    filtro character varying(2000),
    data_type character varying(2),
    alias_tavola character varying(255)
);


--
-- Name: sprint_mtd_folder; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_folder (
    id_folder numeric(6,0) NOT NULL,
    nome_folder character varying(100) NOT NULL
);


--
-- Name: sprint_mtd_legge; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_legge (
    id_legge numeric(6,0) NOT NULL,
    nome_legge character varying(100) NOT NULL,
    codice character varying(25)
);


--
-- Name: sprint_mtd_oggetto; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_oggetto (
    id_oggetto numeric(6,0) NOT NULL,
    alias character varying(255),
    appg_from character varying(4000),
    appg_where character varying(4000),
    tipo_oggetto character varying(5),
    legge numeric(6,0),
    stato numeric(6,0)
);


--
-- Name: sprint_mtd_profilo_utente; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_profilo_utente (
    id_profilo numeric(6,0) NOT NULL,
    denominazione character varying(255)
);


--
-- Name: sprint_mtd_r1_folderlegge; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_r1_folderlegge (
    id_folder numeric(6,0) NOT NULL,
    id_legge numeric(6,0) NOT NULL
);


--
-- Name: sprint_mtd_r2_sezionelegge; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_r2_sezionelegge (
    id_legge numeric(6,0) NOT NULL,
    id_sezione numeric(6,0) NOT NULL
);


--
-- Name: sprint_mtd_r3_campo_sezlegge; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_r3_campo_sezlegge (
    id_campo numeric(6,0) NOT NULL,
    id_legge numeric(6,0) NOT NULL,
    id_sezione numeric(6,0) NOT NULL
);


--
-- Name: sprint_mtd_r_campo_oggprof; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_r_campo_oggprof (
    id_campo_ris_ricerca numeric(6,0) NOT NULL,
    id_profilo numeric(6,0) NOT NULL,
    id_oggetto numeric(6,0) NOT NULL,
    ordine numeric(2,0) NOT NULL
);


--
-- Name: sprint_mtd_r_campo_ricercapred; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_r_campo_ricercapred (
    id_campo_ris_ricerca numeric(6,0) NOT NULL,
    id_ricerca_pred numeric(6,0) NOT NULL,
    ordine numeric(2,0) NOT NULL
);


--
-- Name: sprint_mtd_r_criterio_oggprof; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_r_criterio_oggprof (
    id_profilo numeric(6,0) NOT NULL,
    id_oggetto numeric(6,0) NOT NULL,
    id_criterio numeric(6,0) NOT NULL
);


--
-- Name: sprint_mtd_r_ogg_prof; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_r_ogg_prof (
    id_profilo numeric(6,0) NOT NULL,
    id_oggetto numeric(6,0) NOT NULL
);


--
-- Name: sprint_mtd_r_profilo_ricerca; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_r_profilo_ricerca (
    id_profilo numeric(6,0) NOT NULL,
    id_ricerca_pred numeric(6,0) NOT NULL
);


--
-- Name: sprint_mtd_ric_18_54_183; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_ric_18_54_183 (
    id_mtd numeric(6,0) NOT NULL,
    fk_padre numeric(6,0),
    codice character varying(25),
    descrizione character varying(255),
    flg_obsoleto numeric(1,0) DEFAULT 0,
    ordine numeric(2,0),
    CONSTRAINT dom_011929 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_mtd_ric_generica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_ric_generica (
    id_mtd numeric(6,0) NOT NULL,
    fk_padre numeric(6,0),
    codice character varying(25),
    descrizione character varying(255),
    flg_obsoleto numeric(1,0) DEFAULT 0,
    ordine numeric(2,0),
    CONSTRAINT dom_011930 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_mtd_ricerca_pred_clob; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_ricerca_pred_clob (
    id_ricerca_pred numeric(6,0) NOT NULL,
    titolo_ricerca character varying(255),
    tipo_oggetto character varying(5),
    legge numeric(6,0),
    stato numeric(6,0),
    filtro text
);


--
-- Name: sprint_mtd_sezione; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_sezione (
    id_sezione numeric(6,0) NOT NULL,
    fk_folder numeric(6,0) NOT NULL,
    nome_sezione character varying(100) NOT NULL
);


--
-- Name: sprint_mtd_tavola; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_tavola (
    id_tavola numeric(6,0) NOT NULL,
    nome_tavola character varying(30) NOT NULL
);


--
-- Name: sprint_mtd_utente; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_mtd_utente (
    id_utente numeric(6,0) NOT NULL,
    fk_profilo numeric(6,0) NOT NULL,
    codfiscale character varying(15),
    nome character varying(50),
    cognome character varying(50),
    cod_istat_ente character varying(6),
    nome_ente character varying(255),
    settore character varying(255),
    matricola character varying(20)
);


--
-- Name: sprint_r_18_54_183_dinamica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_18_54_183_dinamica (
    id_mtd numeric(6,0) NOT NULL,
    id_richiesta_generica numeric(8,0) NOT NULL
);


--
-- Name: sprint_r_38_calamita; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_38_calamita (
    id_richiesta_generica_padre numeric(8,0) NOT NULL,
    id_richiesta_generica_figlio numeric(8,0) NOT NULL
);


--
-- Name: sprint_r_analisi_dinamica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_analisi_dinamica (
    id_analisi_rischio numeric(6,0) NOT NULL,
    id_mtd numeric(6,0) NOT NULL
);


--
-- Name: sprint_r_area_idro_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_area_idro_evento (
    id_evento numeric(8,0) NOT NULL,
    id_area_idro numeric(6,0) NOT NULL,
    data_inserimento date NOT NULL
);


--
-- Name: sprint_r_area_idro_ric_generic; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_area_idro_ric_generic (
    id_richiesta_generica numeric(8,0) NOT NULL,
    id_area_idro numeric(6,0) NOT NULL,
    data_inserimento date NOT NULL
);


--
-- Name: sprint_r_evento_comune; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_evento_comune (
    fk_tope_comune numeric(6,0) NOT NULL,
    fk_evento numeric(8,0) NOT NULL,
    data_inserimento date,
    istat_provincia character varying(3)
);


--
-- Name: sprint_r_geometria_richiesta; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_geometria_richiesta (
    id_richiesta_generica numeric(8,0) NOT NULL,
    tipo_geo character(1),
    flg_disabilitato numeric(1,0) DEFAULT 0,
    CONSTRAINT dom_011931 CHECK ((flg_disabilitato = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_r_province_collegate; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_province_collegate (
    istat_provincia_padre character varying(3),
    istat_provincia_collegata character varying(3)
);


--
-- Name: sprint_r_ric_generica_comune; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_ric_generica_comune (
    id_richiesta_generica numeric(8,0) NOT NULL,
    fk_tope_comune numeric(6,0) NOT NULL,
    data_inserimento date,
    istat_provincia character varying(3)
);


--
-- Name: sprint_r_ric_generica_dinamica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_ric_generica_dinamica (
    id_mtd numeric(6,0) NOT NULL,
    id_richiesta_generica numeric(8,0) NOT NULL
);


--
-- Name: sprint_r_ricgen_allegato; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_r_ricgen_allegato (
    id_richiesta_generica numeric(8,0) NOT NULL,
    id_allegato_ric numeric(6,0) NOT NULL,
    data_inserimento date
);


--
-- Name: sprint_s_analisi_rischio; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_s_analisi_rischio (
    id_analisi_rischio numeric(6,0) NOT NULL,
    fk_vulnerabilita numeric(6,0) NOT NULL,
    fk_storico_richiesta_1854 numeric(6,0),
    fk_storico_richiesta_38cal numeric(6,0),
    fk_val_danno numeric(6,0) NOT NULL,
    fk_val_rischio numeric(6,0) NOT NULL
);


--
-- Name: sprint_s_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_s_evento (
    id_storico_evento numeric(6,0) NOT NULL,
    fk_tipologia numeric(6,0) NOT NULL,
    fk_stato numeric(6,0) NOT NULL,
    fk_evento numeric(8,0) NOT NULL,
    data_inserimento date NOT NULL,
    mod_data date NOT NULL,
    mod_utente character varying(100) NOT NULL,
    data_chiusura date,
    flg_straordinario numeric(1,0) DEFAULT 0,
    rif_legge_apertura character varying(255),
    rif_legge_chiusura character varying(255),
    descrizione character varying(1000),
    nota character varying(1000),
    localita character varying(255),
    ente_segnalatore character varying(100) NOT NULL,
    utente_segnalatore character varying(100),
    cod_evento character varying(25) NOT NULL,
    flg_richiesta numeric(1,0) DEFAULT 0 NOT NULL,
    data_inserimento_utente date,
    descrizione_comune character varying(200),
    CONSTRAINT dom_011932 CHECK ((flg_straordinario = ANY (ARRAY[(0)::numeric, (1)::numeric]))),
    CONSTRAINT dom_011933 CHECK ((flg_richiesta = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_s_lotto; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_s_lotto (
    id_storico_lotto numeric(6,0) NOT NULL,
    fk_storico_richiesta numeric(6,0) NOT NULL,
    n_lotto numeric(2,0),
    importo numeric(8,2),
    priorita numeric(2,0),
    anno numeric(4,0),
    data_associazione date,
    provvedimento_finanziamento character varying(255),
    progr_annuale character varying(255)
);


--
-- Name: sprint_s_ric_183; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_s_ric_183 (
    id_storico_richiesta numeric(6,0) NOT NULL,
    frana_superficie_mq numeric(9,2),
    frana_superficie_mc numeric(9,2),
    conoide_sup_bacino numeric(9,2),
    conoide_sup_conoide numeric(9,2),
    idro_sup_bacino_sez numeric(9,2),
    idro_sup_portata numeric(9,2),
    idro_sup_pioggia_mm_hh numeric(6,0),
    idro_sup_pioggia_mm_gg numeric(9,0),
    idro_sup_desc_evento character varying(1000),
    idro_sup_franco_arginale numeric(8,0),
    idro_sup_data_evento date,
    fk_frana_pres_interventi numeric(6,0) NOT NULL,
    fk_valanga_pres_interventi numeric(6,0) NOT NULL,
    fk_frana_pres_opere_negative numeric(6,0) NOT NULL,
    fk_valanga_volume numeric(6,0) NOT NULL,
    fk_frana_stato_attivita numeric(6,0) NOT NULL,
    fk_valanga_ricorrenza numeric(6,0) NOT NULL,
    fk_frana_velocita numeric(6,0) NOT NULL,
    fk_frana_distr_attivita numeric(6,0) NOT NULL,
    fk_conoide_pres_interventi numeric(6,0) NOT NULL,
    fk_frana_tipo numeric(6,0) NOT NULL,
    fk_conoide_pres_opere_negative numeric(6,0) NOT NULL,
    fk_conoide_pendenza numeric(6,0) NOT NULL,
    fk_conoide_i_asprezza_melton numeric(6,0) NOT NULL,
    fk_conoide_ricorrenza numeric(6,0) NOT NULL,
    fk_conoide_diametro_interno numeric(6,0) NOT NULL,
    frana_hazard character varying(3),
    conoide_hazard character varying(3),
    valanga_hazard character varying(3),
    idro_sup_hazard character varying(3),
    fk_idro_sup_tr numeric(6,0) NOT NULL
);


--
-- Name: sprint_s_ric_18_54_183; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_s_ric_18_54_183 (
    id_storico_richiesta numeric(6,0) NOT NULL,
    fk_prog_triennale_triennio numeric(6,0) NOT NULL,
    fk_tipo_programmazione numeric(6,0) NOT NULL,
    fk_tipo_progetto numeric(6,0) NOT NULL,
    necessita_intervento character varying(1000),
    obiettivo_intervento character varying(1000),
    effetti_intervento character varying(1000),
    anno_ultimo_fin numeric(4,0),
    importo_prog numeric(8,2),
    anno_prog numeric(4,0),
    l_fin_prog character varying(255),
    desc_altra_programmazione character varying(255),
    flg_stato_programma numeric(1,0) DEFAULT 0,
    progettazione_prel_data date,
    progettazione_prel_estremi character varying(255),
    finanziamento_anno_1 numeric(4,0),
    finanziamento_importo_anno_1 numeric(8,2),
    finanziamento_anno_2 numeric(4,0),
    finanziamento_importo_anno_2 numeric(8,2),
    finanziamento_anno_3 numeric(4,0),
    finanziamento_importo_anno_3 numeric(8,2),
    fk_settore_intervento numeric(6,0) NOT NULL,
    fk_progettazione numeric(6,0) NOT NULL,
    CONSTRAINT dom_011934 CHECK ((flg_stato_programma = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_s_ric_38_calamita; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_s_ric_38_calamita (
    id_storico_richiesta numeric(6,0) NOT NULL,
    fk_evento numeric(8,0) NOT NULL,
    importo_urgente numeric(10,2),
    importo_definitivo numeric(10,2),
    determina_modifica character varying(255),
    importo_somma_urgenza numeric(10,2),
    n_ordinanza_sindacale character varying(255),
    data_ordinanza date
);


--
-- Name: sprint_s_ric_generica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_s_ric_generica (
    id_storico_richiesta numeric(6,0) NOT NULL,
    fk_tipo_ente1 numeric(6,0),
    fk_tipo_amm_esecutrice1 numeric(6,0),
    fk_richiesta_generica numeric(8,0) NOT NULL,
    fk_stato numeric(6,0) NOT NULL,
    fk_tipo_intervento numeric(6,0) NOT NULL,
    fk_tope_provincia numeric(6,0),
    fk_tope_comune numeric(6,0),
    fk_tope_indirizzo numeric(6,0),
    fk_tope_ente_richiedente1 numeric(6,0),
    fk_tope_amministrazione_ese1 numeric(6,0),
    cod_richiesta character varying(100) NOT NULL,
    mod_data date NOT NULL,
    mod_utente character varying(100) NOT NULL,
    data_inserimento date NOT NULL,
    descrizione_danno character varying(1000) NOT NULL,
    altro_ente character varying(255),
    ente_codice_fiscale character varying(16),
    ente_comune character varying(100),
    ente_provincia character varying(50),
    referente_ente_nome character varying(25),
    referente_ente_cognome character varying(25),
    referente_ente_telefono character varying(15),
    provvedimento_finanziamento character varying(255),
    descrizione_intervento character varying(4000),
    corso_nat character varying(50),
    localita character varying(250),
    altro_indirizzo character varying(255),
    civico character varying(10),
    flg_sopralluogo numeric(1,0) DEFAULT 0,
    data_sopralluogo date,
    nome_compilatore character varying(50) NOT NULL,
    cognome_compilatore character varying(50) NOT NULL,
    settore_compilatore character varying(255),
    n_entrata_protocollo character varying(25),
    data_entrata_protocollo date,
    n_uscita_protocollo character varying(25),
    data_uscita_protocollo date,
    data_pratica_wfr date,
    n_pratica_wfr character varying(25),
    note character varying(1000),
    flg_disabilitato_cambio_legge numeric(1,0) DEFAULT 0,
    costi_lavori numeric(10,2),
    spese_gen_tecn numeric(10,2),
    costi_prove numeric(10,2),
    costi_espropri numeric(10,2),
    costi_imprevisti numeric(10,2),
    altri_finanz numeric(10,2),
    fk_categoria numeric(6,0) NOT NULL,
    fk_codice numeric(6,0) NOT NULL,
    fk_tasso_iva_lavori numeric(6,0) NOT NULL,
    fk_tasso_iva_somme_disp numeric(6,0) NOT NULL,
    altra_amm_esecutrice character varying(255),
    denominazione_strada character varying(255),
    fascia_pai character varying(10),
    flg_dissesto_pai numeric(1,0),
    importo_proposto_ente numeric(8,2),
    spese_494_96 numeric(10,2),
    incentivo_prog_163_2006 numeric(10,2),
    fk_tipo_strada numeric(6,0) NOT NULL,
    condizioni_percorribilita character varying(1000),
    condizioni_esercizio character varying(1000),
    condizioni_agibilita character varying(1000),
    fk_cambio_legge numeric(6,0),
    n_ricevimento_protocollo character varying(25),
    data_ricevimento_protocollo date,
    n_lotto numeric(2,0),
    data_inserimento_utente date,
    fk_tipo_opere numeric(6,0) DEFAULT 0 NOT NULL,
    flg_wizard numeric(1,0) DEFAULT 0 NOT NULL,
    ente_indirizzo character varying(255),
    descrizione_comune character varying(200),
    fk_motivo_intervento numeric(6,0),
    codice_archivio character varying(100),
    codice_rendis character varying(100),
    flg_georiferito numeric(1,0),
    fk_tipo_ente character varying(20),
    fk_tipo_amm_esecutrice character varying(20),
    fk_tope_amministrazione_esecut character varying(20),
    fk_tope_ente_richiedente character varying(20),
    data_inizio_lavori date,
    durata_lavori numeric(6,0),
    CONSTRAINT dom_011935 CHECK ((flg_sopralluogo = ANY (ARRAY[(0)::numeric, (1)::numeric]))),
    CONSTRAINT dom_011936 CHECK ((flg_disabilitato_cambio_legge = ANY (ARRAY[(0)::numeric, (1)::numeric]))),
    CONSTRAINT dom_011937 CHECK ((flg_dissesto_pai = ANY (ARRAY[(0)::numeric, (1)::numeric]))),
    CONSTRAINT dom_011938 CHECK ((flg_wizard = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_s_stralcio; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_s_stralcio (
    id_stralcio numeric(6,0) NOT NULL,
    fk_storico_richiesta numeric(6,0) NOT NULL,
    importo numeric(8,2),
    anno numeric(4,0),
    l_fin character varying(255)
);


--
-- Name: sprint_sr_18_54_183_dinamica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_18_54_183_dinamica (
    id_mtd numeric(6,0) NOT NULL,
    id_storico_richiesta numeric(6,0) NOT NULL
);


--
-- Name: sprint_sr_38_calamita; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_38_calamita (
    id_storico_richiesta_padre numeric(6,0) NOT NULL,
    id_storico_richiesta_figlio numeric(6,0) NOT NULL
);


--
-- Name: sprint_sr_analisi_dinamica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_analisi_dinamica (
    id_analisi_rischio numeric(6,0) NOT NULL,
    id_mtd numeric(6,0) NOT NULL
);


--
-- Name: sprint_sr_area_idro_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_area_idro_evento (
    fk_storico_evento numeric(6,0) NOT NULL,
    id_area_idro numeric(6,0) NOT NULL,
    data_inserimento date
);


--
-- Name: sprint_sr_area_idro_ric_generi; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_area_idro_ric_generi (
    id_storico_richiesta numeric(6,0) NOT NULL,
    id_area_idro numeric(6,0) NOT NULL,
    data_inserimento date
);


--
-- Name: sprint_sr_evento_comune; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_evento_comune (
    fk_tope_comune numeric(6,0) NOT NULL,
    fk_storico_evento numeric(6,0) NOT NULL,
    data_inserimento date,
    istat_provincia character varying(3)
);


--
-- Name: sprint_sr_evento_ricgen; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_evento_ricgen (
    id_storico_evento numeric(6,0) NOT NULL,
    id_richiesta_generica numeric(8,0) NOT NULL
);


--
-- Name: sprint_sr_ric_generica_comune; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_ric_generica_comune (
    id_storico_richiesta numeric(6,0) NOT NULL,
    fk_tope_comune numeric(6,0) NOT NULL,
    data_inserimento date,
    istat_provincia character varying(3)
);


--
-- Name: sprint_sr_ric_generica_dinamic; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_sr_ric_generica_dinamic (
    id_mtd numeric(6,0) NOT NULL,
    id_storico_richiesta numeric(6,0) NOT NULL
);


--
-- Name: sprint_t_allegato_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_allegato_evento (
    id_allegato_evento numeric(6,0) NOT NULL,
    fk_evento numeric(8,0) NOT NULL,
    nome_file character varying(100) NOT NULL,
    descrizione character varying(2000),
    data_inserimento date NOT NULL,
    estensione character varying(50) NOT NULL,
    allegato_evento bytea NOT NULL
);


--
-- Name: sprint_t_allegato_ric; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_allegato_ric (
    id_allegato_ric numeric(6,0) NOT NULL,
    nome_file character varying(100) NOT NULL,
    descrizione character varying(2000),
    data_inserimento date NOT NULL,
    estensione character varying(50) NOT NULL,
    allegato_ric bytea NOT NULL
);


--
-- Name: sprint_t_analisi_rischio; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_analisi_rischio (
    id_analisi_rischio numeric(6,0) NOT NULL,
    fk_richiesta_generica_38cal numeric(8,0),
    fk_richiesta_generica_1854 numeric(8,0),
    fk_vulnerabilita numeric(6,0) NOT NULL,
    fk_val_rischio numeric(6,0) NOT NULL,
    fk_val_danno numeric(6,0) NOT NULL
);


--
-- Name: sprint_t_appg_aggregazioni; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_appg_aggregazioni (
    tipo_territorio numeric(6,0),
    data_modifica date,
    tipo_aggr character varying(100),
    flg_obsoleto numeric(1,0) DEFAULT 0 NOT NULL,
    note character varying(250),
    id_tipoaggr character varying(10),
    CONSTRAINT dom_011939 CHECK ((flg_obsoleto = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_t_appg_settori; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_appg_settori (
    id_settore numeric(6,0) NOT NULL,
    denominazione character varying(255) NOT NULL,
    indirizzo character varying(255) NOT NULL,
    telefono character varying(20),
    fax character varying(20),
    e_mail character varying(255),
    cod_infopersona character varying(20),
    cod_istat character varying(20)
);


--
-- Name: sprint_t_area_idro; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_area_idro (
    id_area_idro numeric(6,0) NOT NULL,
    denominazione character varying(255)
);


--
-- Name: sprint_t_centroide; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_centroide (
    id_comune numeric(6,0) NOT NULL,
    nome character varying(255),
    x_coord numeric(12,5),
    y_coord numeric(12,5)
);


--
-- Name: sprint_t_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_evento (
    id_evento numeric(8,0) NOT NULL,
    fk_tipologia numeric(6,0) NOT NULL,
    fk_stato numeric(6,0) NOT NULL,
    data_inserimento date NOT NULL,
    mod_data date NOT NULL,
    mod_utente character varying(100) NOT NULL,
    data_chiusura date,
    flg_straordinario numeric(1,0) DEFAULT 0,
    rif_legge_apertura character varying(255),
    rif_legge_chiusura character varying(255),
    descrizione character varying(1000),
    nota character varying(1000),
    localita character varying(255),
    ente_segnalatore character varying(100) NOT NULL,
    utente_segnalatore character varying(100),
    cod_evento character varying(25) NOT NULL,
    flg_richiesta numeric(1,0) DEFAULT 0 NOT NULL,
    data_inserimento_utente date,
    cod_infopersona character varying(20),
    descrizione_comune character varying(200),
    CONSTRAINT dom_011940 CHECK ((flg_straordinario = ANY (ARRAY[(0)::numeric, (1)::numeric]))),
    CONSTRAINT dom_011941 CHECK ((flg_richiesta = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_t_lotto; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_lotto (
    id_lotto numeric(6,0) NOT NULL,
    fk_richiesta_generica numeric(8,0) NOT NULL,
    n_lotto numeric(2,0),
    importo numeric(10,2),
    priorita numeric(2,0),
    anno numeric(4,0),
    provvedimento_finanziamento character varying(255),
    data_associazione date,
    progr_annuale character varying(255)
);


--
-- Name: sprint_t_map_group_layer; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_map_group_layer (
    id_group_layer integer NOT NULL,
    group_layer_order integer NOT NULL,
    title character varying(500) NOT NULL
);


--
-- Name: sprint_t_map_group_layer_id_group_layer_seq; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.sprint_t_map_group_layer_id_group_layer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_t_map_group_layer_id_group_layer_seq; Type: SEQUENCE OWNED BY; Schema: sprint; Owner: -
--

ALTER SEQUENCE sprint.sprint_t_map_group_layer_id_group_layer_seq OWNED BY sprint.sprint_t_map_group_layer.id_group_layer;


--
-- Name: sprint_t_map_layer; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_map_layer (
    id_layer integer NOT NULL,
    id_group_layer integer NOT NULL,
    layer_order integer NOT NULL,
    url character varying(500) NOT NULL,
    layers character varying(200) NOT NULL,
    versione character varying(50) NOT NULL,
    format character varying(50) NOT NULL,
    visible boolean NOT NULL,
    title character varying(200) NOT NULL,
    feature_format character varying(200)
);


--
-- Name: sprint_t_map_layer_feature; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_map_layer_feature (
    id_layer_eature integer NOT NULL,
    id_layer integer NOT NULL,
    feature_key character varying(200),
    feature_label character varying(200)
);


--
-- Name: sprint_t_map_layer_feature_id_layer_eature_seq; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.sprint_t_map_layer_feature_id_layer_eature_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_t_map_layer_feature_id_layer_eature_seq; Type: SEQUENCE OWNED BY; Schema: sprint; Owner: -
--

ALTER SEQUENCE sprint.sprint_t_map_layer_feature_id_layer_eature_seq OWNED BY sprint.sprint_t_map_layer_feature.id_layer_eature;


--
-- Name: sprint_t_map_layer_id_layer_seq; Type: SEQUENCE; Schema: sprint; Owner: -
--

CREATE SEQUENCE sprint.sprint_t_map_layer_id_layer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprint_t_map_layer_id_layer_seq; Type: SEQUENCE OWNED BY; Schema: sprint; Owner: -
--

ALTER SEQUENCE sprint.sprint_t_map_layer_id_layer_seq OWNED BY sprint.sprint_t_map_layer.id_layer;


--
-- Name: sprint_t_parametri; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_parametri (
    id_parametro numeric NOT NULL,
    chiave character varying(100) NOT NULL,
    valore character varying(4000),
    valore_data bytea
);


--
-- Name: sprint_t_ric_183; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_ric_183 (
    id_richiesta_generica numeric(8,0) NOT NULL,
    fk_frana_tipo numeric(6,0) NOT NULL,
    fk_frana_distr_attivita numeric(6,0) NOT NULL,
    fk_frana_velocita numeric(6,0) NOT NULL,
    fk_frana_stato_attivita numeric(6,0) NOT NULL,
    fk_frana_pres_interventi numeric(6,0) NOT NULL,
    fk_frana_pres_opere_negative numeric(6,0) NOT NULL,
    frana_superficie_mq numeric(9,2),
    frana_superficie_mc numeric(9,2),
    fk_conoide_i_asprezza_melton numeric(6,0) NOT NULL,
    fk_conoide_diametro_interno numeric(6,0) NOT NULL,
    fk_conoide_ricorrenza numeric(6,0) NOT NULL,
    fk_conoide_pendenza numeric(6,0) NOT NULL,
    fk_conoide_pres_opere_negative numeric(6,0) NOT NULL,
    fk_conoide_pres_interventi numeric(6,0) NOT NULL,
    conoide_sup_bacino numeric(9,2),
    conoide_sup_conoide numeric(9,2),
    fk_valanga_ricorrenza numeric(6,0) NOT NULL,
    fk_valanga_volume numeric(6,0) NOT NULL,
    fk_valanga_pres_interventi numeric(6,0) NOT NULL,
    idro_sup_bacino_sez numeric(9,2),
    idro_sup_portata numeric(9,2),
    idro_sup_pioggia_mm_hh numeric(6,0),
    idro_sup_pioggia_mm_gg numeric(9,0),
    idro_sup_desc_evento character varying(1000),
    idro_sup_franco_arginale numeric(8,0),
    idro_sup_data_evento date,
    fk_idro_sup_tr numeric(6,0) NOT NULL,
    frana_hazard character varying(3),
    conoide_hazard character varying(3),
    valanga_hazard character varying(3),
    idro_sup_hazard character varying(3)
);


--
-- Name: sprint_t_ric_18_54_183; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_ric_18_54_183 (
    id_richiesta_generica numeric(8,0) NOT NULL,
    fk_prog_triennale_triennio numeric(6,0) NOT NULL,
    fk_tipo_programmazione numeric(6,0) NOT NULL,
    fk_progettazione numeric(6,0) NOT NULL,
    fk_tipo_progetto numeric(6,0) DEFAULT 0 NOT NULL,
    necessita_intervento character varying(1000),
    obiettivo_intervento character varying(1000),
    effetti_intervento character varying(1000),
    anno_ultimo_fin numeric(4,0),
    importo_prog numeric(10,2),
    anno_prog numeric(4,0),
    l_fin_prog character varying(255),
    desc_altra_programmazione character varying(255),
    flg_stato_programma numeric(1,0) DEFAULT 0,
    progettazione_prel_data date,
    progettazione_prel_estremi character varying(255),
    finanziamento_anno_1 numeric(4,0),
    finanziamento_importo_anno_1 numeric(8,2),
    finanziamento_anno_2 numeric(4,0),
    finanziamento_importo_anno_2 numeric(8,2),
    finanziamento_anno_3 numeric(4,0),
    finanziamento_importo_anno_3 numeric(8,2),
    fk_settore_intervento numeric(6,0) DEFAULT 0 NOT NULL,
    CONSTRAINT dom_011942 CHECK ((flg_stato_programma = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_t_ric_38_calamita; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_ric_38_calamita (
    id_richiesta_generica numeric(8,0) NOT NULL,
    importo_urgente numeric(10,2),
    importo_definitivo numeric(10,2),
    determina_modifica character varying(255),
    fk_evento numeric(8,0) NOT NULL,
    importo_somma_urgenza numeric(10,2),
    n_ordinanza_sindacale character varying(255),
    data_ordinanza date
);


--
-- Name: sprint_t_ric_generica; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_ric_generica (
    id_richiesta_generica numeric(8,0) NOT NULL,
    fk_cambio_legge numeric(6,0),
    fk_tipo_amm_esecutrice1 numeric(6,0),
    fk_tipo_ente1 numeric(6,0),
    fk_categoria numeric(6,0) NOT NULL,
    fk_stato numeric(6,0) NOT NULL,
    fk_codice numeric(6,0) NOT NULL,
    fk_tipo_intervento numeric(6,0) NOT NULL,
    fk_tasso_iva_lavori numeric(6,0) NOT NULL,
    fk_tasso_iva_somme_disp numeric(6,0) NOT NULL,
    fk_tope_provincia numeric(6,0),
    fk_tope_comune numeric(6,0),
    fk_tope_indirizzo numeric(6,0),
    fk_tope_ente_richiedente numeric(6,0),
    fk_tope_amministrazione_esecu1 numeric(6,0),
    cod_richiesta character varying(100) NOT NULL,
    mod_data date NOT NULL,
    mod_utente character varying(100) NOT NULL,
    data_inserimento date NOT NULL,
    descrizione_danno character varying(1000) NOT NULL,
    altro_ente character varying(255),
    ente_codice_fiscale character varying(16),
    ente_comune character varying(100),
    ente_provincia character varying(50),
    referente_ente_nome character varying(25),
    referente_ente_cognome character varying(25),
    referente_ente_telefono character varying(15),
    provvedimento_finanziamento character varying(255),
    descrizione_intervento character varying(4000),
    corso_nat character varying(50),
    localita character varying(250),
    altro_indirizzo character varying(255),
    civico character varying(10),
    flg_sopralluogo numeric(1,0) DEFAULT 0,
    data_sopralluogo date,
    nome_compilatore character varying(50) NOT NULL,
    cognome_compilatore character varying(50) NOT NULL,
    settore_compilatore character varying(255),
    n_entrata_protocollo character varying(25),
    data_entrata_protocollo date,
    n_uscita_protocollo character varying(25),
    data_uscita_protocollo date,
    data_pratica_wfr date,
    n_pratica_wfr character varying(25),
    note character varying(1000),
    flg_disabilitato_cambio_legge numeric(1,0) DEFAULT 0,
    costi_lavori numeric(10,2),
    spese_gen_tecn numeric(10,2),
    costi_prove numeric(10,2),
    costi_espropri numeric(10,2),
    costi_imprevisti numeric(10,2),
    altri_finanz numeric(10,2),
    altra_amm_esecutrice character varying(255),
    denominazione_strada character varying(255),
    fascia_pai character varying(50),
    flg_dissesto_pai numeric(1,0),
    importo_proposto_ente numeric(8,2),
    spese_494_96 numeric(10,2),
    incentivo_prog_163_2006 numeric(10,2),
    fk_tipo_strada numeric(6,0) NOT NULL,
    flg_wizard numeric(1,0) DEFAULT 0 NOT NULL,
    condizioni_percorribilita character varying(1000),
    condizioni_esercizio character varying(1000),
    condizioni_agibilita character varying(1000),
    n_ricevimento_protocollo character varying(25),
    data_ricevimento_protocollo date,
    n_lotto numeric(2,0),
    data_inserimento_utente date,
    fk_tipo_opere numeric(6,0) DEFAULT 0 NOT NULL,
    ente_indirizzo character varying(255),
    cod_infopersona character varying(20),
    descrizione_comune character varying(200),
    data_comunicaz_finanziam date,
    note_ec character varying(1000),
    importo_a numeric(10,2),
    importo_c numeric(10,2),
    flg_dissesto_senso_pai numeric(1,0) DEFAULT 0,
    fk_tipo_dissesto numeric(6,0),
    flg_rilievo numeric(1,0) DEFAULT 0,
    fk_dissesto_pai_prgc numeric(6,0),
    fk_motivo_intervento numeric(6,0),
    codice_archivio character varying(100),
    codice_rendis character varying(100),
    flg_georiferito numeric(1,0),
    descrizione_dissesto character varying(1000),
    codice_cup character varying(255),
    fk_tipo_ente character varying(20),
    fk_tipo_amm_esecutrice character varying(20),
    fk_tope_amministrazione_esecut character varying(20),
    corelatore character varying(100),
    data_inizio_lavori date,
    durata_lavori numeric(6,0),
    CONSTRAINT dom_011943 CHECK ((flg_sopralluogo = ANY (ARRAY[(0)::numeric, (1)::numeric]))),
    CONSTRAINT dom_011944 CHECK ((flg_disabilitato_cambio_legge = ANY (ARRAY[(0)::numeric, (1)::numeric]))),
    CONSTRAINT dom_011945 CHECK ((flg_dissesto_pai = ANY (ARRAY[(0)::numeric, (1)::numeric]))),
    CONSTRAINT dom_011946 CHECK ((flg_wizard = ANY (ARRAY[(0)::numeric, (1)::numeric])))
);


--
-- Name: sprint_t_stralcio; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_t_stralcio (
    id_stralcio numeric(6,0) NOT NULL,
    fk_richiesta_generica numeric(8,0) NOT NULL,
    importo numeric(8,2),
    anno numeric(4,0),
    l_fin character varying(255)
);


--
-- Name: sprint_to_wf; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_to_wf (
    id_sprint_to_wf numeric NOT NULL,
    data_elab character varying(8),
    model_code character varying(2),
    id_emeter character varying(10),
    cod_emeter character varying(100),
    operazione character varying(1),
    oggetto character varying(255),
    matricola_referente character varying(20),
    numero_protocollo_anno character varying(12),
    data_lettera character varying(12),
    responsabile_programmazione character varying(101),
    settore_intervento character varying(40),
    categoria_dissesto_intervento character varying(40),
    tipologia_dissesto_intervento character varying(1),
    bacino character varying(255),
    corso_acqua character varying(255),
    coordinata_utm_x character varying(25),
    coordinata_utm_y character varying(25),
    importo_progetto character varying(12),
    importo_richiesto character varying(12),
    cofinanziamento_previsto character varying(12),
    note character varying(1000),
    tipo_ambito character varying(1),
    descrizione_ambito character varying(40),
    esito character varying(400)
);


--
-- Name: sprint_w_comuni_evento; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.sprint_w_comuni_evento (
    id_evento numeric(8,0) NOT NULL,
    comune character varying(4) NOT NULL
);


--
-- Name: vsde_evento_ln; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_evento_ln AS
 SELECT geo_ln_evento.id_ln_evento,
    geo_ln_evento.geometria,
    sprint_t_evento.cod_evento,
    sprint_t_evento.descrizione AS descrizione_evento,
    sprint_t_evento.fk_tipologia,
    sprint_d_evento.descrizione,
    sprint_t_evento.fk_stato,
    sprint_d_evento_1.descrizione AS stato,
    sprint_t_evento.flg_straordinario
   FROM (sprint.sprint_d_evento sprint_d_evento_1
     JOIN (sprint.sprint_d_evento
     JOIN (sprint.geo_ln_evento
     JOIN sprint.sprint_t_evento ON ((geo_ln_evento.id_ln_evento = sprint_t_evento.id_evento))) ON ((sprint_d_evento.id = sprint_t_evento.fk_tipologia))) ON ((sprint_d_evento_1.id = sprint_t_evento.fk_stato)))
  WHERE ((sprint_t_evento.fk_stato = (14)::numeric) OR (sprint_t_evento.fk_stato = (15)::numeric));


--
-- Name: vsde_evento_ln_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_evento_ln_storico AS
 SELECT geo_ln_evento.id_ln_evento,
    geo_ln_evento.geometria,
    sprint_t_evento.cod_evento,
    sprint_t_evento.descrizione AS descrizione_evento,
    sprint_t_evento.fk_tipologia,
    sprint_d_evento.descrizione,
    sprint_t_evento.fk_stato,
    sprint_d_evento_1.descrizione AS stato,
    sprint_t_evento.flg_straordinario
   FROM (sprint.sprint_d_evento sprint_d_evento_1
     JOIN (sprint.sprint_d_evento
     JOIN (sprint.geo_ln_evento
     JOIN sprint.sprint_t_evento ON ((geo_ln_evento.id_ln_evento = sprint_t_evento.id_evento))) ON ((sprint_d_evento.id = sprint_t_evento.fk_tipologia))) ON ((sprint_d_evento_1.id = sprint_t_evento.fk_stato)))
  WHERE (sprint_t_evento.fk_stato = (16)::numeric);


--
-- Name: vsde_evento_pl; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_evento_pl AS
 SELECT geo_pl_evento.id_pl_evento,
    geo_pl_evento.geometria,
    sprint_t_evento.cod_evento,
    sprint_t_evento.descrizione AS descrizione_evento,
    sprint_t_evento.fk_tipologia,
    sprint_d_evento.descrizione,
    sprint_t_evento.fk_stato,
    sprint_d_evento_1.descrizione AS stato,
    sprint_t_evento.flg_straordinario
   FROM (sprint.sprint_d_evento sprint_d_evento_1
     JOIN (sprint.sprint_d_evento
     JOIN (sprint.geo_pl_evento
     JOIN sprint.sprint_t_evento ON ((geo_pl_evento.id_pl_evento = sprint_t_evento.id_evento))) ON ((sprint_d_evento.id = sprint_t_evento.fk_tipologia))) ON ((sprint_d_evento_1.id = sprint_t_evento.fk_stato)))
  WHERE ((sprint_t_evento.fk_stato = (14)::numeric) OR (sprint_t_evento.fk_stato = (15)::numeric));


--
-- Name: vsde_evento_pl_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_evento_pl_storico AS
 SELECT geo_pl_evento.id_pl_evento,
    geo_pl_evento.geometria,
    sprint_t_evento.cod_evento,
    sprint_t_evento.descrizione AS descrizione_evento,
    sprint_t_evento.fk_tipologia,
    sprint_d_evento.descrizione,
    sprint_t_evento.fk_stato,
    sprint_d_evento_1.descrizione AS stato,
    sprint_t_evento.flg_straordinario
   FROM (sprint.sprint_d_evento sprint_d_evento_1
     JOIN (sprint.sprint_d_evento
     JOIN (sprint.geo_pl_evento
     JOIN sprint.sprint_t_evento ON ((geo_pl_evento.id_pl_evento = sprint_t_evento.id_evento))) ON ((sprint_d_evento.id = sprint_t_evento.fk_tipologia))) ON ((sprint_d_evento_1.id = sprint_t_evento.fk_stato)))
  WHERE (sprint_t_evento.fk_stato = (16)::numeric);


--
-- Name: vsde_evento_pt; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_evento_pt AS
 SELECT geo_pt_evento.id_pt_evento,
    geo_pt_evento.geometria,
    sprint_t_evento.cod_evento,
    sprint_t_evento.descrizione AS descrizione_evento,
    sprint_t_evento.fk_tipologia,
    sprint_d_evento.descrizione,
    sprint_t_evento.fk_stato,
    sprint_d_evento_1.descrizione AS stato,
    sprint_t_evento.flg_straordinario,
    sprint_t_evento.descrizione_comune
   FROM (sprint.sprint_d_evento sprint_d_evento_1
     JOIN (sprint.sprint_d_evento
     JOIN (sprint.geo_pt_evento
     JOIN sprint.sprint_t_evento ON ((geo_pt_evento.id_pt_evento = sprint_t_evento.id_evento))) ON ((sprint_d_evento.id = sprint_t_evento.fk_tipologia))) ON ((sprint_d_evento_1.id = sprint_t_evento.fk_stato)))
  WHERE ((sprint_t_evento.fk_stato = (14)::numeric) OR (sprint_t_evento.fk_stato = (15)::numeric));


--
-- Name: vsde_evento_pt_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_evento_pt_storico AS
 SELECT geo_pt_evento.id_pt_evento,
    geo_pt_evento.geometria,
    sprint_t_evento.cod_evento,
    sprint_t_evento.descrizione AS descrizione_evento,
    sprint_t_evento.fk_tipologia,
    sprint_d_evento.descrizione,
    sprint_t_evento.fk_stato,
    sprint_d_evento_1.descrizione AS stato,
    sprint_t_evento.flg_straordinario,
    sprint_t_evento.descrizione_comune
   FROM (sprint.sprint_d_evento sprint_d_evento_1
     JOIN (sprint.sprint_d_evento
     JOIN (sprint.geo_pt_evento
     JOIN sprint.sprint_t_evento ON ((geo_pt_evento.id_pt_evento = sprint_t_evento.id_evento))) ON ((sprint_d_evento.id = sprint_t_evento.fk_tipologia))) ON ((sprint_d_evento_1.id = sprint_t_evento.fk_stato)))
  WHERE (sprint_t_evento.fk_stato = (16)::numeric);


--
-- Name: vsde_ric_183_pt_consultazione; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_183_pt_consultazione AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.fk_categoria,
    sprint_d_richiesta_generica_4.descrizione AS categoria_intervento,
    sprint_t_ric_generica.n_lotto,
    sprint_t_lotto.importo AS importo_1_lotto,
    sprint_t_ric_generica.mod_data,
    sprint_t_ric_generica.fk_tipo_opere,
    sprint_d_richiesta_generica_5.descrizione AS tipo_opere,
    sprint_d_richiesta_generica_5.fk_padre,
    sprint_d_richiesta_generica_6.descrizione AS padre_opere,
    sprint_t_ric_generica.descrizione_comune
   FROM (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_6
     RIGHT JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_5
     JOIN (((((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     JOIN sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3 ON ((sprint_t_ric_generica.fk_categoria = sprint_d_richiesta_generica_3.id)))
     LEFT JOIN sprint.sprint_t_ric_18_54_183 ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_18_54_183.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_18_54_183.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_1854)))
     LEFT JOIN sprint.sprint_t_lotto ON ((sprint_t_ric_18_54_183.id_richiesta_generica = sprint_t_lotto.fk_richiesta_generica))) ON ((sprint_d_richiesta_generica_5.id = sprint_t_ric_generica.fk_tipo_opere))) ON ((sprint_d_richiesta_generica_6.id = sprint_d_richiesta_generica_5.fk_padre)))
  WHERE ((geo_pt_intervento.fk_legge = (4)::numeric) AND ((sprint_t_ric_generica.n_lotto IS NULL) OR (sprint_t_lotto.n_lotto = sprint_t_ric_generica.n_lotto)) AND (sprint_t_ric_generica.fk_stato = ANY (ARRAY[(3)::numeric, (85)::numeric, (6)::numeric, (2)::numeric, (4)::numeric])) AND (sprint_t_ric_generica.mod_data >= (('now'::text)::date - '3 years'::interval)));


--
-- Name: vsde_ric_183_pt_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_183_pt_storico AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.fk_categoria,
    sprint_d_richiesta_generica_4.descrizione AS categoria_intervento,
    a.tot_lotto,
    a.importo_1_lotto,
    sprint_t_ric_generica.fk_tipo_opere,
    sprint_d_richiesta_generica_5.descrizione AS tipo_opere,
    sprint_d_richiesta_generica_5.fk_padre,
    sprint_d_richiesta_generica_6.descrizione AS padre_opere,
    sprint_t_ric_generica.descrizione_comune
   FROM sprint.sprint_d_richiesta_generica,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_5,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_6,
    sprint.sprint_t_ric_generica,
    sprint.sprint_r_geometria_richiesta,
    sprint.geo_pt_intervento,
    sprint.sprint_t_ric_18_54_183,
    sprint.sprint_t_analisi_rischio,
    sprint.sprint_d_analisi_rischio,
    ( SELECT sprint_t_lotto.fk_richiesta_generica,
            count(sprint_t_lotto.id_lotto) AS tot_lotto,
            sum(COALESCE(sprint_t_lotto.importo, (0)::numeric)) AS importo_1_lotto
           FROM sprint.sprint_t_ric_generica sprint_t_ric_generica_1,
            sprint.sprint_t_lotto
          WHERE (sprint_t_ric_generica_1.id_richiesta_generica = sprint_t_lotto.fk_richiesta_generica)
          GROUP BY sprint_t_lotto.fk_richiesta_generica) a
  WHERE ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato) AND (sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento) AND (sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica) AND (sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento) AND (sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice) AND (sprint_t_ric_generica.fk_categoria = sprint_d_richiesta_generica_3.id) AND (sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_18_54_183.id_richiesta_generica) AND (sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio) AND (sprint_t_ric_18_54_183.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_1854) AND (sprint_t_ric_18_54_183.id_richiesta_generica = a.fk_richiesta_generica) AND (sprint_d_richiesta_generica_5.id = sprint_t_ric_generica.fk_tipo_opere) AND (sprint_d_richiesta_generica_6.id = sprint_d_richiesta_generica_5.fk_padre) AND ((geo_pt_intervento.fk_legge = (4)::numeric) AND ((sprint_t_ric_generica.fk_stato = (4)::numeric) OR (sprint_t_ric_generica.fk_stato = (5)::numeric))));


--
-- Name: vsde_ric_18_pt_consultazione; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_18_pt_consultazione AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    round((((round((sprint_t_ric_generica.costi_lavori + ((sprint_t_ric_generica.costi_lavori * (sprint_d_richiesta_generica_2.codice)::numeric) / (100)::numeric)), 2) + (((sprint_t_ric_generica.spese_gen_tecn + sprint_t_ric_generica.costi_prove) + sprint_t_ric_generica.costi_espropri) + sprint_t_ric_generica.costi_imprevisti)) + (((sprint_t_ric_generica.spese_gen_tecn + sprint_t_ric_generica.costi_prove) * (sprint_d_richiesta_generica_3.codice)::numeric) / (100)::numeric)) - sprint_t_ric_generica.altri_finanz), 2) AS importo_richiesto,
    sprint_t_ric_generica.mod_data,
    sprint_t_ric_generica.descrizione_comune
   FROM (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
  WHERE ((geo_pt_intervento.fk_legge = (1)::numeric) AND (sprint_t_ric_generica.fk_stato = ANY (ARRAY[(3)::numeric, (4)::numeric])) AND (sprint_t_ric_generica.mod_data >= (('now'::text)::date - '3 years'::interval)));


--
-- Name: vsde_ric_18_pt_inserimento; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_18_pt_inserimento AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    ((((sprint_t_ric_generica.costi_lavori + ((sprint_t_ric_generica.costi_lavori * (sprint_d_richiesta_generica_2.codice)::numeric) / (100)::numeric)) + (((sprint_t_ric_generica.spese_gen_tecn + sprint_t_ric_generica.costi_prove) + sprint_t_ric_generica.costi_espropri) + sprint_t_ric_generica.costi_imprevisti)) + (((sprint_t_ric_generica.spese_gen_tecn + sprint_t_ric_generica.costi_prove) * (sprint_d_richiesta_generica_3.codice)::numeric) / (100)::numeric)) - sprint_t_ric_generica.altri_finanz) AS importo_richiesto,
    sprint_t_ric_generica.descrizione_comune
   FROM (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
  WHERE (geo_pt_intervento.fk_legge = (1)::numeric);


--
-- Name: vsde_ric_18_pt_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_18_pt_storico AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    round((((round((sprint_t_ric_generica.costi_lavori + ((sprint_t_ric_generica.costi_lavori * (sprint_d_richiesta_generica_2.codice)::numeric) / (100)::numeric)), 2) + (((sprint_t_ric_generica.spese_gen_tecn + sprint_t_ric_generica.costi_prove) + sprint_t_ric_generica.costi_espropri) + sprint_t_ric_generica.costi_imprevisti)) + (((sprint_t_ric_generica.spese_gen_tecn + sprint_t_ric_generica.costi_prove) * (sprint_d_richiesta_generica_3.codice)::numeric) / (100)::numeric)) - sprint_t_ric_generica.altri_finanz), 2) AS importo_richiesto,
    sprint_t_ric_generica.descrizione_comune
   FROM (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
  WHERE ((geo_pt_intervento.fk_legge = (1)::numeric) AND ((sprint_t_ric_generica.fk_stato = (4)::numeric) OR (sprint_t_ric_generica.fk_stato = (5)::numeric)));


--
-- Name: vsde_ric_38_pt_consultazione; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_38_pt_consultazione AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.mod_data,
    sprint_t_ric_generica.descrizione_comune
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE ((geo_pt_intervento.fk_legge = (2)::numeric) AND (sprint_t_ric_generica.fk_stato = ANY (ARRAY[(3)::numeric, (2)::numeric, (6)::numeric, (4)::numeric, (85)::numeric])) AND (sprint_t_ric_generica.mod_data >= (('now'::text)::date - '3 years'::interval)));


--
-- Name: vsde_ric_38_pt_inserimento; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_38_pt_inserimento AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.descrizione_comune
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE (geo_pt_intervento.fk_legge = (2)::numeric);


--
-- Name: vsde_ric_38_pt_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_38_pt_storico AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.descrizione_comune
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE ((geo_pt_intervento.fk_legge = (2)::numeric) AND ((sprint_t_ric_generica.fk_stato = (4)::numeric) OR (sprint_t_ric_generica.fk_stato = (5)::numeric)));


--
-- Name: vsde_ric_38_strao_pt_tutte; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_38_strao_pt_tutte AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_38_calamita.fk_evento,
    sprint_t_evento.cod_evento,
    sprint_t_evento.descrizione,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.fk_tipo_ente,
    sprint_r_ric_generica_comune.fk_tope_comune,
    sprint_r_ric_generica_comune.istat_provincia,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_d_richiesta_generica_5.descrizione AS sottocategoria,
    sprint_t_ric_generica.data_pratica_wfr,
    sprint_t_ric_generica.n_pratica_wfr,
    sprint_t_ric_generica.provvedimento_finanziamento,
    sprint_t_ric_generica.nome_compilatore,
    sprint_t_ric_generica.cognome_compilatore,
    sprint_t_ric_generica.note,
    ((COALESCE(sprint_t_ric_38_calamita.importo_urgente, (0)::numeric) + COALESCE(sprint_t_ric_38_calamita.importo_definitivo, (0)::numeric)) + COALESCE(sprint_t_ric_38_calamita.importo_somma_urgenza, (0)::numeric)) AS totale_richiesto,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_38_calamita.importo_somma_urgenza,
    sprint_t_ric_38_calamita.n_ordinanza_sindacale,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.descrizione_intervento,
    sprint_t_ric_generica.mod_data,
    sprint_t_ric_generica.data_inserimento,
    sprint_t_ric_generica.descrizione_comune,
    round((public.st_x(geo_pt_intervento.geometria))::numeric, 2) AS co_x,
    round((public.st_y(geo_pt_intervento.geometria))::numeric, 2) AS co_y,
    sprint_t_ric_generica.flg_dissesto_senso_pai,
    sprint_t_ric_generica.flg_georiferito,
    sprint_t_ric_generica.codice_cup,
    sprint_t_ric_generica.descrizione_dissesto,
    sprint_t_ric_generica.fk_tipo_ente AS id_aggregazioni,
    sprint_t_appg_aggregazioni.tipo_aggr AS aggregazioni,
    sprint_t_ric_generica.flg_wizard,
    sprint_t_ric_generica.flg_sopralluogo,
        CASE sprint_t_ric_generica.flg_georiferito
            WHEN 0 THEN 'NO'::text
            WHEN 1 THEN 'SI'::text
            ELSE NULL::text
        END AS georiferito,
    sprint_d_richiesta_generica_6.descrizione AS descrizione_tipo_dissesto,
        CASE sprint_t_ric_generica.flg_dissesto_senso_pai
            WHEN 1 THEN 'NO'::text
            WHEN 2 THEN 'SI'::text
            ELSE NULL::text
        END AS dissesto_senso_pai,
    sprint_t_ric_generica.localita
   FROM sprint.sprint_r_ric_generica_comune,
    ((((((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_5
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice))) ON ((sprint_d_richiesta_generica_5.id = sprint_t_ric_generica.fk_categoria)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
     LEFT JOIN sprint.sprint_t_evento ON ((sprint_t_ric_38_calamita.fk_evento = sprint_t_evento.id_evento)))
     LEFT JOIN sprint.sprint_t_appg_aggregazioni ON (((sprint_t_ric_generica.fk_tipo_ente)::text = (sprint_t_appg_aggregazioni.id_tipoaggr)::text)))
     LEFT JOIN sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_6 ON ((sprint_d_richiesta_generica_6.id = sprint_t_ric_generica.fk_tipo_dissesto)))
  WHERE (geo_pt_intervento.id_pt_intervento = sprint_r_ric_generica_comune.id_richiesta_generica)
  ORDER BY sprint_t_ric_generica.id_richiesta_generica DESC, sprint_t_ric_generica.data_inserimento DESC;


--
-- Name: vsde_ric_54_pt_consultazione; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_54_pt_consultazione AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.fk_categoria,
    sprint_d_richiesta_generica_4.descrizione AS categoria_intervento,
    sprint_t_ric_generica.n_lotto,
    sprint_t_lotto.importo AS importo_1_lotto,
    sprint_t_ric_generica.mod_data,
    sprint_t_ric_generica.fk_tipo_opere,
    sprint_d_richiesta_generica_5.descrizione AS tipo_opere,
    sprint_d_richiesta_generica_5.fk_padre,
    sprint_d_richiesta_generica_6.descrizione AS padre_opere,
    sprint_t_ric_generica.descrizione_comune
   FROM (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_6
     RIGHT JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_5
     JOIN (((((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     JOIN sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3 ON ((sprint_t_ric_generica.fk_categoria = sprint_d_richiesta_generica_3.id)))
     LEFT JOIN sprint.sprint_t_ric_18_54_183 ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_18_54_183.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_18_54_183.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_1854)))
     LEFT JOIN sprint.sprint_t_lotto ON ((sprint_t_ric_18_54_183.id_richiesta_generica = sprint_t_lotto.fk_richiesta_generica))) ON ((sprint_d_richiesta_generica_5.id = sprint_t_ric_generica.fk_tipo_opere))) ON ((sprint_d_richiesta_generica_6.id = sprint_d_richiesta_generica_5.fk_padre)))
  WHERE ((geo_pt_intervento.fk_legge = (3)::numeric) AND ((sprint_t_ric_generica.n_lotto IS NULL) OR (sprint_t_lotto.n_lotto = sprint_t_ric_generica.n_lotto)) AND (sprint_t_ric_generica.fk_stato = ANY (ARRAY[(3)::numeric, (85)::numeric, (6)::numeric, (2)::numeric, (4)::numeric])) AND (sprint_t_ric_generica.mod_data >= (('now'::text)::date - '3 years'::interval)));


--
-- Name: vsde_ric_54_pt_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_54_pt_storico AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_t_ric_generica.fk_tipo_intervento,
    sprint_d_richiesta_generica_1.descrizione AS tipo_intervento,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.fk_categoria,
    sprint_d_richiesta_generica_4.descrizione AS categoria_intervento,
    a.tot_lotto,
    a.importo_1_lotto,
    sprint_t_ric_generica.fk_tipo_opere,
    sprint_d_richiesta_generica_5.descrizione AS tipo_opere,
    sprint_d_richiesta_generica_5.fk_padre,
    sprint_d_richiesta_generica_6.descrizione AS padre_opere,
    sprint_t_ric_generica.descrizione_comune
   FROM sprint.sprint_d_richiesta_generica,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_5,
    sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_6,
    sprint.sprint_t_ric_generica,
    sprint.sprint_r_geometria_richiesta,
    sprint.geo_pt_intervento,
    sprint.sprint_t_ric_18_54_183,
    sprint.sprint_t_analisi_rischio,
    sprint.sprint_d_analisi_rischio,
    ( SELECT sprint_t_lotto.fk_richiesta_generica,
            count(sprint_t_lotto.id_lotto) AS tot_lotto,
            sum(COALESCE(sprint_t_lotto.importo, (0)::numeric)) AS importo_1_lotto
           FROM sprint.sprint_t_ric_generica sprint_t_ric_generica_1,
            sprint.sprint_t_lotto
          WHERE (sprint_t_ric_generica_1.id_richiesta_generica = sprint_t_lotto.fk_richiesta_generica)
          GROUP BY sprint_t_lotto.fk_richiesta_generica) a
  WHERE ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato) AND (sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento) AND (sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica) AND (sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento) AND (sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice) AND (sprint_t_ric_generica.fk_categoria = sprint_d_richiesta_generica_3.id) AND (sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_18_54_183.id_richiesta_generica) AND (sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio) AND (sprint_t_ric_18_54_183.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_1854) AND (sprint_t_ric_18_54_183.id_richiesta_generica = a.fk_richiesta_generica) AND (sprint_d_richiesta_generica_5.id = sprint_t_ric_generica.fk_tipo_opere) AND (sprint_d_richiesta_generica_6.id = sprint_d_richiesta_generica_5.fk_padre) AND ((geo_pt_intervento.fk_legge = (3)::numeric) AND ((sprint_t_ric_generica.fk_stato = (4)::numeric) OR (sprint_t_ric_generica.fk_stato = (5)::numeric))));


--
-- Name: vsde_ric_strao_ln_consultazion; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_ln_consultazion AS
 SELECT geo_ln_intervento.id_ln_intervento,
    geo_ln_intervento.geometria,
    geo_ln_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.mod_data
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_ln_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_ln_intervento.id_ln_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE ((geo_ln_intervento.fk_legge = (5)::numeric) AND ((sprint_t_ric_generica.fk_stato = (3)::numeric) OR (sprint_t_ric_generica.fk_stato = (2)::numeric) OR (sprint_t_ric_generica.fk_stato = (1)::numeric) OR (sprint_t_ric_generica.fk_stato = (6)::numeric) OR (sprint_t_ric_generica.fk_stato = (85)::numeric) OR ((sprint_t_ric_generica.fk_stato = (4)::numeric) AND ((date_part('year'::text, sprint_t_ric_generica.mod_data) = date_part('year'::text, ('now'::text)::date)) OR (date_part('year'::text, sprint_t_ric_generica.mod_data) = (date_part('year'::text, ('now'::text)::date) - (1)::double precision))))));


--
-- Name: vsde_ric_strao_ln_inserimento; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_ln_inserimento AS
 SELECT geo_ln_intervento.id_ln_intervento,
    geo_ln_intervento.geometria,
    geo_ln_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.fk_evento,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_ln_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_ln_intervento.id_ln_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE (geo_ln_intervento.fk_legge = (5)::numeric);


--
-- Name: vsde_ric_strao_ln_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_ln_storico AS
 SELECT geo_ln_intervento.id_ln_intervento,
    geo_ln_intervento.geometria,
    geo_ln_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_ln_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_ln_intervento.id_ln_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE ((geo_ln_intervento.fk_legge = (5)::numeric) AND ((sprint_t_ric_generica.fk_stato = (4)::numeric) OR (sprint_t_ric_generica.fk_stato = (5)::numeric)));


--
-- Name: vsde_ric_strao_pl_consultazion; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_pl_consultazion AS
 SELECT geo_pl_intervento.id_pl_intervento,
    geo_pl_intervento.geometria,
    geo_pl_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.mod_data
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pl_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pl_intervento.id_pl_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE ((geo_pl_intervento.fk_legge = (5)::numeric) AND ((sprint_t_ric_generica.fk_stato = (3)::numeric) OR (sprint_t_ric_generica.fk_stato = (2)::numeric) OR (sprint_t_ric_generica.fk_stato = (1)::numeric) OR (sprint_t_ric_generica.fk_stato = (6)::numeric) OR (sprint_t_ric_generica.fk_stato = (85)::numeric) OR ((sprint_t_ric_generica.fk_stato = (4)::numeric) AND ((date_part('year'::text, sprint_t_ric_generica.mod_data) = date_part('year'::text, ('now'::text)::date)) OR (date_part('year'::text, sprint_t_ric_generica.mod_data) = (date_part('year'::text, ('now'::text)::date) - (1)::double precision))))));


--
-- Name: vsde_ric_strao_pl_inserimento; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_pl_inserimento AS
 SELECT geo_pl_intervento.id_pl_intervento,
    geo_pl_intervento.geometria,
    geo_pl_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.fk_evento,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pl_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pl_intervento.id_pl_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE (geo_pl_intervento.fk_legge = (5)::numeric);


--
-- Name: vsde_ric_strao_pl_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_pl_storico AS
 SELECT geo_pl_intervento.id_pl_intervento,
    geo_pl_intervento.geometria,
    geo_pl_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pl_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pl_intervento.id_pl_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE ((geo_pl_intervento.fk_legge = (5)::numeric) AND ((sprint_t_ric_generica.fk_stato = (4)::numeric) OR (sprint_t_ric_generica.fk_stato = (5)::numeric)));


--
-- Name: vsde_ric_strao_pt_consultazion; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_pt_consultazion AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.mod_data,
    sprint_t_ric_generica.descrizione_comune
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE ((geo_pt_intervento.fk_legge = (5)::numeric) AND (sprint_t_ric_generica.fk_stato = ANY (ARRAY[(3)::numeric, (2)::numeric, (1)::numeric, (6)::numeric, (4)::numeric, (85)::numeric])) AND (sprint_t_ric_generica.mod_data >= (('now'::text)::date - '3 years'::interval)));


--
-- Name: vsde_ric_strao_pt_inserimento; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_pt_inserimento AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.fk_evento,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.descrizione_comune
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE (geo_pt_intervento.fk_legge = (5)::numeric);


--
-- Name: vsde_ric_strao_pt_storico; Type: VIEW; Schema: sprint; Owner: -
--

CREATE VIEW sprint.vsde_ric_strao_pt_storico AS
 SELECT geo_pt_intervento.id_pt_intervento,
    geo_pt_intervento.geometria,
    geo_pt_intervento.fk_legge,
    sprint_t_ric_generica.id_richiesta_generica,
    sprint_t_ric_generica.cod_richiesta,
    sprint_t_ric_generica.fk_tope_ente_richiedente,
    sprint_t_ric_generica.descrizione_danno,
    sprint_t_ric_generica.fk_codice,
    sprint_d_richiesta_generica_4.descrizione AS codice,
    sprint_t_ric_38_calamita.importo_urgente,
    sprint_t_ric_38_calamita.importo_definitivo,
    sprint_t_ric_generica.fk_stato,
    sprint_d_richiesta_generica.descrizione AS stato,
    sprint_d_richiesta_generica_2.codice AS tasso_iva_lavori,
    sprint_t_ric_generica.spese_gen_tecn,
    sprint_t_ric_generica.costi_prove,
    sprint_t_ric_generica.costi_espropri,
    sprint_t_ric_generica.costi_imprevisti,
    sprint_d_richiesta_generica_3.codice AS tasso_iva_somme_disp,
    sprint_d_analisi_rischio.descrizione AS classe_rischio,
    sprint_t_ric_generica.descrizione_comune
   FROM (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_4
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_3
     JOIN (((sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_2
     JOIN (sprint.sprint_d_richiesta_generica sprint_d_richiesta_generica_1
     JOIN (sprint.sprint_d_richiesta_generica
     JOIN sprint.sprint_t_ric_generica ON ((sprint_d_richiesta_generica.id = sprint_t_ric_generica.fk_stato))) ON ((sprint_d_richiesta_generica_1.id = sprint_t_ric_generica.fk_tipo_intervento))) ON ((sprint_d_richiesta_generica_2.id = sprint_t_ric_generica.fk_tasso_iva_lavori)))
     JOIN sprint.sprint_r_geometria_richiesta ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_r_geometria_richiesta.id_richiesta_generica)))
     JOIN sprint.geo_pt_intervento ON ((sprint_r_geometria_richiesta.id_richiesta_generica = geo_pt_intervento.id_pt_intervento))) ON ((sprint_d_richiesta_generica_3.id = sprint_t_ric_generica.fk_tasso_iva_somme_disp))) ON ((sprint_d_richiesta_generica_4.id = sprint_t_ric_generica.fk_codice)))
     LEFT JOIN sprint.sprint_t_ric_38_calamita ON ((sprint_t_ric_generica.id_richiesta_generica = sprint_t_ric_38_calamita.id_richiesta_generica)))
     LEFT JOIN (sprint.sprint_d_analisi_rischio
     JOIN sprint.sprint_t_analisi_rischio ON ((sprint_d_analisi_rischio.id = sprint_t_analisi_rischio.fk_val_rischio))) ON ((sprint_t_ric_38_calamita.id_richiesta_generica = sprint_t_analisi_rischio.fk_richiesta_generica_38cal)))
  WHERE ((geo_pt_intervento.fk_legge = (5)::numeric) AND ((sprint_t_ric_generica.fk_stato = (4)::numeric) OR (sprint_t_ric_generica.fk_stato = (5)::numeric)));


--
-- Name: wf_to_sprint; Type: TABLE; Schema: sprint; Owner: -
--

CREATE TABLE sprint.wf_to_sprint (
    id_wf_to_sprint numeric NOT NULL,
    data_elab character varying(8),
    model_code character varying(2),
    id_emeter character varying(10),
    operazione character varying(1),
    numero_pratica character varying(30),
    data_inserimento character varying(12),
    documento character varying(40),
    progressivo character varying(1),
    legge character varying(20),
    data_anno character varying(12),
    importo character varying(12),
    importo_assegnato character varying(12),
    importo_consuntivo character varying(12),
    esito character varying(400)
);


--
-- Name: sprint_t_map_group_layer id_group_layer; Type: DEFAULT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_map_group_layer ALTER COLUMN id_group_layer SET DEFAULT nextval('sprint.sprint_t_map_group_layer_id_group_layer_seq'::regclass);


--
-- Name: sprint_t_map_layer id_layer; Type: DEFAULT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_map_layer ALTER COLUMN id_layer SET DEFAULT nextval('sprint.sprint_t_map_layer_id_layer_seq'::regclass);


--
-- Name: sprint_t_map_layer_feature id_layer_eature; Type: DEFAULT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_map_layer_feature ALTER COLUMN id_layer_eature SET DEFAULT nextval('sprint.sprint_t_map_layer_feature_id_layer_eature_seq'::regclass);


--
-- Name: geo_ln_evento pk_geo_ln_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_ln_evento
    ADD CONSTRAINT pk_geo_ln_evento PRIMARY KEY (id_ln_evento);


--
-- Name: geo_ln_intervento pk_geo_ln_intervento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_ln_intervento
    ADD CONSTRAINT pk_geo_ln_intervento PRIMARY KEY (id_ln_intervento);


--
-- Name: geo_pl_evento pk_geo_pl_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pl_evento
    ADD CONSTRAINT pk_geo_pl_evento PRIMARY KEY (id_pl_evento);


--
-- Name: geo_pl_intervento pk_geo_pl_intervento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pl_intervento
    ADD CONSTRAINT pk_geo_pl_intervento PRIMARY KEY (id_pl_intervento);


--
-- Name: geo_pt_evento pk_geo_pt_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pt_evento
    ADD CONSTRAINT pk_geo_pt_evento PRIMARY KEY (id_pt_evento);


--
-- Name: geo_pt_intervento pk_geo_pt_intervento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pt_intervento
    ADD CONSTRAINT pk_geo_pt_intervento PRIMARY KEY (id_pt_intervento);


--
-- Name: sprint_d_analisi_rischio pk_sprint_d_analisi_rischio; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_d_analisi_rischio
    ADD CONSTRAINT pk_sprint_d_analisi_rischio PRIMARY KEY (id);


--
-- Name: sprint_d_evento pk_sprint_d_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_d_evento
    ADD CONSTRAINT pk_sprint_d_evento PRIMARY KEY (id);


--
-- Name: sprint_d_ric_183 pk_sprint_d_ric_183; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_d_ric_183
    ADD CONSTRAINT pk_sprint_d_ric_183 PRIMARY KEY (id);


--
-- Name: sprint_d_ric_18_54_183 pk_sprint_d_ric_18_54_183; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_d_ric_18_54_183
    ADD CONSTRAINT pk_sprint_d_ric_18_54_183 PRIMARY KEY (id);


--
-- Name: sprint_d_richiesta_generica pk_sprint_d_richiesta_generica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_d_richiesta_generica
    ADD CONSTRAINT pk_sprint_d_richiesta_generica PRIMARY KEY (id);


--
-- Name: sprint_mtd_analisi_rischio pk_sprint_mtd_analisi_rischio; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_analisi_rischio
    ADD CONSTRAINT pk_sprint_mtd_analisi_rischio PRIMARY KEY (id_mtd);


--
-- Name: sprint_mtd_campo pk_sprint_mtd_campo; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_campo
    ADD CONSTRAINT pk_sprint_mtd_campo PRIMARY KEY (id_campo);


--
-- Name: sprint_mtd_campo_ris_ricerca pk_sprint_mtd_campo_ris_ricerc; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_campo_ris_ricerca
    ADD CONSTRAINT pk_sprint_mtd_campo_ris_ricerc PRIMARY KEY (id_campo_ris_ricerca);


--
-- Name: sprint_mtd_config pk_sprint_mtd_config; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_config
    ADD CONSTRAINT pk_sprint_mtd_config PRIMARY KEY (id);


--
-- Name: sprint_mtd_criterio pk_sprint_mtd_criterio; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_criterio
    ADD CONSTRAINT pk_sprint_mtd_criterio PRIMARY KEY (id_criterio);


--
-- Name: sprint_mtd_folder pk_sprint_mtd_folder; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_folder
    ADD CONSTRAINT pk_sprint_mtd_folder PRIMARY KEY (id_folder);


--
-- Name: sprint_mtd_legge pk_sprint_mtd_legge; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_legge
    ADD CONSTRAINT pk_sprint_mtd_legge PRIMARY KEY (id_legge);


--
-- Name: sprint_mtd_oggetto pk_sprint_mtd_oggetto; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_oggetto
    ADD CONSTRAINT pk_sprint_mtd_oggetto PRIMARY KEY (id_oggetto);


--
-- Name: sprint_mtd_profilo_utente pk_sprint_mtd_profilo_utente; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_profilo_utente
    ADD CONSTRAINT pk_sprint_mtd_profilo_utente PRIMARY KEY (id_profilo);


--
-- Name: sprint_mtd_r1_folderlegge pk_sprint_mtd_r1_folderlegge; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r1_folderlegge
    ADD CONSTRAINT pk_sprint_mtd_r1_folderlegge PRIMARY KEY (id_folder, id_legge);


--
-- Name: sprint_mtd_r2_sezionelegge pk_sprint_mtd_r2_sezionelegge; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r2_sezionelegge
    ADD CONSTRAINT pk_sprint_mtd_r2_sezionelegge PRIMARY KEY (id_legge, id_sezione);


--
-- Name: sprint_mtd_r3_campo_sezlegge pk_sprint_mtd_r3_campo_sezlegg; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r3_campo_sezlegge
    ADD CONSTRAINT pk_sprint_mtd_r3_campo_sezlegg PRIMARY KEY (id_campo, id_legge, id_sezione);


--
-- Name: sprint_mtd_r_campo_oggprof pk_sprint_mtd_r_campo_oggprof; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_campo_oggprof
    ADD CONSTRAINT pk_sprint_mtd_r_campo_oggprof PRIMARY KEY (id_campo_ris_ricerca, id_profilo, id_oggetto);


--
-- Name: sprint_mtd_r_campo_ricercapred pk_sprint_mtd_r_campo_ricercap; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_campo_ricercapred
    ADD CONSTRAINT pk_sprint_mtd_r_campo_ricercap PRIMARY KEY (id_campo_ris_ricerca, id_ricerca_pred);


--
-- Name: sprint_mtd_r_criterio_oggprof pk_sprint_mtd_r_criterio_oggpr; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_criterio_oggprof
    ADD CONSTRAINT pk_sprint_mtd_r_criterio_oggpr PRIMARY KEY (id_profilo, id_oggetto, id_criterio);


--
-- Name: sprint_mtd_r_ogg_prof pk_sprint_mtd_r_ogg_prof; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_ogg_prof
    ADD CONSTRAINT pk_sprint_mtd_r_ogg_prof PRIMARY KEY (id_profilo, id_oggetto);


--
-- Name: sprint_mtd_r_profilo_ricerca pk_sprint_mtd_r_profilo_ricerc; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_profilo_ricerca
    ADD CONSTRAINT pk_sprint_mtd_r_profilo_ricerc PRIMARY KEY (id_profilo, id_ricerca_pred);


--
-- Name: sprint_mtd_ric_18_54_183 pk_sprint_mtd_ric_18_54_183; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_ric_18_54_183
    ADD CONSTRAINT pk_sprint_mtd_ric_18_54_183 PRIMARY KEY (id_mtd);


--
-- Name: sprint_mtd_ric_generica pk_sprint_mtd_ric_generica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_ric_generica
    ADD CONSTRAINT pk_sprint_mtd_ric_generica PRIMARY KEY (id_mtd);


--
-- Name: sprint_mtd_ricerca_pred_clob pk_sprint_mtd_ricer_pred_clob; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_ricerca_pred_clob
    ADD CONSTRAINT pk_sprint_mtd_ricer_pred_clob PRIMARY KEY (id_ricerca_pred);


--
-- Name: sprint_mtd_sezione pk_sprint_mtd_sezione; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_sezione
    ADD CONSTRAINT pk_sprint_mtd_sezione PRIMARY KEY (id_sezione);


--
-- Name: sprint_mtd_tavola pk_sprint_mtd_tavola; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_tavola
    ADD CONSTRAINT pk_sprint_mtd_tavola PRIMARY KEY (id_tavola);


--
-- Name: sprint_mtd_utente pk_sprint_mtd_utenti; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_utente
    ADD CONSTRAINT pk_sprint_mtd_utenti PRIMARY KEY (id_utente);


--
-- Name: sprint_r_18_54_183_dinamica pk_sprint_r_18_54_183_dinamica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_18_54_183_dinamica
    ADD CONSTRAINT pk_sprint_r_18_54_183_dinamica PRIMARY KEY (id_mtd, id_richiesta_generica);


--
-- Name: sprint_r_38_calamita pk_sprint_r_38_calamita; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_38_calamita
    ADD CONSTRAINT pk_sprint_r_38_calamita PRIMARY KEY (id_richiesta_generica_padre, id_richiesta_generica_figlio);


--
-- Name: sprint_r_analisi_dinamica pk_sprint_r_analisi_dinamica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_analisi_dinamica
    ADD CONSTRAINT pk_sprint_r_analisi_dinamica PRIMARY KEY (id_analisi_rischio, id_mtd);


--
-- Name: sprint_r_area_idro_evento pk_sprint_r_area_idro_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_area_idro_evento
    ADD CONSTRAINT pk_sprint_r_area_idro_evento PRIMARY KEY (id_evento, id_area_idro);


--
-- Name: sprint_r_area_idro_ric_generic pk_sprint_r_area_idro_ric_gene; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_area_idro_ric_generic
    ADD CONSTRAINT pk_sprint_r_area_idro_ric_gene PRIMARY KEY (id_richiesta_generica, id_area_idro);


--
-- Name: sprint_r_evento_comune pk_sprint_r_evento_comune; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_evento_comune
    ADD CONSTRAINT pk_sprint_r_evento_comune PRIMARY KEY (fk_tope_comune, fk_evento);


--
-- Name: sprint_r_geometria_richiesta pk_sprint_r_geometria_richiest; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_geometria_richiesta
    ADD CONSTRAINT pk_sprint_r_geometria_richiest PRIMARY KEY (id_richiesta_generica);


--
-- Name: sprint_r_ric_generica_dinamica pk_sprint_r_ric_gen_dinamica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_ric_generica_dinamica
    ADD CONSTRAINT pk_sprint_r_ric_gen_dinamica PRIMARY KEY (id_mtd, id_richiesta_generica);


--
-- Name: sprint_r_ric_generica_comune pk_sprint_r_ric_generica_comun; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_ric_generica_comune
    ADD CONSTRAINT pk_sprint_r_ric_generica_comun PRIMARY KEY (id_richiesta_generica, fk_tope_comune);


--
-- Name: sprint_r_ricgen_allegato pk_sprint_r_ricgen_allegato; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_ricgen_allegato
    ADD CONSTRAINT pk_sprint_r_ricgen_allegato PRIMARY KEY (id_richiesta_generica, id_allegato_ric);


--
-- Name: sprint_s_analisi_rischio pk_sprint_s_analisi_rischio; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_analisi_rischio
    ADD CONSTRAINT pk_sprint_s_analisi_rischio PRIMARY KEY (id_analisi_rischio);


--
-- Name: sprint_s_evento pk_sprint_s_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_evento
    ADD CONSTRAINT pk_sprint_s_evento PRIMARY KEY (id_storico_evento);


--
-- Name: sprint_s_lotto pk_sprint_s_lotto; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_lotto
    ADD CONSTRAINT pk_sprint_s_lotto PRIMARY KEY (id_storico_lotto);


--
-- Name: sprint_s_ric_183 pk_sprint_s_ric_183; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT pk_sprint_s_ric_183 PRIMARY KEY (id_storico_richiesta);


--
-- Name: sprint_s_ric_18_54_183 pk_sprint_s_ric_18_54_183; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_18_54_183
    ADD CONSTRAINT pk_sprint_s_ric_18_54_183 PRIMARY KEY (id_storico_richiesta);


--
-- Name: sprint_s_ric_38_calamita pk_sprint_s_ric_38_calamita; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_38_calamita
    ADD CONSTRAINT pk_sprint_s_ric_38_calamita PRIMARY KEY (id_storico_richiesta);


--
-- Name: sprint_s_ric_generica pk_sprint_s_ric_generica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT pk_sprint_s_ric_generica PRIMARY KEY (id_storico_richiesta);


--
-- Name: sprint_s_stralcio pk_sprint_s_stralcio; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_stralcio
    ADD CONSTRAINT pk_sprint_s_stralcio PRIMARY KEY (id_stralcio);


--
-- Name: sprint_sr_18_54_183_dinamica pk_sprint_sr_18_54_183_dinamic; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_18_54_183_dinamica
    ADD CONSTRAINT pk_sprint_sr_18_54_183_dinamic PRIMARY KEY (id_mtd, id_storico_richiesta);


--
-- Name: sprint_sr_38_calamita pk_sprint_sr_38_calamita; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_38_calamita
    ADD CONSTRAINT pk_sprint_sr_38_calamita PRIMARY KEY (id_storico_richiesta_padre, id_storico_richiesta_figlio);


--
-- Name: sprint_sr_analisi_dinamica pk_sprint_sr_analisi_dinamica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_analisi_dinamica
    ADD CONSTRAINT pk_sprint_sr_analisi_dinamica PRIMARY KEY (id_analisi_rischio, id_mtd);


--
-- Name: sprint_sr_area_idro_evento pk_sprint_sr_area_idro_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_area_idro_evento
    ADD CONSTRAINT pk_sprint_sr_area_idro_evento PRIMARY KEY (fk_storico_evento, id_area_idro);


--
-- Name: sprint_sr_area_idro_ric_generi pk_sprint_sr_area_idro_ric_gen; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_area_idro_ric_generi
    ADD CONSTRAINT pk_sprint_sr_area_idro_ric_gen PRIMARY KEY (id_storico_richiesta, id_area_idro);


--
-- Name: sprint_sr_evento_comune pk_sprint_sr_evento_comune; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_evento_comune
    ADD CONSTRAINT pk_sprint_sr_evento_comune PRIMARY KEY (fk_tope_comune, fk_storico_evento);


--
-- Name: sprint_sr_evento_ricgen pk_sprint_sr_evento_ricgen; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_evento_ricgen
    ADD CONSTRAINT pk_sprint_sr_evento_ricgen PRIMARY KEY (id_storico_evento, id_richiesta_generica);


--
-- Name: sprint_sr_ric_generica_dinamic pk_sprint_sr_ric_gen_dinamica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_ric_generica_dinamic
    ADD CONSTRAINT pk_sprint_sr_ric_gen_dinamica PRIMARY KEY (id_mtd, id_storico_richiesta);


--
-- Name: sprint_sr_ric_generica_comune pk_sprint_sr_ric_generica_comu; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_ric_generica_comune
    ADD CONSTRAINT pk_sprint_sr_ric_generica_comu PRIMARY KEY (id_storico_richiesta, fk_tope_comune);


--
-- Name: sprint_t_allegato_evento pk_sprint_t_allegato_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_allegato_evento
    ADD CONSTRAINT pk_sprint_t_allegato_evento PRIMARY KEY (id_allegato_evento);


--
-- Name: sprint_t_allegato_ric pk_sprint_t_allegato_ric; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_allegato_ric
    ADD CONSTRAINT pk_sprint_t_allegato_ric PRIMARY KEY (id_allegato_ric);


--
-- Name: sprint_t_analisi_rischio pk_sprint_t_analisi_rischio; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_analisi_rischio
    ADD CONSTRAINT pk_sprint_t_analisi_rischio PRIMARY KEY (id_analisi_rischio);


--
-- Name: sprint_t_appg_settori pk_sprint_t_appg_settori; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_appg_settori
    ADD CONSTRAINT pk_sprint_t_appg_settori PRIMARY KEY (id_settore);


--
-- Name: sprint_t_area_idro pk_sprint_t_area_idro; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_area_idro
    ADD CONSTRAINT pk_sprint_t_area_idro PRIMARY KEY (id_area_idro);


--
-- Name: sprint_t_centroide pk_sprint_t_centroide; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_centroide
    ADD CONSTRAINT pk_sprint_t_centroide PRIMARY KEY (id_comune);


--
-- Name: sprint_t_evento pk_sprint_t_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_evento
    ADD CONSTRAINT pk_sprint_t_evento PRIMARY KEY (id_evento);


--
-- Name: sprint_t_lotto pk_sprint_t_lotto; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_lotto
    ADD CONSTRAINT pk_sprint_t_lotto PRIMARY KEY (id_lotto);


--
-- Name: sprint_t_map_group_layer pk_sprint_t_map_group_layer; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_map_group_layer
    ADD CONSTRAINT pk_sprint_t_map_group_layer PRIMARY KEY (id_group_layer);


--
-- Name: sprint_t_map_layer pk_sprint_t_map_layer; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_map_layer
    ADD CONSTRAINT pk_sprint_t_map_layer PRIMARY KEY (id_layer);


--
-- Name: sprint_t_map_layer_feature pk_sprint_t_map_layer_feature; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_map_layer_feature
    ADD CONSTRAINT pk_sprint_t_map_layer_feature PRIMARY KEY (id_layer_eature);


--
-- Name: sprint_t_ric_183 pk_sprint_t_ric_183; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT pk_sprint_t_ric_183 PRIMARY KEY (id_richiesta_generica);


--
-- Name: sprint_t_ric_18_54_183 pk_sprint_t_ric_18_54_183; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_18_54_183
    ADD CONSTRAINT pk_sprint_t_ric_18_54_183 PRIMARY KEY (id_richiesta_generica);


--
-- Name: sprint_t_ric_38_calamita pk_sprint_t_ric_38_calamita; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_38_calamita
    ADD CONSTRAINT pk_sprint_t_ric_38_calamita PRIMARY KEY (id_richiesta_generica);


--
-- Name: sprint_t_ric_generica pk_sprint_t_ric_generica; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_generica
    ADD CONSTRAINT pk_sprint_t_ric_generica PRIMARY KEY (id_richiesta_generica);


--
-- Name: sprint_t_stralcio pk_sprint_t_stralcio; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_stralcio
    ADD CONSTRAINT pk_sprint_t_stralcio PRIMARY KEY (id_stralcio);


--
-- Name: sprint_to_wf pk_sprint_to_wf; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_to_wf
    ADD CONSTRAINT pk_sprint_to_wf PRIMARY KEY (id_sprint_to_wf);


--
-- Name: sprint_w_comuni_evento pk_sprint_w_comuni_evento; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_w_comuni_evento
    ADD CONSTRAINT pk_sprint_w_comuni_evento PRIMARY KEY (id_evento, comune);


--
-- Name: wf_to_sprint pk_wf_to_sprint; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.wf_to_sprint
    ADD CONSTRAINT pk_wf_to_sprint PRIMARY KEY (id_wf_to_sprint);


--
-- Name: sde_logfiles sde_logfiles_pk; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sde_logfiles
    ADD CONSTRAINT sde_logfiles_pk PRIMARY KEY (logfile_id);


--
-- Name: sde_logfiles sde_logfiles_uk; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sde_logfiles
    ADD CONSTRAINT sde_logfiles_uk UNIQUE (logfile_name);


--
-- Name: sde_logfiles sde_logfiles_uk2; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sde_logfiles
    ADD CONSTRAINT sde_logfiles_uk2 UNIQUE (logfile_data_id);


--
-- Name: sprint_t_parametri sprint_t_parametri_pk; Type: CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_parametri
    ADD CONSTRAINT sprint_t_parametri_pk PRIMARY KEY (id_parametro);


--
-- Name: ak1_sprint_t_lotto; Type: INDEX; Schema: sprint; Owner: -
--

CREATE UNIQUE INDEX ak1_sprint_t_lotto ON sprint.sprint_t_lotto USING btree (fk_richiesta_generica, n_lotto);


--
-- Name: ind_geo_ln_evento; Type: INDEX; Schema: sprint; Owner: -
--

CREATE INDEX ind_geo_ln_evento ON sprint.geo_ln_evento USING btree (geometria);


--
-- Name: ind_geo_ln_intervento; Type: INDEX; Schema: sprint; Owner: -
--

CREATE INDEX ind_geo_ln_intervento ON sprint.geo_ln_intervento USING btree (geometria);


--
-- Name: ind_geo_pl_evento; Type: INDEX; Schema: sprint; Owner: -
--

CREATE INDEX ind_geo_pl_evento ON sprint.geo_pl_evento USING btree (geometria);


--
-- Name: ind_geo_pl_intervento; Type: INDEX; Schema: sprint; Owner: -
--

CREATE INDEX ind_geo_pl_intervento ON sprint.geo_pl_intervento USING btree (geometria);


--
-- Name: ind_geo_pt_evento; Type: INDEX; Schema: sprint; Owner: -
--

CREATE INDEX ind_geo_pt_evento ON sprint.geo_pt_evento USING btree (geometria);


--
-- Name: ind_geo_pt_intervento; Type: INDEX; Schema: sprint; Owner: -
--

CREATE INDEX ind_geo_pt_intervento ON sprint.geo_pt_intervento USING btree (geometria);


--
-- Name: pk_sprint_r_province_collegate; Type: INDEX; Schema: sprint; Owner: -
--

CREATE UNIQUE INDEX pk_sprint_r_province_collegate ON sprint.sprint_r_province_collegate USING btree (istat_provincia_padre, istat_provincia_collegata);


--
-- Name: sde_logfile_data_idx1; Type: INDEX; Schema: sprint; Owner: -
--

CREATE INDEX sde_logfile_data_idx1 ON sprint.sde_logfile_data USING btree (logfile_data_id, sde_row_id);


--
-- Name: sde_logfile_data_idx2; Type: INDEX; Schema: sprint; Owner: -
--

CREATE INDEX sde_logfile_data_idx2 ON sprint.sde_logfile_data USING btree (sde_row_id);


--
-- Name: sprint_t_analisi_rischio sprint_d_analisi_rischio_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_analisi_rischio
    ADD CONSTRAINT sprint_d_analisi_rischio_01 FOREIGN KEY (fk_vulnerabilita) REFERENCES sprint.sprint_d_analisi_rischio(id);


--
-- Name: sprint_t_analisi_rischio sprint_d_analisi_rischio_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_analisi_rischio
    ADD CONSTRAINT sprint_d_analisi_rischio_02 FOREIGN KEY (fk_val_rischio) REFERENCES sprint.sprint_d_analisi_rischio(id);


--
-- Name: sprint_t_analisi_rischio sprint_d_analisi_rischio_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_analisi_rischio
    ADD CONSTRAINT sprint_d_analisi_rischio_03 FOREIGN KEY (fk_val_danno) REFERENCES sprint.sprint_d_analisi_rischio(id);


--
-- Name: sprint_s_analisi_rischio sprint_d_analisi_rischio_51; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_analisi_rischio
    ADD CONSTRAINT sprint_d_analisi_rischio_51 FOREIGN KEY (fk_vulnerabilita) REFERENCES sprint.sprint_d_analisi_rischio(id);


--
-- Name: sprint_s_analisi_rischio sprint_d_analisi_rischio_52; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_analisi_rischio
    ADD CONSTRAINT sprint_d_analisi_rischio_52 FOREIGN KEY (fk_val_rischio) REFERENCES sprint.sprint_d_analisi_rischio(id);


--
-- Name: sprint_s_analisi_rischio sprint_d_analisi_rischio_53; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_analisi_rischio
    ADD CONSTRAINT sprint_d_analisi_rischio_53 FOREIGN KEY (fk_val_danno) REFERENCES sprint.sprint_d_analisi_rischio(id);


--
-- Name: sprint_t_evento sprint_d_evento_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_evento
    ADD CONSTRAINT sprint_d_evento_01 FOREIGN KEY (fk_stato) REFERENCES sprint.sprint_d_evento(id);


--
-- Name: sprint_t_evento sprint_d_evento_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_evento
    ADD CONSTRAINT sprint_d_evento_02 FOREIGN KEY (fk_tipologia) REFERENCES sprint.sprint_d_evento(id);


--
-- Name: sprint_s_evento sprint_d_evento_51; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_evento
    ADD CONSTRAINT sprint_d_evento_51 FOREIGN KEY (fk_tipologia) REFERENCES sprint.sprint_d_evento(id);


--
-- Name: sprint_s_evento sprint_d_evento_52; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_evento
    ADD CONSTRAINT sprint_d_evento_52 FOREIGN KEY (fk_stato) REFERENCES sprint.sprint_d_evento(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_01 FOREIGN KEY (fk_frana_tipo) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_02 FOREIGN KEY (fk_frana_velocita) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_03 FOREIGN KEY (fk_frana_stato_attivita) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_04; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_04 FOREIGN KEY (fk_frana_distr_attivita) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_05; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_05 FOREIGN KEY (fk_frana_pres_interventi) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_06; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_06 FOREIGN KEY (fk_frana_pres_opere_negative) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_08; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_08 FOREIGN KEY (fk_conoide_i_asprezza_melton) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_09; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_09 FOREIGN KEY (fk_conoide_diametro_interno) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_10; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_10 FOREIGN KEY (fk_conoide_pendenza) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_11; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_11 FOREIGN KEY (fk_conoide_ricorrenza) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_12; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_12 FOREIGN KEY (fk_conoide_pres_interventi) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_13; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_13 FOREIGN KEY (fk_conoide_pres_opere_negative) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_15; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_15 FOREIGN KEY (fk_valanga_ricorrenza) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_16; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_16 FOREIGN KEY (fk_valanga_volume) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_18; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_18 FOREIGN KEY (fk_valanga_pres_interventi) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_183 sprint_d_ric_183_19; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_d_ric_183_19 FOREIGN KEY (fk_idro_sup_tr) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_51; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_51 FOREIGN KEY (fk_frana_distr_attivita) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_52; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_52 FOREIGN KEY (fk_frana_tipo) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_53; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_53 FOREIGN KEY (fk_frana_velocita) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_54; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_54 FOREIGN KEY (fk_frana_stato_attivita) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_55; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_55 FOREIGN KEY (fk_frana_pres_interventi) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_56; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_56 FOREIGN KEY (fk_frana_pres_opere_negative) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_57; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_57 FOREIGN KEY (fk_idro_sup_tr) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_58; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_58 FOREIGN KEY (fk_conoide_diametro_interno) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_59; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_59 FOREIGN KEY (fk_conoide_ricorrenza) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_60; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_60 FOREIGN KEY (fk_conoide_pendenza) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_62; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_62 FOREIGN KEY (fk_conoide_pres_interventi) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_64; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_64 FOREIGN KEY (fk_valanga_ricorrenza) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_65; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_65 FOREIGN KEY (fk_valanga_volume) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_66; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_66 FOREIGN KEY (fk_valanga_pres_interventi) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_68; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_68 FOREIGN KEY (fk_conoide_i_asprezza_melton) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_s_ric_183 sprint_d_ric_183_99; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_d_ric_183_99 FOREIGN KEY (fk_conoide_pres_opere_negative) REFERENCES sprint.sprint_d_ric_183(id);


--
-- Name: sprint_t_ric_18_54_183 sprint_d_ric_18_54_183_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_01 FOREIGN KEY (fk_prog_triennale_triennio) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_t_ric_18_54_183 sprint_d_ric_18_54_183_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_03 FOREIGN KEY (fk_tipo_programmazione) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_t_ric_18_54_183 sprint_d_ric_18_54_183_07; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_07 FOREIGN KEY (fk_settore_intervento) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_t_ric_18_54_183 sprint_d_ric_18_54_183_08; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_08 FOREIGN KEY (fk_progettazione) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_t_ric_18_54_183 sprint_d_ric_18_54_183_09; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_09 FOREIGN KEY (fk_tipo_progetto) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_s_ric_18_54_183 sprint_d_ric_18_54_183_51; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_51 FOREIGN KEY (fk_settore_intervento) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_s_ric_18_54_183 sprint_d_ric_18_54_183_52; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_52 FOREIGN KEY (fk_prog_triennale_triennio) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_s_ric_18_54_183 sprint_d_ric_18_54_183_53; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_53 FOREIGN KEY (fk_tipo_programmazione) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_s_ric_18_54_183 sprint_d_ric_18_54_183_54; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_54 FOREIGN KEY (fk_progettazione) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_s_ric_18_54_183 sprint_d_ric_18_54_183_59; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_18_54_183
    ADD CONSTRAINT sprint_d_ric_18_54_183_59 FOREIGN KEY (fk_tipo_progetto) REFERENCES sprint.sprint_d_ric_18_54_183(id);


--
-- Name: sprint_d_richiesta_generica sprint_d_richiesta_gen_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_d_richiesta_generica
    ADD CONSTRAINT sprint_d_richiesta_gen_02 FOREIGN KEY (fk_padre) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_d_richiesta_generica sprint_d_richiesta_gen_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_d_richiesta_generica
    ADD CONSTRAINT sprint_d_richiesta_gen_03 FOREIGN KEY (fk_padre_2) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_s_ric_generica sprint_d_richiesta_generica_51; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_d_richiesta_generica_51 FOREIGN KEY (fk_stato) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_s_ric_generica sprint_d_richiesta_generica_52; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_d_richiesta_generica_52 FOREIGN KEY (fk_tipo_intervento) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_s_ric_generica sprint_d_richiesta_generica_53; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_d_richiesta_generica_53 FOREIGN KEY (fk_categoria) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_s_ric_generica sprint_d_richiesta_generica_54; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_d_richiesta_generica_54 FOREIGN KEY (fk_codice) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_s_ric_generica sprint_d_richiesta_generica_55; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_d_richiesta_generica_55 FOREIGN KEY (fk_tasso_iva_lavori) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_s_ric_generica sprint_d_richiesta_generica_56; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_d_richiesta_generica_56 FOREIGN KEY (fk_tasso_iva_somme_disp) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_s_ric_generica sprint_d_richiesta_generica_58; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_d_richiesta_generica_58 FOREIGN KEY (fk_tipo_strada) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_s_ric_generica sprint_d_richiesta_generica_59; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_d_richiesta_generica_59 FOREIGN KEY (fk_tipo_opere) REFERENCES sprint.sprint_d_richiesta_generica(id);


--
-- Name: sprint_mtd_analisi_rischio sprint_mtd_analisi_rischio_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_analisi_rischio
    ADD CONSTRAINT sprint_mtd_analisi_rischio_01 FOREIGN KEY (fk_padre) REFERENCES sprint.sprint_mtd_analisi_rischio(id_mtd);


--
-- Name: sprint_r_analisi_dinamica sprint_mtd_analisi_rischio_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_analisi_dinamica
    ADD CONSTRAINT sprint_mtd_analisi_rischio_02 FOREIGN KEY (id_mtd) REFERENCES sprint.sprint_mtd_analisi_rischio(id_mtd);


--
-- Name: sprint_sr_analisi_dinamica sprint_mtd_analisi_rischio_51; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_analisi_dinamica
    ADD CONSTRAINT sprint_mtd_analisi_rischio_51 FOREIGN KEY (id_mtd) REFERENCES sprint.sprint_mtd_analisi_rischio(id_mtd);


--
-- Name: sprint_mtd_r3_campo_sezlegge sprint_mtd_campo_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r3_campo_sezlegge
    ADD CONSTRAINT sprint_mtd_campo_01 FOREIGN KEY (id_campo) REFERENCES sprint.sprint_mtd_campo(id_campo);


--
-- Name: sprint_mtd_r_campo_oggprof sprint_mtd_campo_ris_ric_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_campo_oggprof
    ADD CONSTRAINT sprint_mtd_campo_ris_ric_01 FOREIGN KEY (id_campo_ris_ricerca) REFERENCES sprint.sprint_mtd_campo_ris_ricerca(id_campo_ris_ricerca);


--
-- Name: sprint_mtd_r_campo_ricercapred sprint_mtd_campo_ris_ric_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_campo_ricercapred
    ADD CONSTRAINT sprint_mtd_campo_ris_ric_02 FOREIGN KEY (id_campo_ris_ricerca) REFERENCES sprint.sprint_mtd_campo_ris_ricerca(id_campo_ris_ricerca);


--
-- Name: sprint_mtd_r_criterio_oggprof sprint_mtd_criterio_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_criterio_oggprof
    ADD CONSTRAINT sprint_mtd_criterio_01 FOREIGN KEY (id_criterio) REFERENCES sprint.sprint_mtd_criterio(id_criterio);


--
-- Name: sprint_mtd_r1_folderlegge sprint_mtd_folder_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r1_folderlegge
    ADD CONSTRAINT sprint_mtd_folder_01 FOREIGN KEY (id_folder) REFERENCES sprint.sprint_mtd_folder(id_folder);


--
-- Name: sprint_mtd_sezione sprint_mtd_folder_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_sezione
    ADD CONSTRAINT sprint_mtd_folder_02 FOREIGN KEY (fk_folder) REFERENCES sprint.sprint_mtd_folder(id_folder);


--
-- Name: sprint_mtd_r1_folderlegge sprint_mtd_legge_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r1_folderlegge
    ADD CONSTRAINT sprint_mtd_legge_01 FOREIGN KEY (id_legge) REFERENCES sprint.sprint_mtd_legge(id_legge);


--
-- Name: geo_pt_intervento sprint_mtd_legge_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pt_intervento
    ADD CONSTRAINT sprint_mtd_legge_02 FOREIGN KEY (fk_legge) REFERENCES sprint.sprint_mtd_legge(id_legge);


--
-- Name: geo_pl_intervento sprint_mtd_legge_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pl_intervento
    ADD CONSTRAINT sprint_mtd_legge_03 FOREIGN KEY (fk_legge) REFERENCES sprint.sprint_mtd_legge(id_legge);


--
-- Name: geo_ln_intervento sprint_mtd_legge_04; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_ln_intervento
    ADD CONSTRAINT sprint_mtd_legge_04 FOREIGN KEY (fk_legge) REFERENCES sprint.sprint_mtd_legge(id_legge);


--
-- Name: sprint_mtd_r2_sezionelegge sprint_mtd_legge_06; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r2_sezionelegge
    ADD CONSTRAINT sprint_mtd_legge_06 FOREIGN KEY (id_legge) REFERENCES sprint.sprint_mtd_legge(id_legge);


--
-- Name: sprint_mtd_r3_campo_sezlegge sprint_mtd_legge_07; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r3_campo_sezlegge
    ADD CONSTRAINT sprint_mtd_legge_07 FOREIGN KEY (id_legge) REFERENCES sprint.sprint_mtd_legge(id_legge);


--
-- Name: sprint_mtd_r_ogg_prof sprint_mtd_oggetto_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_ogg_prof
    ADD CONSTRAINT sprint_mtd_oggetto_01 FOREIGN KEY (id_oggetto) REFERENCES sprint.sprint_mtd_oggetto(id_oggetto);


--
-- Name: sprint_mtd_r_profilo_ricerca sprint_mtd_profilo_ut_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_profilo_ricerca
    ADD CONSTRAINT sprint_mtd_profilo_ut_01 FOREIGN KEY (id_profilo) REFERENCES sprint.sprint_mtd_profilo_utente(id_profilo);


--
-- Name: sprint_mtd_utente sprint_mtd_profilo_ut_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_utente
    ADD CONSTRAINT sprint_mtd_profilo_ut_02 FOREIGN KEY (fk_profilo) REFERENCES sprint.sprint_mtd_profilo_utente(id_profilo);


--
-- Name: sprint_mtd_r_ogg_prof sprint_mtd_profilo_ut_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_ogg_prof
    ADD CONSTRAINT sprint_mtd_profilo_ut_03 FOREIGN KEY (id_profilo) REFERENCES sprint.sprint_mtd_profilo_utente(id_profilo);


--
-- Name: sprint_mtd_ric_18_54_183 sprint_mtd_ric_18_54_183_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_ric_18_54_183
    ADD CONSTRAINT sprint_mtd_ric_18_54_183_01 FOREIGN KEY (fk_padre) REFERENCES sprint.sprint_mtd_ric_18_54_183(id_mtd);


--
-- Name: sprint_r_18_54_183_dinamica sprint_mtd_ric_18_54_183_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_18_54_183_dinamica
    ADD CONSTRAINT sprint_mtd_ric_18_54_183_02 FOREIGN KEY (id_mtd) REFERENCES sprint.sprint_mtd_ric_18_54_183(id_mtd);


--
-- Name: sprint_sr_18_54_183_dinamica sprint_mtd_ric_18_54_183_51; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_18_54_183_dinamica
    ADD CONSTRAINT sprint_mtd_ric_18_54_183_51 FOREIGN KEY (id_mtd) REFERENCES sprint.sprint_mtd_ric_18_54_183(id_mtd);


--
-- Name: sprint_mtd_ric_generica sprint_mtd_ric_generica_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_ric_generica
    ADD CONSTRAINT sprint_mtd_ric_generica_01 FOREIGN KEY (fk_padre) REFERENCES sprint.sprint_mtd_ric_generica(id_mtd);


--
-- Name: sprint_r_ric_generica_dinamica sprint_mtd_ric_generica_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_ric_generica_dinamica
    ADD CONSTRAINT sprint_mtd_ric_generica_02 FOREIGN KEY (id_mtd) REFERENCES sprint.sprint_mtd_ric_generica(id_mtd) ON DELETE CASCADE;


--
-- Name: sprint_sr_ric_generica_dinamic sprint_mtd_ric_generica_51; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_ric_generica_dinamic
    ADD CONSTRAINT sprint_mtd_ric_generica_51 FOREIGN KEY (id_mtd) REFERENCES sprint.sprint_mtd_ric_generica(id_mtd);


--
-- Name: sprint_mtd_r_profilo_ricerca sprint_mtd_ric_pred_clob_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_profilo_ricerca
    ADD CONSTRAINT sprint_mtd_ric_pred_clob_01 FOREIGN KEY (id_ricerca_pred) REFERENCES sprint.sprint_mtd_ricerca_pred_clob(id_ricerca_pred);


--
-- Name: sprint_mtd_r_campo_ricercapred sprint_mtd_ric_pred_clob_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_campo_ricercapred
    ADD CONSTRAINT sprint_mtd_ric_pred_clob_02 FOREIGN KEY (id_ricerca_pred) REFERENCES sprint.sprint_mtd_ricerca_pred_clob(id_ricerca_pred);


--
-- Name: sprint_mtd_r3_campo_sezlegge sprint_mtd_sezione_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r3_campo_sezlegge
    ADD CONSTRAINT sprint_mtd_sezione_01 FOREIGN KEY (id_sezione) REFERENCES sprint.sprint_mtd_sezione(id_sezione);


--
-- Name: sprint_mtd_r2_sezionelegge sprint_mtd_sezione_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r2_sezionelegge
    ADD CONSTRAINT sprint_mtd_sezione_02 FOREIGN KEY (id_sezione) REFERENCES sprint.sprint_mtd_sezione(id_sezione);


--
-- Name: sprint_mtd_r_criterio_oggprof sprint_mtd_t_ogg_prof_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_criterio_oggprof
    ADD CONSTRAINT sprint_mtd_t_ogg_prof_01 FOREIGN KEY (id_profilo, id_oggetto) REFERENCES sprint.sprint_mtd_r_ogg_prof(id_profilo, id_oggetto);


--
-- Name: sprint_mtd_r_campo_oggprof sprint_mtd_t_ogg_prof_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_r_campo_oggprof
    ADD CONSTRAINT sprint_mtd_t_ogg_prof_02 FOREIGN KEY (id_profilo, id_oggetto) REFERENCES sprint.sprint_mtd_r_ogg_prof(id_profilo, id_oggetto);


--
-- Name: sprint_mtd_campo sprint_mtd_tavola_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_mtd_campo
    ADD CONSTRAINT sprint_mtd_tavola_01 FOREIGN KEY (fk_tavola) REFERENCES sprint.sprint_mtd_tavola(id_tavola);


--
-- Name: geo_ln_intervento sprint_r_geometria_rich_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_ln_intervento
    ADD CONSTRAINT sprint_r_geometria_rich_01 FOREIGN KEY (id_ln_intervento) REFERENCES sprint.sprint_r_geometria_richiesta(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: geo_pl_intervento sprint_r_geometria_rich_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pl_intervento
    ADD CONSTRAINT sprint_r_geometria_rich_02 FOREIGN KEY (id_pl_intervento) REFERENCES sprint.sprint_r_geometria_richiesta(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: geo_pt_intervento sprint_r_geometria_rich_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pt_intervento
    ADD CONSTRAINT sprint_r_geometria_rich_03 FOREIGN KEY (id_pt_intervento) REFERENCES sprint.sprint_r_geometria_richiesta(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_sr_analisi_dinamica sprint_s_analisi_rischio_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_analisi_dinamica
    ADD CONSTRAINT sprint_s_analisi_rischio_01 FOREIGN KEY (id_analisi_rischio) REFERENCES sprint.sprint_s_analisi_rischio(id_analisi_rischio);


--
-- Name: sprint_sr_evento_comune sprint_s_evento_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_evento_comune
    ADD CONSTRAINT sprint_s_evento_02 FOREIGN KEY (fk_storico_evento) REFERENCES sprint.sprint_s_evento(id_storico_evento);


--
-- Name: sprint_sr_area_idro_evento sprint_s_evento_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_area_idro_evento
    ADD CONSTRAINT sprint_s_evento_03 FOREIGN KEY (fk_storico_evento) REFERENCES sprint.sprint_s_evento(id_storico_evento);


--
-- Name: sprint_sr_evento_ricgen sprint_s_evento_04; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_evento_ricgen
    ADD CONSTRAINT sprint_s_evento_04 FOREIGN KEY (id_storico_evento) REFERENCES sprint.sprint_s_evento(id_storico_evento);


--
-- Name: sprint_s_ric_183 sprint_s_ric_18_54_183_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_183
    ADD CONSTRAINT sprint_s_ric_18_54_183_02 FOREIGN KEY (id_storico_richiesta) REFERENCES sprint.sprint_s_ric_18_54_183(id_storico_richiesta);


--
-- Name: sprint_s_stralcio sprint_s_ric_18_54_183_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_stralcio
    ADD CONSTRAINT sprint_s_ric_18_54_183_03 FOREIGN KEY (fk_storico_richiesta) REFERENCES sprint.sprint_s_ric_18_54_183(id_storico_richiesta);


--
-- Name: sprint_s_analisi_rischio sprint_s_ric_18_54_183_05; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_analisi_rischio
    ADD CONSTRAINT sprint_s_ric_18_54_183_05 FOREIGN KEY (fk_storico_richiesta_1854) REFERENCES sprint.sprint_s_ric_18_54_183(id_storico_richiesta);


--
-- Name: sprint_s_lotto sprint_s_ric_18_54_183_06; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_lotto
    ADD CONSTRAINT sprint_s_ric_18_54_183_06 FOREIGN KEY (fk_storico_richiesta) REFERENCES sprint.sprint_s_ric_18_54_183(id_storico_richiesta);


--
-- Name: sprint_sr_18_54_183_dinamica sprint_s_ric_18_54_183_07; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_18_54_183_dinamica
    ADD CONSTRAINT sprint_s_ric_18_54_183_07 FOREIGN KEY (id_storico_richiesta) REFERENCES sprint.sprint_s_ric_18_54_183(id_storico_richiesta);


--
-- Name: sprint_s_analisi_rischio sprint_s_ric_38_calamita_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_analisi_rischio
    ADD CONSTRAINT sprint_s_ric_38_calamita_02 FOREIGN KEY (fk_storico_richiesta_38cal) REFERENCES sprint.sprint_s_ric_38_calamita(id_storico_richiesta);


--
-- Name: sprint_sr_38_calamita sprint_s_ric_38_calamita_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_38_calamita
    ADD CONSTRAINT sprint_s_ric_38_calamita_03 FOREIGN KEY (id_storico_richiesta_padre) REFERENCES sprint.sprint_s_ric_38_calamita(id_storico_richiesta);


--
-- Name: sprint_sr_38_calamita sprint_s_ric_38_calamita_04; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_38_calamita
    ADD CONSTRAINT sprint_s_ric_38_calamita_04 FOREIGN KEY (id_storico_richiesta_figlio) REFERENCES sprint.sprint_s_ric_38_calamita(id_storico_richiesta);


--
-- Name: sprint_s_ric_18_54_183 sprint_s_ric_generica_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_18_54_183
    ADD CONSTRAINT sprint_s_ric_generica_01 FOREIGN KEY (id_storico_richiesta) REFERENCES sprint.sprint_s_ric_generica(id_storico_richiesta);


--
-- Name: sprint_s_ric_38_calamita sprint_s_ric_generica_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_38_calamita
    ADD CONSTRAINT sprint_s_ric_generica_03 FOREIGN KEY (id_storico_richiesta) REFERENCES sprint.sprint_s_ric_generica(id_storico_richiesta);


--
-- Name: sprint_sr_ric_generica_comune sprint_s_ric_generica_04; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_ric_generica_comune
    ADD CONSTRAINT sprint_s_ric_generica_04 FOREIGN KEY (id_storico_richiesta) REFERENCES sprint.sprint_s_ric_generica(id_storico_richiesta);


--
-- Name: sprint_sr_area_idro_ric_generi sprint_s_ric_generica_05; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_area_idro_ric_generi
    ADD CONSTRAINT sprint_s_ric_generica_05 FOREIGN KEY (id_storico_richiesta) REFERENCES sprint.sprint_s_ric_generica(id_storico_richiesta);


--
-- Name: sprint_sr_ric_generica_dinamic sprint_s_ric_generica_06; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_ric_generica_dinamic
    ADD CONSTRAINT sprint_s_ric_generica_06 FOREIGN KEY (id_storico_richiesta) REFERENCES sprint.sprint_s_ric_generica(id_storico_richiesta);


--
-- Name: sprint_s_ric_generica sprint_s_ric_generica_07; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_generica
    ADD CONSTRAINT sprint_s_ric_generica_07 FOREIGN KEY (fk_cambio_legge) REFERENCES sprint.sprint_s_ric_generica(id_storico_richiesta);


--
-- Name: sprint_r_ricgen_allegato sprint_t_allegato_ric_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_ricgen_allegato
    ADD CONSTRAINT sprint_t_allegato_ric_01 FOREIGN KEY (id_allegato_ric) REFERENCES sprint.sprint_t_allegato_ric(id_allegato_ric);


--
-- Name: sprint_r_analisi_dinamica sprint_t_analisi_rischio_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_analisi_dinamica
    ADD CONSTRAINT sprint_t_analisi_rischio_01 FOREIGN KEY (id_analisi_rischio) REFERENCES sprint.sprint_t_analisi_rischio(id_analisi_rischio) ON DELETE CASCADE;


--
-- Name: sprint_r_area_idro_evento sprint_t_area_idro_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_area_idro_evento
    ADD CONSTRAINT sprint_t_area_idro_01 FOREIGN KEY (id_area_idro) REFERENCES sprint.sprint_t_area_idro(id_area_idro);


--
-- Name: sprint_r_area_idro_ric_generic sprint_t_area_idro_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_area_idro_ric_generic
    ADD CONSTRAINT sprint_t_area_idro_02 FOREIGN KEY (id_area_idro) REFERENCES sprint.sprint_t_area_idro(id_area_idro);


--
-- Name: sprint_sr_area_idro_ric_generi sprint_t_area_idro_81; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_area_idro_ric_generi
    ADD CONSTRAINT sprint_t_area_idro_81 FOREIGN KEY (id_area_idro) REFERENCES sprint.sprint_t_area_idro(id_area_idro);


--
-- Name: sprint_sr_area_idro_evento sprint_t_area_idro_82; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_sr_area_idro_evento
    ADD CONSTRAINT sprint_t_area_idro_82 FOREIGN KEY (id_area_idro) REFERENCES sprint.sprint_t_area_idro(id_area_idro);


--
-- Name: sprint_t_ric_38_calamita sprint_t_evento_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_38_calamita
    ADD CONSTRAINT sprint_t_evento_01 FOREIGN KEY (fk_evento) REFERENCES sprint.sprint_t_evento(id_evento) ON DELETE CASCADE;


--
-- Name: sprint_r_evento_comune sprint_t_evento_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_evento_comune
    ADD CONSTRAINT sprint_t_evento_02 FOREIGN KEY (fk_evento) REFERENCES sprint.sprint_t_evento(id_evento) ON DELETE CASCADE;


--
-- Name: sprint_r_area_idro_evento sprint_t_evento_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_area_idro_evento
    ADD CONSTRAINT sprint_t_evento_03 FOREIGN KEY (id_evento) REFERENCES sprint.sprint_t_evento(id_evento) ON DELETE CASCADE;


--
-- Name: geo_pl_evento sprint_t_evento_04; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pl_evento
    ADD CONSTRAINT sprint_t_evento_04 FOREIGN KEY (id_pl_evento) REFERENCES sprint.sprint_t_evento(id_evento) ON DELETE CASCADE;


--
-- Name: geo_ln_evento sprint_t_evento_05; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_ln_evento
    ADD CONSTRAINT sprint_t_evento_05 FOREIGN KEY (id_ln_evento) REFERENCES sprint.sprint_t_evento(id_evento) ON DELETE CASCADE;


--
-- Name: geo_pt_evento sprint_t_evento_06; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.geo_pt_evento
    ADD CONSTRAINT sprint_t_evento_06 FOREIGN KEY (id_pt_evento) REFERENCES sprint.sprint_t_evento(id_evento) ON DELETE CASCADE;


--
-- Name: sprint_t_allegato_evento sprint_t_evento_07; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_allegato_evento
    ADD CONSTRAINT sprint_t_evento_07 FOREIGN KEY (fk_evento) REFERENCES sprint.sprint_t_evento(id_evento) ON DELETE CASCADE;


--
-- Name: sprint_s_evento sprint_t_evento_82; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_evento
    ADD CONSTRAINT sprint_t_evento_82 FOREIGN KEY (fk_evento) REFERENCES sprint.sprint_t_evento(id_evento);


--
-- Name: sprint_s_ric_38_calamita sprint_t_evento_83; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_s_ric_38_calamita
    ADD CONSTRAINT sprint_t_evento_83 FOREIGN KEY (fk_evento) REFERENCES sprint.sprint_t_evento(id_evento);


--
-- Name: sprint_t_analisi_rischio sprint_t_ric_18_54_183_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_analisi_rischio
    ADD CONSTRAINT sprint_t_ric_18_54_183_01 FOREIGN KEY (fk_richiesta_generica_1854) REFERENCES sprint.sprint_t_ric_18_54_183(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_t_ric_183 sprint_t_ric_18_54_183_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_183
    ADD CONSTRAINT sprint_t_ric_18_54_183_02 FOREIGN KEY (id_richiesta_generica) REFERENCES sprint.sprint_t_ric_18_54_183(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_t_stralcio sprint_t_ric_18_54_183_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_stralcio
    ADD CONSTRAINT sprint_t_ric_18_54_183_03 FOREIGN KEY (fk_richiesta_generica) REFERENCES sprint.sprint_t_ric_18_54_183(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_t_lotto sprint_t_ric_18_54_183_05; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_lotto
    ADD CONSTRAINT sprint_t_ric_18_54_183_05 FOREIGN KEY (fk_richiesta_generica) REFERENCES sprint.sprint_t_ric_18_54_183(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_r_18_54_183_dinamica sprint_t_ric_18_54_183_06; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_18_54_183_dinamica
    ADD CONSTRAINT sprint_t_ric_18_54_183_06 FOREIGN KEY (id_richiesta_generica) REFERENCES sprint.sprint_t_ric_18_54_183(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_t_analisi_rischio sprint_t_ric_38_calamita_01; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_analisi_rischio
    ADD CONSTRAINT sprint_t_ric_38_calamita_01 FOREIGN KEY (fk_richiesta_generica_38cal) REFERENCES sprint.sprint_t_ric_38_calamita(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_r_38_calamita sprint_t_ric_38_calamita_02; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_38_calamita
    ADD CONSTRAINT sprint_t_ric_38_calamita_02 FOREIGN KEY (id_richiesta_generica_padre) REFERENCES sprint.sprint_t_ric_38_calamita(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_r_38_calamita sprint_t_ric_38_calamita_03; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_r_38_calamita
    ADD CONSTRAINT sprint_t_ric_38_calamita_03 FOREIGN KEY (id_richiesta_generica_figlio) REFERENCES sprint.sprint_t_ric_38_calamita(id_richiesta_generica) ON DELETE CASCADE;


--
-- Name: sprint_t_ric_generica sprint_t_ric_generica_07; Type: FK CONSTRAINT; Schema: sprint; Owner: -
--

ALTER TABLE ONLY sprint.sprint_t_ric_generica
    ADD CONSTRAINT sprint_t_ric_generica_07 FOREIGN KEY (fk_cambio_legge) REFERENCES sprint.sprint_t_ric_generica(id_richiesta_generica);


-- fine baseline

