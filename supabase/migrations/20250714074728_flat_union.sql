-- Exercice 2 - Étape 1: Créer la table des régions dans MySQL
USE ecommerce_ops_db;

-- Créer la table des régions
CREATE TABLE regions (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Insérer les données des régions selon l'image
INSERT INTO regions (region_id, name) VALUES 
(1, 'Analamanga'),
(2, 'alaotra mangoro'),
(3, 'boeny');

-- Vérifier les données
SELECT * FROM regions ORDER BY region_id;