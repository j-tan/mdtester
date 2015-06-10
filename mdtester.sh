#!/bin/bash

federation=""
entityid="https://test-sp.test.aaf.edu.au/idp/shibboleth"
md_test_url="https://ds.test.aaf.edu.au/distribution/metadata/metadata.aaf.signed.complete.xml"

usage() {
  printf "Usage: mdtester.sh --federation [test|prod]\n"
}

if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
  usage
  exit 1
fi

while [ "$1" != "" ]; do
  case $1 in
    --federation )
      shift
      if [ "$1" == "test" ] || [ "$1" == "prod" ]; then
        federation="$1"
      else
        usage
        exit 1
      fi
      ;;
    * )
      printf "Unknown argument '$1'\n"
      usage
      exit 1
      ;;
  esac
done

# download the metadata file if it doesn't exist
if [ ! -e ./AAF-metadata.xml ]; then
  curl "$md_test_url" --silent --output ./AAF-metadata.xml
fi

grep DiscoveryResponse ./AAF-metadata.xml | awk -F"Location=" '{print $2}' \
| awk '{print $1}' | tr -d '"' | while read line; do
  if [[ "$line" =~ DS$ ]]; then
    url="${line/%DS/Login}?entityID=$entityid"
  elif [[ "$line" =~ Login$ ]]; then
    url="$line?entityID=$entityid"
  else
    url="$(sed 's:/[^/]*$::' <<< "$line")/Login?entityID=$entityid"
  fi
  output=$(curl -m 20 -skL -w "%{http_code} %{url_effective}\\n" "$url" -o /dev/null)
  echo "$output"
  status_code=$(awk '{print $1}' <<< "$output")
  echo "$output" >> "$status_code.log"
done
