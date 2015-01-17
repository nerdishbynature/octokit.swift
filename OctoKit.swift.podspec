Pod::Spec.new do |s|
  s.name             = "OctoKit.swift"
  s.version          = "0.1.0"
  s.summary          = "Swift version of the Octokit family"
  s.description      = <<-DESC
                        You are looking at the Swift port of the
                        Octokit family. This is very unofficial and not maintained
                        by Github.
                       DESC
  s.homepage         = "https://github.com/nerdishbynature/octokit.swift"
  s.license          = 'MIT'
  s.author           = { "Piet Brauer" => "piet@nerdishbynature.com" }
  s.source           = { :git => "git://github.com/nerdishbynature/octokit.swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pietbrauer'
  s.module_name     = "Octokit"
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod'
  s.dependency "Alamofire", "~> 1.1.3"
end
