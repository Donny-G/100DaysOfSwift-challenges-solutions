//
//  ViewController.swift
//  Project2.2
//
//  Created by Donny G on 08/03/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    var countries = [String]()
    var scores = 0
    var correctAnswer = 0
    var counter = 0
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    notificationRegister()
    sheduleNotifications()
        
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor.darkGray.cgColor
    button2.layer.borderColor = UIColor.darkGray.cgColor
    button3.layer.borderColor = UIColor.darkGray.cgColor
    askQuestion(action: nil)
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .done, target: self, action: #selector(scoreShow))
    }
    
    func askQuestion(action: UIAlertAction!) {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    
    button1.setImage(UIImage(named: countries[0]), for:.normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
   
    title = countries[correctAnswer].uppercased() + "   🏆 Score is \(scores)"
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
        if sender.tag == correctAnswer {
            title = "Correct"
            scores += 1
    
        } else {
            title = "Wrong. This flag belongs to \(countries[sender.tag].uppercased())"
            
            scores -= 1
        }
        
    counter += 1
    if counter < 10 {
        
    let ac = UIAlertController(title: title, message: "Score is \(scores)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac,animated: true)
    } else {
        let finalAC = UIAlertController(title: "Thank you for game", message: "Your total score is \(scores)", preferredStyle: .alert)
        finalAC.addAction(UIAlertAction(title: "New Game", style:.destructive, handler: askQuestion))
        present(finalAC,animated: true)
        scores = 0
        counter = 0
        }
    }

    @objc func scoreShow() {
        
        func scoreShare(action: UIAlertAction!) {
            let resultMessage = "My score is \(scores)"
            let vc = UIActivityViewController(activityItems: [resultMessage], applicationActivities: [])
            present(vc, animated: true)
        }
        
        let scoreAlert = UIAlertController(title: "Score", message: "Your score is \(scores)", preferredStyle: .alert)
        scoreAlert.addAction(UIAlertAction(title: "Share", style: .default, handler: scoreShare))
        present(scoreAlert, animated: true)
    }
    
    func notificationRegister() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notification is enabled")
            } else {
                print("Notification is disabled")
            }
        }
    }
    
    func sheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.delegate = self
        let content = UNMutableNotificationContent()
        content.title = "Let's play"
        content.body = "Hello, let's play again, beat your current highscore"
        content.categoryIdentifier = "shedule"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        for day in 1...7 {
        dateComponents.hour = 12
        dateComponents.minute = 00
            dateComponents.day = day
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
       // let checkTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        }
    }
    
}
