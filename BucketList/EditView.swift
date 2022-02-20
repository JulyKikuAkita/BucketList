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
    var onSave: (Location) -> Void
    @StateObject private var viewModel:EditViewModel

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(viewModel.pages, id:\.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    guard let newLocation = viewModel.save() else {
                        print("save lovation failed")
                        return
                    }
                    onSave(newLocation)
                    dismiss()
                }
                Spacer()
                Button("Delete") {
                    guard let newLocation = viewModel.save() else {
                        print("save lovation failed")
                        return
                    }
                    onSave(newLocation)
                    dismiss()
                }
            }.task {
                await viewModel.fetchNearbyPlaces()
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
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: EditViewModel(location: location))
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.exampleFleurDeChineHotelSunMoonLake) { newLocation in }
    }
}
