from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'owner': 'lkbbad',
    'start_date': datetime(2024, 1, 1),
    'retries': 1,
}

with DAG(
    dag_id='dbt_pipeline_thelook',
    default_args=default_args,
    description='Modular dbt pipeline for theLook eCommerce project',
    schedule_interval=None,
    catchup=False,
    tags=['dbt', 'thelook'],
) as dag:

    dbt_seed = BashOperator(
        task_id='dbt_seed',
        bash_command='cd /usr/app/dbt && dbt seed',
    )

    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command='cd /usr/app/dbt && dbt run',
    )

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /usr/app/dbt && dbt test',
    )

    train_cross_sell_model = BashOperator(
        task_id='train_cross_sell_model',
        bash_command='python /usr/app/mlops/train_cross_sell_model.py',
    )

    dbt_docs_generate = BashOperator(
        task_id='dbt_docs_generate',
        bash_command='cd /usr/app/dbt && dbt docs generate',
    )

    # Define execution order
    dbt_seed >> dbt_run >> dbt_test >> train_cross_sell_model >> dbt_docs_generate
