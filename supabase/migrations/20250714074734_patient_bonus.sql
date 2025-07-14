-- Exercice 2 - Étape 4: Procédure pour charger la dimension région
SET search_path = ecommerce_dwh;

-- Procédure pour charger la dimension région
CREATE OR REPLACE PROCEDURE ecommerce_dwh.load_dim_region()
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO ecommerce_dwh.dim_region (region_id, region_name)
  SELECT 
    (trim(r.region_id))::INT,
    UPPER(trim(r.name))  -- Convertir en majuscules comme demandé
  FROM raw.regions_raw r
  WHERE NOT EXISTS (
    SELECT 1
      FROM ecommerce_dwh.dim_region tgt
     WHERE tgt.region_id = (trim(r.region_id))::INT
  );
END;
$$;