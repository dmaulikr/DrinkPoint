//
//  MapAnnotation.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8-17-16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {

    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }    
}