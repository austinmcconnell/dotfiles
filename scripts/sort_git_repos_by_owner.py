#!/usr/bin/env python3

# ---------------------------------------------------------------
# Git Repository Organizer
#
# This script organizes Git repositories in the ~/projects directory
# by moving them into subdirectories based on their remote owner.
#
# For example:
# - A repo with remote URL https://github.com/owner/repo-name
#   will be moved to ~/projects/owner/repo-name
#
# - A repo with SSH URL git@github.com:owner/repo-name.git
#   will be moved to ~/projects/owner/repo-name
# ---------------------------------------------------------------

from pathlib import Path
import subprocess

def yes_or_no_question(question, default_no=True):
    """
    Ask a yes/no question and return the answer as a boolean.

    Args:
        question (str): The question to ask
        default_no (bool): Whether the default answer is No

    Returns:
        bool: True for yes, False for no
    """
    choices = ' [y/N]: ' if default_no else ' [Y/n]: '
    default_answer = 'n' if default_no else 'y'
    reply = str(input(question + choices)).lower().strip() or default_answer
    if reply[0] == 'y':
        return True
    if reply[0] == 'n':
        return False
    else:
        return False if default_no else True

# Directory containing all projects
REPOSITORIES_DIR = Path.home() / 'projects'

# Get all directories in the projects folder
projects = sorted([x for x in REPOSITORIES_DIR.iterdir() if x.is_dir()])

for project in projects:
    # Print separator for better readability
    print('*' * 70)
    print(f'Checking project: {project}')
    print('*' * 70)

    git_dir = project / '.git'

    # Skip if not a git repository
    if not git_dir.exists():
        print('Not a git repo. Skipping...')
        continue

    # Get the remote origin URL
    output = subprocess.run(['git', 'remote', 'get-url', 'origin'], cwd=project, capture_output=True, universal_newlines=True)
    fetch_url = output.stdout.strip('\n').rstrip('.git')

    if fetch_url == '':
        continue

    # Parse the owner and repo name from the URL
    # Handles both HTTPS and SSH URL formats
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

    # Directory where the repo should be moved
    owner_dir = REPOSITORIES_DIR / repo_owner

    # Ask for confirmation before moving
    response = yes_or_no_question(question=f'Move project {repo_name} to {owner_dir}?')

    if response is True:
        # Create owner directory if it doesn't exist
        if not owner_dir.exists():
            print(f'{owner_dir} directory does not exist. Creating...')
            owner_dir.mkdir()

        # Move the repository to the owner directory
        output = subprocess.run(['mv', project, owner_dir], cwd=project, capture_output=True, universal_newlines=True)
        if output.stdout:
            print(output.stdout)
        if output.stderr:
            print(output.stderr)
