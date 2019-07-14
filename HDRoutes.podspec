Pod::Spec.new do |s|
  s.name         = "HDRoutes"
  s.version      = "0.3.0"
  s.summary      = "URL routing library for iOS with a simple API written in Swift 5."
  s.homepage     = "https://github.com/wangwanjie/HDLRoutes"
  s.license      = "BSD 3-Clause \"New\" License"
  s.author       = { "VanJay" => "wangwanjie1993@gmail.com" }
  s.source       = { :git => "https://github.com/wangwanjie/HDRoutes.git", :tag => "0.3.0" }
  s.framework    = 'Foundation'
  s.requires_arc = true
  s.swift_version = "5"

  s.source_files = 'HDRoutes', 'HDRoutes/*.{swift}', 'HDRoutes/Classes/*.{swift}'

  s.ios.deployment_target = '10.0'
end
