//
//  ViewController.swift
//  Project7
//
//  Created by Donny G on 30/03/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: устанавливаем кнопки
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
    
        performSelector(inBackground: #selector(fetchJSON), with: nil)
}
    
        // MARK: указываем ресурс для парсинга
    @objc func fetchJSON(){
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        //MARK: парсинг данных с сайта
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
               parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(errorMessage), with: nil, waitUntilDone: false)
}
    
    //MARK: функция для кнопки фильтрации
    @objc func search(){
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let word = ac?.textFields?[0].text else { return }
            self?.submit(word)
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Restore", style: .destructive, handler: { (UIAlertAction) in
            self.filteredPetitions = self.petitions
            self.tableView.reloadData()
        }))
        present(ac,animated: true)
}
    
    //MARK: функция для кнопки CREDITS
    @objc func creditsButton(){
        let ac = UIAlertController(title: "Info", message: "The data is from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
}
    
    //MARK: функция для парсинга
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPetition = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetition.results
            filteredPetitions = petitions
            DispatchQueue.main.async {
                [weak self] in
            self?.tableView.reloadData()
            }
        }
}

    //MARK: функция для выявления ошибки с парсингом
       @objc func errorMessage(){
            let ac = UIAlertController(title: "Warning", message: "There is some problem with source site or your internet connection", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true)
}

    //MARK: ROWS IN SECTION
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
}
    
    //MARK: отображение ячеек
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
    let filtered = filteredPetitions[indexPath.row]
        cell.textLabel?.text = filtered.title
        cell.detailTextLabel?.text = filtered.body
    
        return cell
}
    
   //MARK: функция для запуска фильтра
    func submit(_ word: String) {
        DispatchQueue.global().async { [weak self] in
            self?.filteredPetitions.removeAll()
            for petetion in self!.petitions{
                if petetion.title.contains(word) {
                    
                    self?.filteredPetitions.append(petetion)
                    DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                    }
                }
            }
            
            if (self?.filteredPetitions.isEmpty)! {
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                self?.warningMessage()
                }
            }
}
    
    func warningMessage(){
        let ac = UIAlertController(title: "Warning", message: "These Aren't The Droids You're Looking For. Use another key word for search", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async {
            [weak self] in
            self?.present(ac, animated: true)
        }
}

    //MARK: отображение detailviewcontroller
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailView = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
}
    
}
    
 



