//
//  MapViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/10/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    let locationManager = CLLocationManager()

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBOutlet weak var milesLabel: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        let coyoteUglySaloon = CLLocation(latitude: 36.163687, longitude: -86.775784)
        let distanceInMeters = lastLocation.distanceFromLocation(coyoteUglySaloon)
        let distanceInMiles = distanceInMeters / 1609.34
        milesLabel.text = String(format: "%.1f", distanceInMiles)
        if let location = locations.first {
            print("location:: \(location)")
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}