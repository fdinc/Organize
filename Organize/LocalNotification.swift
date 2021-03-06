// TODO: able to complete the task from the notifcation center (with Notification Action swipe buttons)
// TODO: unable to complete the task the first time when accepting notifications (because unknown user selection and the timing of that selection)

import UIKit

class LocalNotification {
  static let sharedInstance = LocalNotification()
  
  private let displayTitle: String = "Enable Notifications"
  private let displayMessage: String = "Would you like to get notified of the reminders you create?"
  private let displayButtonYes: String = "Yes"
  private let displayButtonNo: String = "No"
  typealias completionHandler = ((success: Bool) -> ())?
  
  func checkPermission(controller controller: UIViewController) -> Bool {
    guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else {
      return false
    }
    
    if settings.types == .None {
      // if already asked
      if let _ = Constant.UserDefault.get(key: .IsLocalNotificationPermissionAsked) {
        displayPostPremission(controller: controller)
      } else {
        displayPrePremission(controller: controller)
      }
      return false
    }
    
    return true
  }
  
  private func displayPrePremission(controller controller: UIViewController) {
    // get premission
    Util.threadMain {
      // alert before requesting premission
      let ac = UIAlertController(title: self.displayTitle, message: self.displayMessage, preferredStyle: .Alert)
      ac.addAction(UIAlertAction(title: self.displayButtonYes, style: .Default) { action in
        self.registerPermission()
        })
      ac.addAction(UIAlertAction(title: self.displayButtonNo, style: .Cancel, handler: nil))
      controller.presentViewController(ac, animated: true, completion: nil)
    }
  }
  
  private func displayPostPremission(controller controller: UIViewController) {
    // apple settings
    Util.threadMain {
      // alert after premission has been asked but rejected
      let ac = UIAlertController(title: self.displayTitle, message: self.displayMessage, preferredStyle: .Alert)
      ac.addAction(UIAlertAction(title: self.displayButtonYes, style: .Default) { action in
        self.navigateToAppleSettings()
        })
      ac.addAction(UIAlertAction(title: self.displayButtonNo, style: .Cancel, handler: nil))
      controller.presentViewController(ac, animated: true, completion: nil)
    }
  }
  
  private func registerPermission() {
    // also registers for push notifications
    let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    Constant.UserDefault.set(key: .IsLocalNotificationPermissionAsked, val: true)
  }
  
  
  private func navigateToAppleSettings() {
    if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
      UIApplication.sharedApplication().openURL(url)
    }
  }
  
  func hasPremission() -> Bool {
    guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else {
      return false
    }
    if settings.types == .None {
      return false
    }
    
    return true
  }
  
  func create(controller controller: UIViewController, body: String, action: String?, fireDate: NSDate?, soundName: String?, uid: String, completion: completionHandler) {
    // check ability to send
    let hasPermission = checkPermission(controller: controller)
    
    if hasPermission {
      // create
      let notification = UILocalNotification()
      
      // badge
      notification.applicationIconBadgeNumber += 1
      
      // is a string containing the text to show to users. The title of the message will automatically be your app's name.
      notification.alertBody = body
      
      // is a string shown under your message that completes the sentence, "Slide to…" For example, if you set it be "pericombobulate", it would read "Slide to pericombobulate."
      notification.alertAction = action
      
      // decides when the notification should be shown. iOS tracks this for us, so our app doesn't need to be running when it's time for the notification to be delivered.
      notification.fireDate = fireDate ?? NSDate(timeIntervalSinceNow: 5)
      
      // we'll be using the default alert sound, but it's not hard to specify your own – just make sure you include it in the project!
      notification.soundName = soundName ?? UILocalNotificationDefaultSoundName
      
      // is a dictionary of keys and values that you can provide. The system does nothing with these other than hand them back to you when the app launches so you can respond.
      notification.userInfo = ["uid": uid]
      
      // schedule
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // completion
    if let completion = completion {
      completion(success: hasPermission)
    }
  }
  
  func delete(uid uid: String) {
    // delete notification based on uid from userInfo object
    let app = UIApplication.sharedApplication()
    if let notifications = app.scheduledLocalNotifications {
      for notification in notifications {
        if let userInfo = notification.userInfo, let userId = userInfo["uid"] as? String {
          if userId == uid {
            app.cancelLocalNotification(notification)
            return
          }
        }
      }
    }
  }
  
  func destroy() {
    // removes all local notifications
    let app = UIApplication.sharedApplication()
    if let notifications = app.scheduledLocalNotifications {
      for notification in notifications {
        app.cancelLocalNotification(notification)
      }
    }
  }
  
  func read() {
    // check if app came from a notification
  }
}

