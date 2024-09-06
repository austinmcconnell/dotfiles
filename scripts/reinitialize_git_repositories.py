#!/usr/bin/env python3
from pathlib import Path
import subprocess

def find_repos_in_dir(directory, level=1):
    max_level=2
    if level > max_level:
        return

    projects = sorted([x for x in directory.iterdir() if x.is_dir()])

    for project in projects:

        print('*' * 30 * level)
        print(f'Checking {project.relative_to(REPOSITORIES_DIR)}')
        print('*' * 30 * level)

        git_dir = project / '.git'

        if not git_dir.exists():
            print(f'{project.relative_to(REPOSITORIES_DIR)} is not a git repository.\
                \nRecursing into {project} directory')
            find_repos_in_dir(directory=project, level=level + 1)
            continue

        hooks_dir = git_dir / 'hooks'

        if hooks_dir.is_symlink():
            print(f'{hooks_dir.relative_to(project)} is symlinked to {hooks_dir.resolve()}. Removing symlink...')
            hooks_dir.unlink()
        elif hooks_dir.exists():
            hooks = [x for x in hooks_dir.iterdir() if x.is_file()]
            for hook in hooks:
                print(f'Removing hook: {hook.name}')
                hook.unlink()

        subprocess.run(['git', 'remote', '--verbose'], cwd=project)
        subprocess.run(['git', 'init'], cwd=project)
        subprocess.run(['git', 'remote', 'set-head', 'origin', '--auto'], cwd=project)

        pre_commit_file = project / '.pre-commit-config.yaml'

        if pre_commit_file.exists():
            print('Initializing pre-commit...')
            subprocess.run(['pre-commit', 'install'], cwd=project)

REPOSITORIES_DIR = Path.home() / 'projects'

find_repos_in_dir(directory=REPOSITORIES_DIR)
