#!/usr/bin/env bash

# Add Travis CI.

TRAVIS_CONFIG=".travis.yml"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --ci-travis-config)
      TRAVIS_CONFIG="$2"
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
  echo "fasttrack ci-travis [options]"
  echo ""
  echo "    Adds Travis CI config"
  echo ""
  echo "Options"
  echo "    --ci-travis-config       config file name, defaults to '.travis.yml'"
  echo "    -h, --help               show this output"
  exit 0
fi

echo "Adding Travis CI config."

echo "Writing Travis config to '$TRAVIS_CONFIG'."
cat >$TRAVIS_CONFIG <<EOL
language: node_js
os:
  - linux
cache:
  yarn: true
  directories:
    - ~/.npm
notifications:
  email: false
node_js:
  - '10'
script:
  - yarn test
  - yarn build
matrix:
  allow_failures: []
  fast_finish: true
after_success:
  - yarn release
branches:
  except:
    - /^v\d+\.\d+\.\d+$/
EOL
