//
//  UserNotificationService.swift
//  PusReminder
//
//  Created by Khaled Rahman Ayon on 18/12/2017.
//  Copyright © 2017 Khaled Rahman Ayon. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation

class UserNotificationService: NSObject {
    
    private override init() {}
    static let instance = UserNotificationService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options : UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        unCenter.requestAuthorization(options: options) { (success, error) in
            print(error ?? "Successfull!!")
            guard success else {
                print("User denied the access")
                return
            }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
        setupActionsAndConfigure()
    }
    
    func setupActionsAndConfigure() {
        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue, title: "Timer action logic", options: .authenticationRequired)
        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue, title: "Date action logic", options: .destructive)
        let locationAction = UNNotificationAction(identifier: NotificationActionID.location.rawValue, title: "Location action logic", options: .foreground)
        
        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue, actions: [timerAction], intentIdentifiers: [])
        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue, actions: [dateAction], intentIdentifiers: [])
        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue, actions: [locationAction], intentIdentifiers: [])
        
        unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
    }
    
    func getAttachment(for id: NotificationAttachmentID) -> UNNotificationAttachment? {
        var imagename: String
        switch id {
        case .timer: imagename = "TimerAlert"
        case .date: imagename = "DateAlert"
        case .location: imagename = "LocationAlert"
        }
        guard let url = Bundle.main.url(forResource: imagename, withExtension: ".png") else { return nil}
        do {
            let attachment = try UNNotificationAttachment(identifier: id.rawValue, url: url)
            return attachment
            
        } catch {
            return nil
        }
}
    
    func timerRequest(with interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timer finished"
        content.body = "Your timer is all done. YAY!!!"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.timer.rawValue
        
        if let attachment = getAttachment(for: .timer) {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.timer", content: content, trigger: trigger)
        
        unCenter.add(request)
    }
    
    func dateRequest(with components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Date Trigger!!"
        content.body = "Welcome to the future!!"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.date.rawValue
        
        if let attachment = getAttachment(for: .date) {
            content.attachments = [attachment]
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
        
        unCenter.add(request)
    }
    
    func locationRequest() {
        let content = UNMutableNotificationContent()
        content.title = "you have returned"
        content.body = "Are you in the region!"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.location.rawValue
        
        if let attachment = getAttachment(for: .location) {
            content.attachments = [attachment]
        }
        
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request)
    }
}

extension UserNotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN DID RECIVE RESPONSE")
        
        if let action = NotificationActionID(rawValue: response.actionIdentifier) {
            NotificationCenter.default.post(name: NSNotification.Name("internalnotification.handelAction"), object: action)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN WILL PRESENT")
        
        let options : UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
