//
//  ViewController.swift
//  Project21
//
//  Created by Donny G on 25/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shedule", style: .plain, target: self, action: #selector(sheduleLocal))
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //pull out the buried userInfo dictionary
    
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received:\(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                //the user swiped to unlock
                print("Default identifier")
                
            //Challenge 1
            case "show0":
                //the user tapped our "show more info..." button
               alert(title: "Case 1", message: "Hello there")
            //Challenge 1
            case "show1":
                alert(title: "Case 2", message: "Hello again")
                
            //Challenge 2
            case "rml":
                shedule(timeInterval: 86400)
                print("Remind me later on")
                
            default:
                break
            }
        }
        //you must call the completion handler when you're done
        completionHandler()
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay")
            } else {
                print("D'oh")
            }
        }
    }
    
    @objc func sheduleLocal() {
        shedule(timeInterval: 5)
    }
    
    //Challenge 2
    func shedule(timeInterval: Double){
        
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 02
        //calendar notif
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // time interval notif
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let show0 = UNNotificationAction(identifier: "show0", title: "Tell me more..", options: .foreground)
        //Challenge 1
        let show1 = UNNotificationAction(identifier: "show1", title: "Tell me more more...", options: .foreground)
        
        //Challenge 2
        let remindMeLater = UNNotificationAction(identifier: "rml", title: "Remind me later", options: .destructive)
        
        //Challenge 1, 2
        let category = UNNotificationCategory(identifier: "alarm", actions: [show0, show1, remindMeLater], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    //Challenge 1
    func alert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
}

