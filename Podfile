source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!

def library
    pod 'KissXML'
    pod 'KissXML/libxml_module'

end

def tunnel
    pod 'MMWormhole', '~> 2.0.0'
end

def socket
    pod 'CocoaAsyncSocket', '~> 7.4.3'
end


target "SHVPN" do

    pod 'AFNetworking', '~> 3.1.0'
    
    pod 'MBProgressHUD'

    pod 'IQKeyboardManager', '~> 5.0.8'

    pod 'SDWebImage', '~> 4.3.3'
    pod 'SVProgressHUD', '~> 2.0.3'
     pod 'Masonry', '~> 1.1.0'
     
     pod 'LBXScan/UI','~> 2.2'
     pod 'SDCycleScrollView', '~> 1.74'
    library
    socket
end

target "PacketTunnel" do
    tunnel
    socket
end

target "SwordProcessor" do
    socket
end

target "TodayWidget" do
    library
    socket
    
end

target "SHVPNLibrary" do
    library
end



