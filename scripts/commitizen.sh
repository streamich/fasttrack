#!/usr/bin/env bash

# Add Commitizen config.

COMMITIZEN_PATH="git-cz"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --commitizen-path)
      COMMITIZEN_PATH="$2"
      shift # past argument
      shift # past value
      ;;
      -h|--help)
      HELP=true
      shift # past argument
      ;;
      *)
      shift # in case of unknown argument
      ;;
  esac
done
set -- "${POSITIONAL[@]}"

if [ "$HELP" = true ] ; then
  echo "fasttrack commitizen [options]"
  echo ""
  echo "    Adds Commitizen to config"
  echo ""
  echo "Options"
  echo "    --commitizen-path         commitizen CLI to use, defaults to git-cz"
  echo "    -h, --help                show this output"
  exit 0
fi

echo "Adding Commitizen config."

echo "Using '$COMMITIZEN_PATH' CLI."
climod-json --file package.json --key "config.commitizen.path" --set "$COMMITIZEN_PATH"
