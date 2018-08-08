
Pod::Spec.new do |s|

  s.name         = "RQJsonKit"
  s.version      = "0.0.1"
  s.summary      = "An easy tool for json to model."
  s.homepage     = "https://github.com/18703637316/RQJsonKit.git"
  s.license      = "MIT (example)"
  s.license      = { :type => 'MIT', :text => <<-LICENSE
                      FREE BY REN.QIANGQIANG
                      LICENSE
                   }
  s.author             = { "REN.QIANGQIANG" => "18703637316@163.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/18703637316/RQJsonKit.git", :tag => "#{s.version}" }
  s.source_files  = "RQJsonKit", "RQJsonKit/**/*.{h,m}"

end
