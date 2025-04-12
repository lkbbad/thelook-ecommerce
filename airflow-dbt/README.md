# Airflow + dbt Integration for theLook eCommerce Project

This folder contains the Apache Airflow setup used to orchestrate dbt runs for the theLook eCommerce project.

## Contents

- `dags/`: Contains the DAG definition (dbt_pipeline_thelook)
- `docker-compose.yaml`: Spins up a local Airflow environment with web UI

## Getting Started

1. Navigate to this folder:  
   `cd airflow-dbt`

2. Spin up Airflow:  
   `docker-compose up -d`  
   `docker-compose up`

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
   - `dbt docs generate`  

Your dbt project should be available at:  
  `${HOME}/thelook-ecommerce`  
You can change this location in the `docker-compose.yaml` file.  

Make sure your profiles.yml file is mounted to:  
  `/home/airflow/.dbt/profiles.yml`  

## Notes

- Logs and metadata are stored locally in:  
  - `logs/`  
  - `airflow_metadata/`  

These folders are excluded from version control (see `.gitignore`).  

Airflow uses the SequentialExecutor and a local SQLite DB. This is suitable for local development, not production.  

If you modify your DAG or dbt project, simply re-trigger the DAG from the Airflow UI.  

## Suggested Improvements

- Switch to the DbtCoreOperator (via dbt-airflow plugin) for tighter integration.
- Parameterize dbt targets and environments using Airflow variables.
- Add Slack/email alerting for DAG failures.
- Use Docker volumes relative to your project folder (rather than absolute user paths) for easier sharing.
