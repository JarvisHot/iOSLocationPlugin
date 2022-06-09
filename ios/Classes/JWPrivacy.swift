//
//  JWPrivacy.swift
//  consumeShop
//
//  Created by jiang on 2020/12/24.
//

import UIKit
import CoreLocation

class JWPrivacy: NSObject {
    
    
    class func canGetLocationAuthorization(completion:@escaping (() -> Void)) {
        if CLLocationManager.locationServicesEnabled()==true && (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            completion()
        }else if(CLLocationManager.authorizationStatus() == .denied){
            let appName = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
            let av = UIAlertController(title: "温馨提示", message: "\(appName)想使用您的定位权限", preferredStyle: .alert)
            av.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { al in
                
            }))
            av.addAction(UIAlertAction(title: "去设置", style: .default, handler: { al in
                let url = URL(string: UIApplication.openSettingsURLString)
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }))
            getTopVC()?.present(av, animated: true, completion: nil)
            
        }
    }
}
func getTopVC() -> (UIViewController?) {
    var window = UIApplication.shared.keyWindow
    //是否为当前显示的window
    if window?.windowLevel != UIWindow.Level.normal{
        let windows = UIApplication.shared.windows
        for  windowTemp in windows{
            if windowTemp.windowLevel == UIWindow.Level.normal{
                window = windowTemp
                break
            }
        }
    }
    let vc = window?.rootViewController
    return getTopVC(withCurrentVC: vc)
}
///根据控制器获取 顶层控制器
func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
    if VC == nil {
        print("： 找不到顶层控制器")
        return nil
    }
    if let presentVC = VC?.presentedViewController {
        //modal出来的 控制器
        return getTopVC(withCurrentVC: presentVC)
    }else if let tabVC = VC as? UITabBarController {
        // tabBar 的跟控制器
        if let selectVC = tabVC.selectedViewController {
            return getTopVC(withCurrentVC: selectVC)
        }
        return nil
    } else if let naiVC = VC as? UINavigationController {
        // 控制器是 nav
        return getTopVC(withCurrentVC:naiVC.visibleViewController)
    } else {
        // 返回顶控制器
        return VC
    }
}
