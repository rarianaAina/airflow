# Exercices ETL - Session Juillet 2025

Ce projet contient les solutions pour les deux exercices ETL demandés.

## Structure du projet

```
├── exercice1/                 # Exercice 1 - Ajout colonne region_id
│   ├── 01_add_region_column_mysql.sql
│   ├── 02_update_raw_schema.sql
│   ├── 03_update_dwh_star_schema.sql
│   ├── 04_update_dwh_olap_schema.sql
│   ├── 05_update_etl_procedures.sql
│   └── 06_sales_by_region_query.sql
├── exercice2/                 # Exercice 2 - Table des régions
│   ├── 01_create_regions_table_mysql.sql
│   ├── 02_create_regions_raw_table.sql
│   ├── 03_create_dim_region_dwh.sql
│   ├── 04_load_dim_region_procedure.sql
│   ├── 05_update_fact_sales_with_region_key.sql
│   └── 06_sales_by_region_name_query.sql
└── airflow_dags/
    └── exercice_etl_dag.py    # DAG Airflow pour orchestrer les exercices
```

## Exercice 1 : Ajout de la colonne region_id

### Objectifs
1. Ajouter une colonne `region_id` dans la table source "sales" dans MySQL
2. Ramener cette nouvelle colonne dans la table "fact_sales" sur le DWH
3. Créer un graphique montrant le montant des ventes par région

### Étapes réalisées
1. **Modification MySQL** : Ajout de la colonne `region_id` avec les valeurs selon le tableau fourni
2. **Mise à jour RAW** : Ajout de la colonne dans `sales_raw`
3. **Mise à jour DWH** : Ajout de la colonne dans `fact_sales`
4. **Procédures ETL** : Modification des procédures pour inclure `region_id`
5. **Requêtes analytiques** : Création des requêtes pour analyser les ventes par région

## Exercice 2 : Table des régions

### Objectifs
1. Créer une nouvelle source de données : table des régions
2. Intégrer cette table dans une table dimension du DWH (noms en majuscules)
3. Recréer le graphique en affichant les noms des régions

### Étapes réalisées
1. **Table source** : Création de la table `regions` dans MySQL
2. **Table RAW** : Création de `regions_raw` dans PostgreSQL
3. **Dimension** : Création de `dim_region` avec noms en majuscules
4. **Procédures** : Création de `load_dim_region()`
5. **Mise à jour fact** : Ajout de `region_key` dans `fact_sales`
6. **Requêtes finales** : Requêtes avec noms de régions

## Utilisation avec Airflow

Le DAG `exercice_etl_dag.py` orchestre toutes les étapes :

1. **Connexions requises** :
   - `mysql_ops` : Connexion vers MySQL (base OLTP)
   - `postgres_dwh` : Connexion vers PostgreSQL (DWH)

2. **Exécution** :
   ```bash
   # Activer le DAG dans Airflow
   airflow dags unpause exercice_etl_regions
   
   # Déclencher manuellement
   airflow dags trigger exercice_etl_regions
   ```

3. **Résultats** :
   - Graphique généré : `/tmp/sales_by_region.png`
   - Données disponibles pour analyse dans le DWH

## Requêtes d'analyse

### Ventes par région (ID)
```sql
SELECT 
    region_id,
    SUM(total_amount) as total_sales,
    COUNT(*) as number_of_sales
FROM ecommerce_dwh.fact_sales
WHERE region_id IS NOT NULL
GROUP BY region_id
ORDER BY region_id;
```

### Ventes par région (Nom)
```sql
SELECT 
    dr.region_name,
    SUM(fs.total_amount) as total_sales,
    COUNT(*) as number_of_sales
FROM ecommerce_dwh.fact_sales fs
JOIN ecommerce_dwh.dim_region dr ON fs.region_key = dr.region_key
GROUP BY dr.region_name
ORDER BY total_sales DESC;
```

## Notes techniques

- Les noms de régions sont automatiquement convertis en majuscules lors du chargement
- Les procédures ETL gèrent les doublons avec des clauses `NOT EXISTS`
- Les index sont créés pour optimiser les performances des jointures
- Le graphique utilise matplotlib et seaborn pour la visualisation