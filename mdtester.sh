#!/bin/bash

entityid="https://test-sp.test.aaf.edu.au/idp/shibboleth"

usage() {
  printf "Usage: mdtester.sh [--entityid ENTITYID]\n"
}

if [ "$#" -gt 2 ]; then
  usage
  exit 1
fi

while [ "$1" != "" ]; do
  case $1 in
    --entityid )
      shift
      entityid="$1"
      ;;
    * )
      printf "Unknown argument '$1'\n"
      usage
      exit 1
      ;;
  esac
done