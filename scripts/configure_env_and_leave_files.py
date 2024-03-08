#!/usr/bin/env python3
from pathlib import Path

REPOSITORIES_DIR = Path.home() / 'projects'

# This assumes git repos have been sorted by owner as in scripts/sort_git_repos_by_owner.py
owner_dirs = sorted([x for x in REPOSITORIES_DIR.iterdir() if x.is_dir()])

projects = []
for project_dir in owner_dirs:
    projects.extend([y for y in project_dir.iterdir() if y.is_dir()])
projects = sorted(projects)

for project in projects:

    print('*' * 70)
    print(f'Checking project: {project}')
    print('*' * 70)

    git_dir = project / '.git'

    if not git_dir.exists():
        print('Not a git repo. Skipping...')
        continue

    venv_dir = project / '.venv'

    if not venv_dir.exists():
        print('No .venv directory found. Skipping...')
        continue

    env_file = project / '.env'
    env_leave_file = project / '.env.leave'

    if env_file.exists():
        contents = env_file.read_text()
        lines = contents.split('\n')

        if 'source .venv/bin/activate' in lines:
            print('.env file looks good')
        else:
            print('source .venv/bin/activate not found. Adding...')
            lines.append('# Activate virtual environment')
            lines.append('source .venv/bin/activate')

            env_file.write_text('\n'.join(lines))
    else:
        print('.env not found. Adding...')
        lines = ['# Activate virtual environment', 'source .venv/bin/activate']
        env_file.write_text('\n'.join(lines))

    if env_leave_file.exists():
        contents = env_leave_file.read_text()
        lines = contents.split('\n')

        if 'deactivate' in lines:
            print('.env.leave file looks good')
        else:
            print('deactivate not found. Adding...')
            lines.append('# Deactivate virtual environment')
            lines.append('deactivate')

            env_leave_file.write_text('\n'.join(lines))
    else:
        print('.env.leave not found. Adding...')
        lines = ['# Deactivate virtual environment', 'deactivate']
        env_leave_file.write_text('\n'.join(lines))
