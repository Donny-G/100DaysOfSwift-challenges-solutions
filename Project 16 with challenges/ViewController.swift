//
//  ViewController.swift
//  Project16
//
//  Created by Donny G on 10/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "https://en.wikipedia.org/wiki/London")
        
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "https://en.wikipedia.org/wiki/Oslo")
        
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "https://en.wikipedia.org/wiki/Paris")
        
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "https://en.wikipedia.org/wiki/Rome")
        
        let washington = Capital(title: "Washington D.C.", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View", style: .plain, target: self, action: #selector(selectedType))
    }
    
    @objc func selectedType (){
        let ac = UIAlertController(title: "Choose type of view", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .standard
        }))
        
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: {[weak self] _ in
            self?.mapView.mapType = .satellite
        }))
        
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: {[weak self] _ in
            self?.mapView.mapType = .hybrid
        }))
        
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: {[weak self] _ in
            self?.mapView.mapType = .hybridFlyover
        }))
        
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default, handler: {[weak self] _ in
            self?.mapView.mapType = .mutedStandard
        }))
        
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: {[weak self] _ in
            self?.mapView.mapType = .satelliteFlyover
        }))
        
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {return nil}
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .black
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            annotationView?.annotation = annotation

        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else
        {return}
        let info = capital.info
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else {fatalError("Unable to load site")}
        vc.info = info
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

