#!/usr/bin/env python3
from pathlib import Path
import subprocess

def yes_or_no_question(question, default_no=True):
    choices = ' [y/N]: ' if default_no else ' [Y/n]: '
    default_answer = 'n' if default_no else 'y'
    reply = str(input(question + choices)).lower().strip() or default_answer
    if reply[0] == 'y':
        return True
    if reply[0] == 'n':
        return False
    else:
        return False if default_no else True

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

    output = subprocess.run(['git', 'remote', 'get-url', 'origin'], cwd=project, capture_output=True, universal_newlines=True)
    fetch_url = output.stdout.strip('\n').rstrip('.git')
    if fetch_url == '':
        continue
    if 'https' in fetch_url:
        repo_owner = fetch_url.split('/')[-2]
        repo_name = fetch_url.split('/')[-1]
    elif 'git@' in fetch_url:
        repo_owner = fetch_url.split('/')[-2].split(':')[1]
        repo_name = fetch_url.split('/')[-1]
    else:
        print(f'URL: {fetch_url}')
        raise RuntimeError('Unknown url scheme')
    print(f'Owner: {repo_owner}\tName: {repo_name}')

    owner_dir = REPOSITORIES_DIR / repo_owner

    response = yes_or_no_question(question=f'Move project {repo_name} to {owner_dir}?')

    if response is True:
        if not owner_dir.exists():
            print(f'{owner_dir} directory does not exist. Creating...')
            owner_dir.mkdir()

        output = subprocess.run(['mv', project, owner_dir], cwd=project, capture_output=True, universal_newlines=True)
        if output.stdout:
            print(output.stdout)
        if output.stderr:
            print(output.stderr)
