#!/usr/bin/env bash

# Add storybook to your project.

# Fetch CLI named params.
STORYBOOK_PORT=6010
STORYBOOK_DIR=.storybook
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
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
  echo "fasttrack storybook [options]"
  echo ""
  echo "    Add storybook to your project."
  echo ""
  echo "Options"
  echo "    -h, --help         show this output"
  exit 0
fi

echo "Create /.storybook config folder."
mkdir -p $STORYBOOK_DIR

echo "Installing NPM dependencies."
yarn add --dev \
  @storybook/addon-actions \
  @storybook/addon-links \
  @storybook/addon-options \
  @storybook/addon-viewport \
  @storybook/addon-notes \
  @storybook/addon-knobs \
  @storybook/addon-backgrounds \
  @storybook/react \
  storybook-readme \
  url-loader

echo "Installing NPM dependencies for TypeScript."
yarn add --dev \
  fork-ts-checker-webpack-plugin \
  ts-loader

echo "Adding package.json scripts."
if ! [ -x "$(command -v climod-add-script)" ]; then
  yarn global add climod-add-script
fi
climod-add-script --name=storybook --cmd="start-storybook -p $STORYBOOK_PORT"
climod-add-script --name="storybook:build" --cmd="build-storybook"
climod-add-script --name="storybook:clean" --cmd="rimraf storybook-static"

echo "Adding Storybook config /$STORYBOOK_DIR/config.js"
cat >$STORYBOOK_DIR/config.js <<EOL
import React from 'react';
import {configure, addDecorator} from '@storybook/react';
import {setOptions} from '@storybook/addon-options';
import backgrounds from '@storybook/addon-backgrounds';
import {theme} from '../src/theme';

setOptions({
  sortStoriesByKind: false,
  showStoriesPanel: true,
  showAddonPanel: true,
  showSearchBox: false,
  addonPanelInRight: true,
  hierarchySeparator: /\//,
  hierarchyRootSeparator: /\|/,
  sidebarAnimations: false,
});

addDecorator(
  backgrounds([
    {name: 'White', value: '#fff', default: true},
    {name: 'Snow', value: theme.snow[0], default: true},
    {name: 'Steel', value: theme.steel},
    {name: 'Black', value: theme.black},
  ]),
);

const req = require.context('../src/', true, /.*(stories|story)\.(js|jsx|ts|tsx)?$/);

const loadStories = () => {
  const nonMd = [];
  const md = [];

  for (const filename of req.keys()) {
    if (filename.indexOf('/markdown/') > -1) {
      md.push(filename);
    } else {
      nonMd.push(filename);
    }
  }

  nonMd.forEach((filename) => req(filename));
  md.forEach((filename) => req(filename));
};

configure(loadStories, module);
EOL

echo "Adding Storybook addon config /$STORYBOOK_DIR/addons.js"
cat >$STORYBOOK_DIR/addons.js <<EOL
import '@storybook/addon-options/register';
import '@storybook/addon-actions/register';
import '@storybook/addon-knobs/register';
import '@storybook/addon-notes/register';
import '@storybook/addon-viewport/register';
import '@storybook/addon-backgrounds/register';
EOL

echo "Adding Storybook Webpack config /$STORYBOOK_DIR/webpack.config.js"
cat >$STORYBOOK_DIR/webpack.config.js <<EOL
const path = require('path');
const {compilerOptions} = require('../tsconfig.json');
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');

const SRC_PATH = path.join(__dirname, '../src');

module.exports = {
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: 'ts-loader',
        include: [SRC_PATH],
        options: {
          transpileOnly: true, // use transpileOnly mode to speed-up compilation
          compilerOptions: {
            ...compilerOptions,
            declaration: false,
          },
        },
      },
      {
        test: /\.(png|jpg|gif)$/,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 8192,
            },
          },
        ],
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx', '.gif', '.jpg', '.png'],
    enforceExtension: false,
  },
  plugins: [new ForkTsCheckerWebpackPlugin()],
};
EOL
