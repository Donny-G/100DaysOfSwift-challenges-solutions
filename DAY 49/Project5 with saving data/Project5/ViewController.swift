//
//  ViewController.swift
//  Project5
//
//  Created by DeNNiO   G on 21/03/2019.
//  Copyright © 2019 DeNNiO   G. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    var startWord: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .plain, target: self, action: #selector(newGame))
        
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsUrl){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        let defaults = UserDefaults.standard
        usedWords = defaults.object(forKey: "usedWords") as? [String] ?? [String]()
        startWord = defaults.object(forKey: "startWord") as? String ?? ""
        startGame()
    }
    
    @objc func startGame() {
        if !usedWords.isEmpty {
            title = startWord
        } else {
        title = allWords.randomElement()
        startWord = title!
        let defaults = UserDefaults.standard
           defaults.set(startWord, forKey: "startWord") 
            
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        }
    }
    
    
    @objc func newGame (){
        usedWords.removeAll()
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
        
    }
    
    @objc func promtForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[weak self, weak ac] action in guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
            
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer)  {
                    if isDublicate(word: lowerAnswer){
                    usedWords.insert(answer.lowercased(), at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    save()
                    return
                    }else{
                        showErrorMessage(errorTitle: "Dublicate", errorMessage: "The word is the same as start word")
                    }
                }else{
                    showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make up the word and be sure it is more than 3 characters")
                }
            }else{
                showErrorMessage(errorTitle: "Word is used already", errorMessage: "Be more original")
            }
        }else{
            
            guard let title = title?.lowercased() else {return}
            showErrorMessage(errorTitle: "Word is not possible", errorMessage: "You can't spell that word from \(title)")
        }
        
        }
    
    
    func isPossible(word: String) -> Bool{
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    
    func isOriginal(word: String) -> Bool{
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool{
        guard word.count > 3 else {return false}
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isDublicate(word: String) -> Bool {
        if word == title?.lowercased() {
            return false
        }else{
            return true
        }
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func save(){
        let defaults = UserDefaults.standard
            defaults.set(usedWords, forKey: "usedWords")
    }
    
   
    
}

