#!/usr/bin/env python3

# ---------------------------------------------------------------
# Git Repository Reinitializer
#
# This script recursively finds Git repositories in the ~/projects
# directory and reinitializes them by:
# 1. Removing Git hooks or symlinks to hooks
# 2. Reinitializing the Git repository
# 3. Setting up the default branch for the origin remote
# 4. Installing pre-commit hooks if a config file exists
#
# This is useful when migrating repositories or fixing corrupted
# Git repositories.
# ---------------------------------------------------------------

from pathlib import Path
import subprocess

def find_repos_in_dir(directory, level=1):
    """
    Recursively find and reinitialize Git repositories in a directory.

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

        # Handle Git hooks directory
        hooks_dir = git_dir / 'hooks'

        # Remove symlinked hooks directory
        if hooks_dir.is_symlink():
            print(f'{hooks_dir.relative_to(project)} is symlinked to {hooks_dir.resolve()}. Removing symlink...')
            hooks_dir.unlink()
        # Remove individual hooks
        elif hooks_dir.exists():
            hooks = [x for x in hooks_dir.iterdir() if x.is_file()]
            for hook in hooks:
                print(f'Removing hook: {hook.name}')
                hook.unlink()

        # Show remote information
        subprocess.run(['git', 'remote', '--verbose'], cwd=project)

        # Reinitialize the repository
        subprocess.run(['git', 'init'], cwd=project)

        # Set the default branch for the origin remote
        subprocess.run(['git', 'remote', 'set-head', 'origin', '--auto'], cwd=project)

        # Check for pre-commit configuration
        pre_commit_file = project / '.pre-commit-config.yaml'

        # Install pre-commit hooks if config exists
        if pre_commit_file.exists():
            print('Initializing pre-commit...')
            subprocess.run(['pre-commit', 'install'], cwd=project)
        else:
            print('No pre-commit config found. Skipping initialization...')

# Directory containing all projects
REPOSITORIES_DIR = Path.home() / 'projects'

# Start the recursive search
find_repos_in_dir(directory=REPOSITORIES_DIR)
