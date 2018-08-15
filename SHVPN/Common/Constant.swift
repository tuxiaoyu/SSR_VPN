
//
//  Constant.swift
//  SHVPN
//
//  Created by 王雷 on 2017/8/29.
//  Copyright © 2017年 TouchingApp. All rights r.eserved.
//
import UIKit

//device
let  IsIOS6 = ((UIDevice.current.systemVersion as NSString).doubleValue<=7.0)
let  IsIOS7 = ((UIDevice.current.systemVersion as NSString).doubleValue>=7.0)
let  IsIOS8 = ((UIDevice.current.systemVersion as NSString).doubleValue>=8.0)
let  IsIOS9 = ((UIDevice.current.systemVersion as NSString).doubleValue>=9.0)
let  IsIOS10 = ((UIDevice.current.systemVersion as NSString).doubleValue>=10.0)

//frame
let screenHeight = UIScreen.main.bounds.size.height
let screenWidth = UIScreen.main.bounds.size.width

//color
func RGBA (_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    
}
//主颜色
//let mainColor  =   CommUtls .color(withHexString: "#4A90E2")//蓝
let mainColor  =   CommUtls .color(withHexString: "#5CB65B")//绿


//let mainNavBarColor = CommUtls.color(withHexString: "#5CB65B")//绿
//let mainNavBarColor = CommUtls.color(withHexString: "#46474B")//
let mainNavBarColor = UIColor.white

let mainBgColor = CommUtls.color(withHexString: "#F6F6F6")//灰











