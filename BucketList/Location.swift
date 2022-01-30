//
//  Location.swift
//  BucketList
//
//  Created by Ifang Lee on 1/28/22.
//

import Foundation
import CoreLocation
import MapKit
/**
 protocols:
 Identifiable, so we can create many location markers in our map.
 Codable, so we can load and save map data easily.
 Equatable, so we can find one particular location in an array of locations.
 */
struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // Good practice to add exmpale:  makes SwiftUI previewing significantly easier
    static let example = Location(id: UUID(), name: "Buckinghan Palace", description: "Where Queen Elizabeth lives with her dorgis.", latitude: 51.501, longitude: -0.141)
    static let exampleFleurDeChineHotelSunMoonLake = Location(id: UUID(), name: "Fleur de Chine", description: "Fleur de Chine Hotel at Sun Moon Lake", latitude: 23.8709, longitude: 120.9235)

    /**
        By default, a struct conform to Equatable automatically comparing every properties, which is rather wasteful given there's already UUID
        Thus, overide == function to only compare id of Location struct
     */
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
