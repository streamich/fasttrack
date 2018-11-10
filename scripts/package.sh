#!/usr/bin/env bash
echo "Adding package.json"

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
  echo "fasttrack package [options]"
  echo ""
  echo "    Creates package.json file"
  echo ""
  echo "Options"
  echo "    --username       GitHub username, defaults to 'streamich'"
  echo "    -h, --help       show this output"
  exit 0
fi

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
