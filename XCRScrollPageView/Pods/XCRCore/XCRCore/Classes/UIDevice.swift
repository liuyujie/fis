//
//  UIDevice.swift
//  XCRCore
//
//  Created by ZhangAimin on 2017/9/18.
//

import UIKit
import AdSupport

/// XCRCore
private let DeviceList = [
    "iPod1,1": "iPod Touch",
    "iPod2,1": "iPod Touch 2",
    "iPod3,1": "iPod Touch 3",
    "iPod4,1": "iPod Touch 4",
    "iPod5,1": "iPod Touch 5",
    "iPod7,1": "iPod Touch 6",

    "iPhone3,1": "iPhone 4 (GSM)",
    "iPhone3,2": "iPhone 4",
    "iPhone3,3": "iPhone 4 (CDMA/Verizon/Sprint)",
    "iPhone4,1": "iPhone 4s",
    "iPhone5,1": "iPhone 5 (GSM)",
    "iPhone5,2": "iPhone 5 (GSM+CDMA)",
    "iPhone5,3": "iPhone 5c (GSM)",
    "iPhone5,4": "iPhone 5c (GSM+CDMA)",
    "iPhone6,1": "iPhone 5s (GSM)",
    "iPhone6,2": "iPhone 5s (GSM+CDMA)",
    "iPhone7,2": "iPhone 6",
    "iPhone7,1": "iPhone 6 Plus",
    "iPhone8,1": "iPhone 6s",
    "iPhone8,2": "iPhone 6s Plus",
    "iPhone8,4": "iPhone SE",
    "iPhone9,1": "iPhone 7 (CDMA)",
    "iPhone9,3": "iPhone 7 (GSM)",
    "iPhone9,2": "iPhone 7 Plus (CDMA)",
    "iPhone9,4": "iPhone 7 Plus (GSM)",

    "iPhone10,1": "iPhone 8 (CDMA+GSM/LTE)",
    "iPhone10,4": "iPhone 8 (GSM/LTE)",
    "iPhone10,2": "iPhone 8 Plus (CDMA+GSM/LTE)",
    "iPhone10,5": "iPhone 8 Plus (GSM/LTE)",

    "iPhone10,3": "iPhone X (CDMA+GSM/LTE)",
    "iPhone10,6": "iPhone X (GSM/LTE)",

    "iPad1,1": "iPad (Wifi)",
    "iPad1,2": "iPad (Cellular)",

    "iPad2,1": "iPad 2 (WiFi)",
    "iPad2,2": "iPad 2 (GSM)",
    "iPad2,3": "iPad 2 (CDMA)",
    "iPad2,4": "iPad 2 (WiFi Rev A)",
    "iPad2,5": "iPad Mini (WiFi)",
    "iPad2,6": "iPad Mini (GSM)",
    "iPad2,7": "iPad Mini (GSM+CDMA)",

    "iPad3,1": "iPad 3 (WiFi)",
    "iPad3,2": "iPad 3 (GSM)",
    "iPad3,3": "iPad 3 (GSM+CDMA)",
    "iPad3,4": "iPad 4 (WiFi)",
    "iPad3,5": "iPad 4 (GSM)",
    "iPad3,6": "iPad 4 (GSM+CDMA)",

    "iPad4,1": "iPad Air (WiFi)",
    "iPad4,2": "iPad Air (GSM)",
    "iPad4,3": "iPad Air (GSM+CDMA)",
    "iPad4,4": "iPad Mini 2 (WiFi)",
    "iPad4,5": "iPad Mini 2 (GSM)",
    "iPad4,6": "iPad Mini 2 (GSM+CDMA)",
    "iPad4,7": "iPad Mini 3 (WiFi)",
    "iPad4,8": "iPad Mini 3 (GSM)",
    "iPad4,9": "iPad Mini 3 (GSM+CDMA)",

    "iPad5,1": "iPad Mini 4 (WiFi)",
    "iPad5,2": "iPad Mini 4 (Cellular)",
    "iPad5,3": "iPad Air 2 (WiFi)",
    "iPad5,4": "iPad Air 2 (Cellular)",

    "iPad6,3": "iPad Pro 12.9\" (WiFi)",
    "iPad6,4": "iPad Pro 12.9\" (Cellular)",
    "iPad6,7": "iPad Pro 9.7\" (WiFi)",
    "iPad6,8": "iPad Pro 9.7\" (Cellular)",

    "iPad6,11": "iPad (5th gen, WiFi)",
    "iPad6,12": "iPad (5th gen, LTE)",
    "iPad7,1": "iPad Pro (12.9, 2nd gen, WiFi)",
    "iPad7,2": "iPad Pro (12.9, 2nd gen, LTE)",
    "iPad7,3": "iPad Pro (10.5, WiFi)",
    "iPad7,4": "iPad Pro (10.5, LTE)",

    "i386": "32-bit Simulator",
    "x86_64": "64-bit Simulator"
]

extension UIDevice {

    /// Returns device‘s idfa
    /// In iOS 10.0 and later, the value of advertisingIdentifier is all zeroes when the user has limited ad tracking
    /// If the value is nil, wait and get the value again later. This happens, for example, after the device has been restarted but before the user has unlocked the device.
    public static var idfa: String {
        var deviceId = ""
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            deviceId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        if deviceId.isEmpty || deviceId == "00000000-0000-0000-0000-000000000000" {
            deviceId = ""
        }
        return deviceId
    }

    /// Returns device‘s id, idfa->idfv->uuid
    public static var deviceId: String {
        if let idfaStr = XCRIDFV.shared().read() {
            return idfaStr as! String
        }
        return ""
    }

    public static var imeiCode: String {
        let imeiCode = UIDevice.idfa
        if imeiCode.length > 0 {
            return imeiCode
        }
        return UIDevice.deviceId
    }

    /// XCRCore
    public static var idForVendor: String? {
        if let idfaStr = XCRIDFV.shared().read() {
            return idfaStr as? String
        }
        return ""
    }

    /// XCRCore - Operating system name
    public class func systemName() -> String {
        return UIDevice.current.systemName
    }

    /// XCRCore - Operating system version
    public class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /// XCRCore - Operating system version
    public class func systemFloatVersion() -> Float {
        return (systemVersion() as NSString).floatValue
    }

    /// XCRCore
    public class func deviceName() -> String {
        return UIDevice.current.name
    }

    /// Return device version ""
    public static var deviceVersion: String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }

    /// XCRCore
    public class func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }

    /// XCRCore
    public class func deviceModelReadable() -> String {
        return DeviceList[deviceModel()] ?? deviceModel()
    }

    /// Returns true if the device is iPhone
    public class func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }

    /// Returns true if the device is iPad
    public class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }

    /// XCRCore
    public class func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)

        for child in mirror.children {
            let value = child.value

            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }
}
