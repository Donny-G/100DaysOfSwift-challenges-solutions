//
//  Note.swift
//  Milestone project 7 (notes)
//
//  Created by Donny G on 01/10/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import Foundation

struct Note: Codable {
    var id: String!
    var text: String
    var date: Date
    
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: Date())
    }
}

