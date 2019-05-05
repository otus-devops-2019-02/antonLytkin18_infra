#!/usr/bin/python

import json
import subprocess
import os


class InventoryGenerator:

    def __init__(self):
        self._hosts = {}
        os.chdir('../terraform/stage/')
        terraform_result = subprocess.check_output(['terraform', 'output', '-json'])
        for key, item in json.loads(terraform_result).iteritems():
            self._hosts[key] = item['value']

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
            server_name = name + '_server'
            all.append(server_name)
            inventory[server_name] = {'hosts': [name]}

        print(json.dumps(inventory))


generator = InventoryGenerator()
generator.print_json()
