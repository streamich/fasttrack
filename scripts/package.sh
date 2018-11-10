#!/usr/bin/env bash
echo "Adding package.json"

# Default GitHub username to use if one not set.
DEFAULT_USERNAME="streamich"

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
  esac
done
set -- "${POSITIONAL[@]}"

if [ -z ${USERNAME+x} ]; then
  echo "--username not set, will use default username: '$DEFAULT_USERNAME'.";
  USERNAME=$DEFAULT_USERNAME;
fi

echo "Using GitHub username: '$USERNAME'.";

# Check mrm is installed.
if ! [ -x "$(command -v mrm)" ]; then
  yarn global add mrm
fi

GITHUB_URL="https://github.com/$USERNAME"

mrm package \
  --config:url $GITHUB_URL \
  --config:github "$USERNAME"
