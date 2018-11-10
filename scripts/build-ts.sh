DIST="lib" # Distribution folder.
# Setup build.
echo "Setting up build."
yarn add --dev rimraf
climod-add-script --name clean --cmd "rimraf $DIST"
climod-add-script --name build --cmd "tsc"
climod-json --file package.json --key files --set "[\"${DIST}/\"]" --json
climod-json --file package.json --key main --set "lib/index.js"
climod-json --file package.json --key types --set "lib/index.d.ts"
climod-json --file package.json --key typings --set "lib/index.d.ts"
