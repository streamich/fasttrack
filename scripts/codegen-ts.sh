#!/usr/bin/env bash

# Add sample TypeScript code.

DIR_SRC="src" # Source folder.
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --dir-src)
      DIR_SRC="$2"
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
  echo "fasttrack codegen-ts [options]"
  echo ""
  echo "    Adds sample TypeScript code."
  echo ""
  echo "Options"
  echo "    --dir-src       source folder, defaults to 'src'"
  echo "    -h, --help      show this output"
  exit 0
fi

echo "Adding sample TypeScript code."

echo "Creating folder '$DIR_SRC'."
mkdir -p $DIR_SRC

echo "Creating file '$DIR_SRC/index.ts'."
cat >$DIR_SRC/index.ts <<EOL
console.log('Hello world!'); // tslint:disable-line no-console
EOL
