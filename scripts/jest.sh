#!/usr/bin/env bash

# Install Jest.

DIR_SRC="src" # Source folder.
DIR_DIST="lib" # Distribution folder.
JEST_CONFIG_FILE="jest.config.js"
JEST_TEST_DIR="$DIR_SRC/__tests__"
JEST_SETUP_FILENAME="setup.js"
JEST_TS=false # Whether to add TypeScript support.
HELP=false

# Fetch CLI named params.
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      --jest-config-file)
      JEST_CONFIG_FILE="$2"
      shift # past argument
      shift # past value
      ;;
      --jest-test-dir)
      JEST_TEST_DIR="$2"
      shift # past argument
      shift # past value
      ;;
      --jest-setup-filename)
      JEST_SETUP_FILENAME="$2"
      shift # past argument
      shift # past value
      ;;
      --jest-ts)
      JEST_TS=true
      shift # past argument
      ;;
      --dir-src)
      DIR_SRC="$2"
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
  echo "fasttrack-cli jest [options]"
  echo ""
  echo "    Install Jest"
  echo ""
  echo "Options"
  echo "    --jest-config-file        config file name, defaults to jest.config.js"
  echo "    --jest-test-dir           main testing folder, defaults to 'src/__tests__'"
  echo "    --jest-setup-filename     runtime setup file, defaults to 'setup.js'"
  echo "    --jest-ts                 boolean flag, if set, will install TypeScript transform"
  echo "    --dir-src                 source folder, defaults to 'src'"
  echo "    --dir-dist                dist folder to be added to Git ignore, defaults to 'lib'"
  echo "    -h, --help                show this output"
  exit 0
fi

echo "Adding Jest."

echo "Installing Jest dependencies."
yarn add --dev @types/jest jest

if [ "$JEST_TS" = true ] ; then
  echo "Installing Jest TypeScript dependencies."
  yarn add --dev ts-jest
fi

TS_TRANSFORM=""
if [ "$JEST_TS" = true ] ; then
  TS_TRANSFORM=$(cat <<-END
  transform: {
    '^.+\\.tsx?$': 'ts-jest',
  },
END
)
fi

echo "Creating Jest test directory."
mkdir -p $JEST_TEST_DIR

echo "Creating Jest runtime setup file."
cat >$JEST_TEST_DIR/$JEST_SETUP_FILENAME <<EOL
// Jest setup.
process.env.JEST = true;
EOL

echo "Writing Jest config to $JEST_CONFIG_FILE."
cat >$JEST_CONFIG_FILE <<EOL
module.exports = {
  verbose: true,
  testURL: 'http://localhost/',
  setupFiles: ['<rootDir>/${DIR_TESTS_MAIN}/setup.js'],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx'],
${TS_TRANSFORM}
  transformIgnorePatterns: [],
  testRegex: '.*/__tests__/.*\\.(test|spec)\\.(jsx?|tsx?)$',
};
EOL


# Check climod-add-script is installed.
if ! [ -x "$(command -v climod-add-script)" ]; then
  yarn global add climod-add-script
fi

# Add scripts to `package.json`.
climod-add-script --name=test --cmd="jest --no-cache --config='$JEST_CONFIG_FILE'"
