#!/usr/bin/env bash

ORIGIN="https://raw.githubusercontent.com/streamich/fasttrack/master/bash"
USERNAME="streamich" # GitHub username.
DIRNAME=${PWD##*/}
PROJECT_NAME=$DIRNAME
SRC="src" # Source folder.
DIST="lib" # Distribution folder.

echo Working directory: $(pwd)

# Install global dependencies.
yarn global add \
  mrm \
  climod-json \
  climod-add-script


# Add package.json.
bash <(curl -s $ORIGIN/package.sh) "$@"


# README.
echo "Adding README":
README_FILE="README.md"
cat >$README_FILE <<EOL
# ${PROJECT_NAME}
EOL


# Add license.
echo "Adding license."
LICENSE="Unlicense" # License type.
LICENSE_FILE="LICENSE" # License file name.
LICENSE_DESCRIPTION="public domain" # Short one-line description of the license.
climod-json --file ./package.json --key license --set "$LICENSE"
npx mrm license --config:license "$LICENSE" --config:licenseFile $LICENSE_FILE
cat >>$README_FILE <<EOL

## License

[${LICENSE}](${LICENSE_FILE}) &mdash; ${LICENSE_DESCRIPTION}.
EOL


# Add Husky.
echo "Adding Husky."
yarn add --dev tslint-config-common husky


# Add TypeScript.
echo "Adding TypeScript."
TYPESCRIPT_CONFIG_FILE="tsconfig.json"
yarn add --dev tslint-config-common typescript ts-node
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


# Add Prettier.
echo "Adding Prettier."
PRETTIER_CONFIG_FILE="prettier.config.js"
cat >$PRETTIER_CONFIG_FILE <<EOL
module.exports = {
  arrowParens: 'always',
  printWidth: 120,
  tabWidth: 2,
  useTabs: false,
  semi: true,
  singleQuote: true,
  trailingComma: 'all',
  bracketSpacing: false,
  jsxBracketSameLine: false,
};
EOL
yarn add --dev prettier pretty-quick
climod-add-script --name=prettier --cmd="prettier --ignore-path .gitignore --write 'src/**/*.{ts,tsx,js,jsx}'"
climod-add-script --name="prettier:diff" --cmd="prettier -l 'src/**/*.{ts,tsx,js,jsx}'"
climod-add-script --name=prepush --cmd="yarn prettier:diff"
climod-add-script --name=precommit --cmd="pretty-quick --staged && yarn tslint"


# Add TSLint.
echo "Adding TSLint."
TSLINT_CONFIG="tslint-config-common"
TSLINT_CONFIG_FILE="tslint.json"
yarn add --dev tslint $TSLINT_CONFIG
climod-add-script --name=tslint --cmd="tslint 'src/**/*.{js,jsx,ts,tsx}' -t verbose"
climod-add-script --name=precommit --cmd="yarn tslint"
cat >$TSLINT_CONFIG_FILE <<EOL
{
  "extends": [
    "${TSLINT_CONFIG}"
  ]
}
EOL


# Add Commitlint.
echo "Adding Commitlint."
COMMITLINT_CONFIG_FILE="commitlint.config.js"
yarn add --dev @commitlint/cli @commitlint/config-conventional
climod-add-script --name=commitmsg --cmd="commitlint -E GIT_PARAMS"
cat >$COMMITLINT_CONFIG_FILE <<EOL
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'subject-case': [1, 'always', 'lower-case'],
  },
};
EOL


# Add .gitignore.
echo "Adding .gitignore file."
GITIGNORE_TYPE="Node"
GITIGNORE_FILE=".gitignore"
curl -o $GITIGNORE_FILE https://raw.githubusercontent.com/github/gitignore/master/$GITIGNORE_TYPE.gitignore
cat >>$GITIGNORE_FILE <<EOL

# Build folder
${DIST}/
EOL


# Codegen.
echo "Adding sample code."
mkdir -p $SRC
cat >$SRC/index.ts <<EOL
console.log('Hello world!'); // tslint:disable-line no-console
EOL


# Setup build.
echo "Setting up build."
yarn add --dev rimraf
climod-add-script --name clean --cmd "rimraf $DIST"
climod-add-script --name build --cmd "tsc"
climod-json --file package.json --key files --set "[\"${DIST}/\"]" --json
climod-json --file package.json --key main --set "lib/index.js"
climod-json --file package.json --key types --set "lib/index.d.ts"
climod-json --file package.json --key typings --set "lib/index.d.ts"


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


# Add semantic-release.
echo "Adding semantic-release."
yarn add --dev \
  semantic-release \
  @semantic-release/changelog \
  @semantic-release/npm \
  @semantic-release/git
climod-add-script --name release --cmd "semantic-release"
climod-json --file package.json --key release --json --set "{\"verifyConditions\": [\"@semantic-release/changelog\",\"@semantic-release/npm\",\"@semantic-release/git\"], \"prepare\": [\"@semantic-release/changelog\",\"@semantic-release/npm\",\"@semantic-release/git\"]}"


# Add Commitizen config.
echo "Adding Commitizen config."
climod-json --file package.json --key "config.commitizen.path" --set "git-cz"


# Run app.
RUN_COMMAND="npx ts-node src/index.ts"
echo "Running your app with $RUN_COMMAND"
$RUN_COMMAND


# Add Git.
echo "Adding Git"
git init
git config user.name "$USERNAME"
git add -A
git commit -m "chore: setup project with <https://github.com/streamich/fasttrack>" --no-verify
