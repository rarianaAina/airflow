-- Exercice 1 - Étape 6: Requête pour obtenir le montant des ventes par région
SET search_path = ecommerce_dwh;

-- Requête pour calculer le montant des ventes par région
SELECT 
    region_id,
    SUM(total_amount) as total_sales,
    COUNT(*) as number_of_sales,
    AVG(total_amount) as average_sale
FROM fact_sales
WHERE region_id IS NOT NULL
GROUP BY region_id
ORDER BY region_id;

-- Requête détaillée avec informations supplémentaires
SELECT 
    fs.region_id,
    SUM(fs.total_amount) as total_sales,
    COUNT(*) as number_of_sales,
    AVG(fs.total_amount) as average_sale,
    MIN(dd.date_key) as first_sale_date,
    MAX(dd.date_key) as last_sale_date
FROM fact_sales fs
JOIN dim_date dd ON fs.date_key = dd.date_key
WHERE fs.region_id IS NOT NULL
GROUP BY fs.region_id
ORDER BY fs.region_id;