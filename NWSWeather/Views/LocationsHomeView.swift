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
    @State private var locationViewModels: [LocationViewModel] = []
    @State private var userLocationViewModel: LocationViewModel?
    @State private var showSettingsView: Bool = false
    var body: some View {
        NavigationStack {
            if locationSearchManager.searchText == "" {
                List {
                    
                    
                    // MARK: User Location View
                    if let userLocationViewModel = userLocationViewModel {
                        LocationListTileView(locationViewModel: userLocationViewModel, todaysForecast: userLocationViewModel.dailyForecast.first!, isUserLocation: true)
                            .listRowSeparator(.hidden)
                    } else {
                        // Loading View
                        Text("Loading User Location")
                    }
                    
                    
                    // MARK: Other Locations
                    ForEach(locations) { location in
                        LocationListRowView(locationId: location.id, locationViewModels: $locationViewModels)
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
                .refreshable {
                    if let userLocation = await dataManager.getUserLocation(latitude: userLocationManager.latitude, longitude: userLocationManager.longitude) {
                        if let locationViewModel = await dataManager.getLocationViewModel(location: userLocation) {
                            self.userLocationViewModel = locationViewModel
                        }
                    }
                    for location in locations {
                        if let locationViewModel = await dataManager.getLocationViewModel(location: location) {
                            locationViewModels.append(locationViewModel)
                        }
                    }
                }
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
            print("home")
            if let userLocation = await dataManager.getUserLocation(latitude: userLocationManager.latitude, longitude: userLocationManager.longitude) {
                if let locationViewModel = await dataManager.getLocationViewModel(location: userLocation) {
                    self.userLocationViewModel = locationViewModel
                }
            }
            for location in locations {
                if let locationViewModel = await dataManager.getLocationViewModel(location: location) {
                    locationViewModels.append(locationViewModel)
                }
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
