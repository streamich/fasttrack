#!/usr/bin/env bash

# Install React.

HELP=false

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
  echo "fasttrack react [options]"
  echo ""
  echo "    Install React"
  echo ""
  echo "Options"
  echo "    -h, --help             show this output"
  exit 0
fi

echo "Installing React and other dependencies."
yarn add react react-dom
yarn add --dev @types/react @types/react-dom

echo "Creating sample component."
mkdir -p src/components
cat >src/components/App.tsx <<EOL
import * as React from 'react';

const App: React.SFC<{}> = () => {
  return (
    <div>
      Hello world!
    </div>
  );
};

export default App;
EOL
