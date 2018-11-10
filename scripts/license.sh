#!/usr/bin/env bash

# Adds license to a project.

# License name, as found here: https://github.com/sapegin/mrm-tasks/tree/master/packages/mrm-task-license/templates.
LICENSE="Unlicense"
LICENSE_FILE="LICENSE" # License file name.
LICENSE_DESCRIPTION="" # Short one-line description of the license.
README_FILE="README.md"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --license)
      LICENSE="$2"
      shift # past argument
      shift # past value
      ;;
      --license-file)
      LICENSE_FILE="$2"
      shift # past argument
      shift # past value
      ;;
      --license-description)
      LICENSE_DESCRIPTION="$2"
      shift # past argument
      shift # past value
      ;;
      --readme-file)
      README_FILE="$2"
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
  echo "fasttrack-cli license [options]"
  echo ""
  echo "    Adds license to a project."
  echo ""
  echo "Options"
  echo "    --license                 one of the available licenses from mrm-task-license"
  echo "    --license-file            file name, defaults to README.md"
  echo "    --license-description     short description"
  echo "    --readme-file             readme file name, where to add reference, defaults to README.md"
  echo "    -h, --help                show this output"
  exit 0
fi

echo "Adding license."


if [$LICENSE_DESCRIPTION == ""] ; then
  if [$LICENSE_DESCRIPTION == ""] ; then
    LICENSE_DESCRIPTION="public domain"
  fi
fi


# Add `license` key to package.json.
if [ -f package.json ]; then
  echo "Adding license key to package.json"
  if ! [ -x "$(command -v climod-json)" ]; then
    yarn global add climod-json
  fi
  climod-json --file ./package.json --key license --set "$LICENSE"
else
  echo "Not adding license to package.json as package.json not found"
fi


# Add license file.
echo "Creating license file $LICENSE_FILE with $LICENSE license."
if ! [ -x "$(command -v mrm)" ]; then
  yarn global add mrm
fi
npx mrm license --config:license "$LICENSE" --config:licenseFile $LICENSE_FILE


# Add license to README.
if [ -f $README_FILE ]; then
  echo "Adding license to $README_FILE readme."
  cat >>$README_FILE <<EOL

## License

[${LICENSE}](${LICENSE_FILE}) &mdash; ${LICENSE_DESCRIPTION}.
EOL
else
  echo "README file $README_FILE not found, not adding license to README."
fi
