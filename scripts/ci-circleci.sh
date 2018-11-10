#!/usr/bin/env bash

# Add CircleCI.

CIRCLECI_IMAGE="167590677736.dkr.ecr.us-east-1.amazonaws.com/p4-ci"
CIRCLECI_DIR=".circleci"
CIRCLECI_CONFIG="config.yml"
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --ci-circleci-image)
      CIRCLECI_IMAGE="$2"
      shift # past argument
      shift # past value
      ;;
      --ci-circleci-dir)
      CIRCLECI_DIR="$2"
      shift # past argument
      shift # past value
      ;;
      --ci-circleci-config)
      CIRCLECI_CONFIG="$2"
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
  echo "fasttrack ci-circleci [options]"
  echo ""
  echo "    Adds CircleCI config"
  echo ""
  echo "Options"
  echo "    --ci-circleci-image        Docker image used in CircleCI"
  echo "    --ci-circleci-dir          folder where to put config, defaults to '.circleci'"
  echo "    --ci-circleci-config       config file name, defaults to 'config.yml'"
  echo "    -h, --help                 show this output"
  exit 0
fi

echo "Adding CircleCI config."

echo "Creating .circleci folder."
mkdir -p .circleci

echo "Writing CircleCI config to '$CIRCLECI_DIR/$CIRCLECI_CONFIG'."
cat >$CIRCLECI_DIR/$CIRCLECI_CONFIG <<EOL
version: 2

refs:
  container: &container
    docker:
      - image: ${CIRCLECI_IMAGE}
    working_directory: ~/repo
  steps:
    - &Versions
      run:
        name: Versions
        command: node -v && npm -v && yarn -v
    - &Install
      run:
        name: Install Dependencies
        command: yarn install --pure-lockfile
    - &Build
      run:
        name: Build
        command: yarn build
    - &Test
      run:
        name: Test
        command: yarn test
    - &Post_to_dev_null
      run:
        name: 'Post to Slack #dev-null'
        command: npx ci-scripts slack --channel="dev-null"

jobs:
  all:
    <<: *container
    steps:
      - checkout
      - *Versions
      - *Install
      - *Build
      - *Test
      - *Post_to_dev_null

  master:
    <<: *container
    steps:
      - checkout
      - *Versions
      - *Install
      - *Build
      - *Test
      - *Post_to_dev_null
      - run:
          name: Release
          command: yarn release
      - *Post_to_dev_null

  nightly:
    <<: *container
    steps:
      - checkout
      - *Versions
      - *Install
      - *Build
      - *Test
      - *Post_to_dev_null
      - run:
          name: Post to Slack on FAILURE
          command: npx ci slack --channel="dev" --text="*${PROJECT_NAME}* nightly build failed :scream:" --icon_emoji=tired_face
          when: on_fail

workflows:
  version: 2
  all:
    jobs:
      - all:
          context: common-env-vars
          filters:
            branches:
              ignore:
                - master
                - gh-pages
  master:
    jobs:
      - master:
          context: common-env-vars
          filters:
            branches:
              only: master
  nightly:
    triggers:
      - schedule:
          cron: '0 1 * * *'
          filters:
            branches:
              only: master
    jobs:
      - nightly:
          context: common-env-vars
EOL
