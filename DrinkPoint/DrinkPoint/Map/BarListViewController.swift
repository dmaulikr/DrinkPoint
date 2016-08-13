//
//  BarListViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8/2/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import MapKit

class BarListViewController: UITableViewController, MKMapViewDelegate {
    
    var detailViewController: BarDetailViewController? = nil
    var objects = [AnyObject]()
    var coordinate: Coordinate?
    var venues: [Venue] = [] {
        didSet {
            tableView.reloadData()
            addMapAnnotations()
        }
    }
    let foursquareClient = FoursquareClient(
        clientID: "OD1R3AZKRVHJYF1BOU0F1UVLH3ZPEB45UG0D53WGHH0PDKTL",
        clientSecret: "TZJGGS1JPTZ1VM3K3VHBOCF3QSF0KES411MMKU3UCQV4ZIA2")
    let manager = LocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func refreshData(sender: AnyObject) {
        if let coordinate = coordinate {
            foursquareClient.fetchBarsFor(coordinate, category: .Bar(nil))
            { result in
                switch result {
                case .Success(let venues):
                    self.venues = venues
                case .Failure(let error):
                    print(error)
                }
            }
        }
        refreshControl?.endRefreshing()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.getPermission()
        manager.onLocationFix = { [weak self] coordinate in
            self?.coordinate = coordinate
            self?.foursquareClient.fetchBarsFor(coordinate, category: .Bar(nil))
            { result in
                switch result {
                case .Success(let venues):
                    self?.venues = venues
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        region.center = mapView.userLocation.coordinate
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
    }
    
    func addMapAnnotations() {
        if venues.count > 0 {
            let annotations: [MKPointAnnotation] = venues.map { venue in
                let point = MKPointAnnotation()
                if let coordinate = venue.location?.coordinate{
                    point.coordinate = CLLocationCoordinate2D(latitude: coordinate.longitude, longitude: coordinate.longitude)
                    point.title = venue.name
                }
                return point
            }
            mapView.addAnnotations(annotations)
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BarCell", forIndexPath: indexPath) as! BarCell
        let venue = venues[indexPath.row]
        cell.barTitleLabel.text = venue.name
        cell.barCheckinLabel.text = venue.checkins.description
        cell.barCategoryLabel.text = venue.categoryName
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! BarDetailViewController
                let venue = venues[indexPath.row]
                controller.venue = venue
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}