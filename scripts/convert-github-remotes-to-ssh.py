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
# If no directory is provided, defaults to $PROJECTS_DIR
# ---------------------------------------------------------------

import os
from pathlib import Path
import subprocess
import sys

MAX_DEPTH = 3


def convert_https_to_ssh(https_url):
    """Convert GitHub HTTPS URL to SSH format.

    Args:
        https_url (str): HTTPS URL like https://github.com/owner/repo.git

    Returns:
        str: SSH URL like git@github.com:owner/repo.git, or None if not a GitHub URL.
    """
    if not https_url.startswith('https://github.com/'):
        return None

    path_part = https_url.replace('https://github.com/', '')
    return f'git@github.com:{path_part}'


def _list_subdirs(directory):
    """Return sorted non-hidden subdirectories, or empty list on error."""
    try:
        return sorted(x for x in directory.iterdir() if x.is_dir() and not x.name.startswith('.'))
    except PermissionError:
        print(f'Permission denied accessing {directory}')
        return []


def _get_remotes(project):
    """Return list of remote names for a git repository.

    Args:
        project (Path): Path to the git repository.

    Returns:
        list[str]: Remote names, or empty list on error.
    """
    try:
        result = subprocess.run(
            ['git', 'remote'],  # noqa: S607
            cwd=project,
            capture_output=True,
            text=True,
            check=True,
        )
        return [r for r in result.stdout.strip().split('\n') if r]
    except subprocess.CalledProcessError:
        print(f'Error getting remotes for {project.name}')
        return []


def _convert_remote(project, remote):
    """Check a single remote and convert HTTPS to SSH if applicable.

    Args:
        project (Path): Path to the git repository.
        remote (str): Remote name to check.

    Returns:
        bool: True if the remote was converted.
    """
    try:
        result = subprocess.run(  # noqa: S603
            ['git', 'remote', 'get-url', remote],  # noqa: S607
            cwd=project,
            capture_output=True,
            text=True,
            check=True,
        )
        current_url = result.stdout.strip()
    except subprocess.CalledProcessError:
        print(f'Error getting URL for remote {remote}')
        return False

    print(f'Remote "{remote}": {current_url}')

    if not current_url.startswith('https://github.com/'):
        if current_url.startswith('git@github.com:'):
            print('  ✅ Already using SSH')
        else:
            print('  [i] Not a GitHub URL, skipping')
        return False

    ssh_url = convert_https_to_ssh(current_url)
    if not ssh_url:
        print('  ⚠️  Could not parse URL for conversion')
        return False

    print(f'  → Converting to: {ssh_url}')
    try:
        subprocess.run(  # noqa: S603
            ['git', 'remote', 'set-url', remote, ssh_url],  # noqa: S607
            cwd=project,
            check=True,
        )
        print(f'  ✅ Successfully converted {remote} to SSH')
        return True
    except subprocess.CalledProcessError as e:
        print(f'  ❌ Error converting {remote}: {e}')
        return False


def _print_remotes(project):
    """Print current remote URLs for a repository."""
    try:
        result = subprocess.run(
            ['git', 'remote', '-v'],  # noqa: S607
            cwd=project,
            capture_output=True,
            text=True,
            check=True,
        )
        print(result.stdout)
    except subprocess.CalledProcessError:
        print('Error displaying updated remotes')


def find_repos_in_dir(directory, base_dir, level=1):
    """Recursively find Git repositories and convert HTTPS remotes to SSH.

    Args:
        directory (Path): Directory to search for repositories.
        base_dir (Path): Root scan directory (for display paths).
        level (int): Current recursion level (for formatting output).
    """
    if level > MAX_DEPTH:
        return

    for project in _list_subdirs(directory):
        print('*' * (30 + level * 10))
        print(f'Checking {project.relative_to(base_dir)} (level {level})')
        print('*' * (30 + level * 10))

        if not (project / '.git').exists():
            print(f'{project.relative_to(base_dir)} is not a git repository.')
            if level < MAX_DEPTH:
                print(f'Recursing into {project.name} directory...')
                find_repos_in_dir(directory=project, base_dir=base_dir, level=level + 1)
            continue

        remotes = _get_remotes(project)
        if not remotes:
            print(f'No remotes found for {project.name}')
            continue

        results = [_convert_remote(project, remote) for remote in remotes]

        if any(results):
            print('\n📋 Updated remotes:')
            _print_remotes(project)

        print()


def _list_owner_dirs(projects_dir):
    """List owner directories and exit if none found.

    Args:
        projects_dir (Path): Parent directory to scan.

    Returns:
        list[Path]: Sorted list of owner directories.
    """
    if not projects_dir.exists():
        print(f'Directory {projects_dir} does not exist')
        sys.exit(1)

    owner_dirs = _list_subdirs(projects_dir)
    if not owner_dirs:
        print(f'No directories found in {projects_dir}')
        sys.exit(1)

    return owner_dirs


def select_directory():
    """Interactive directory selection from $PROJECTS_DIR."""
    projects_dir = Path(os.environ.get('PROJECTS_DIR', Path.home() / 'projects'))
    owner_dirs = _list_owner_dirs(projects_dir)

    print(f'Available directories in {projects_dir}:')
    print()
    for i, dir_path in enumerate(owner_dirs, 1):
        git_count = len([x for x in dir_path.iterdir() if x.is_dir() and (x / '.git').exists()])
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
            if choice_num == len(owner_dirs) + 1:
                return projects_dir
            print(f'Please enter a number between 1 and {len(owner_dirs) + 1}')
        except ValueError:
            print('Please enter a valid number')
        except KeyboardInterrupt:
            print('\nCancelled')
            sys.exit(0)


def main():
    """Convert GitHub HTTPS remotes to SSH across repositories."""
    if len(sys.argv) > 1:  # noqa: SIM108
        scan_dir = Path(sys.argv[1]).expanduser().resolve()
    else:
        scan_dir = select_directory()

    if not scan_dir.exists():
        print(f'Directory {scan_dir} does not exist')
        sys.exit(1)

    if not scan_dir.is_dir():
        print(f'{scan_dir} is not a directory')
        sys.exit(1)

    print(f'Scanning for Git repositories in: {scan_dir}')
    print('Looking for GitHub HTTPS remotes to convert to SSH...')
    print('=' * 60)
    print()

    find_repos_in_dir(directory=scan_dir, base_dir=scan_dir)

    print('=' * 60)
    print('Conversion complete!')
    print()
    print('Note: After converting to SSH, make sure you have:')
    print('1. SSH key added to your GitHub account')
    print('2. SSH key loaded in your SSH agent')
    print('3. GitHub.com in your known_hosts file')


if __name__ == '__main__':
    main()
