#!/bin/bash
. /home/bodily11/creativity_app/venv/bin/activate

# virtualenv is now active, which means your PATH has been modified.
# Don't try to run python from /usr/bin/python, just run "python" and
# let the PATH figure out which version to run (based on what your
# virtualenv has configured).
cd
cd creativity_app
python cron_tasks.py
