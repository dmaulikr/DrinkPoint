//
//  MapBoxViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/1/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
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

        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        map = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURLWithVersion(9))
        map.setCenterCoordinate(CLLocationCoordinate2D(
            latitude: 36.162664,
            longitude: -86.781602),
            zoomLevel: 12,
            animated: false)
        map.delegate = self
        view.addSubview(map)

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let marker = MGLPointAnnotation()
        marker.coordinate = map.centerCoordinate
        marker.title = "DrinkPoint Marker"
        marker.subtitle = "Have fun having fun!"
        map.addAnnotation(marker)
        map.selectAnnotation(marker, animated: true)

    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}