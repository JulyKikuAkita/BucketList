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
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                Section("Nearby…") {
                    switch loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(pages, id:\.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text("Page description here")
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
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description

                    onSave(newLocation)
                    dismiss()
                }
            }.task {
                await fetchNearbyPlaces()
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
    
    // fetch places from Wikipidia
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        // guard let url = URL(string: urlString) else {
        guard let url = getGPSQueryUrl() else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // we got some data back!
            let items = try JSONDecoder().decode(Result.self, from: data)
            
            // success – convert the array values to our pages array
            pages = items.query.pages.values.sorted{ $0.title < $1.title }
            loadingState = .loaded
        } catch {
            // if we're still here it means the request failed somehow
            loadingState = .failed
        }
    }
    
    /**
     Generate "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
     
     */
    func getGPSQueryUrl() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "en.wikipedia.org"
        components.path = "/w/api.php"
        components.queryItems = [
            URLQueryItem(name: "ggscoord", value: "\(location.latitude)|\(location.longitude)"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "coordinates|pageimages|pageterms"),
            URLQueryItem(name: "colimit", value: "50"),
            URLQueryItem(name: "piprop", value: "thumbnail"),
            URLQueryItem(name: "pithumbsize", value: "500"),
            URLQueryItem(name: "pilimit", value: "50"),
            URLQueryItem(name: "wbptterms", value: "description"),
            URLQueryItem(name: "generator", value: "geosearch"),
            URLQueryItem(name: "ggsradius", value: "10000"),
            URLQueryItem(name: "ggslimit", value: "50"),
            URLQueryItem(name: "format", value: "json")
        ]
        return components.url
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.exampleFleurDeChineHotelSunMoonLake) { newLocation in }
    }
}
