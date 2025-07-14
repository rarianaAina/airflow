-- Exercice 2 - Étape 3: Créer la dimension région dans le DWH
SET search_path = ecommerce_dwh;

-- Créer la table de dimension des régions
CREATE TABLE IF NOT EXISTS dim_region (
    region_key SERIAL PRIMARY KEY,
    region_id INT NOT NULL UNIQUE,
    region_name TEXT NOT NULL
);

-- Créer un index sur region_id pour les jointures
CREATE INDEX IF NOT EXISTS idx_dim_region_id ON dim_region(region_id);