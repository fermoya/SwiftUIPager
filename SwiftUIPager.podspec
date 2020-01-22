Pod::Spec.new do |s|

  s.name         = "SwiftUIPager"
  s.version      = "1.1.0"
  s.summary      = "Native pager for SwiftUI. Easily to use, easy to customize."

  s.description  = <<-DESC
  This framework provides a pager build on top of SwiftUI native components. Views are recycled, so you do not have to worry about memory issues. It is very easy to use and lets you customize it. For example, you can change the aspect ratio of the page displayed, the spacing between pages or you can make it interactive.
                   DESC

  s.homepage     = "https://medium.com/@fmdr.ct"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "fermoya" => "fmdr.ct@gmail.com" }

  s.platforms = { :ios => "13.0", :osx => "10.15", :watchos => "6.0" }
  s.swift_version = "5.1"

  s.source       = { :git => "https://github.com/fermoya/SwiftUIPager.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/SwiftUIPager/**/*"

  s.xcconfig = { "SWIFT_VERSION" => "5.1" }
  s.documentation_url = "https://github.com/fermoya/SwiftUIPager/blob/master/README.md"

end
