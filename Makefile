install:
	brew install carthage
	carthage bootstrap

test:
	set -o pipefail && xcodebuild clean test -scheme OctoKit -sdk iphonesimulator | xcpretty -c -r junit --output $(CIRCLE_TEST_REPORTS)/xcode/results.xml
