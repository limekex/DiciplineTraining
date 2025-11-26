import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
   static let shared = NotificationManager()
   
   override private init() {
       super.init()
       // Set the delegate for notification center
       UNUserNotificationCenter.current().delegate = self
   }

   /// Requests authorization to send notifications.
   func requestAuthorization(completion: @escaping (Bool) -> Void) {
       UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
           if let error = error {
               print("🔴 NotificationManager: Authorization request failed - \(error.localizedDescription)")
           }
           DispatchQueue.main.async {
               print(granted ? "🟢 NotificationManager: Authorization granted." : "🟡 NotificationManager: Authorization denied.")
               completion(granted)
           }
       }
   }

   /// Schedules a daily repeating reminder.
   func scheduleDailyReminder(hour: Int, minute: Int, identifier: String = "daily.checkin") {
       let center = UNUserNotificationCenter.current()
       
       center.getNotificationSettings { settings in
           guard settings.authorizationStatus == .authorized else {
               print("🟡 NotificationManager: Cannot schedule reminder, authorization not granted.")
               return
           }

           let content = UNMutableNotificationContent()
           content.title = "Dagsjekk — trening"
           content.body = "Husker du å logge dagens trening?"
           content.sound = .default

           var dateComponents = DateComponents()
           dateComponents.hour = hour
           dateComponents.minute = minute

           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
           let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

           center.add(request) { error in
               if let error = error {
                   print("🔴 NotificationManager: Failed to schedule reminder - \(error.localizedDescription)")
               } else {
                   print("🟢 NotificationManager: Daily reminder scheduled successfully for \(hour):\(String(format: "%02d", minute))")
               }
           }
       }
   }

   /// Cancels a pending reminder.
   func cancelReminder(identifier: String = "daily.checkin") {
       UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
       print("🔵 NotificationManager: Canceled reminder with identifier: \(identifier)")
   }
   
   // MARK: - UNUserNotificationCenterDelegate
   
   /// Handles notification presentation while the app is in the foreground.
   func userNotificationCenter(
       _ center: UNUserNotificationCenter,
       willPresent notification: UNNotification,
       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
   ) {
       print("🟢 NotificationManager: Received notification while app is in foreground.")
       // Show the notification banner, play a sound, and update the badge
       completionHandler([.banner, .sound, .badge])
   }
}
