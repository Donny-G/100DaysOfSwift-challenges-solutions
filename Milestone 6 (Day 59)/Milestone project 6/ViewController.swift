//
//  ViewController.swift
//  Milestone project 6
//
//  Created by DeNNiO   G on 03/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Countries"
        loading()
    }
    
    func loading() {
        guard let url = Bundle.main.url(forResource: "Countries", withExtension: "json") else {
            fatalError("Unable to find file")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load data")
        }
        let decoder = JSONDecoder()
        guard let decodedCountries = try? decoder.decode([Country].self, from: data) else {
            fatalError("Unable to decode countries")
        }
        self.countries = decodedCountries
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard  let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController else { fatalError("Unable to instantiate DVC")}
        vc.country = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

