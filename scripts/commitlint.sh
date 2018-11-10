#!/usr/bin/env bash

# Add Commitlint.

COMMITLINT_CONFIG_FILE="commitlint.config.js"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --commitlint-config-file)
      COMMITLINT_CONFIG_FILE="$2"
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
  echo "fasttrack-cli commitlint [options]"
  echo ""
  echo "    Adds Commitlint to project"
  echo ""
  echo "Options"
  echo "    --commitlint-config-file    config file name, default to commitlint.config.js"
  echo "    -h, --help                  show this output"
  exit 0
fi


echo "Adding Commitlint."


echo "Installing Commitlint dependencies."
yarn add --dev @commitlint/cli @commitlint/config-conventional


# Add commitmsg hook script.
if [ -f package.json ]; then
  echo "Adding Commitlint hook script to package.json"
  if ! [ -x "$(command -v climod-add-script)" ]; then
    yarn global add climod-add-script
  fi
  climod-add-script --name=commitmsg --cmd="commitlint -E GIT_PARAMS"
else
  echo "Not adding Commitlint script hook, because package.json not found."
fi


echo "Creating Commitlint config at $COMMITLINT_CONFIG_FILE."
cat >$COMMITLINT_CONFIG_FILE <<EOL
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'subject-case': [1, 'always', 'lower-case'],
  },
};
EOL
