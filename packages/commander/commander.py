#!/usr/bin/env python

import os
import json
import sys

"""
This is the script that all my menus scripts runs on, kept this script through out all my arch (Now even NixOS!) reinstallations, still going strong.

is uses rofi
"""

def e(command): 
    return os.popen(command).read()[:-1]


if len(sys.argv) > 1:
    default_prompt = sys.argv[1]
else:
    default_prompt = "Commands:"


if len(sys.argv) > 2:
    filterer = sys.argv[2]
else:
    filterer = "rofi"

commands_file = None

if len(sys.argv) > 3:
    commands_file = sys.argv[3]
else:
    commands_file = os.path.expandvars("$XDG_CONFIG_HOME/commander/commands.json")

commands = open(os.path.expanduser(commands_file), 'r').read()
commands = json.loads(commands)


def menu(commands, prompt = default_prompt):
    command_names = []
    command_actions = []
    command_prompts = []

    for command in commands:
        command_names.append(command['name'])
        command_actions.append(command['action'])

        if 'prompt' in command:
            command_prompts.append(command['prompt'])
        else:
            command_prompts.append(prompt)


    if filterer == "rofi":
        c = 'echo "{}" | rofi -dmenu -format i -i -p "{}" -theme-str \'element-icon {{ enabled: false; }} \''.format("\n".join(command_names), prompt)
    elif filterer == "tofi":
        c = 'echo "{}" | tofi --prompt-text "{}"'.format("\n".join(command_names), prompt)
    elif filterer == "fzf":
        c = 'echo "{}" | cat -n | fzf --prompt="{}" --with-nth 2.. | awk \'{{print $1}}\''.format("\n".join(command_names), prompt)
    else:
        print("filterer " + filterer + " not supported")
        sys.exit()

    index = e(c)

    if index != '':
        if filterer != "tofi":
            index = int(index)
        else:
            index = command_names.index(index)

        if filterer == "fzf":
            index = index - 1

        command = command_actions[index]

        if type(command) == list:
            menu(command, command_prompts[index])
        else:
            print("EXECUTING: {}".format(command.format(filterer)))
            os.system(command.format(filterer))

menu(commands)
