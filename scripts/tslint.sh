#!/usr/bin/env bash

# Add TSLint.

TSLINT_CONFIG="tslint-config-common"
TSLINT_CONFIG_FILE="tslint.json"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --tslint-config)
      TSLINT_CONFIG="$2"
      shift # past argument
      shift # past value
      ;;
      --tslint-config-file)
      TSLINT_CONFIG_FILE="$2"
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
  echo "fasttrack-cli readme [options]"
  echo ""
  echo "    Creates README file"
  echo ""
  echo "Options"
  echo "    --tslint-config       TSLint config to use, defaults to tslint-config-common"
  echo "    --tslint-config-file   File where to set TSLint config, defaults to tslint.json"
  echo "    -h, --help        show this output"
  exit 0
fi


echo "Adding TSLint."


echo "Installing TSLint dependencies."
yarn add --dev tslint $TSLINT_CONFIG


echo "Adding TSLint scripts to package.json"
# Check climod-add-script is installed.
if ! [ -x "$(command -v climod-add-script)" ]; then
  yarn global add climod-add-script
fi
climod-add-script --name=tslint --cmd="tslint 'src/**/*.{js,jsx,ts,tsx}' -t verbose"
climod-add-script --name=precommit --cmd="yarn tslint"


echo "Creating TSLint config at $TSLINT_CONFIG_FILE."
cat >$TSLINT_CONFIG_FILE <<EOL
{
  "extends": [
    "${TSLINT_CONFIG}"
  ]
}
EOL
