#!/usr/bin/env python3
"""
Installation script for the various modules in this dotfile repository
"""

import argparse
import logging
import os
from pathlib import Path
from typing import List

HOME = Path.home()
CONFIG_DIR = Path(os.getenv("XDG_CONFIG_HOME", HOME / ".config"))
SCRIPTPATH = Path(__file__).parent.resolve()
MODULES = {d.stem for d in SCRIPTPATH.iterdir() if (d.is_dir()) and d.stem != ".git"}

NECESSITIES = {"fish", "nvim", "git", "fd"}

DESCRIPTION = "Install configuration files"

logging.basicConfig(
    style="{", format="{name} {levelname:8s} {message}", level=logging.INFO
)
LOG = logging.getLogger("INSTALLER")


def parse_args():
    parser = argparse.ArgumentParser(description=DESCRIPTION)
    parser.add_argument(
        "modules",
        metavar="MODULE",
        type=str,
        nargs="+",
        help=f"List of modules to install. Must be one of the following:\n {MODULES}",
        choices=MODULES,
    )
    parser.add_argument(
        "-n",
        "--dryrun",
        action="store_true",
        help="Just print the actions that are going to happen",
    )
    args = parser.parse_args()
    return args


def _install_module_dir(module: str, dryrun=False):
    LOG.info(f"Attempting to install `{module}`")

    module_dir = (SCRIPTPATH / module).resolve()
    assert module_dir.is_dir()

    dest_dir = CONFIG_DIR / module
    if dest_dir.is_symlink():
        if dest_dir.resolve() == module_dir:
            LOG.info(f"`{module}` already installed: {dest_dir} -> {dest_dir.resolve()}")
            return
        LOG.info(f"Removing this symlink: {dest_dir} -> {dest_dir.resolve()}")
        if not dryrun:
            dest_dir.unlink()
    if dest_dir.is_dir():
        LOG.info(f"Removing pre-existing directory: {dest_dir}")
        if not dryrun:
            dest_dir.rmdir()

    LOG.info(f"Creating symlink: {dest_dir} -> {module_dir}")
    if not dryrun:
        dest_dir.symlink_to(module_dir, target_is_directory=True)


def main():
    args = parse_args()
    modules = args.modules
    dryrun = args.dryrun

    for module in modules:
        _install_module_dir(module, dryrun)


if __name__ == "__main__":
    main()
