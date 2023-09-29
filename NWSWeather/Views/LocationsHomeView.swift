//
//  LocationsHomeView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/18/23.
//

import SwiftUI
import SwiftData

struct LocationsHomeView: View {
    @EnvironmentObject private var userLocationManager: UserLocationManager
    @EnvironmentObject private var locationSearchManager: LocationSearchManager
    @EnvironmentObject private var dataManager: DataManager
    @Environment(\.modelContext) private var context
    @Query(sort: \Location.sortOrder) private var locations: [Location]
    @State private var userLocation: Location?
    @State private var showSettingsView: Bool = false
    var body: some View {
        NavigationStack {
            if locationSearchManager.searchText == "" {
                List {
                    
                    
                    // MARK: User Location View
                    if let userLocation = userLocation {
                        LocationListRowView(location: userLocation, isUserLocation: true)
                            .listRowSeparator(.hidden)
                    } else {
                        // Loading View
                        Text("Loading User Location")
                    }
                    
                    
                    // MARK: Other Locations
                    ForEach(locations) { location in
                        LocationListRowView(location: location, isUserLocation: false)
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            context.delete(locations[index])
                        }
                    })
                    .onMove(perform: move)
                }
                .navigationTitle("Weather Forecasts")
//                .refreshable {

//                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        EditButton()
                        NavigationLink(destination: SettingsView(), label: {
                            Image(systemName: "gear")
                                .font(.system(size: 16))
                        })
                    }
                }
            } else {
                LocationSearchResultsView()
            }
        }
        .searchable(text: $locationSearchManager.searchText)
        .task {
            if userLocationManager.authorisationStatus == .authorizedWhenInUse {
                userLocation = await dataManager.getUserLocation(latitude: userLocationManager.latitude, longitude: userLocationManager.longitude)
            }
        }
    }
    
    // Move function
    func move(from source: IndexSet, to destination: Int) {
        var sortedLocations: [Location] = locations
        var newSortOrder: Int = 1
        sortedLocations.sort {
            $0.sortOrder < $1.sortOrder
        }
        sortedLocations.move(fromOffsets: source, toOffset: destination)
        for sortedLocation in sortedLocations {
            sortedLocation.sortOrder = newSortOrder
            newSortOrder += 1
        }
        for location in locations {
            for sortedLocation in sortedLocations {
                if sortedLocation.id == location.id {
                    location.sortOrder = sortedLocation.sortOrder
                }
            }
        }
    }
}

#Preview {
    LocationsHomeView()
}
