# Codegen.
SRC="src" # Source folder.
echo "Adding sample code."
mkdir -p $SRC
cat >$SRC/index.ts <<EOL
console.log('Hello world!'); // tslint:disable-line no-console
EOL
