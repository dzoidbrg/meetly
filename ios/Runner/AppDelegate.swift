import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
@main
@objc class AppDelegate: FlutterAppDelegate,MessagingDelegate {
    var fcmToken: String?

 
    // For self signed certificates, only use for development
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)

       FirebaseApp.configure()
      Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
                      
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
          let batteryChannel = FlutterMethodChannel(name: "mast3rsoft.com/meetlyv2",
                                                    binaryMessenger: controller.binaryMessenger)
          batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // This method is invoked on the UI thread.
            // Handle battery messages.
              guard call.method == "getFCMToken" else {
                  result(FlutterMethodNotImplemented)
                  return
                }
              self?.getFCMToken(result: result)
              return
          })

        return true
  }
    private func getFCMToken(result: FlutterResult) {
        result(self.fcmToken)
    }
    internal func messaging(_ messaging: FirebaseMessaging.Messaging, didReceiveRegistrationToken fcmToken: String?) {
        /* store the fcmToken */
        guard let fcmToken = fcmToken else { return }
        print("fcmToken: \(fcmToken)")
        self.fcmToken = fcmToken
    }
    
    // Called when APNs has assigned a device token to the app
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         // Convert token to string
         let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
         let token = tokenParts.joined()
         
         // Store the token for later use
         print("Device Token: \(token)")
         
         // Here you would typically send this token to your server
         // sendTokenToServer(token)
     }

}

extension AppDelegate {
  // Receive displayed notifications for iOS 10 devices.
   
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo
        
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // ...

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
        return [[.badge, .sound,.list,.banner]]
  }

    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)
  }
}
