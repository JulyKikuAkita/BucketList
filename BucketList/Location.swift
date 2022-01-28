//
//  Location.swift
//  BucketList
//
//  Created by Ifang Lee on 1/28/22.
//

import Foundation

/**
 protocols:
 Identifiable, so we can create many location markers in our map.
 Codable, so we can load and save map data easily.
 Equatable, so we can find one particular location in an array of locations.
 */
struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
