-- Exercice 2 - Étape 6: Requête pour obtenir les ventes par nom de région
SET search_path = ecommerce_dwh;

-- Requête pour calculer le montant des ventes par nom de région
SELECT 
    dr.region_name,
    SUM(fs.total_amount) as total_sales,
    COUNT(*) as number_of_sales,
    AVG(fs.total_amount) as average_sale
FROM fact_sales fs
JOIN dim_region dr ON fs.region_key = dr.region_key
GROUP BY dr.region_name
ORDER BY total_sales DESC;

-- Requête détaillée avec informations temporelles
SELECT 
    dr.region_name,
    SUM(fs.total_amount) as total_sales,
    COUNT(*) as number_of_sales,
    AVG(fs.total_amount) as average_sale,
    MIN(fs.date_key) as first_sale_date,
    MAX(fs.date_key) as last_sale_date
FROM fact_sales fs
JOIN dim_region dr ON fs.region_key = dr.region_key
JOIN dim_date dd ON fs.date_key = dd.date_key
GROUP BY dr.region_name
ORDER BY total_sales DESC;