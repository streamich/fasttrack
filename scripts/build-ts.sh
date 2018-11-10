#!/usr/bin/env bash

# Add TypeScript build and clean scripts.

DIR_DIST="lib" # Distribution folder.
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --dir-dist)
      DIR_DIST="$2"
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
  echo "fasttrack build-ts [options]"
  echo ""
  echo "    Add TypeScript build and clean scripts."
  echo ""
  echo "Options"
  echo "    --dir-dist      dist folder, defaults to 'lib'"
  echo "    -h, --help      show this output"
  exit 0
fi

echo "Add TypeScript build and clean scripts."

echo "Installing build-ts dependencies."
yarn add --dev rimraf
if ! [ -x "$(command -v climod-add-script)" ]; then
  yarn global add climod-add-script
fi
if ! [ -x "$(command -v climod-json)" ]; then
  yarn global add climod-json
fi

echo "Adding build and clean scripts."
climod-add-script --name clean --cmd "rimraf $DIST"
climod-add-script --name build --cmd "tsc"

echo "Configuring distribution files."
climod-json --file package.json --key files --set "[\"${DIST}/\"]" --json
climod-json --file package.json --key main --set "lib/index.js"
climod-json --file package.json --key types --set "lib/index.d.ts"
climod-json --file package.json --key typings --set "lib/index.d.ts"
