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
    @Query private var locations: [Location]
    @State private var userLocation: Location?
    @State var hasLoadedLocations: Bool = false
    var body: some View {
        NavigationStack {
            if locationSearchManager.searchText == "" {
                List {
                    
                    
                    // MARK: User Location View
                    if let location = userLocation {
                        LocationListRowView(location: location)
                    } else {
                        // Loading View
                        Text("Loading User")
                    }
                    
                    
                    // MARK: Other Locations
                    ForEach(locations) { location in
                        LocationListRowView(location: location)
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            context.delete(locations[index])
                        }
                    })
//                    .onMove(perform: move)
                }
                .navigationTitle("Weather")
                .listStyle(.plain)
                .toolbar {
                    EditButton()
                }
            } else {
                LocationSearchResultsView()
            }
        }
        .searchable(text: $locationSearchManager.searchText)
        .task {
            userLocation = await dataManager.userLocationForecast(latitude: userLocationManager.latitude, longitude: userLocationManager.longitude)
            for location in locations {
                if let forecast = await dataManager.getForecast(url: location.dailyForecastUrl) {
                    location.dailyForecast = forecast
                }
            }
            try? context.save()
            hasLoadedLocations = true
        }
    }
//    func move(from source: IndexSet, to destination: Int) {
//        locations.move(fromOffsets: source, toOffset: destination)
//    }
}

#Preview {
    LocationsHomeView()
}
