//
//  ContentView.swift
//  BucketList
//
//  Created by Ifang Lee on 12/24/21.
//
import MapKit
import SwiftUI

//All data type should conform to the Identifiable to display properly on map
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span:MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)) // London

    let londonLocations  = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]

    var body: some View {
        //1. only zoom to London
        // Map(coordinateRegion: $mapRegion)

        //2. Show 2 blue tint of londonLocations
//        Map(coordinateRegion: $mapRegion, annotationItems: londonLocations) { location in
//            MapMarker(coordinate: location.coordinate, tint: .blue)
//        }

        //3. Show custom mark of londonLocations, even pass in swiftUI view
//        Map(coordinateRegion: $mapRegion, annotationItems: londonLocations) { location in
//            MapAnnotation(coordinate: location.coordinate){
//                Circle()
//                    .stroke(.red, lineWidth: 3)
//                    .frame(width: 44, height: 44)
//                    .onTapGesture {
//                        print("Tapped on \(location.name)")
//                    }
//            }
//        }

        //3. Wrap custom mark of londonLocations at navigation view
        NavigationView {
            Map(coordinateRegion: $mapRegion, annotationItems: londonLocations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    NavigationLink {
                        Text(location.name)
                    } label: {
                        Rectangle()
                            .stroke(.blue, lineWidth: 3)
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .navigationTitle("London Explorer")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
