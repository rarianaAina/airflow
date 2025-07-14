-- Exercice 1 - Étape 1: Ajouter la colonne region_id dans la table sales MySQL
USE ecommerce_ops_db;

-- Ajouter la colonne region_id à la table sales
ALTER TABLE sales ADD COLUMN region_id INT;

-- Mettre à jour les données avec les valeurs de région selon l'image
UPDATE sales SET region_id = 2 WHERE sale_id = 1;
UPDATE sales SET region_id = 1 WHERE sale_id = 2;
UPDATE sales SET region_id = 1 WHERE sale_id = 3;
UPDATE sales SET region_id = 2 WHERE sale_id = 4;
UPDATE sales SET region_id = 2 WHERE sale_id = 5;
UPDATE sales SET region_id = 2 WHERE sale_id = 6;
UPDATE sales SET region_id = 1 WHERE sale_id = 7;
UPDATE sales SET region_id = 3 WHERE sale_id = 8;
UPDATE sales SET region_id = 3 WHERE sale_id = 9;
UPDATE sales SET region_id = 1 WHERE sale_id = 10;

-- Vérifier les données
SELECT sale_id, region_id FROM sales ORDER BY sale_id;