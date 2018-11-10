#!/usr/bin/env bash

ORIGIN="https://raw.githubusercontent.com/streamich/fasttrack/master/bash"

echo Working directory: $(pwd)

# TODO: Remove this
yarn global add mrm climod-json climod-add-script

bash <(curl -s $ORIGIN/package.sh) "$@"
echo "Adding Husky."
yarn add --dev tslint-config-common husky

bash <(curl -s $ORIGIN/readme.sh) "$@"
bash <(curl -s $ORIGIN/license.sh) "$@"
bash <(curl -s $ORIGIN/typescript.sh) "$@"
bash <(curl -s $ORIGIN/prettier.sh) "$@"
bash <(curl -s $ORIGIN/tslint.sh) "$@"
bash <(curl -s $ORIGIN/commitlint.sh) "$@"
bash <(curl -s $ORIGIN/gitignore.sh) "$@"
bash <(curl -s $ORIGIN/codegen-ts.sh) "$@"
bash <(curl -s $ORIGIN/build-ts.sh) "$@"
bash <(curl -s $ORIGIN/ci-circleci.sh) "$@"
bash <(curl -s $ORIGIN/semantic-release.sh) "$@"
bash <(curl -s $ORIGIN/commitizen.sh) "$@"
bash <(curl -s $ORIGIN/git.sh) "$@"

# Run app.
RUN_COMMAND="npx ts-node src/index.ts"
echo "Running your app with $RUN_COMMAND"
$RUN_COMMAND
