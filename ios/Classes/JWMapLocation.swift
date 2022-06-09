//
//  JWMapLocation.swift
//  HealthGroup
//
//  Created by jiang on 2021/5/25.
//  Copyright © 2021 sxw. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

typealias markBlock = ((CLPlacemark?) -> ())
@objcMembers class JWMapLocation: NSObject,CLLocationManagerDelegate {

    private var locMarkBlock: markBlock?
    private var statusUpdateBlock: ((CLAuthorizationStatus) -> Void)?
    class func startLoc(sucblock:@escaping markBlock,statusUpdateBlock:((CLAuthorizationStatus) -> Void)?) {
        JWMapLocation.shared().requestloc(sucblock: sucblock, statusUpdateBlock: statusUpdateBlock)
    }
     
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.statusUpdateBlock?(status)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            let geo = CLGeocoder()
            geo.reverseGeocodeLocation(loc) { placemarks, error in
                if error != nil && placemarks?.count == 0 {
                    self.locMarkBlock?(nil)
                }else {
                    if let mark = placemarks?.first {
                        self.locMarkBlock?(mark)
                        self.locationManager.stopUpdatingLocation()
                    }
                }
            }
        }
    }
    private static let maploc : JWMapLocation = {
        let maploc = JWMapLocation()
        return maploc
    }()
    private class func shared() -> JWMapLocation {
        return maploc
    }
    
    class func stop() {
        JWMapLocation.shared().stop()
    }
    private func requestloc(sucblock:@escaping markBlock, statusUpdateBlock: ((CLAuthorizationStatus) -> Void)?) {
        self.locMarkBlock = sucblock
        self.statusUpdateBlock = statusUpdateBlock
        self.locationManager.requestWhenInUseAuthorization()
        JWPrivacy.canGetLocationAuthorization {
            
            self.locationManager.startUpdatingLocation()
        }
        
    }
    private func stop() {
        self.locationManager.stopUpdatingLocation()
    }
   class func systemNavToLoc(coordinate:CLLocationCoordinate2D,addressName:String) {
        var mapsArr = ["苹果地图"]
        if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
            mapsArr.append("高德地图")
        }
        if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) {
            mapsArr.append("百度地图")
        }
        let alert = UIAlertController(title: "选择地图", message: nil, preferredStyle: .actionSheet)
        for str in mapsArr {
            alert.addAction(UIAlertAction(title: str, style: .default, handler: { (al) in
                if str == "苹果地图" {
                    let currentI = MKMapItem.forCurrentLocation()
                    let toi = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                    toi.name = addressName
                    MKMapItem.openMaps(with: [currentI,toi], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,])
                }else if str == "高德地图" {
                    let openstr = "iosamap://viewMap?sourceApplication=yaoLive&poiname=\(addressName)&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&dev=0"
                    UIApplication.shared.open(URL(string: openstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, options: [:], completionHandler: nil)
                }else if str == "百度地图" {
                    let openstr  = "baidumap://map/marker?coord_type=gcj02&zoom=17&location=\(coordinate.latitude),\(coordinate.longitude)&title=\(addressName)&content=\"\"&src=0"
                    UIApplication.shared.open(URL(string: openstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, options: [:], completionHandler: nil)
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: { (al) in
            
        }))
        getTopVC()?.present(alert, animated: true) {
            
        }
    }
    lazy var locationManager:CLLocationManager = {
        let man = CLLocationManager()
        man.delegate = self
        man.distanceFilter = 10.0
        man.desiredAccuracy = kCLLocationAccuracyBest
        return man
    }()
    
}
