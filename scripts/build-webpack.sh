#!/usr/bin/env bash

# Adds Webpack build.

HELP=false
BUILD_WEBPACK_REACT=true
BUILD_WEBPACK_DIR="targets/browser"
BUILD_WEBPACK_DIR_PUBLIC="public"
BUILD_WEBPACK_CONFIG=$BUILD_WEBPACK_DIR/webpack.cofnig.js

# Fetch CLI named params.
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
  echo "fasttrack build-webpack [options]"
  echo ""
  echo "    Adds Webpack build"
  echo ""
  echo "Options"
  echo "    -h, --help             show this output"
  exit 0
fi

echo "Installing Webpack and related dependencies."
yarn add \
  webpack \
  webpack-cli \
  webpack-manifest-plugin \
  webpack-pwa-manifest \
  webpack-bundle-analyzer \
  webpack-dev-server

if [ "$BUILD_WEBPACK_REACT" = true] ; then
  echo "Installing TypeScript loader."
  yarn add ts-loader
fi

echo "Creating target folder '$BUILD_WEBPACK_DIR'."
mkdir -p $BUILD_WEBPACK_DIR

echo "Creating output folder '$BUILD_WEBPACK_DIR_PUBLIC'."
mkdir -p $BUILD_WEBPACK_DIR_PUBLIC

echo "Writing Webpack config at '$BUILD_WEBPACK_CONFIG'."
cat >$BUILD_WEBPACK_CONFIG <<EOL
const webpack = require('webpack');
const path = require('path');
const ManifestPlugin = require('webpack-manifest-plugin');
const WebpackPwaManifest = require('webpack-pwa-manifest');

const DEV = process.env.NODE_ENV !== 'production';
const BUILD_NUM = process.env.CIRCLE_BUILD_NUM;

const plugins = [
  // Global variables.
  new webpack.DefinePlugin({
    __DEV__: JSON.stringify(DEV),
    'process.env': {
      BUILD_NUM: JSON.stringify(BUILD_NUM),
      NODE_ENV: JSON.stringify(process.env.NODE_ENV || 'development'),
    },
  }),

  // List of all files generated by Webpack.
  new ManifestPlugin({
    fileName: 'files.json',
  }),

  // PWA manifest file.
  new WebpackPwaManifest({
    inject: false,
    fingerprints: false,
    name: 'My Project',
    short_name: 'My project',
    description: 'My project app!',
    background_color: '#ffffff',
  }),
];

if (process.env.ANALYZER) {
  plugins.push(new (require('webpack-bundle-analyzer')).BundleAnalyzerPlugin());
}

module.exports = {
  devtool: DEV ? 'source-map' : false,
  mode: DEV ? 'development' : 'production',
  entry: {
    index: path.join(__dirname, 'index.ts'),
  },
  output: {
    filename: '[name].js',
    chunkFilename: '[name].js',
    path: path.join(__dirname, '..', '..', 'public', 'dist'),
    publicPath: '/dist/',
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx'],
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: ['ts-loader'],
      },
    ],
  },
  plugins,
  devServer: {
    contentBase: path.join(__dirname, '..', '..', 'public'),
    publicPath: '/dist/',
    host: '127.0.0.1',
    inline: true,
    watchContentBase: true,
    historyApiFallback: {
      index: 'index.html',
    },
  },
};
EOL

echo "Writing Webpack entry file at '$BUILD_WEBPACK_DIR/index.tsx'."
cat >$BUILD_WEBPACK_DIR/index.tsx <<EOL
import * as React from 'react';
import {render} from 'react-dom';
import App from '../../src/components/App';

const renderApp = () => {
    render(<App />, document.getElementById('app'));
};

export default renderApp;
EOL

echo "Writing Webpack entry index.html at '$BUILD_WEBPACK_DIR_PUBLIC/index.html'."
cat >$BUILD_WEBPACK_DIR_PUBLIC/index.html <<EOL
<!DOCTYPE html>
<html>
  <body>
    <div id="app"></div>
    <script src="./dist/index.js"></script>
  </body>
</html>
EOL

echo "Installing build dependencies."
yarn add --dev rimraf
if ! [ -x "$(command -v climod-add-script)" ]; then
  yarn global add climod-add-script
fi

echo "Adding build and clean scripts."
climod-add-script --name clean --cmd "rimraf $BUILD_WEBPACK_DIR_PUBLIC/dist"
climod-add-script --name build --cmd "webpack -p --config $BUILD_WEBPACK_CONFIG"
climod-add-script --name start --cmd "webpack-dev-server --color --config $BUILD_WEBPACK_CONFIG"
