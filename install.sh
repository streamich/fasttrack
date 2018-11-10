BIN_FOLDER="/usr/local/bin"
FASTTRACK="https://raw.githubusercontent.com/streamich/fasttrack/master/fasttrack"

curl -o $BIN_FOLDER/fasttrack $FASTTRACK
cp $BIN_FOLDER/fasttrack $BIN_FOLDER/ft
chmod +x $BIN_FOLDER/fasttrack
chmod +x $BIN_FOLDER/ft
