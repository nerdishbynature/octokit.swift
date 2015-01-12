Pod::Spec.new do |s|
  s.name             = "OctoKit.swift"
  s.version          = "0.1.0"
  s.summary          = "Swift port of Octokit.objc"
  s.description      = <<-DESC
                        Swift port of Octokit.objc
                       DESC
  s.homepage         = "https://github.com/nerdishbynature/octokit.swift"
  s.license          = 'MIT'
  s.author           = { "Piet Brauer" => "piet@nerdishbynature.com" }
  s.source           = { :git => "https://github.com/nerdishbynature/octokit.swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pietbrauer'
  s.module_name     = "Octokit"
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod'
end
