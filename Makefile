install:
	brew update
	brew install carthage
	brew install python
	pip install codecov
	carthage bootstrap

test:
	pod lib lint --quick
	set -o pipefail && xcodebuild clean test -scheme OctoKit -sdk iphonesimulator ONLY_ACTIVE_ARCH=YES -enableCodeCoverage YES | xcpretty -c

post_coverage:
	bundle exec slather coverage --input-format profdata -x --ignore "../**/*/Xcode*" --ignore "Carthage/**" --output-directory slather-report --scheme OctoKit Octokit.xcodeproj
	codecov -f slather-report/cobertura.xml
