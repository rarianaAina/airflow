-- Exercice 2 - Étape 2: Créer la table regions_raw dans le schéma RAW
SET search_path = raw;

-- Créer la table regions_raw (tous les champs en TEXT)
CREATE TABLE regions_raw (
    region_id TEXT,
    name TEXT
);

-- Note: Les données seront chargées depuis MySQL lors du prochain ETL