# Airflow + dbt Integration for theLook eCommerce Project

This folder contains the Apache Airflow setup used to orchestrate dbt and MLOps tasks for the theLook eCommerce project.

## Contents

- `dags/`: Contains the DAG definition (dbt_pipeline_thelook)
- `docker-compose.yaml`: Spins up a local Airflow environment with web UI
- `mlops/`: Python script for model training + requirements
- `logs/` and `airflow_metadata/`: Store task logs and metadata (excluded from version control)

## Getting Started

1. Navigate to this folder:  
   `cd airflow-dbt`

2. Spin up Airflow:  
   `docker-compose up -d`  

3. Access Airflow UI:  
   - Visit `http://localhost:8080`
   - Default credentials: 
     Username: admin  
     Password: admin  

4. Trigger the `dbt_pipeline_thelook` DAG.  
   This will run:  
   - `dbt seed`  
   - `dbt run`  
   - `dbt test`  
   - `train_cross_sell_model.py` (Python ML training)
   - `dbt docs generate`  

Your dbt project should be located at: `${HOME}/thelook-ecommerce`. This is mounted into the container at `/usr/app/dbt` (editable in `docker-compose.yaml`).

 Your `profiles.yml` file should be located at: `/home/airflow/.dbt/profiles.yml`  

Your service account JSON for BigQuery should also be mounted and referenced via the `GOOGLE_APPLICATION_CREDENTIALS` env variable.

## Notes

- This Airflow setup uses `SequentialExecutor` and a local SQLite DB. It's perfect for local dev but not for production workloads.
- Logs are stored under `logs/` and Airflow metadata under `airflow_metadata/` (both are `.gitignore`d).
- If you update the DAG or dbt models, just trigger the DAG again from the Airflow UI.

## Suggested Improvements

- Use the `DbtCoreOperator` (via `dbt-airflow` plugin) for tighter integration with dbt Cloud or CLI.
- Parameterize dbt targets and environments using Airflow Variables or Connections.
- Add alerting via Slack or email on DAG failures.
- Use relative Docker volume mounts (`../`, `./`) to make setup more portable.
- Add a scoring step or metadata logging to BigQuery or GCS for complete MLOps traceability.