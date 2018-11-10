#!/usr/bin/env bash

# Add .gitignore to project.

GITIGNORE_TYPE="Node"
GITIGNORE_FILE=".gitignore"
DIR_DIST="lib"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --gitignore-type)
      GITIGNORE_TYPE="$2"
      shift # past argument
      shift # past value
      ;;
      --gitignore-file)
      GITIGNORE_FILE="$2"
      shift # past argument
      shift # past value
      ;;
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
  echo "fasttrack gitignore [options]"
  echo ""
  echo "    Add .gitignore to project"
  echo ""
  echo "Options"
  echo "    --gitignore-type   gitignore file as found at https://github.com/github/gitignore, defaults to 'Node'"
  echo "    --gitignore-file    file name, defaults to ''.gitignore'"
  echo "    --dir-dist         dist folder to be added to Git ignore, defaults to 'lib'"
  echo "    -h, --help         show this output"
  exit 0
fi


echo "Adding .gitignore file."


echo "Creating Git ignore file at $GITIGNORE_FILE."
curl -o $GITIGNORE_FILE https://raw.githubusercontent.com/github/gitignore/master/$GITIGNORE_TYPE.gitignore


echo "Adding build folder to Git ignore."
cat >>$GITIGNORE_FILE <<EOL

# Build folder
${DIR_DIST}/
EOL
