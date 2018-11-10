# Add semantic-release.
echo "Adding semantic-release."
yarn add --dev \
  semantic-release \
  @semantic-release/changelog \
  @semantic-release/npm \
  @semantic-release/git
climod-add-script --name release --cmd "semantic-release"
climod-json --file package.json --key release --json --set "{\"verifyConditions\": [\"@semantic-release/changelog\",\"@semantic-release/npm\",\"@semantic-release/git\"], \"prepare\": [\"@semantic-release/changelog\",\"@semantic-release/npm\",\"@semantic-release/git\"]}"
