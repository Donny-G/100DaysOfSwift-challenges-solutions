//
//  ViewController.swift
//  Project22
//
//  Created by Donny G. on 02/10/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var distanceReading: UILabel!
    
    @IBOutlet var circleDetector: UIImageView!
    
    @IBOutlet var beaconName: UILabel!
    
    var locationManager: CLLocationManager?

    var firstTime = false
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray

        circleDetector.layer.cornerRadius = 128
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
              if status == .authorizedAlways {
                  if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                      if CLLocationManager.isRangingAvailable() {
                      startScanning()
                      }
                  }
              }
          }
    
    func startScanning() {
        //for iOS 13
        let beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        locationManager?.startRangingBeacons(satisfying: beaconIdentityConstraint)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconName.text =  "NO BEACON NEAR"
                self.circleAnimation(scale: 0.001)
                
            case .far:
                self.alert()
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.beaconName.text = self.uuid.uuidString
                self.circleAnimation(scale: 0.25)
                
            case .near:
                self.alert()
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.beaconName.text = self.uuid.uuidString
                self.circleAnimation(scale: 0.5)
                
            case .immediate:
                self.alert()
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.beaconName.text = self.uuid.uuidString
                self.circleAnimation(scale: 1)
                
            @unknown default:
                self.alert()
                self.view.backgroundColor = UIColor.black
                self.distanceReading.text = "WHOA!"
                self.beaconName.text = self.uuid.uuidString
                self.circleAnimation(scale: 2)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon  = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func alert() {
        if !firstTime {
            let ac  = UIAlertController(title: "NEW BEACON", message: "YOU HAVE FIUND NEW BEACON, DUDE", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true)
            firstTime = true
        }
    }
    
    func circleAnimation(scale: CGFloat) {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: [], animations: {
        self.circleDetector.transform = CGAffineTransform(scaleX: scale, y: scale)
             })
    }
    
}
