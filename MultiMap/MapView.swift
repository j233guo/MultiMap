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
    @State private var selectedLocations = Set<Location>()
    
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
            selectedLocations = [newLocation]
        }
        searchText = ""
    }
    
    var body: some View {
        NavigationSplitView {
            List(locations, id: \.id, selection: $selectedLocations) { location in
                Text(location.name)
                    .tag(location)
            }
            .frame(minWidth: 200)
        } detail: {
            VStack {
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
                .ignoresSafeArea()
            }
            .onChange(of: selectedLocations) { _ in
                var visibleMap = MKMapRect.null
                for location in selectedLocations {
                    let mapPoint = MKMapPoint(location.coordinate)
                    let pointRect = MKMapRect(x: mapPoint.x - 100_000, y: mapPoint.y - 100_000, width: 200_000, height: 200_000)
                    visibleMap = visibleMap.union(pointRect)
                }
                var newRegion = MKCoordinateRegion(visibleMap)
                newRegion.span.latitudeDelta *= 1.5
                newRegion.span.longitudeDelta *= 1.5
                withAnimation {
                    region = newRegion
                }
            }
        }
        .searchable(text: $searchText, placement: .sidebar)
        .onSubmit(of: .search, runSearch)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
