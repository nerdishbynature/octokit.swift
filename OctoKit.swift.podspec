Pod::Spec.new do |s|
  s.name             = "OctoKit.swift"
  s.version          = "0.7.4"
  s.summary          = "A Swift API Client for GitHub and GitHub Enterprise"
  s.description      = <<-DESC
                        You are looking at the A Swift API Client for GitHub and GitHub Enterprise.
                        This is very unofficial and not maintained by Github.
                        DESC
  s.homepage         = "https://github.com/nerdishbynature/octokit.swift"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Piet Brauer" => "piet@nerdishbynature.com" }
  s.source           = { :git => "https://github.com/nerdishbynature/octokit.swift.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/pietbrauer"
  s.module_name     = "Octokit"
  s.dependency "NBNRequestKit", "~> 2.0"
  s.requires_arc = true
  s.source_files = "OctoKit/*.swift"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
end
