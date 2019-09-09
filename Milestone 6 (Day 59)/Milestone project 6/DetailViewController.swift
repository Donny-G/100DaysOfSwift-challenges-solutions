//
//  DetailViewController.swift
//  Milestone project 6
//
//  Created by DeNNiO   G on 05/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var country: Country!
    var html: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButton))
        title = country.name
        
        let webView = WKWebView()
        view = webView
        let html = """
<html>
<head>
<meta name = "viewport" content = "width=device-width, initial-scale=1">
        <style> body { font-family: Arial; font-size: 100%; } </style>
</head>
<body>
        <b>Calling code: </b>\(country.callingCodes)<br>
        <b>Capital: </b>\(country.capital)<br>
        <b>Alt spellings: </b>\(country.altSpellings)<br>
        <b>Region: </b>\(country.region)<br>
        <b>Subregion: </b>\(country.subregion)<br>
        <b>Population: </b>\(country.population)<br>
        <b>Geographical coordinates: </b>\(country.latlng)<br>
        <b>Demonym: </b>\(country.demonym)<br>
        <b>Area: </b>\(country.area ?? 0.0)<br>
        <b>Gini: </b>\(country.gini ?? 0.0)<br>
        <b>Timezones: </b>\(country.timezones)<br>
        <b>Borders: </b> \(country.borders)<br>
        <b>Native name: </b> \(country.nativeName)<br>
        <b>Numeric code: </b> \(country.numericCode ?? "")<br>
        <br>
        <b>Currencies</b><br>
        Code: \(country.currenciescode ?? "")<br>
        Name: \(country.currenciesname ?? "")<br>
        Symbol: \(country.currenciessymbol ?? "")<br>
        <br>
        <b>Languages</b><br>
        iso639_1: \(country.languagesiso639_1 ?? "")<br>
        iso639_2: \(country.languagesiso639_2)<br>
        Language name: \(country.languagesname)<br>
        Language native name: \(country.languagesnativeName)
    
</body>
</hhtml>
"""
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    @objc func shareButton(){
        
      let date = """
        Calling code: \(country.callingCodes)
        Capital: \(country.capital)
        Alt spellings: \(country.altSpellings)
        Region: \(country.region)
        Subregion: \(country.subregion)
        Population: \(country.population)
        Geographical coordinates: \(country.latlng)
        Demonym: \(country.demonym)
        Area: \(country.area ?? 0.0)
        Gini: \(country.gini ?? 0.0)
        Timezones: \(country.timezones)
        Borders: \(country.borders)
        Native name: \(country.nativeName)
        Numeric code: \(country.numericCode ?? "")
        Code: \(country.currenciescode ?? "")
        Name: \(country.currenciesname ?? "")
        Symbol: \(country.currenciessymbol ?? "")
        Languages
        iso639_1: \(country.languagesiso639_1 ?? "")
        iso639_2: \(country.languagesiso639_2)
        Language name: \(country.languagesname)
        Language native name: \(country.languagesnativeName)
        """
        let avc = UIActivityViewController(activityItems: [date], applicationActivities: [])
        present(avc, animated: true, completion: nil)
    }
    
    
}
