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
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isUnlocked {
                Map(coordinateRegion: $viewModel.mapRegiion, annotationItems: viewModel.locations) { location in
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
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
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
                            viewModel.addLocation()
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
            } else {
                Button("Unlock Places") {
                    viewModel.authenticate()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            // sheet takes an optional binding, auto unwrapped when it has a value set.
            // thus no need to unwrap the text view
            EditView(location: place) {
                viewModel.update(location: $0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
