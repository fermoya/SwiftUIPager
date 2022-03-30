Pod::Spec.new do |s|

  s.name         = "SwiftUIPager"
  s.version      = ENV['LIB_VERSION'] # pod trunk me --verbose
  s.summary      = "Native pager for SwiftUI. Easily to use, easy to customize."

  s.description  = <<-DESC
  This framework provides a pager build on top of SwiftUI native components. Views are recycled, so you do not have to worry about memory issues. It is very easy to use and lets you customize it. For example, you can change the page aspect ratio, the scroll orientation and/or direction, the spacing between pages... It comes with with two pagination effects to make it look even more beautiful.
                   DESC

  s.homepage     = "https://medium.com/@fmdr.ct"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "fermoya" => "fmdr.ct@gmail.com" }

  s.platforms = { :ios => "13.0", :osx => "10.15", :watchos => "6.0", :tvos => "13.0" }
  s.swift_version = "5.1"

  s.source       = { :git => "https://github.com/fermoya/SwiftUIPager.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/SwiftUIPager/**/*.swift"

  s.documentation_url = "https://github.com/fermoya/SwiftUIPager/blob/main/README.md"

end
