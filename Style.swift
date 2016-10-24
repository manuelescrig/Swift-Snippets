//
//  Style.swift
//  Amcor POC
//
//  Created by Manuel on 9/30/16.
//  Copyright © 2016 Liip AG. All rights reserved.
//

import UIKit
import SystemConfiguration

struct Style {

    static var themeTitleFont = UIFont(name: "HelveticaNeue-Light", size: 23)
    static var themeSubtTitleFont = UIFont(name: "HelveticaNeue-Medium", size: 19)
    static var themeNavigationBarTitleFont = UIFont(name: "HelveticaNeue-Medium", size: 21)
    static var themeParagraphFont = UIFont(name: "HelveticaNeue-Light", size: 17)
    static var themeButtonFont = UIFont(name: "HelveticaNeue-Medium", size: 17)
    static var themeStatusFont = UIFont(name: "HelveticaNeue-Medium", size: 15)
    
    static var systemFont = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightBold)
    static var smallCapsDesc = systemFont.fontDescriptor.addingAttributes([
        UIFontDescriptorFeatureSettingsAttribute: [
            [
                UIFontFeatureTypeIdentifierKey: kUpperCaseType,
                UIFontFeatureSelectorIdentifierKey: kUpperCaseSmallCapsSelector
            ]
        ]
        ])
    static var themeLogoFont = UIFont(descriptor: smallCapsDesc, size: systemFont.pointSize)

    
    
    static var themeTextColor = UIColor.init(colorLiteralRed: 0/255.0, green: 32/255.0, blue: 47/255.0, alpha: 1)
    static var themeDarkColor = UIColor.init(colorLiteralRed: 0/255.0, green: 47/255.0, blue: 71/255.0, alpha: 1)
    static var themeColor = UIColor.init(colorLiteralRed: 0/255.0, green: 73/255.0, blue: 102/255.0, alpha: 1)
    static var themeLightColor = UIColor.init(colorLiteralRed: 141/255.0, green: 215/255.0, blue: 248/255.0, alpha: 1)
    static var themeSecondColor = UIColor.init(colorLiteralRed: 20/255.0, green: 179/255.0, blue: 98/255.0, alpha: 1)
    static var themeSecondLightColor = UIColor.init(colorLiteralRed: 135/255.0, green: 204/255.0, blue: 161/255.0, alpha: 1)
    static var themeBackgroundColor = UIColor.white
    
    static var themeCornerRadius = 13
    static var themeNavigationBarHeight: CGFloat = 44
    static var themeTableHeaderHeight: CGFloat = 44
    static var themeTableCellHeight: CGFloat = 56

    static var cameraTipsDelayTime: Double = 13
    static var cameraTipsHelpAnimationTime: Double = 13

    static var cameraTipAnimationTime: Double = 0.22
    static var cameraTipDurationTime: Double = 3.5
    
}


struct Keys {
    
    static var userDefaultsPassword = "userDefaultsPassword"
    static var userDefaultsPasswordLength = 4

    static var scanViewController = "scanViewController"
    static var scanHistoryViewController = "scanHistoryViewController"

}



// MARK: Util methods

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func platform() -> String {
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)! as String
}


func isInternetAvailable() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}


