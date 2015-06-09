#!/bin/bash

entityid="https://test-sp.test.aaf.edu.au/idp/shibboleth"

usage() {
  printf "Usage: mdtester.sh [--entityid ENTITYID]\n"
}

if [ "$#" -gt 2 ]; then
  usage
  exit 1
fi
