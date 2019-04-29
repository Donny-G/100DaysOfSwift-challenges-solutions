//
//  ViewController.swift
//  Project8
//
//  Created by Donny G on 06/04/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var tappedButtons = [UIButton]()
    var solutions = [String]()
    var nextLevel: UIButton!
    var gameover:UILabel!
    var blankLabel: UILabel!
    var levelLabel:UILabel!
    var clear: UIButton!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    //MARK: VIEW
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        //MARK: VIEW PROPERTIES
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letteres to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        gameover = UILabel()
        gameover.translatesAutoresizingMaskIntoConstraints = false
        gameover.isHidden = true
        gameover.text = "GAME OVER"
        gameover.font = UIFont.systemFont(ofSize: 78)
        gameover.textColor = .red
        view.addSubview(gameover)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        clear.addTarget(self, action: #selector(crearTapped), for: .touchUpInside)
        clear.isHidden = true
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(buttonsView)
        
        let newGame = UIButton(type: .system)
        newGame.translatesAutoresizingMaskIntoConstraints = false
        newGame.setTitle("New Game", for: .normal)
        newGame.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(newGame)
        newGame.addTarget(self, action: #selector(newGame1), for: .touchUpInside)
        
        nextLevel = UIButton(type: .system)
        nextLevel.translatesAutoresizingMaskIntoConstraints = false
        nextLevel.setTitle("Next Level", for: .normal)
        nextLevel.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        nextLevel.tintColor = .red
        nextLevel.isHidden = true
        view.addSubview(nextLevel)
        nextLevel.addTarget(self, action: #selector(levelUp), for: .touchUpInside)
        
        blankLabel = UILabel()
        blankLabel.translatesAutoresizingMaskIntoConstraints = false
        blankLabel.text = "Come back later"
        blankLabel.textAlignment = .center
        blankLabel.font = UIFont.systemFont(ofSize: 44)
        blankLabel.isHidden = true
        blankLabel.backgroundColor = .yellow
        blankLabel.sizeThatFits(CGSize(width: 750, height: 320))
        view.addSubview(blankLabel)
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Level: 1"
        view.addSubview(levelLabel)
        
        //MARK: CONSTRAINTS
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
        
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            newGame.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            newGame.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 20),
            newGame.heightAnchor.constraint(equalToConstant: 44),
            
            nextLevel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            nextLevel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 150),
            nextLevel.heightAnchor.constraint(equalToConstant: 44),
            
            gameover.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            gameover.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
        
            blankLabel.widthAnchor.constraint(equalToConstant: 750),
            blankLabel.heightAnchor.constraint(equalToConstant: 320),
            blankLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blankLabel.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            blankLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -80)
            ])
        
        //MARK: SET OF LETTER BUTTONS
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                let frame = CGRect(x: col*width, y: row*height, width: width, height: height)
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
    }
        
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadLevel()
    }
        
}
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {return}
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)

        tappedButtons.append(sender)
        if !tappedButtons.isEmpty {
            clear.isHidden = false
        }
        sender.backgroundColor = .black
        
}
    
    @objc func submitTapped(_ sender: UIButton) {
        clear.isHidden = true
        guard let answerText = currentAnswer.text else {return}
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            for sender in tappedButtons{
            sender.isHidden = true
        }
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""
            
            score += 1
            if score == 5 {
                nextLevel.isHidden = false
        }
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for a new level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's Go", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
        else { let ac = UIAlertController(title: "OOPS", message: "Your answer is not correct", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel
                , handler: { (action) in
                    self.currentAnswer.text = ""
                    for sender in self.tappedButtons {
                        sender.isHidden = true
                    }
            }))
            self.present(ac, animated: true)
        if tappedButtons.count >= 7{
            print("gameover")
            gameover.isHidden = false
            
            }
        }
        
}
    
    @objc func crearTapped(_ sender: UIButton){
           currentAnswer.text = ""
            for btn in tappedButtons{
            btn.backgroundColor = .white
            tappedButtons.removeAll()
            clear.isHidden = true
    }
        
}
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
            
                for (index, line) in lines.enumerated(){
                    let parts = line.components(separatedBy: ":")
                    let answer = parts[0]
                    let clue = parts[1]
                    clueString += "\(index + 1). \(clue)\n"
                
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                    }
                }
            }
        DispatchQueue.main.async {
            [weak self] in
            
        self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
            guard let letterButtons = self?.letterButtons else {return}

        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
        
}
    
   @objc func levelUp(action: UIAlertAction){
    solutions.removeAll(keepingCapacity: true)
    //nextLevel.isHidden = true
    for btn in tappedButtons {
        btn.backgroundColor = .white
        btn.isHidden = false
        gameover.isHidden = true
    }
    level += 1
    loadLevel()
    print(solutions)
 
    if solutions.isEmpty {
        
        let ac = UIAlertController(title: "Sorry, but new level is not available now", message: "Please come back later, we will add new levels soon", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            self.blankLabel.isHidden = false
        }))
        present(ac, animated: true)
        for btn in tappedButtons {
            btn.backgroundColor = .white
            btn.isHidden = true
            gameover.isHidden = true
        }
    }
    
}
    
    @objc func newGame1(action: UIAlertAction){
        blankLabel.isHidden = true
        nextLevel.isHidden = true
        for btn in tappedButtons {
            btn.backgroundColor = .white
            btn.isHidden = false
        }
        gameover.isHidden = true
        tappedButtons.removeAll()
        score = 0
        level = 1
        loadLevel()
}

}
