from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.mysql.operators.mysql import MySqlOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python import PythonOperator
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from airflow.providers.postgres.hooks.postgres import PostgresHook

default_args = {
    'owner': 'etl_team',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 21),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

def create_sales_by_region_chart():
    """Fonction pour créer le graphique des ventes par région"""
    # Connexion à PostgreSQL
    pg_hook = PostgresHook(postgres_conn_id='postgres_dwh')
    
    # Requête pour obtenir les données
    query = """
    SELECT 
        dr.region_name,
        SUM(fs.total_amount) as total_sales
    FROM ecommerce_dwh.fact_sales fs
    JOIN ecommerce_dwh.dim_region dr ON fs.region_key = dr.region_key
    GROUP BY dr.region_name
    ORDER BY total_sales DESC;
    """
    
    # Exécuter la requête et obtenir les données
    df = pg_hook.get_pandas_df(query)
    
    # Créer le graphique
    plt.figure(figsize=(10, 6))
    sns.barplot(data=df, x='region_name', y='total_sales', palette='viridis')
    plt.title('Montant des Ventes par Région', fontsize=16, fontweight='bold')
    plt.xlabel('Région', fontsize=12)
    plt.ylabel('Montant Total des Ventes (€)', fontsize=12)
    plt.xticks(rotation=45)
    plt.tight_layout()
    
    # Sauvegarder le graphique
    plt.savefig('/tmp/sales_by_region.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    print("Graphique créé avec succès : /tmp/sales_by_region.png")

with DAG(
    dag_id='exercice_etl_regions',
    default_args=default_args,
    description='DAG pour les exercices ETL avec gestion des régions',
    schedule_interval=None,
    catchup=False,
    tags=['etl', 'exercice', 'regions']
) as dag:

    # EXERCICE 1 - Tâches
    
    # 1. Ajouter la colonne region_id dans MySQL
    add_region_column_mysql = MySqlOperator(
        task_id='add_region_column_mysql',
        mysql_conn_id='mysql_ops',
        sql='exercice1/01_add_region_column_mysql.sql',
    )
    
    # 2. Mettre à jour le schéma RAW
    update_raw_schema = PostgresOperator(
        task_id='update_raw_schema',
        postgres_conn_id='postgres_dwh',
        sql='exercice1/02_update_raw_schema.sql',
    )
    
    # 3. Mettre à jour le schéma DWH
    update_dwh_schema = PostgresOperator(
        task_id='update_dwh_schema',
        postgres_conn_id='postgres_dwh',
        sql='exercice1/04_update_dwh_olap_schema.sql',
    )
    
    # 4. Mettre à jour les procédures ETL
    update_etl_procedures = PostgresOperator(
        task_id='update_etl_procedures',
        postgres_conn_id='postgres_dwh',
        sql='exercice1/05_update_etl_procedures.sql',
    )
    
    # EXERCICE 2 - Tâches
    
    # 1. Créer la table des régions dans MySQL
    create_regions_mysql = MySqlOperator(
        task_id='create_regions_mysql',
        mysql_conn_id='mysql_ops',
        sql='exercice2/01_create_regions_table_mysql.sql',
    )
    
    # 2. Créer la table regions_raw
    create_regions_raw = PostgresOperator(
        task_id='create_regions_raw',
        postgres_conn_id='postgres_dwh',
        sql='exercice2/02_create_regions_raw_table.sql',
    )
    
    # 3. Créer la dimension région dans le DWH
    create_dim_region = PostgresOperator(
        task_id='create_dim_region',
        postgres_conn_id='postgres_dwh',
        sql='exercice2/03_create_dim_region_dwh.sql',
    )
    
    # 4. Créer la procédure de chargement
    create_load_dim_region_proc = PostgresOperator(
        task_id='create_load_dim_region_proc',
        postgres_conn_id='postgres_dwh',
        sql='exercice2/04_load_dim_region_procedure.sql',
    )
    
    # 5. Mettre à jour fact_sales avec region_key
    update_fact_sales_region = PostgresOperator(
        task_id='update_fact_sales_region',
        postgres_conn_id='postgres_dwh',
        sql='exercice2/05_update_fact_sales_with_region_key.sql',
    )
    
    # 6. Créer le graphique des ventes par région
    create_chart = PythonOperator(
        task_id='create_sales_chart',
        python_callable=create_sales_by_region_chart,
    )

    # Définir les dépendances
    # Exercice 1
    add_region_column_mysql >> update_raw_schema >> update_dwh_schema >> update_etl_procedures
    
    # Exercice 2
    create_regions_mysql >> create_regions_raw >> create_dim_region >> create_load_dim_region_proc >> update_fact_sales_region >> create_chart
    
    # L'exercice 2 dépend de l'exercice 1
    update_etl_procedures >> create_regions_mysql