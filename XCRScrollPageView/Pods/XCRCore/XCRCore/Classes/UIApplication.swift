//
//  UIApplication.swift
//  XCRKit
//
//  Created by ZhangAimin on 2017/9/18.
//

import UIKit

extension UIApplication {

    public static let userAgent: String = {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            let osNameVersion: String = {
                let versionString: String

                if #available(OSX 10.10, *) {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                } else {
                    versionString = "10.9"
                }
                return "iOS \(versionString)"
            }()
            return "\(executable)/\(bundle) (\(version); \(osNameVersion))"
        }
        return "XCar" + UIApplication.appVersion
    }()

    /// Returns app's name
    public static var appDisplayName: String {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        return ""
    }

    /// Returns app's version number
    public static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    /// Return app's build number
    public static var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// Return app's bundle ID
    public static var appBundleID: String {
        return Bundle.main.bundleIdentifier ?? ""
    }

    /// Returns current screen orientation
    public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    /// Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }

//    public class func present(_ fromViewController: UIViewController, toViewController: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
//        if let from = fromViewController.presentedViewController {
//            present(from, toViewController: toViewController, animated: flag, completion: completion)
//        } else if let from = fromViewController.parent {
//            present(from, toViewController: toViewController, animated: flag, completion: completion)
//        } else {
//            fromViewController.present(toViewController, animated: flag, completion: completion)
//        }
//    }
}
