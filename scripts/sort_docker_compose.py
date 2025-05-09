#!/usr/bin/env python3
import argparse
from collections import OrderedDict

import yaml

parser = argparse.ArgumentParser()
parser.add_argument('files', nargs=argparse.REMAINDER)
args = parser.parse_args()


def represent_none(self, _):
    return self.represent_scalar('tag:yaml.org,2002:null', '')


yaml.add_representer(
    OrderedDict,
    lambda dumper, data: dumper.represent_mapping(
        'tag:yaml.org,2002:map', data.items()
    ),
)
yaml.add_representer(type(None), represent_none)


class MyDumper(yaml.Dumper):
    def increase_indent(self, flow=False, indentless=False):
        return super().increase_indent(flow, False)


top_level_key_order = ['version', 'include', 'services', 'volumes', 'networks']
services_key_order = [
    'container_name',
    'image',
    'build',
    'ports',
    'working_dir',
    'env_file',
    'environment',
    'volumes',
    'networks',
    'network_mode',
    'entrypoint',
    'command',
    'restart',
    'pull_policy'
]
networks_key_order = [
    'name',
    'external',
    'driver',
    'driver_opts',
]


def order_dictionary(data, top_keys: list):
    keys = data.keys()
    ordered_data = OrderedDict()

    for key in top_keys:
        if key in data:
            ordered_data[key] = data[key]
            if key == 'services' and key in ordered_data:
                for service in ordered_data[key].keys():
                    ordered_data[key][service] = order_dictionary(
                        ordered_data[key][service], top_keys=services_key_order
                    )
            elif key == 'networks' and key in ordered_data:
                for network in ordered_data[key].keys():
                    if isinstance(ordered_data[key][network], dict):
                        ordered_data[key][network] = order_dictionary(
                            ordered_data[key][network], top_keys=networks_key_order
                        )

    remaining_keys = keys - top_keys

    for key in remaining_keys:
        print(f'Unspecified order for key: {key}')
        if key in data:
            ordered_data[key] = data[key]

    return ordered_data


for file in args.files:
    with open(file, 'r+') as yamlfile:
        contents = yaml.safe_load(yamlfile)

    contents_sorted = order_dictionary(data=contents, top_keys=top_level_key_order)
    yaml.dump(contents_sorted, sort_keys=False)

    with open(file, 'w') as yamlfile:
        yaml.dump(
            contents_sorted,
            yamlfile,
            Dumper=MyDumper,
            explicit_start=True,
            default_flow_style=False,
            width=float('inf'),
        )
