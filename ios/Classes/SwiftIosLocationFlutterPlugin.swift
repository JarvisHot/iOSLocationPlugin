import Flutter
import UIKit

public class SwiftIosLocationFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ios_location_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftIosLocationFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if call.method == "startLocation" {
          JWMapLocation.startLoc { mark in
              result(["status" : true,"city": mark?.locality ?? "Sydney"])
          } statusUpdateBlock: { status in
            
//              result(["status":false,"locStatus":status])
          }

      }
  }
}
