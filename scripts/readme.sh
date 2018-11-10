#!/usr/bin/env bash

# Creates a README file.

DIRNAME=${PWD##*/}
README_FILE="README.md"
README_PROJECT_NAME=$DIRNAME
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --readme-file)
      README_FILE="$2"
      shift # past argument
      shift # past value
      ;;
      --project)
      README_PROJECT_NAME="$2"
      shift # past argument
      shift # past value
      ;;
      -h|--help)
      HELP=true
      shift # past argument
      ;;
  esac
done
set -- "${POSITIONAL[@]}"

if [ "$HELP" = true ] ; then
  echo "fasttrack-cli readme [options]"
  echo ""
  echo "    Creates README file"
  echo ""
  echo "Options"
  echo "    --readme-file       README file name, defaults to README.md"
  echo "    -h, --help        show this output"
  exit 0
fi

echo "Adding README."

cat >$README_FILE <<EOL
# ${README_PROJECT_NAME}
EOL
