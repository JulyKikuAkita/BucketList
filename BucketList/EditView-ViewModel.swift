//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Ifang Lee on 2/6/22.
//

import Foundation
import MapKit

extension EditView {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @MainActor class EditViewModel: ObservableObject {
        @Published var location: Location?
        @Published var name: String
        @Published var description: String
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        
        init(location: Location? = nil) {
            if let loc = location {
                self.location = loc
                name = loc.name
                description = loc.description
            } else {
                name = ""
                description = ""
            }
        }
        
        func save() -> Location? {
            guard let original = location else {
                print("Original location is nil, cannot save new location")
                return nil
            }
            var newLocation = original
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
        
        // fetch places from Wikipidia
        func fetchNearbyPlaces() async {
            guard let location = location else { return }
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
                pages = items.query.pages.values.sorted()
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
            guard let location = location else { return nil}

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
}
