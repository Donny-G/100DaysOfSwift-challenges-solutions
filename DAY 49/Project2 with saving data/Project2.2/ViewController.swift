//
//  ViewController.swift
//  Project2.2
//
//  Created by Donny G on 08/03/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var counter = 0
    var highScore = 0
    
    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "highScore") as? Int {
             highScore = savedData
        }else{
                print("Unable to load data")
        }
        
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor.darkGray.cgColor
    button2.layer.borderColor = UIColor.darkGray.cgColor
    button3.layer.borderColor = UIColor.darkGray.cgColor
    askQuestion(action: nil)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Highscore", style: .done, target: self, action: #selector(scoreShow))
    }
    
    func askQuestion(action: UIAlertAction!) {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    
    button1.setImage(UIImage(named: countries[0]), for:.normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
   
    title = countries[correctAnswer].uppercased() + "   🏆 Score is \(score)"
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 10
        } else {
            title = "Wrong. This flag belongs to \(countries[sender.tag].uppercased())"
            score -= 5
        }
    counter += 1
        
        if counter < 10 {
    let ac = UIAlertController(title: title, message: "Score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac,animated: true)
        } else  {
            if score > highScore {
                highScore = score
                save()

        let finalAC = UIAlertController(title: "Thank you for game", message: "Your highscore is \(highScore)", preferredStyle: .alert)
        finalAC.addAction(UIAlertAction(title: "New Game", style:.destructive, handler: newGame))
                present(finalAC,animated: true)}
            else {
                let gameOverAC = UIAlertController(title: "Thank you for game", message: "Your previous highscore is \(highScore), please play again", preferredStyle: .alert)
                gameOverAC.addAction(UIAlertAction(title: "New Game", style: .destructive, handler: newGame))
                present(gameOverAC, animated: true)
            }
        }
    }
    
    func newGame(action: UIAlertAction!){
        score = 0
        counter = 0
        askQuestion(action: nil)
    }

    @objc func scoreShow() {
        func scoreShare(action: UIAlertAction!) {
            let resultMessage = "My highscore is \(highScore)"
            let vc = UIActivityViewController(activityItems: [resultMessage], applicationActivities: [])
            present(vc, animated: true)
        }
        
        let scoreAlert = UIAlertController(title: "Highscore", message: "Your highscore is \(highScore)", preferredStyle: .alert)
        scoreAlert.addAction(UIAlertAction(title: "Share", style: .default, handler: scoreShare))
        scoreAlert.addAction(UIAlertAction(title: "Back", style: .cancel))
        present(scoreAlert, animated: true)
    }
    //not using encode as this function will be used in button type/ data type in this case will be Any
    func save() {
            let defaults = UserDefaults.standard
        do { defaults.set(highScore, forKey: "highScore")
            print("Load succesfull")
        } catch {
            print("unable to save data")
        }
    }
    
}
