//
//  ViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8-17-16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView?
    @IBOutlet var tableView: UITableView?
    
    @IBAction func foursquareLearnMore(sender: AnyObject) {
        SafariHandling.presentSafariVC(NSURL(string: "https://foursquare.com/about")!)
    }
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var venues: [Venue]?
    let distanceSpan: Double = 3000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.onVenuesUpdated(_:)), name: API.notifications.venuesUpdated, object: nil)
    }
    
    func refreshVenues(location: CLLocation?, getDataFromFoursquare: Bool = false) {
        if location != nil {
            lastLocation = location
        }
        if let location = lastLocation {
            if getDataFromFoursquare == true {
                MapAPI.sharedInstance.getBarsWithLocation(location)
            }
            let (start, stop) = calculateCoordinatesWithRegion(location)
            let predicate = NSPredicate(format: "latitude < %f AND latitude > %f AND longitude > %f AND longitude < %f", start.latitude, stop.latitude, start.longitude, stop.longitude)
            let realm = try! Realm()
            venues = realm.objects(Venue).filter(predicate).sort {
                location.distanceFromLocation($0.coordinate) < location.distanceFromLocation($1.coordinate)
            }
            for venue in venues! {
                let annotation = MapAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
                mapView?.addAnnotation(annotation)
            }
            tableView?.reloadData()
        }
    }
    
    func calculateCoordinatesWithRegion(location:CLLocation) -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distanceSpan, distanceSpan)
        var start: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var stop: CLLocationCoordinate2D = CLLocationCoordinate2D()
        start.latitude  = region.center.latitude  + (region.span.latitudeDelta  / 2)
        start.longitude = region.center.longitude - (region.span.longitudeDelta / 2)
        stop.latitude   = region.center.latitude  - (region.span.latitudeDelta  / 2)
        stop.longitude  = region.center.longitude + (region.span.longitudeDelta / 2)
        return (start, stop)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tableView = self.tableView {
            tableView.delegate = self
            tableView.dataSource = self
        }
        if let mapView = self.mapView {
            mapView.delegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)
            mapView.setRegion(region, animated: true)
            refreshVenues(newLocation, getDataFromFoursquare: true)
        }
    }
    
    func onVenuesUpdated(notification: NSNotification) {
        refreshVenues(nil)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")        
//            let infoButton = UIButton(type: .DetailDisclosure)
//            annotationView!.rightCalloutAccessoryView = infoButton
        }
        annotationView?.canShowCallout = true
        return annotationView
    }
    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let venue = view.annotation as! Venue
//        let placeName = String(venue.name)
//        let placeInfo = String(venue.address)
//        let alertController = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
//        alertController.addAction(UIAlertAction(title: "Got It!", style: .Default, handler: nil))
//        presentViewController(alertController, animated: true, completion: nil)
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier")
            cell!.backgroundColor = UIColor.clearColor()
        }
        if let venue = venues?[indexPath.row] {
            cell!.textLabel?.text = venue.name
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell!.detailTextLabel?.text = venue.address
            cell?.detailTextLabel?.textColor = UIColor.whiteColor()
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let venue = venues?[indexPath.row] {
            let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)), distanceSpan, distanceSpan)
            mapView?.setRegion(region, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}