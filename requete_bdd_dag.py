from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

default_args = {
    'owner': 'toi',
    'depends_on_past': False,
    'start_date': datetime(2025, 5, 19),
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}

with DAG(
    dag_id='requete_postgres_dag',
    default_args=default_args,
    description='DAG pour exécuter une requête sur PostgreSQL',
    schedule_interval=None,
    catchup=False,
) as dag:

    requete_postgres = PostgresOperator(
        task_id='select_exemple',
        postgres_conn_id='postgres_local',  # identifiant que tu as mis dans l’interface
        sql='SELECT * FROM produit LIMIT 10;',  # Mets ici ta requête réelle
    )
