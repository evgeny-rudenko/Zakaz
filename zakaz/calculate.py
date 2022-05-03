# prefect flow
import os
from prefect import Flow
from prefect.tasks.dbt import DbtShellTask
from sqlalchemy import false, true

with Flow(name="dbt_flow") as f:
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    task = DbtShellTask(overwrite_profiles=False, shell="bash",
    command="dbt run", return_all=true, log_stderr=true,profiles_dir="/home/evgeny/.dbt" )(command='dbt run')

out = f.run()
