Pod::Spec.new do |s|
  s.name         = "Zune"
  s.version      = "0.1.0"
  s.summary      = "Http and Socks proxy based on Privoxy and Antinat"
  s.description  = <<-DESC
                   Http and Socks proxy based on Privoxy and Antinat.
                   DESC
  s.homepage     = "http://icodesign.me"
  s.license      = "GPLv2"
  s.author        = { "iCodesign" => "leimagnet@gmail.com" }
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.source_files  = "Zune", "Zune/**/*.{c,h,m,swift}"
  s.libraries = "z"
  s.pod_target_xcconfig = {
    'OTHER_CFLAGS' => '-DHAVE_CONFIG_H -DUSE_CRYPTO_OPENSSL -DLIB_ONLY -DUDPRELAY_LOCAL -DMODULE_LOCAL',
    # 'HEADER_SEARCH_PATHS' => '',
  }
  s.vendored_libraries = 'lib/Antinat/expat-lib/lib/libexpat.a', 'lib/shadowsocks-libev/libopenssl/lib/libcrypto.a', 'lib/shadowsocks-libev/libopenssl/lib/libssl.a', 'lib/shadowsocks-libev/libsodium-ios/lib/libsodium.a'
end