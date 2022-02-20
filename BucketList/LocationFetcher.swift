//
//  LocationFetcher.swift
//  BucketList
//
//  Created by July on 2/19/22.
//
/**
 Day 78 Challenge: https://www.hackingwithswift.com/100/swiftui/78
 
 Follow up: Add a new feature for naming a picture app https://www.hackingwithswift.com/guide/ios-swiftui/6/3/challenge
 when you’re viewing a picture that was imported, you should show a map with a pin that marks where they were when that picture was added.
 It might be on the same screen side by side with the photo, it might be shown or hidden using a segmented control, or perhaps it’s on a different screen – it’s down to you.
 */

import Foundation
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
