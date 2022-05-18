DB=$(pwd)/databases/nekohtml-$(git rev-parse --short HEAD)

codeql database create --overwrite --language=java -s . -v $DB --command="ant -f build.xml"
