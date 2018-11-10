#!/usr/bin/env bash

# - Installs Prettier and pretty-quick
# - Adds scripts to package.json

PRETTIER_CONFIG_FILE="prettier.config.js"
PRETTIER_ARROW_PARENS="always"
PRETTIER_PRINT_WIDTH=120
PRETTIER_TAB_WIDTH=2
PRETTIER_TRAILING_COMMA="all"
PRETTIER_USE_TABS="false"
PRETTIER_SEMI="true"
PRETTIER_SINGLE_QUOTE="true"
PRETTIER_BRACKET_SPACING="false"
PRETTIER_JSX_BRACKET_SAME_LINE="false"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --prettier-config)
      PRETTIER_CONFIG_FILE="$2"
      shift # past argument
      shift # past value
      ;;
      --prettier-arrow-parens)
      PRETTIER_ARROW_PARENS="$2"
      shift # past argument
      shift # past value
      ;;
      --prettier-print-width)
      PRETTIER_PRINT_WIDTH="$2"
      shift # past argument
      shift # past value
      ;;
      --prettier-trailing-comma)
      PRETTIER_TRAILING_COMMA="$2"
      shift # past argument
      shift # past value
      ;;
      --prettier-use-tabs)
      PRETTIER_USE_TABS="$2"
      shift # past argument
      shift # past value
      ;;
      --prettier-semi)
      PRETTIER_SEMI="$2"
      shift # past argument
      shift # past value
      ;;
      --prettier-single-quote)
      PRETTIER_SINGLE_QUOTE="$2"
      shift # past argument
      shift # past value
      ;;
      --prettier-bracket-spacing)
      PRETTIER_BRACKET_SPACING="$2"
      shift # past argument
      shift # past value
      ;;
      --prettier-jsx-bracket-same-line)
      PRETTIER_JSX_BRACKET_SAME_LINE="$2"
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
  echo "fasttrack-cli prettier [options]"
  echo ""
  echo " - Installs Prettier and pretty-quick"
  echo " - Adds scripts to package.json"
  echo ""
  echo "Options"
  echo "    --prettier-config                 Config file, defaults to prettier.config.js"
  echo "    --prettier-arrow-parens           arrowParams setting, defaults to 'always'"
  echo "    --prettier-print-width            printWidth setting, defaults to 120"
  echo "    --prettier-trailing-comma         trailingComma setting, defaults to 'all'"
  echo "    --prettier-use-tabs               useTabs setting, defaults to false"
  echo "    --prettier-semi                   semi setting, defaults to true"
  echo "    --prettier-single-quote           singleQuote setting, defaults to true"
  echo "    --prettier-bracket-spacing        bracketSpacing setting, defaults to false"
  echo "    --prettier-jsx-bracket-same-line  jsxBracketSameLine setting, defaults to false"
  echo "    -h, --help                        show this output"
  exit 0
fi

echo "Adding Prettier."

# Install `prettier` and `pretty-quick`
yarn add --dev prettier pretty-quick

# Check climod-add-script is installed.
if ! [ -x "$(command -v climod-add-script)" ]; then
  yarn global add climod-add-script
fi

# Add scripts to `package.json`.
climod-add-script --name=prettier --cmd="prettier --ignore-path .gitignore --write 'src/**/*.{ts,tsx,js,jsx}'"
climod-add-script --name="prettier:diff" --cmd="prettier -l 'src/**/*.{ts,tsx,js,jsx}'"
climod-add-script --name=prepush --cmd="yarn prettier:diff"
climod-add-script --name=precommit --cmd="pretty-quick --staged && yarn tslint"

echo "Writing Prettier config to '$PRETTIER_CONFIG_FILE'."
cat >$PRETTIER_CONFIG_FILE <<EOL
module.exports = {
  arrowParens: '${PRETTIER_ARROW_PARENS}',
  printWidth: ${PRETTIER_PRINT_WIDTH},
  tabWidth: ${PRETTIER_TAB_WIDTH},
  useTabs: ${PRETTIER_USE_TABS},
  semi: ${PRETTIER_SEMI},
  singleQuote: ${PRETTIER_SINGLE_QUOTE},
  trailingComma: '${PRETTIER_TRAILING_COMMA}',
  bracketSpacing: ${PRETTIER_BRACKET_SPACING},
  jsxBracketSameLine: ${PRETTIER_JSX_BRACKET_SAME_LINE},
};
EOL
