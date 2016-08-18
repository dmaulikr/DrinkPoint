//
//  MapAPI.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8-17-16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation
import QuadratTouch
import MapKit
import RealmSwift

struct API {
    struct notifications {
        static let venuesUpdated = "venues_updated"
    }
}

class MapAPI {

    static let sharedInstance = MapAPI()
    
    var session: Session?
    
    init() {
        let client = Client(
            clientID: "OD1R3AZKRVHJYF1BOU0F1UVLH3ZPEB45UG0D53WGHH0PDKTL",
            clientSecret: "TZJGGS1JPTZ1VM3K3VHBOCF3QSF0KES411MMKU3UCQV4ZIA2",
            redirectURL: "")
        let configuration = Configuration(client: client)
        Session.setupSharedSessionWithConfiguration(configuration)
        self.session = Session.sharedSession()
    }
    
    func getBarsWithLocation(location: CLLocation) {
        if let session = self.session {
            var parameters = location.parameters()
            parameters += [Parameter.categoryId: "4bf58dd8d48988d116941735"]
            parameters += [Parameter.radius: "5000"]
            parameters += [Parameter.limit: "50"]
            let searchTask = session.venues.search(parameters) {
                (result) -> Void in
                if let response = result.response {
                    if let venues = response["venues"] as? [[String: AnyObject]] {
                        autoreleasepool {
                            let realm = try! Realm()
                            realm.beginWrite()
                            for venue: [String: AnyObject] in venues {
                                let venueObject: Venue = Venue()
                                if let id = venue["id"] as? String {
                                    venueObject.id = id
                                }
                                if let name = venue["name"] as? String {
                                    venueObject.name = name
                                }
                                if let location = venue["location"] as? [String: AnyObject] {
                                    if let longitude = location["lng"] as? Float {
                                        venueObject.longitude = longitude
                                    }
                                    if let latitude = location["lat"] as? Float {
                                        venueObject.latitude = latitude
                                    }
                                    if let formattedAddress = location["formattedAddress"] as? [String] {
                                        venueObject.address = formattedAddress.joinWithSeparator(" ")
                                    }
                                }
                                realm.add(venueObject, update: true)
                            }
                            do {
                                try realm.commitWrite()
                                print("Committing write . . .")
                            }
                            catch (let error) {
                                print("No Realm data: \(error)")
                            }
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName(API.notifications.venuesUpdated, object: nil, userInfo: nil)
                    }
                }
            }
            searchTask.start()
        }
    }
}

extension CLLocation {

    func parameters() -> Parameters {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}