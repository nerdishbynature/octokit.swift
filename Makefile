SHA=$(shell git rev-parse HEAD)
BRANCH=$(shell git name-rev --name-only HEAD)

install:
	brew outdated carthage || brew upgrade carthage || brew install carthage
	carthage bootstrap

test:
	bundle exec fastlane code_coverage configuration:Debug --env default

post_coverage:
	bundle exec slather coverage --input-format profdata -x --ignore "../**/*/Xcode*" --ignore "Carthage/**" --output-directory slather-report --scheme OctoKit OctoKit.xcodeproj
	curl -X POST -d @slather-report/cobertura.xml "https://codecov.io/upload/v2?token="$(CODECOV_TOKEN)"&commit="$(SHA)"&branch="$(BRANCH)"&job="$(TRAVIS_BUILD_NUMBER)

