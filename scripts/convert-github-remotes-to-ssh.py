#!/usr/bin/env python3

# ---------------------------------------------------------------
# GitHub Remote URL Converter
#
# This script finds Git repositories and converts GitHub HTTPS
# remote URLs to SSH format for better authentication.
#
# For example:
# - https://github.com/owner/repo-name.git
#   becomes git@github.com:owner/repo-name.git
#
# Usage:
#   ./convert-github-remotes-to-ssh.py [directory]
#
# If no directory is provided, defaults to ~/projects
# ---------------------------------------------------------------

import subprocess
import sys
from pathlib import Path


def convert_https_to_ssh(https_url):
    """
    Convert GitHub HTTPS URL to SSH format.

    Args:
        https_url (str): HTTPS URL like https://github.com/owner/repo.git

    Returns:
        str: SSH URL like git@github.com:owner/repo.git
    """
    if not https_url.startswith('https://github.com/'):
        return None

    # Remove https://github.com/ prefix
    path_part = https_url.replace('https://github.com/', '')

    # Convert to SSH format
    ssh_url = f'git@github.com:{path_part}'

    return ssh_url


def find_repos_in_dir(directory, level=1):
    """
    Recursively find Git repositories and convert HTTPS remotes to SSH.

    Args:
        directory (Path): Directory to search for repositories
        level (int): Current recursion level (for formatting output)
    """
    # Limit recursion depth to avoid going too deep
    max_level = 3
    if level > max_level:
        return

    # Get all directories in the current directory
    try:
        projects = sorted([x for x in directory.iterdir() if x.is_dir() and not x.name.startswith('.')])
    except PermissionError:
        print(f'Permission denied accessing {directory}')
        return

    for project in projects:
        # Print separator for better readability
        print('*' * (30 + level * 10))
        print(f'Checking {project.relative_to(SCAN_DIR)} (level {level})')
        print('*' * (30 + level * 10))

        git_dir = project / '.git'

        # If not a git repository, recurse into subdirectories
        if not git_dir.exists():
            print(f'{project.relative_to(SCAN_DIR)} is not a git repository.')
            if level < max_level:
                print(f'Recursing into {project.name} directory...')
                find_repos_in_dir(directory=project, level=level + 1)
            continue

        # Get all remotes
        try:
            result = subprocess.run(['git', 'remote'], cwd=project, capture_output=True, text=True, check=True)
            remotes = result.stdout.strip().split('\n') if result.stdout.strip() else []
        except subprocess.CalledProcessError:
            print(f'Error getting remotes for {project.name}')
            continue

        if not remotes:
            print(f'No remotes found for {project.name}')
            continue

        # Check each remote
        converted_any = False
        for remote in remotes:
            if not remote:  # Skip empty strings
                continue

            try:
                # Get the current URL for this remote
                result = subprocess.run(['git', 'remote', 'get-url', remote],
                                      cwd=project, capture_output=True, text=True, check=True)
                current_url = result.stdout.strip()
            except subprocess.CalledProcessError:
                print(f'Error getting URL for remote {remote}')
                continue

            print(f'Remote "{remote}": {current_url}')

            # Check if it's a GitHub HTTPS URL that needs conversion
            if current_url.startswith('https://github.com/'):
                ssh_url = convert_https_to_ssh(current_url)
                if ssh_url:
                    print(f'  → Converting to: {ssh_url}')

                    try:
                        subprocess.run(['git', 'remote', 'set-url', remote, ssh_url],
                                     cwd=project, check=True)
                        print(f'  ✅ Successfully converted {remote} to SSH')
                        converted_any = True
                    except subprocess.CalledProcessError as e:
                        print(f'  ❌ Error converting {remote}: {e}')
                else:
                    print(f'  ⚠️  Could not parse URL for conversion')
            elif current_url.startswith('git@github.com:'):
                print(f'  ✅ Already using SSH')
            else:
                print(f'  ℹ️  Not a GitHub URL, skipping')

        if converted_any:
            print('\n📋 Updated remotes:')
            try:
                result = subprocess.run(['git', 'remote', '-v'],
                                      cwd=project, capture_output=True, text=True, check=True)
                print(result.stdout)
            except subprocess.CalledProcessError:
                print('Error displaying updated remotes')

        print()


def select_directory():
    """
    Interactive directory selection from ~/projects
    """
    projects_dir = Path.home() / 'projects'

    if not projects_dir.exists():
        print(f'Directory {projects_dir} does not exist')
        sys.exit(1)

    # Get all directories in ~/projects
    try:
        owner_dirs = sorted([x for x in projects_dir.iterdir()
                           if x.is_dir() and not x.name.startswith('.')])
    except PermissionError:
        print(f'Permission denied accessing {projects_dir}')
        sys.exit(1)

    if not owner_dirs:
        print(f'No directories found in {projects_dir}')
        sys.exit(1)

    print('Available directories in ~/projects:')
    print()
    for i, dir_path in enumerate(owner_dirs, 1):
        # Count git repos in this directory
        git_count = len([x for x in dir_path.iterdir()
                        if x.is_dir() and (x / '.git').exists()])
        print(f'{i:2d}. {dir_path.name} ({git_count} git repos)')

    print(f'{len(owner_dirs) + 1:2d}. All directories')
    print()

    while True:
        try:
            choice = input('Select directory (number): ').strip()
            if not choice:
                continue

            choice_num = int(choice)
            if 1 <= choice_num <= len(owner_dirs):
                return owner_dirs[choice_num - 1]
            elif choice_num == len(owner_dirs) + 1:
                return projects_dir
            else:
                print(f'Please enter a number between 1 and {len(owner_dirs) + 1}')
        except ValueError:
            print('Please enter a valid number')
        except KeyboardInterrupt:
            print('\nCancelled')
            sys.exit(0)


def main():
    global SCAN_DIR

    # Get directory from command line argument or interactive selection
    if len(sys.argv) > 1:
        SCAN_DIR = Path(sys.argv[1]).expanduser().resolve()
    else:
        SCAN_DIR = select_directory()

    if not SCAN_DIR.exists():
        print(f'Directory {SCAN_DIR} does not exist')
        sys.exit(1)

    if not SCAN_DIR.is_dir():
        print(f'{SCAN_DIR} is not a directory')
        sys.exit(1)

    print(f'Scanning for Git repositories in: {SCAN_DIR}')
    print('Looking for GitHub HTTPS remotes to convert to SSH...')
    print('=' * 60)
    print()

    # Start the recursive search
    find_repos_in_dir(directory=SCAN_DIR)

    print('=' * 60)
    print('Conversion complete!')
    print()
    print('Note: After converting to SSH, make sure you have:')
    print('1. SSH key added to your GitHub account')
    print('2. SSH key loaded in your SSH agent')
    print('3. GitHub.com in your known_hosts file')


if __name__ == '__main__':
    main()
