//
//  MapView.swift
//  MultiMap
//
//  Created by Jiaming Guo on 2023-08-03.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.6527609, longitude: -79.3834137), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var searchText = ""
    @State private var locations = [Location]()
    
    func runSearch() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else { return }
            guard let item = response.mapItems.first else { return }
            guard let itemName = item.name, let itemLocation = item.placemark.location else { return }
            let newLocation = Location(name: itemName, latitude: itemLocation.coordinate.latitude, longtitude: itemLocation.coordinate.longitude)
            locations.append(newLocation)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search for something..", text: $searchText)
                Button("Go", action: runSearch)
            }
            .padding([.top, .horizontal])
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Text(location.name)
                        .font(.headline)
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(.black)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
