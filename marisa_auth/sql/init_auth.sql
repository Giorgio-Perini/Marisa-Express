USE marisa_express_db;

-- Dettagli extra per i rider
CREATE TABLE IF NOT EXISTS rider_dettagli (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    id_utente       INT          NOT NULL UNIQUE,
    cognome         VARCHAR(100) NOT NULL,
    codice_fiscale  VARCHAR(16)  NOT NULL UNIQUE,
    zona            VARCHAR(100),
    CONSTRAINT fk_rider_dettagli_utente
        FOREIGN KEY (id_utente) REFERENCES utenti(id)
        ON DELETE CASCADE
);

-- Blacklist token JWT (logout)
CREATE TABLE IF NOT EXISTS token_blacklist (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    token      TEXT         NOT NULL,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indice per velocizzare la ricerca del token
CREATE INDEX idx_token_blacklist_created
    ON token_blacklist(created_at);