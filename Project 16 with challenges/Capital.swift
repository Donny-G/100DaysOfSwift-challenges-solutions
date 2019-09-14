//
//  Capital.swift
//  Project16
//
//  Created by Donny G on 11/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import  MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }

}
