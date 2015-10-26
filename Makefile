install:
	bundle check || bundle install --path vendor/bundle
	brew install carthage
	carthage bootstrap

test:
	set -o pipefail && xcodebuild clean test -scheme OctoKit -sdk iphonesimulator9.0 ONLY_ACTIVE_ARCH=NO -destination name="iPhone 6s" | xcpretty -c -r junit --output $(CIRCLE_TEST_REPORTS)/xcode/results.xml
	bundle exec pod lib lint
