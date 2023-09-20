//
//  LocationSearchResultsView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/18/23.
//

import SwiftUI

struct LocationSearchResultsView: View {
    @EnvironmentObject private var locationSearchManager: LocationSearchManager
    @Environment(\.dismissSearch) private var dismissSearch
    @State var newLocation: SearchedLocation?
    var body: some View {
        if locationSearchManager.fetchedPlace != nil {
            List {
                if let place = locationSearchManager.fetchedPlace {
                    Button(action: {
                        newLocation = SearchedLocation(city: place.city, state: place.state, latitude: place.latitude, longitude: place.longitude)
                    }, label: {
                        Text(place.city+", "+place.state)
                    })
                }
            }
            .listStyle(.plain)
            .sheet(item: $newLocation) { location in
                NavigationStack {
                    NewLocationView(dismissSearch: _dismissSearch, city: location.city, state: location.state, latitude: location.latitude, longitude: location.longitude)
                }
            }
        } else {
            Text("No Results")
                .font(.title)
                .bold()
        }
    }
}
