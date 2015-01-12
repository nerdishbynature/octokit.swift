install:
	bundle check || bundle install	
	bundle exec pod install --project-directory=Example

test:
	make install
	set -o pipefail && xcodebuild clean test -workspace OctokitSwift.xcworkspace -scheme OctokitSwift -sdk iphonesimulator8.1 ONLY_ACTIVE_ARCH=NO -destination name="iPhone 6" | xcpretty -tc
