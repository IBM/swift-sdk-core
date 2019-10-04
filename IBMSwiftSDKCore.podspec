Pod::Spec.new do |s|

  s.name                  = 'IBMSwiftSDKCore'
  s.version               = '1.0.0'
  s.summary               = 'Networking layer for the IBM Swift SDKs'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.homepage              = 'https://www.ibm.com/watson/'
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'IBMSwiftSDKCore'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/IBM/swift-sdk-core', :tag => s.version.to_s }

  s.source_files          = 'Sources/**/*.swift'
  s.swift_version         = '4.2'

end
