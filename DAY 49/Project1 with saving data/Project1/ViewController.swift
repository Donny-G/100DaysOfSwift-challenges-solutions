//
//  ViewController.swift
//  Project1
//
//  Created by DeNNiO G on 27/02/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var dict = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        performSelector(inBackground: #selector(loadFiles), with: nil)
        
        let defaults = UserDefaults.standard
        if let loadDict = defaults.object(forKey: "dict") as? Data {
            let jsonDecoder = JSONDecoder()
            do{
                dict = try jsonDecoder.decode([String: Int].self, from: loadDict)
            }catch{
                print("error in load data")
            }
        }
    }
    
    @objc func loadFiles(){
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                
                DispatchQueue.main.async {
                    [weak self] in
                    self?.tableView.reloadData()
                }
            }
            pictures.sort()
        }
        print(dict)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pictures", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        let currentViewedPicture = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Numbers of views: \(dict[currentViewedPicture]!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            vc.positionOfSelectedImage = indexPath.row + 1
            vc.totalPictures = pictures.count
            let pictureTapped = pictures[indexPath.row]
            dict[pictureTapped]! += 1
            tableView.reloadData()
            save()
            print(dict)
        }
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedDict = try? jsonEncoder.encode(dict){
            let defaults = UserDefaults.standard
            defaults.set(savedDict, forKey: "dict")
        }else{
            print("Failed to save data")
        }
    }
    
}


