#!/usr/bin/env bash

# Adds TypeScript to project.

SRC="src" # Source folder.
DIST="lib"
TYPESCRIPT_CONFIG_FILE="tsconfig.json"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --typescript-config-file)
      TYPESCRIPT_CONFIG_FILE="$2"
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
  echo "fasttrack-cli typescript [options]"
  echo ""
  echo "    Adds TypeScript to project"
  echo ""
  echo "Options"
  echo "    --typescript-config-file    name of TypeScript config file, defaults to tsconfig.json"
  echo "    -h, --help                  show this output"
  exit 0
fi


echo "Adding TypeScript."

echo "Installing TypeScript dependencies."
yarn add --dev typescript ts-node

echo "Adding TypeScript config at $TYPESCRIPT_CONFIG_FILE."
cat >$TYPESCRIPT_CONFIG_FILE <<EOL
{
  "compilerOptions": {
    "target": "es2018",
    "module": "commonjs",
    "moduleResolution": "Node",
    "removeComments": true,
    "noImplicitAny": false,
    "allowJs": true,
    "allowSyntheticDefaultImports": true,
    "skipDefaultLibCheck": true,
    "skipLibCheck": true,
    "experimentalDecorators": true,
    "importHelpers": true,
    "pretty": true,
    "sourceMap": true,
    "strict": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "noEmitHelpers": true,
    "noEmitOnError": true,
    "noErrorTruncation": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitReturns": true,
    "declaration": false,
    "lib": ["es2018", "es2017", "esnext", "dom", "esnext.asynciterable"],
    "outDir": "./${DIST}"
  },
  "include": ["src"],
  "exclude": [
    "node_modules",
    "${DIST}",
    "${SRC}/__tests__",
    "${SRC}/**/__tests__/**/*.*",
    "${SRC}/**/__mocks__/**/*.*",
    "*.test.ts",
    "*.spec.ts"
  ]
}
EOL
