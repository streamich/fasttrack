# Add Git.
echo "Adding Git"
git init
git config user.name "$USERNAME"
git add -A
git commit -m "chore: setup project with <https://github.com/streamich/fasttrack>" --no-verify
