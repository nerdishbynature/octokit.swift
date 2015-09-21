install:
	bundle check || bundle install --path vendor/bundle
	bundle exec pod install --project-directory=Example
	brew install carthage

test:
	set -o pipefail && xcodebuild clean test -workspace OctokitSwift.xcworkspace -scheme OctokitSwift -sdk iphonesimulator9.0 ONLY_ACTIVE_ARCH=NO -destination name="iPhone 6s" | xcpretty -c -r junit --output $(CIRCLE_TEST_REPORTS)/xcode/results.xml
