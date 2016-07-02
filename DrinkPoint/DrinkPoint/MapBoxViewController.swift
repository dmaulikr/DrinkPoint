//
//  MapBoxViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/1/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import Mapbox

class MapBoxViewController: UIViewController, MGLMapViewDelegate {

    var map: MGLMapView!
  
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.barTintColor = UIColor(red: 0.031, green: 0.102, blue: 0.125, alpha: 1.00) // Hex #081a20
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        map = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURLWithVersion(9))
        map.setCenterCoordinate(CLLocationCoordinate2D(
            latitude: 36.158895,
            longitude: -86.782080),
            zoomLevel: 14,
            animated: false)
        map.delegate = self
        view.addSubview(map)

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let tootsiesMarker = MGLPointAnnotation()
        tootsiesMarker.coordinate = CLLocationCoordinate2D(latitude: 36.160940, longitude: -86.778316)
        tootsiesMarker.title = "Tootsie’s Orchid Lounge"
        tootsiesMarker.subtitle = "422 Broadway, Nashville, TN 37203"
        map.addAnnotation(tootsiesMarker)
        
        let stationInnMarker = MGLPointAnnotation()
        stationInnMarker.coordinate = CLLocationCoordinate2D(latitude: 36.152530, longitude: -86.784543)
        stationInnMarker.title = "Station Inn"
        stationInnMarker.subtitle = "402 12th Ave S, Nashville, TN 37203"
        map.addAnnotation(stationInnMarker)
        
        let coyoteMarker = MGLPointAnnotation()
        coyoteMarker.coordinate = CLLocationCoordinate2D(latitude: 36.163687, longitude: -86.775784)
        coyoteMarker.title = "Coyote Ugly"
        coyoteMarker.subtitle = "154 2nd Ave N, Nashville, TN 37201"
        map.addAnnotation(coyoteMarker)
        
        let wildhorseMarker = MGLPointAnnotation()
        wildhorseMarker.coordinate = CLLocationCoordinate2D(latitude: 36.162753, longitude: -86.775195)
        wildhorseMarker.title = "Wildhorse Saloon"
        wildhorseMarker.subtitle = "120 2nd Ave N, Nashville, TN 37201"
        map.addAnnotation(wildhorseMarker)
        
        let fleetStreetMarker = MGLPointAnnotation()
        fleetStreetMarker.coordinate = CLLocationCoordinate2D(latitude: 36.164369, longitude: -86.778515)
        fleetStreetMarker.title = "Fleet Street Pub"
        fleetStreetMarker.subtitle = "207 Printers Alley, Nashville, TN 37201"
        map.addAnnotation(fleetStreetMarker)

    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}