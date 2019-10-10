# Run pod lint and integration tests on macOS

set -eu

# We use cocoapods swift_version arrays in the DSL
# so >=1.7.0 is required
sudo gem install cocoapods -v 1.8.3

./Scripts/pod-lint.sh
./Scripts/run-ios-tests.sh
