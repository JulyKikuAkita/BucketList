//
//  ContentView.swift
//  BucketList
//
//  Created by Ifang Lee on 12/24/21.
//
import MapKit
import SwiftUI

// asking users to add places to the map that they want to visit
struct ContentView: View {
    // Kaohsiung: lat: 22.63 long:120.26
    // London: lat: 51.50 long:-0.11
    @State private var mapRegiion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 22.63, longitude: 120.26), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var locations = [Location]()
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegiion, annotationItems: locations) { location in
                //Style1: MapMarker: default map annotation
                //MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))

                //Style2: MapAnnotation: use customized swiftUI view annotation
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "pin.fill")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44) //Apple recommend min acceptable size for all decvices
//                            .background(.white)
                            .clipShape(Circle())
                        Text(location.name)
                    }
                }
            }
            .ignoresSafeArea()

            Circle()
                .fill(.pink)
                .opacity(0.4)
                .frame(width: 32, height: 32)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegiion.center.latitude, longitude: mapRegiion.center.longitude)
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
