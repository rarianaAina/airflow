-- Exercice 2 - Étape 5: Mettre à jour fact_sales pour utiliser region_key
SET search_path = ecommerce_dwh;

-- Ajouter la colonne region_key à fact_sales
ALTER TABLE fact_sales ADD COLUMN region_key INT;

-- Ajouter la contrainte de clé étrangère
ALTER TABLE fact_sales 
ADD CONSTRAINT fk_fact_sales_region 
FOREIGN KEY (region_key) REFERENCES dim_region(region_key);

-- Créer un index sur region_key
CREATE INDEX IF NOT EXISTS idx_fact_sales_region_key ON fact_sales(region_key);