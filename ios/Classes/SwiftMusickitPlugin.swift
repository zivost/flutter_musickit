import Flutter
import UIKit
import StoreKit
import MediaPlayer

enum FlutterErrorCode {
    static let unavailable = "UNAVAILABLE"
    static let denied = "DENIED"
    static let notDetermined = "NOT DETERMINED"
}

public class SwiftMusickitPlugin: NSObject, FlutterPlugin {
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "musickit", binaryMessenger: registrar.messenger())
        let instance = SwiftMusickitPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "ping":
            ping(result: result)
        case "appleMusicRequestPermission":
            appleMusicRequestPermission(result: result)
        case "appleMusicCheckIfDeviceCanPlayback":
            appleMusicCheckIfDeviceCanPlayback(result: result)
        case "fetchUserToken":
            fetchUserToken(developerToken: call.arguments as! String, result: result)
        case "appleMusicPlayTrackId":
            appleMusicPlayTrackId(ids: call.arguments as! [String], result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func appleMusicRequestPermission(result: @escaping FlutterResult) {
        if #available(iOS 9.3, *) {
            switch SKCloudServiceController.authorizationStatus() {
                
            case .authorized:
                // The user's already authorized - we don't need to do anything more here, so we'll exit early.
                
                result("Already authorized")
            case .denied:
                // The user has selected 'Don't Allow' in the past - so we're going to show them a different dialog to push them through to their Settings page and change their mind, and exit the function early.
                
                result(FlutterError(code: FlutterErrorCode.denied, message: "User denied permission", details: "The user has selected 'Don't Allow' in the past."))
                
                // TODO: Show an alert to guide users into the Settings
            case .notDetermined:
                // The user hasn't decided yet - so we'll break out of the switch and ask them.
                break
            case .restricted:
                // User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied."
                
                result(FlutterError(code: FlutterErrorCode.unavailable, message: "User may be restricted", details: "User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied."))
            }
        } else {
            result(FlutterError(code: FlutterErrorCode.unavailable, message: "Not supported on iOS < 9.3", details: nil))
        }
        
        if #available(iOS 9.3, *) {
            SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
                switch status {
                    
                case .authorized:
                    // All good - the user tapped 'OK', so you're clear to move forward and start playing.
                    
                    result("All good")
                case .denied:
                    // The user tapped 'Don't allow'.
                    
                    result(FlutterError(code: FlutterErrorCode.denied, message: "User denied permission", details: "The user tapped 'Don't allow'"))
                case .notDetermined:
                    // The user hasn't decided or it's not clear whether they've confirmed or denied.
                    
                    result(FlutterError(code: FlutterErrorCode.notDetermined, message: "Not determined if confirmed or denied", details: "The user hasn't decided or it's not clear whether they've confirmed or denied."))
                case .restricted:
                    
                    // User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.
                    
                    result(FlutterError(code: FlutterErrorCode.unavailable, message: "User may be restricted", details: "User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied."))
                    
                }
            }
        } else {
            result(FlutterError(code: FlutterErrorCode.unavailable, message: "Not supported on iOS < 9.3", details: nil))
        }
        
    }
    
    // Check if the device is capable of playback
    func appleMusicCheckIfDeviceCanPlayback(result: @escaping FlutterResult) {
        if #available(iOS 9.3, *) {
            let serviceController = SKCloudServiceController()
            
            serviceController.requestCapabilities { (capability: SKCloudServiceCapability, err: Error?) in
                if (err != nil) {
                    result(FlutterError(code: FlutterErrorCode.unavailable, message: "Error Encountered", details: err.debugDescription))
                }
                
                switch capability {
                case SKCloudServiceCapability.musicCatalogPlayback:
                    // The user has an Apple Music subscription and can playback music!
                    result("Apple Music subscription found")
                case SKCloudServiceCapability.addToCloudMusicLibrary:
                    // The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library
                    
                    result("Apple Music subscription found")
                default:
                    // The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one?
                    
                    result(FlutterError(code: FlutterErrorCode.unavailable, message: "Apple Music subscription not available", details: nil))
                    break
                }
            }
        } else {
            result(FlutterError(code: FlutterErrorCode.unavailable, message: "Not supported on iOS < 9.3", details: nil))
        }
    }
    
    // Get Apple Music User Token
    func fetchUserToken(developerToken : String, result: @escaping FlutterResult) {
        print("iOS Developer Token", developerToken)
        if #available(iOS 11.0, *) {
            let serviceController = SKCloudServiceController()
            
            serviceController.requestUserToken(forDeveloperToken: developerToken) { (userToken, err) in
                if (err != nil) {
                    result(FlutterError(code: FlutterErrorCode.unavailable, message: "Error Encountered", details: err.debugDescription))
                    print("iOS fetchUserToken", err.debugDescription)
                } else {
                    result(userToken)
                }
            }
        } else {
            result(FlutterError(code: FlutterErrorCode.unavailable, message: "Not supported on iOS < 9.3", details: nil))
        }
        
        
    }
    
    func appleMusicPlayTrackId(ids:[String], result: FlutterResult) {
        if #available(iOS 9.3, *) {
            systemMusicPlayer.setQueue(with: ids)
            systemMusicPlayer.play()
        } else {
            result(FlutterError(code: FlutterErrorCode.unavailable, message: "Not supported on iOS < 9.3", details: nil))
        }
    }
    
    func ping(result: FlutterResult) {
        result("pong")
    }
}
