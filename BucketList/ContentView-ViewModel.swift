//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Ifang Lee on 2/6/22.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    // The main actor is responsible for running all user interface updates
    // and adding that attribute to the class
    // behind the scenes whenever we use @StateObject or @ObservedObject
    // Swift was silently inferring the @MainActor attribute for us
    @MainActor class ViewModel: ObservableObject {
        // Kaohsiung: lat: 22.63 long:120.26
        // London: lat: 51.50 long:-0.11
        @Published var mapRegiion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 22.63, longitude: 120.26), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        
        let savePath = FileManager.documentDirectory.appendingPathComponent("SavedPlaces")

        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }

        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegiion.center.latitude, longitude: mapRegiion.center.longitude)
            locations.append(newLocation)
            save()
        }

        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return}

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }

        // locations is written with encryption and only can be read when the user has unlocked their device
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }

        func authenticate() {
            let context = LAContext()
            var error: NSError?

            // When that process completes Apple will call our completion closure, but that won’t be called on the main actor despite our @MainActor attribute.
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places" //for Touch ID

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        // solution 1: call task(any background thread, switch to main threa)
                        //Task {
                        //    await MainActor.run {
                        //        self.isUnlocked = true
                        //    }
                        //}
                        //
                        // solution 2: ask for a mainthread
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        // error
                        if let error = authenticationError {
                            print(error.localizedDescription)
                        } else {
                            print("generic error")
                        }
                    }
                }
            } else {
                // no biometrics
                print("The device does not support FaceID/TouchID. Use passcode Instead.")
            }
        }
    }
}

