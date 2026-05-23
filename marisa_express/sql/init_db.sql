-- ============================================
-- MARISA EXPRESS DB — Schema iniziale
-- ============================================

CREATE DATABASE IF NOT EXISTS marisa_express_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE marisa_express_db;

-- --------------------------------------------
-- UTENTI
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS utenti (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    password_hash   VARCHAR(255)    NOT NULL,
    telefono        VARCHAR(20),
    tipo            ENUM('utente','rider','ristoratore') NOT NULL DEFAULT 'utente',
    crediti         DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    foto_profilo    VARCHAR(255),
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------
-- RISTORANTI
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS ristoranti (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    id_utente       INT             NOT NULL,
    nome            VARCHAR(150)    NOT NULL,
    descrizione     TEXT,
    via             VARCHAR(255),
    lat             DECIMAL(10,7),
    lng             DECIMAL(10,7),
    telefono        VARCHAR(20),
    partita_iva     VARCHAR(20),
    foto_profilo    VARCHAR(255),
    categoria       VARCHAR(100),
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ristoranti_utente
        FOREIGN KEY (id_utente) REFERENCES utenti(id)
        ON DELETE CASCADE
);

-- --------------------------------------------
-- MENU ITEMS
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS menu_items (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    id_ristorante   INT             NOT NULL,
    nome            VARCHAR(150)    NOT NULL,
    descrizione     TEXT,
    prezzo          DECIMAL(8,2)    NOT NULL,
    foto            VARCHAR(255),
    disponibile     TINYINT(1)      NOT NULL DEFAULT 1,
    CONSTRAINT fk_menu_ristorante
        FOREIGN KEY (id_ristorante) REFERENCES ristoranti(id)
        ON DELETE CASCADE
);

-- --------------------------------------------
-- ORDINI
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS ordini (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    id_utente           INT             NOT NULL,
    id_ristorante       INT             NOT NULL,
    id_rider            INT,
    stato               ENUM('in_attesa','accettato','in_consegna','consegnato','rifiutato')
                                        NOT NULL DEFAULT 'in_attesa',
    totale              DECIMAL(10,2)   NOT NULL,
    indirizzo_consegna  VARCHAR(255),
    lat_consegna        DECIMAL(10,7),
    lng_consegna        DECIMAL(10,7),
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ordini_utente
        FOREIGN KEY (id_utente) REFERENCES utenti(id),
    CONSTRAINT fk_ordini_ristorante
        FOREIGN KEY (id_ristorante) REFERENCES ristoranti(id),
    CONSTRAINT fk_ordini_rider
        FOREIGN KEY (id_rider) REFERENCES utenti(id)
        ON DELETE SET NULL
);

-- --------------------------------------------
-- ORDINI ITEMS
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS ordini_items (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    id_ordine       INT             NOT NULL,
    id_menu_item    INT             NOT NULL,
    quantita        INT             NOT NULL DEFAULT 1,
    prezzo_unitario DECIMAL(8,2)    NOT NULL,
    CONSTRAINT fk_ordini_items_ordine
        FOREIGN KEY (id_ordine) REFERENCES ordini(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_ordini_items_menu
        FOREIGN KEY (id_menu_item) REFERENCES menu_items(id)
);

-- --------------------------------------------
-- WALLET TRANSAZIONI
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS wallet_transazioni (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    id_utente   INT             NOT NULL,
    importo     DECIMAL(10,2)   NOT NULL,
    tipo        ENUM('ricarica','pagamento','rimborso') NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_wallet_utente
        FOREIGN KEY (id_utente) REFERENCES utenti(id)
        ON DELETE CASCADE
);

-- --------------------------------------------
-- RIDER POSIZIONI
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS rider_posizioni (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    id_rider    INT             NOT NULL UNIQUE,
    lat         DECIMAL(10,7)   NOT NULL,
    lng         DECIMAL(10,7)   NOT NULL,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_rider_posizioni_utente
        FOREIGN KEY (id_rider) REFERENCES utenti(id)
        ON DELETE CASCADE
);

-- --------------------------------------------
-- RIDERS (profilo rider)
-- Usata dal servizio marisa-rider per informazioni profilo
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS riders (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    id_utente       INT             NOT NULL UNIQUE,
    veicolo         VARCHAR(100),
    targa           VARCHAR(20),
    foto_profilo    VARCHAR(255),
    telefono        VARCHAR(20),
    zona            VARCHAR(100),
    lat             DECIMAL(10,7),
    lng             DECIMAL(10,7),
    disponibile     TINYINT(1)      NOT NULL DEFAULT 1,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_riders_utente
        FOREIGN KEY (id_utente) REFERENCES utenti(id)
        ON DELETE CASCADE
);
