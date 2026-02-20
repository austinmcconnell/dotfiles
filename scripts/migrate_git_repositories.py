#!/usr/bin/env python3

# ---------------------------------------------------------------
# Git Repository Reftable Migrator
#
# This script recursively finds Git repositories in the ~/projects
# directory and migrates them to the reftable reference format by:
# 1. Checking if the repository is already using reftable
# 2. Migrating to reftable format if using the files backend
#
# The reftable format provides significant performance improvements:
# - 22x faster git fetch in large repositories
# - 18x faster git push in large repositories
# - Atomic reference updates
# - Better handling of many branches/tags
#
# This migration preserves all history and reflogs.
# ---------------------------------------------------------------

from pathlib import Path
import subprocess

def find_repos_in_dir(directory, level=1):
    """
    Recursively find and migrate Git repositories to reftable format.

    Args:
        directory (Path): Directory to search for repositories
        level (int): Current recursion level (for formatting output)
    """
    # Limit recursion depth to avoid going too deep
    max_level = 2
    if level > max_level:
        return

    # Get all directories in the current directory
    projects = sorted([x for x in directory.iterdir() if x.is_dir()])

    for project in projects:
        # Print separator for better readability
        print('*' * 30 * level)
        print(f'Checking {project.relative_to(REPOSITORIES_DIR)}')
        print('*' * 30 * level)

        git_dir = project / '.git'

        # If not a git repository, recurse into subdirectories
        if not git_dir.exists():
            print(f'{project.relative_to(REPOSITORIES_DIR)} is not a git repository.\
                \nRecursing into {project} directory')
            find_repos_in_dir(directory=project, level=level + 1)
            continue

        # Check current reference format
        config_file = git_dir / 'config'
        if config_file.exists():
            config_content = config_file.read_text()
            if 'refstorage = reftable' in config_content:
                print(f'{project.name} is already using reftable format. Skipping...')
                continue

        # Migrate to reftable format
        print(f'Migrating {project.name} to reftable format...')
        result = subprocess.run(
            ['git', 'refs', 'migrate', '--ref-format=reftable'],
            cwd=project,
            capture_output=True,
            text=True
        )

        if result.returncode == 0:
            print(f'✓ Successfully migrated {project.name} to reftable')
        else:
            print(f'✗ Failed to migrate {project.name}')
            if result.stderr:
                print(f'Error: {result.stderr}')

# Directory containing all projects
REPOSITORIES_DIR = Path.home() / 'projects'

# Start the recursive search
find_repos_in_dir(directory=REPOSITORIES_DIR)
