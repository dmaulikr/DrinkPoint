////
////  MapboxDirectionsViewController.swift
////  DrinkPoint
////
////  Created by Paul Kirk Adams on 7/1/16.
////  Copyright © 2016 BinaryBastards. All rights reserved.
////
//
//import UIKit
//import Mapbox
//import MapboxDirections
//
//class MapBoxdirectionsViewController: UIViewController, MGLMapViewDelegate {
//    
//    let directions = Directions.sharedDirections
//    var map: MGLMapView!
//    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
//        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
//        navigationController!.navigationBar.titleTextAttributes =
//            [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        map.showsUserLocation = true
//        map.delegate = self
//        view.addSubview(map)
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        view.addSubview({ [unowned self] in
//            let label = UILabel(frame: CGRect(x: (self.view.bounds.size.width - 200) / 2,
//                y: (self.view.bounds.size.height - 40) / 2,
//                width: 200,
//                height: 40))
//            label.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]
//            label.textColor = UIColor.whiteColor()
//            label.textAlignment = .Center
//            label.text = "Check the console"
//            return label
//            }())
//        let options = RouteOptions(waypoints: [
//            Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047), name: "Mapbox"),
//            Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), name: "White House"),
//            ])
//        options.includesSteps = true
//        Directions.sharedDirections.calculateDirections(options: options) { (waypoints, routes, error) in
//            guard error == nil else {
//                print("Error calculating directions: \(error!)")
//                return
//            }
//            if let route = routes?.first, leg = route.legs.first {
//                print("Route via \(leg):")
//                let distanceFormatter = NSLengthFormatter()
//                let formattedDistance = distanceFormatter.stringFromMeters(route.distance)
//                let travelTimeFormatter = NSDateComponentsFormatter()
//                travelTimeFormatter.unitsStyle = .Short
//                let formattedTravelTime = travelTimeFormatter.stringFromTimeInterval(route.expectedTravelTime)
//                print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
//                for step in leg.steps {
//                    print("\(step.instructions)")
//                    if step.distance > 0 {
//                        let formattedDistance = distanceFormatter.stringFromMeters(step.distance)
//                        print("— \(formattedDistance) —")
//                    }
//                }
//            }
//        }
//    }
//    
//    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        return true
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//}