#!/usr/bin/env bash

# Add semantic-release.

HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
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
  echo "fasttrack semantic-release [options]"
  echo ""
  echo "    Installs semantic-release"
  echo ""
  echo "Options"
  echo "    -h, --help             show this output"
  exit 0
fi

echo "Adding semantic-release."

echo "Installing semantic-release dependencies."
yarn add --dev \
  semantic-release \
  @semantic-release/changelog \
  @semantic-release/npm \
  @semantic-release/git
if ! [ -x "$(command -v climod-add-script)" ]; then
  yarn global add climod-add-script
fi
if ! [ -x "$(command -v climod-json)" ]; then
  yarn global add climod-json
fi

climod-add-script --name release --cmd "semantic-release"
climod-json --file package.json --key release --json --set "{\"verifyConditions\": [\"@semantic-release/changelog\",\"@semantic-release/npm\",\"@semantic-release/git\"], \"prepare\": [\"@semantic-release/changelog\",\"@semantic-release/npm\",\"@semantic-release/git\"]}"
