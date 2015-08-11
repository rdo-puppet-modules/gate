#!/bin/bash

OPMCI_MODULES=${OPMCI_MODULES:-"~/modules"}
OPMCI_COMPOSITION=${OPMCI_COMPOSITION:-"tests/basic.pp"}
OPMCI_PATH=`dirname "${BASH_SOURCE[0]}"`

for module in $@; do
  (cd "${OPMCI_PATH}/${module}" && rake spec --trace)
done
