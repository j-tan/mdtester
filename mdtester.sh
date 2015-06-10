#!/bin/bash

entityid="https://test-sp.test.aaf.edu.au/idp/shibboleth"
md_test_url="https://ds.test.aaf.edu.au/distribution/metadata/metadata.aaf.signed.complete.xml"

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

  # categorize based on error codes
  case $status_code in
    000|302|404|500 )
      echo "$output" >> "$status_code.log"
      ;;
  esac
done
