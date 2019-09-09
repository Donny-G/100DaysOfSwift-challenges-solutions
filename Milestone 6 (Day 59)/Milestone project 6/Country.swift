//
//  Country.swift
//  Milestone project 6
//
//  Created by DeNNiO   G on 03/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import Foundation

struct Country: Codable {
    var name: String
    var callingCodes: String
    var capital: String
    var altSpellings: [String]
    var region: String
    var subregion: String
    var population: Int
    var latlng: [Double]
    var demonym: String
    var area: Double?
    var gini: Double?
    var timezones: [String]
    var borders: [String]
    var nativeName: String
    var numericCode: String?
    var currenciescode: String?
    var currenciesname: String?
    var currenciessymbol: String?
    var languagesiso639_1: String?
    var languagesiso639_2: String
    var languagesname: String
    var languagesnativeName: String
}
