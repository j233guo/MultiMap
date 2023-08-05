//
//  Location.swift
//  MultiMap
//
//  Created by Jiaming Guo on 2023-08-05.
//

import Foundation
import MapKit

struct Location: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longtitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
}
