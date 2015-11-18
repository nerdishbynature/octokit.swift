install:
	brew update
	brew install carthage
	carthage bootstrap

test:
	set -o pipefail && xcodebuild clean test -scheme OctoKit -sdk iphonesimulator | xcpretty -c
