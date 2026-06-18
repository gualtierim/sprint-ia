-- V001__lookup_minimal.sql
-- Tabelle lookup minime per sviluppo BFF (subset dello schema Oracle Sprint).

CREATE TABLE IF NOT EXISTS sprint_mtd_legge (
    id_legge    INTEGER PRIMARY KEY,
    nome_legge  VARCHAR(255) NOT NULL,
    codice      VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS sprint_d_richiesta_generica (
    id          BIGSERIAL PRIMARY KEY,
    nome_colonna VARCHAR(100) NOT NULL,
    valore      VARCHAR(50) NOT NULL,
    descrizione VARCHAR(255) NOT NULL
);

INSERT INTO sprint_mtd_legge (id_legge, nome_legge, codice) VALUES
    (1, 'Legge 38/2009', '38'),
    (2, 'Legge 183/1989', '183'),
    (3, 'Legge 18/54/183', '18'),
    (4, 'Legge 54', '54'),
    (5, 'Legge straordinaria', 'STR'),
    (6, 'Sopralluogo', 'SOP')
ON CONFLICT (id_legge) DO NOTHING;

INSERT INTO sprint_d_richiesta_generica (nome_colonna, valore, descrizione) VALUES
    ('FK_STATO', '1', 'In lavorazione'),
    ('FK_STATO', '2', 'Inviata'),
    ('FK_STATO', '3', 'Chiusa'),
    ('FK_STATO', '4', 'Bozza'),
    ('FK_STATO', '5', 'In verifica centrale');
