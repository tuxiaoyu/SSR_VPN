//
//  Manager.swift
//  SHVPN
//
//  Created by LEI on 4/7/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//


import SHVPNBase

import SHVPNModel

import KissXML
import NetworkExtension




public enum ManagerError: Error {
    case invalidProvider
    case vpnStartFail
}

public enum VPNStatus {
    case off
    case connecting
    case on
    case disconnecting
}


public let kDefaultGroupIdentifier = "defaultGroup"
public let kDefaultGroupName = "defaultGroupName"
private let statusIdentifier = "status"

//VPN连接状态的通知
public let kProxyServiceVPNStatusNotification = "kProxyServiceVPNStatusNotification"

//分流文件存储的key值
public let VPNShutConfigKey = "VPNShutConfig"


open class Manager : NSObject{
    
    open static let sharedManager = Manager()
    
    open fileprivate(set) var vpnStatus = VPNStatus.off {
        didSet {
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        }
    }
    

    var observerAdded: Bool = false
    //是否分流
    var isShut: Bool = false
    var pro : Proxy = Proxy.init()
    
    fileprivate override  init() {
        super.init()
       self.loadProviderManager { (manager) -> Void in
            if let manager = manager {
                self.updateVPNStatus(manager)
            }
        }
        
        self.addVPNStatusObserver()
    }
    
    func addVPNStatusObserver() {
        guard !observerAdded else{
            return
        }
        loadProviderManager { [unowned self] (manager) -> Void in
            if let manager = manager {
                self.observerAdded = true
                NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: manager.connection, queue: OperationQueue.main, using: { [unowned self] (notification) -> Void in
                    self.updateVPNStatus(manager)
                })
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //连接的状态
    var status = ""
   
    func updateVPNStatus(_ manager: NEVPNManager) {
        switch manager.connection.status {
        case .connected:
            self.vpnStatus = .on
            status = "on"
        case .connecting, .reasserting:
            self.vpnStatus = .connecting
            status = "connecting"
        case .disconnecting:
            self.vpnStatus = .disconnecting
            status = "disconnecting"
        case .disconnected, .invalid:
            self.vpnStatus = .off
            status = "off"
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "vpnStatusNotification"), object: nil, userInfo: ["status":status])
    }

    
  
    open func switchVPN(_ completion: ((NETunnelProviderManager?, Error?) -> Void)? = nil) {
        loadProviderManager { [unowned self] (manager) in
            if let manager = manager {
                self.updateVPNStatus(manager)
            }
            let current = self.vpnStatus
            guard current != .connecting && current != .disconnecting else {
                return
            }
            if current == .off {
                self.startVPN { (manager, error) -> Void in
                    completion?(manager, error)
                }
            }else {
                self.stopVPN()
                completion?(nil, nil)
            }

        }
    }
    
    //MARK  today中的数据
    open func switchVPNFromTodayWidget(_ context: NSExtensionContext) {
        if let url = URL(string: "SHVPN://switch") {
            context.open(url, completionHandler: nil)
        }
    }
    
//    open func setup() {
//        setupDefaultReaml()
//        do {
//            try copyGEOIPData()
//        }catch{
//            print("copyGEOIPData fail")
//        }
//        do {
//            try copyTemplateData()
//        }catch{
//            print("copyTemplateData fail")
//        }
//    }

    func copyGEOIPData() throws {
        guard let fromURL = Bundle.main.url(forResource: "GeoLite2-Country", withExtension: "mmdb") else {
            return
        }
        let toURL = SHVPN.sharedUrl().appendingPathComponent("GeoLite2-Country.mmdb")
        if FileManager.default.fileExists(atPath: fromURL.path) {
            if FileManager.default.fileExists(atPath: toURL.path) {
                try FileManager.default.removeItem(at: toURL)
            }
            try FileManager.default.copyItem(at: fromURL, to: toURL)
        }
    }

    func copyTemplateData() throws {
        guard let bundleURL = Bundle.main.url(forResource: "template", withExtension: "bundle") else {
            return
        }
        let fm = FileManager.default
        let toDirectoryURL = SHVPN.sharedUrl().appendingPathComponent("httptemplate")
        if !fm.fileExists(atPath: toDirectoryURL.path) {
            try fm.createDirectory(at: toDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        for file in try fm.contentsOfDirectory(atPath: bundleURL.path) {
            let destURL = toDirectoryURL.appendingPathComponent(file)
            let dataURL = bundleURL.appendingPathComponent(file)
            if FileManager.default.fileExists(atPath: dataURL.path) {
                if FileManager.default.fileExists(atPath: destURL.path) {
                    try FileManager.default.removeItem(at: destURL)
                }
                try fm.copyItem(at: dataURL, to: destURL)
            }
        }
    }


    
    open func setDefaultConfigGroup(_ id: String, name: String) {
        do {
            try regenerateConfigFiles()
        } catch {

        }
        SHVPN.sharedUserDefaults().set(id, forKey: kDefaultGroupIdentifier)
        SHVPN.sharedUserDefaults().set(name, forKey: kDefaultGroupName)
        SHVPN.sharedUserDefaults().synchronize()
    }
    
    open func regenerateConfigFiles() throws {
        // 保存dns设置 保存到了这里：sharedGeneralConfUrl
//        try generateGeneralConfig()
        // 保存一个sock5连接设置 保存到了这里：sharedSocksConfUrl
        try generateSocksConfig()
        // 保存shadowsock的配置 保存到了这里：sharedProxyConfUrl
        try generateShadowsocksConfig()
        // 这里似乎是设置http的过滤需求 保存到了这里包含了本地的监听端口127.0.0.1:0、keepalive的时间、sock－time－out时间等
        // 另外还解析了自定义的过滤规则以及本来就带有的规则
        try generateHttpProxyConfig()
    }

}

extension Manager {
    
    //MARK  设置默认的线路配置参数（更改）
    var upstreamProxy: Proxy? {

      return  self.pro
    }
    
    //Mark 当代理没有设置或者第一次进入App  设置代理（后期修改  走后台的接口数据）
    var defaultToProxy: Bool {

        return false

    }

    
    func generateSocksConfig() throws {
        let root = NSXMLElement.element(withName: "antinatconfig") as! NSXMLElement
        let interface = NSXMLElement.element(withName: "interface", children: nil, attributes: [NSXMLNode.attribute(withName: "value", stringValue: "127.0.0.1") as! DDXMLNode]) as! NSXMLElement
        root.addChild(interface)
        
        let port = NSXMLElement.element(withName: "port", children: nil, attributes: [NSXMLNode.attribute(withName: "value", stringValue: "0") as! DDXMLNode])  as! NSXMLElement
        root.addChild(port)
        
        let maxbindwait = NSXMLElement.element(withName: "maxbindwait", children: nil, attributes: [NSXMLNode.attribute(withName: "value", stringValue: "10") as! DDXMLNode]) as! NSXMLElement
        root.addChild(maxbindwait)
        
        
        let authchoice = NSXMLElement.element(withName: "authchoice") as! NSXMLElement
        let select = NSXMLElement.element(withName: "select", children: nil, attributes: [NSXMLNode.attribute(withName: "mechanism", stringValue: "anonymous") as! DDXMLNode])  as! NSXMLElement
        
        authchoice.addChild(select)
        root.addChild(authchoice)
        
        let filter = NSXMLElement.element(withName: "filter") as! NSXMLElement
        if let upstreamProxy = upstreamProxy {
            let chain = NSXMLElement.element(withName: "chain", children: nil, attributes: [NSXMLNode.attribute(withName: "name", stringValue: upstreamProxy.name) as! DDXMLNode]) as! NSXMLElement
            switch upstreamProxy.typeRaw {
//            case .Shadowsocks:
//                let uriString = "socks5://127.0.0.1:${ssport}"
//                let uri = NSXMLElement.element(withName: "uri", children: nil, attributes: [NSXMLNode.attribute(withName: "value", stringValue: uriString) as! DDXMLNode]) as! NSXMLElement
//                chain.addChild(uri)
//                let authscheme = NSXMLElement.element(withName: "authscheme", children: nil, attributes: [NSXMLNode.attribute(withName: "value", stringValue: "anonymous") as! DDXMLNode]) as! NSXMLElement
//                chain.addChild(authscheme)
            default:
                break
            }
            root.addChild(chain)
        }
        
        let accept = NSXMLElement.element(withName: "accept") as! NSXMLElement
        filter.addChild(accept)
        root.addChild(filter)
        
        let socksConf = root.xmlString
        try socksConf.write(to: SHVPN.sharedSocksConfUrl(), atomically: true, encoding: String.Encoding.utf8)
    }
    
    func generateShadowsocksConfig() throws {
        let confURL = SHVPN.sharedProxyConfUrl()
        var content = ""
        if let upstreamProxy = upstreamProxy, upstreamProxy.typeRaw ==  "SSR" {
            var arr = ["host": upstreamProxy.host, "port": upstreamProxy.port, "password": upstreamProxy.password ?? "", "authscheme": upstreamProxy.authscheme ?? "", "ota": upstreamProxy.ota, "protocol": upstreamProxy.ssrProtocol ?? "", "obfs": upstreamProxy.ssrObfs ?? "", "obfs_param": upstreamProxy.ssrObfsParam ?? ""] as [String : Any]
            
            do {
                
                let data = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.prettyPrinted)
                content = String(data: data, encoding: String.Encoding.utf8) ?? ""
            }
        }
        try content.write(to: confURL, atomically: true, encoding: String.Encoding.utf8)
    }
    
    func generateHttpProxyConfig() throws {
        let rootUrl = SHVPN.sharedUrl()
        let confDirUrl = rootUrl.appendingPathComponent("httpconf")
        let templateDirPath = rootUrl.appendingPathComponent("httptemplate").path
        let temporaryDirPath = rootUrl.appendingPathComponent("httptemporary").path
        let logDir = rootUrl.appendingPathComponent("log").path
        let maxminddbPath = SHVPN.sharedUrl().appendingPathComponent("GeoLite2-Country.mmdb").path
        let userActionUrl = confDirUrl.appendingPathComponent("SHVPN.action")
        for p in [confDirUrl.path, templateDirPath, temporaryDirPath, logDir] {
            if !FileManager.default.fileExists(atPath: p) {
                _ = try? FileManager.default.createDirectory(atPath: p, withIntermediateDirectories: true, attributes: nil)
            }
        }
        var mainConf: [String: AnyObject] = [:]
        if let path = Bundle.main.path(forResource: "proxy", ofType: "plist"), let defaultConf = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            mainConf = defaultConf
        }
        mainConf["confdir"] = confDirUrl.path as AnyObject?
        mainConf["templdir"] = templateDirPath as AnyObject?
        mainConf["logdir"] = logDir as AnyObject?
        mainConf["mmdbpath"] = maxminddbPath as AnyObject?
        
        mainConf["global-mode"] = defaultToProxy as AnyObject?
        
        mainConf["debug"] = 1024+65536+1 as AnyObject?
//        mainConf["debug"] = 131071
//        mainConf["debug"] = mainConf["debug"] as! Int + 4096
        mainConf["actionsfile"] = userActionUrl.path as AnyObject?

        let mainContent = mainConf.map { "\($0) \($1)"}.joined(separator: "\n")
        try mainContent.write(to: SHVPN.sharedHttpProxyConfUrl(), atomically: true, encoding: String.Encoding.utf8)

        var actionContent: [String] = []
        var forwardURLRules: [String] = []
        let forwardIPRules: [String] = []
        let forwardGEOIPRules: [String] = []
        //分流

        let jsonString: String;

        if isShut == true{
            
              // 获取分流文件
//            if ((UserDefaults.standard.string(forKey: VPNShutConfigKey)) != nil){
//                //取后台的分流配置文件
//                jsonString = UserDefaults.standard.string(forKey: VPNShutConfigKey)!
//            }else{
                //取本地的分流文件
                jsonString = Pollution.JSONString
//            }
            
        }else{
            //未分流
            jsonString = Pollution.ALLJSONString;
            
        }

        if jsonString.characters.count > 0 {
            let data = jsonString.data(using: .utf8);
            let array = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray;
            
            let temp = array.map {"\(String(describing: ($0 as! NSDictionary).object(forKey: "type")!))" + "," + "\(String(describing: ($0 as! NSDictionary).object(forKey: "value")!))" + "," + "\(String(describing: ($0 as! NSDictionary).object(forKey: "action")!))"}

            for item in temp {
                forwardURLRules.append(item)
            }
        }

        
        if forwardURLRules.count > 0 {
            actionContent.append("{+forward-rule}")
            actionContent.append(contentsOf: forwardURLRules)
        }

        if forwardIPRules.count > 0 {
            actionContent.append("{+forward-rule}")
            actionContent.append(contentsOf: forwardIPRules)
        }

        if forwardGEOIPRules.count > 0 {
            actionContent.append("{+forward-rule}")
            actionContent.append(contentsOf: forwardGEOIPRules)
        }

        // DNS pollution
        actionContent.append("{+forward-rule}")
        actionContent.append(contentsOf: Pollution.dnsList.map({ "DNS-IP-CIDR, \($0)/32, PROXY" }))

        let userActionString = actionContent.joined(separator: "\n")
        try userActionString.write(toFile: userActionUrl.path, atomically: true, encoding: String.Encoding.utf8)
    }

}

extension Manager {

    //MARK:是否分流的字段 可以直接调用（由UI界面直接传数据）
    public func setIsShut(Shut:Bool){
        self.isShut = Shut
    }
    
    //MARK:当前代理(由UI界面传数据)
    public func setCurrentProxy( currentProxy : Proxy){
        
           self.pro = currentProxy
    }
    
    //MARK: 保存分流文件直接调用该方法配置分流文件（由UI界面直接传数据）
    public  func setVPNConfige( configString : String ) -> Void {
        UserDefaults.standard.set(configString, forKey: VPNShutConfigKey)
    }
    
    
    public func isVPNStarted(_ complete: @escaping (Bool, NETunnelProviderManager?) -> Void) {
        loadProviderManager { (manager) -> Void in
            if let manager = manager {
                complete(manager.connection.status == .connected, manager)
            }else{
                complete(false, nil)
            }
        }
    }
    
    public func startVPN(_ complete: ((NETunnelProviderManager?, Error?) -> Void)? = nil) {
        startVPNWithOptions(nil, complete: complete)
    }
    
    fileprivate func startVPNWithOptions(_ options: [String : NSObject]?, complete: ((NETunnelProviderManager?, Error?) -> Void)? = nil) {
        // regenerate config files
        do {
            try Manager.sharedManager.regenerateConfigFiles()
        }catch {
            complete?(nil, error)
            return
        }
        // Load provider
        loadAndCreateProviderManager { (manager, error) -> Void in
            if let error = error {
                complete?(nil, error)
            }else{
                guard let manager = manager else {
                    complete?(nil, ManagerError.invalidProvider)
                    return
                }
                if manager.connection.status == .disconnected || manager.connection.status == .invalid {
                    do {
                        try manager.connection.startVPNTunnel(options: options)
                        self.addVPNStatusObserver()
                        complete?(manager, nil)
                    }catch {
                        complete?(nil, error)
                    }
                }else{
                    self.addVPNStatusObserver()
                    complete?(manager, nil)
                }
            }
        }
    }
    
    public func stopVPN() {
        // Stop provider
        loadProviderManager { (manager) -> Void in
            guard let manager = manager else {
                return
            }
            manager.connection.stopVPNTunnel()
        }
    }
    
    public func postMessage() {
        loadProviderManager { (manager) -> Void in
            if let session = manager?.connection as? NETunnelProviderSession,
                let message = "Hello".data(using: String.Encoding.utf8), manager?.connection.status != .invalid
            {
                do {
                    try session.sendProviderMessage(message) { response in
                        
                    }
                } catch {
                    print("Failed to send a message to the provider")
                }
            }
        }
    }
    
    fileprivate func loadAndCreateProviderManager(_ complete: @escaping (NETunnelProviderManager?, Error?) -> Void ) {
        NETunnelProviderManager.loadAllFromPreferences { [unowned self] (managers, error) -> Void in
            if let managers = managers {
                let manager: NETunnelProviderManager
                if managers.count > 0 {
                    manager = managers[0]
                }else{
                    manager = self.createProviderManager()
                }
                manager.isEnabled = true
                manager.localizedDescription = "app_vpn"
                manager.protocolConfiguration?.serverAddress = "Return App Connect"
                manager.isOnDemandEnabled = true
                let quickStartRule = NEOnDemandRuleEvaluateConnection()
                quickStartRule.connectionRules = [NEEvaluateConnectionRule(matchDomains: ["connect.SHVPN.com"], andAction: NEEvaluateConnectionRuleAction.connectIfNeeded)]
                manager.onDemandRules = [quickStartRule]
                manager.saveToPreferences(completionHandler: { (error) -> Void in
                    if let error = error {
                        complete(nil, error)
                    }else{
                        manager.loadFromPreferences(completionHandler: { (error) -> Void in
                            if let error = error {
                                complete(nil, error)
                            }else{
                                complete(manager, nil)
                            }
                        })
                    }
                })
            }else{
                complete(nil, error)
            }
        }
    }
    
    public func loadProviderManager(_ complete: @escaping (NETunnelProviderManager?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) -> Void in
            if let managers = managers {
                if managers.count > 0 {
                    let manager = managers[0]
                    complete(manager)
                    return
                }
            }
            complete(nil)
        }
    }
    
    fileprivate func createProviderManager() -> NETunnelProviderManager {
        let manager = NETunnelProviderManager()
        manager.protocolConfiguration = NETunnelProviderProtocol()
        return manager
    }

}

