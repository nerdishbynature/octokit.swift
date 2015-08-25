install:
	bundle check || bundle install	
	bundle exec pod install --project-directory=Example
	brew install carthage

test:
	make install
	set -o pipefail && xcodebuild clean test -workspace OctokitSwift.xcworkspace -scheme OctokitSwift -sdk iphonesimulator8.3 ONLY_ACTIVE_ARCH=NO -destination name="iPhone 6" | xcpretty -c -r junit --output $(CIRCLE_TEST_REPORTS)/xcode/results.xml
