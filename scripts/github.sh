#!/usr/bin/env bash

# Create GitHub repo and push first commit.

DIRNAME=${PWD##*/}
PROJECT=$DIRNAME
DEFAULT_USERNAME="streamich"

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      -u|--username)
      USERNAME="$2"
      shift # past argument
      shift # past value
      ;;
      --project)
      PROJECT="$2"
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
  echo "fasttrack github [options]"
  echo ""
  echo "    Crete GitHub repo and push."
  echo ""
  echo "Options"
  echo "    --project          repo name, defaults to folder name"
  echo "    -h, --help         show this output"
  exit 0
fi

if [ -z ${USERNAME+x} ]; then
  echo "--username not set, will use default username: '$DEFAULT_USERNAME'.";
  USERNAME=$DEFAULT_USERNAME;
fi
echo "Using GitHub username: '$USERNAME'.";

echo "Creating GitHub repo '$PROJECT'."
echo "https://github.com/$USERNAME/$PROJECT"
ENDPOINT="https://api.github.com/user/repos?access_token=$GITHUB_TOKEN_FASTTRACK"
curl \
  --header "Content-Type: application/json" \
  --header "User-Agent': 'FastTrack" \
  --request POST \
  --data "{\"name\": \"$PROJECT\"}" \
  $ENDPOINT

ORIGIN="git@github.com:$USERNAME/$PROJECT.git"
echo "Adding Git remote origin '$ORIGIN'"
git remote add origin $ORIGIN

echo "Pushing to master"
git push -u origin master
