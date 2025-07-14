-- Exercice 1 - Étape 2: Mettre à jour le schéma RAW pour inclure region_id
SET search_path = raw;

-- Ajouter la colonne region_id à la table sales_raw
ALTER TABLE sales_raw ADD COLUMN region_id TEXT;

-- Note: Les données seront mises à jour lors du prochain ETL depuis MySQL