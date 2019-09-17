set -o pipefail

xcodebuild clean test -scheme IBMSwiftSDKCore -destination "platform=iOS Simulator,name=iPhone 8" | xcpretty
