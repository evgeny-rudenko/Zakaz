# prefect flow
from prefect import Flow
from prefect.tasks.dbt import DbtShellTask
from sqlalchemy import false, true

with Flow(name="dbt_flow") as f:
    task = DbtShellTask(overwrite_profiles=False, shell="bash", 
    command="dbt run", return_all=true, log_stderr=true)

    out = f.run()
