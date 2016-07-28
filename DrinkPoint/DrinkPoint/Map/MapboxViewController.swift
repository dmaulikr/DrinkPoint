//
//  MapboxViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/1/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import Mapbox

class MapboxViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.delegate = self
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURLWithVersion(9))
        let center = CLLocationCoordinate2D(latitude: 36.158895, longitude: -86.782080)
        mapView.setCenterCoordinate(center, zoomLevel: 14, direction: 0, animated: false)
        view.addSubview(mapView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let userMarker = MGLPointAnnotation()
        userMarker.coordinate = CLLocationCoordinate2D.init()
        userMarker.title = "Your Location"
        userMarker.subtitle = "Have fun having fun!"
        mapView.addAnnotation(userMarker)
        
        let tootsiesMarker = MGLPointAnnotation()
        tootsiesMarker.coordinate = CLLocationCoordinate2D(latitude: 36.160940, longitude: -86.778316)
        tootsiesMarker.title = "Tootsie’s Orchid Lounge"
        tootsiesMarker.subtitle = "422 Broadway, Nashville, TN 37203"
        mapView.addAnnotation(tootsiesMarker)
        
        let stationInnMarker = MGLPointAnnotation()
        stationInnMarker.coordinate = CLLocationCoordinate2D(latitude: 36.152530, longitude: -86.784543)
        stationInnMarker.title = "Station Inn"
        stationInnMarker.subtitle = "402 12th Ave S, Nashville, TN 37203"
        mapView.addAnnotation(stationInnMarker)
        
        let coyoteMarker = MGLPointAnnotation()
        coyoteMarker.coordinate = CLLocationCoordinate2D(latitude: 36.163687, longitude: -86.775784)
        coyoteMarker.title = "Coyote Ugly"
        coyoteMarker.subtitle = "154 2nd Ave N, Nashville, TN 37201"
        mapView.addAnnotation(coyoteMarker)
        
        let wildhorseMarker = MGLPointAnnotation()
        wildhorseMarker.coordinate = CLLocationCoordinate2D(latitude: 36.162753, longitude: -86.775195)
        wildhorseMarker.title = "Wildhorse Saloon"
        wildhorseMarker.subtitle = "120 2nd Ave N, Nashville, TN 37201"
        mapView.addAnnotation(wildhorseMarker)
        
        let fleetStreetMarker = MGLPointAnnotation()
        fleetStreetMarker.coordinate = CLLocationCoordinate2D(latitude: 36.164369, longitude: -86.778515)
        fleetStreetMarker.title = "Fleet Street Pub"
        fleetStreetMarker.subtitle = "207 Printers Alley, Nashville, TN 37201"
        mapView.addAnnotation(fleetStreetMarker)
        
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}