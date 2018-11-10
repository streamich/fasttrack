echo "Adding Prettier."

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
  esac
done
set -- "${POSITIONAL[@]}"

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
