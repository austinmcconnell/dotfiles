"""Find orphaned pip packages not tracked in default-packages.

Usage: python pip_orphans.py /path/to/default-packages
Prints orphaned package names, one per line.
"""
import sys
from importlib.metadata import distributions, metadata, PackageNotFoundError
from packaging.requirements import Requirement

tracked = set()
for line in open(sys.argv[1]):
    line = line.strip()
    if line and not line.startswith('#'):
        tracked.add(line)


def norm(n):
    """Normalize package name per PEP 503."""
    return n.lower().replace('_', '-').replace('.', '-').split('[')[0]


# Resolve all deps of tracked packages (including extras)
tracked_and_deps = set()
for spec in tracked:
    pkg_name = norm(spec.split('[')[0])
    tracked_and_deps.add(pkg_name)
    extras = set()
    if '[' in spec:
        extras = {e.strip() for e in spec.split('[')[1].rstrip(']').split(',')}
    try:
        m = metadata(pkg_name)
    except PackageNotFoundError:
        continue
    for req_str in (m.get_all('Requires-Dist') or []):
        req = Requirement(req_str)
        include = False
        if not req.marker:
            include = True
        elif extras:
            for extra in extras:
                if req.marker.evaluate({'extra': extra}):
                    include = True
                    break
        if include:
            tracked_and_deps.add(norm(req.name))

# Find packages not tracked and not required by anything
skip = {'pip', 'setuptools', 'wheel'}
top_level = set()
for dist in distributions():
    name = norm(dist.metadata['Name'])
    if name in skip:
        continue
    if name not in tracked_and_deps:
        top_level.add(name)

# Build full reverse-dep set (all packages required by any installed package)
all_reqs = set()
for dist in distributions():
    for req_str in (dist.metadata.get_all('Requires-Dist') or []):
        req = Requirement(req_str)
        if not req.marker or req.marker.evaluate():
            all_reqs.add(norm(req.name))

for pkg in sorted(top_level - all_reqs):
    print(pkg)
