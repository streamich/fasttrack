#!/usr/bin/env bash

# Adding Git.

# Default GitHub username to use if one not set.
DEFAULT_USERNAME="streamich"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      -u|--username)
      USERNAME="$2"
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
  echo "fasttrack git [options]"
  echo ""
  echo "    Init Git repo and create first commit"
  echo ""
  echo "Options"
  echo "    --username        username to use in Git, defaults to 'streamich'"
  echo "    -h, --help        show this output"
  exit 0
fi

if [ -z ${USERNAME+x} ]; then
  echo "--username not set, will use default username: '$DEFAULT_USERNAME'.";
  USERNAME=$DEFAULT_USERNAME;
fi

echo "Using GitHub username: '$USERNAME'.";

echo "Adding Git"
git init
git config user.name "$USERNAME"
git add -A
git commit -m "chore: setup project with <https://github.com/streamich/fasttrack>" --no-verify
