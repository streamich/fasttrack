# Add Commitizen config.
echo "Adding Commitizen config."
climod-json --file package.json --key "config.commitizen.path" --set "git-cz"
