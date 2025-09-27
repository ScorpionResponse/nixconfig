#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

mkdir -p ~/.config

ln -s ${SCRIPT_DIR}/nixpkgs ~/.config/nixpkgs
