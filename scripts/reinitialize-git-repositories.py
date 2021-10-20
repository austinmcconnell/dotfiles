from pathlib import Path
import subprocess

REPOSITORIES_DIR = Path.home() / 'projects'

projects = sorted([x for x in REPOSITORIES_DIR.iterdir() if x.is_dir()])

for project in projects:

    print('*' * 70)
    print(f'Checking project: {project}')
    print('*' * 70)

    git_dir = project / '.git'

    if not git_dir.exists():
        print('Not a git repo. Skipping...')
        continue

    hooks_dir = git_dir / 'hooks'

    hooks = [x for x in hooks_dir.iterdir() if x.is_file()]
    for hook in hooks:
        print(f'Removing hook: {hook.name}')
        hook.unlink()

    subprocess.run(['git', 'init'], cwd=project)

    pre_commit_file = project / '.pre-commit-config.yaml'

    if pre_commit_file.exists():
        print('Initializing pre-commit...')
        subprocess.run(['pre-commit', 'install'], cwd=project)
