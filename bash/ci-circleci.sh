# Add CircleCI.
CIRCLECI_IMAGE="167590677736.dkr.ecr.us-east-1.amazonaws.com/p4-ci"
mkdir -p .circleci
cat >.circleci/config.yml <<EOL
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
