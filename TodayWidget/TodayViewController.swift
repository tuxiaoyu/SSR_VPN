//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by LEI on 4/12/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import NotificationCenter
import SHVPNBase
import SHVPNLibrary
import CocoaAsyncSocket
import SHVPNModel


public let todayGroup = "group.VPN416.CN"
class TodayViewController: UIViewController {

    
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var changeRouteBtn: UIButton!
    
    @IBOutlet weak var VPNSwitch: UISwitch!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var routDic:NSDictionary = NSDictionary.init()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let shareData = UserDefaults.init(suiteName: todayGroup);
        //用户信息
        let userInfo = shareData?.value(forKey: "userInfo");
        let userInfoDic = self.getDictionaryFromJsonString(jsonString: (userInfo as? String)!)
        let dic:NSDictionary = userInfoDic.object(forKey: "data") as! NSDictionary
        //有效期限
        let str = dic.object(forKey: "user_expiration_date") as! String

        self.timeLabel.text = String.init(format: "有效期限：%@", str )
        
        //线路信息
        let routeInfo = shareData?.value(forKey: "routeDetail");
        let routeInfoDic = self.getDictionaryFromJsonString(jsonString: (routeInfo as? String)!)
        let routeDic:NSDictionary = routeInfoDic.object(forKey: "data") as! NSDictionary
        
        self.routDic = routeDic
        
        let routeStr = routeDic.object(forKey: "vps_area_name") as! String

        self.routeLabel.text = String.init(format: "线路：%@", routeStr)
        print("用户信息",  userInfoDic as Any);
        print("线路信息",  routeInfoDic as Any);
        
        self.changeRouteBtn.addTarget(self, action: #selector(changeRoute), for: UIControlEvents.touchUpInside)
        
        
        let conectStatus :String = shareData?.value(forKey: "connectState") as! String
        
        if conectStatus == "1" {
            self.VPNSwitch.isOn = true
        }else{
            self.VPNSwitch.isOn = false
        }
        
        
        self.VPNSwitch.addTarget(self, action: #selector(vpnLink), for: UIControlEvents.valueChanged)
        //ss连接方式的通知
        
        NotificationCenter.default.addObserver(self, selector: #selector(vpnStatusChange(nofication:)), name: NSNotification.Name(rawValue: "vpnStatusNotification"), object: nil)

        let pro:Proxy = Proxy.init()
        pro.host = self.routDic.value(forKey: "vps_addr") as! String
        pro.password = self.routDic.value(forKey: "ss_pass") as? String
        pro.authscheme = self.routDic.value(forKey: "encrypt") as? String
        pro.port = Int((self.routDic.value(forKey: "port") as? String)!)!
        pro.ssrProtocol = self.routDic.value(forKey: "ss_protocol") as? String
        pro.ssrObfs = self.routDic.value(forKey: "ss_mix") as? String
        pro.typeRaw = "SSR"
        Manager.sharedManager.setCurrentProxy(currentProxy: pro)
        
    }


    //vpn连接
    func vpnLink() {
        
        if self.VPNSwitch.isOn {
            Manager.sharedManager.stopVPN()
            self.VPNSwitch.isOn = false
        }else{
  
            
            Manager.sharedManager.switchVPN()
            self.VPNSwitch.isOn = true
        }
    
    }
    
    func vpnStatusChange(nofication:NSNotification) {
        let dic :NSDictionary  = nofication.userInfo! as NSDictionary
        
        let status:String = dic.value(forKey: "status") as! String
        
        if status == "on"{
            //连接成功
          self.VPNSwitch.isOn = true
        }
        
        if status == "off"{
            //未连接
           self.VPNSwitch.isOn = false
        }
        
        if status == "connecting"{
            //连接中
            self.VPNSwitch.isOn = true
            
        }
        if status == "disconnecting"{
            self.VPNSwitch.isOn = false
        }
        
    }
    
    //json字符串转换
    func getDictionaryFromJsonString(jsonString:String) -> NSDictionary {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try?JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        
        if dict != nil {
            return dict as! NSDictionary
        }
        
        return NSDictionary()
    }
    
    
    //更换线路
    func changeRoute() {
        
        self.extensionContext?.open(URL.init(string: "App://routeList")!, completionHandler: nil)
    }
    
    func widgetPerformUpdate(_ completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
   
    
    
}
