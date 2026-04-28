"""Install LSP library dependencies that Package Control can't resolve.

Package Control's v4 channel cache lacks the asset-based (.whl) releases
for mdpopups and lsp_utils on ST 4070+. This plugin downloads them
directly from GitHub releases using system curl on first run.

Only runs when libraries are missing. Does nothing once installed.
"""

import json
import os
import subprocess

import sublime

# mdpopups: st3-* tags are for Python 3.8, untagged 5.x are for 3.13+
# lsp_utils: v3.4.0+ .whl releases support both 3.8 and 3.13
_LIBRARIES = {
    'mdpopups': {
        'repo': 'facelessuser/sublime-markdown-popups',
        'tag_prefix': 'st3-',
    },
    'lsp_utils': {
        'repo': 'sublimelsp/lsp_utils',
        'tag_prefix': None,
    },
}


def _lib_path():
    return os.path.join(os.path.dirname(sublime.packages_path()), 'Lib', 'python38')


def _is_installed(name):
    return os.path.isdir(os.path.join(_lib_path(), name))


def _install_library(name, info):
    lib_dir = _lib_path()
    os.makedirs(lib_dir, exist_ok=True)

    api_url = f'https://api.github.com/repos/{info["repo"]}/releases?per_page=20'
    result = subprocess.run(  # noqa: S603
        ['curl', '-sL', api_url],  # noqa: S607
        capture_output=True,
        text=True,
        timeout=30,
        check=False,
    )
    releases = json.loads(result.stdout)

    for release in releases:
        if release.get('draft'):
            continue
        tag = release['tag_name']
        if info['tag_prefix'] and not tag.startswith(info['tag_prefix']):
            continue
        if not info['tag_prefix'] and tag.startswith('st3'):
            continue
        assets = [a for a in release.get('assets', []) if a['name'].endswith('.whl')]
        if assets:
            whl_url = assets[0]['browser_download_url']
            break
    else:
        print(f'LSP Library Installer: No compatible .whl found for {name}')
        return False

    tmp_path = os.path.join(lib_dir, name + '.whl')

    print(f'LSP Library Installer: Downloading {name} {tag}')
    subprocess.run(  # noqa: S603
        ['curl', '-sL', '-o', tmp_path, whl_url],  # noqa: S607
        timeout=60,
        check=True,
    )
    subprocess.run(  # noqa: S603
        ['unzip', '-o', '-q', tmp_path, '-d', lib_dir],  # noqa: S607
        timeout=30,
        check=True,
    )
    os.remove(tmp_path)
    print(f'LSP Library Installer: Installed {name} {tag}')
    return True


def plugin_loaded():
    """Sublime Text plugin entry point — install missing LSP libraries."""
    missing = {n: info for n, info in _LIBRARIES.items() if not _is_installed(n)}
    if not missing:
        return

    print(f'LSP Library Installer: Missing libraries: {", ".join(missing)}')
    sublime.set_timeout_async(lambda: _install_missing(missing), 3000)


def _install_missing(missing):
    installed = []
    for name, info in missing.items():
        try:
            if _install_library(name, info):
                installed.append(name)
        except Exception as e:  # noqa: PERF203
            print(f'LSP Library Installer: Error installing {name}: {e}')

    if installed:
        sublime.message_dialog(
            f'Installed missing LSP libraries: {", ".join(installed)}\n\n'
            'Please restart Sublime Text.'
        )
