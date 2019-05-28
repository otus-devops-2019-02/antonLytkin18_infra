#!/usr/bin/python

import json
import subprocess
import os


class InventoryGenerator:

    terraform_output_map = {
        'app_external_ip': 'app',
        'db_external_ip': 'db'
    }

    terraform_dir_path = '/../../../terraform/prod/'

    def __init__(self):
        self._hosts = {}
        current_path = os.path.dirname(os.path.realpath(__file__))
        os.chdir(current_path + self.terraform_dir_path)
        terraform_result = subprocess.check_output(['terraform', 'output', '-json'])
        for key, item in json.loads(terraform_result).iteritems():
            self._hosts[key] = item['value']

    def get_host_name(self, terraform_name):
        host_name = self.terraform_output_map[terraform_name]
        return host_name if host_name else terraform_name + '_host'

    def print_json(self):
        hostvars = {}
        all = []
        inventory = {
            '_meta': {
                'hostvars': hostvars
            },
            'all': {
                'children': all
            }
        }

        for name, ip_address in self._hosts.iteritems():
            hostvars[name] = {'ansible_host': ip_address}
            host_name = self.get_host_name(name)
            all.append(host_name)
            inventory[host_name] = {'hosts': [name]}

        print(json.dumps(inventory))


generator = InventoryGenerator()
generator.print_json()
