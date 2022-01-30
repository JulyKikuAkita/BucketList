//
//  EditView.swift
//  BucketList
//
//  Created by Ifang Lee on 1/29/22.
//

import SwiftUI

/**
 Q:  How can we pass the new location data back?
 - If use @Binding to pass in a remote value, it creates problems with our optional in ContentView: we want EditView to be bound to a real value rather than an optional value
 - onSave: (Location) -> Void: a function to call where we can pass back whatever new location we want.
 */
struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location

    @State private var name: String
    @State private var description: String

    var onSave: (Location) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description

                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }

    /**
     Use initializer to create State structs to initiazlie name and description state value
     - uses the same underscore approach we used when creating a fetch request inside an initializer,
     which allows us to create an instance of the property wrapper not the data inside the wrapper.

     @escaping means the function is being stashed away for user later on, rather than being called immediately, and it’s needed here because the onSave function will get called only when the user presses Save.
     */
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave

        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.exampleFleurDeChineHotelSunMoonLake) { newLocation in }
    }
}
