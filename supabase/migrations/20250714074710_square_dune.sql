-- Exercice 1 - Étape 3: Mettre à jour le schéma DWH étoile pour inclure region_id
SET search_path = ecommerce_dwh_star;

-- Ajouter la colonne region_id à la table fact_sales
ALTER TABLE fact_sales ADD COLUMN region_id INT;

-- Note: Les données seront mises à jour lors du prochain ETL