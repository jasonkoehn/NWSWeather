//
//  LocationListRowView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/18/23.
//

import SwiftUI

struct LocationListRowView: View {
    @EnvironmentObject private var dataManager: DataManager
    var location: Location
    @State private var locationViewModel: LocationViewModel?
    @State private var locationSheet: LocationViewModel?
    var body: some View {
        VStack {
            if let locationViewModel = locationViewModel {
                Button(action: {
                    locationSheet = locationViewModel
                }) {
                    Text(locationViewModel.city)
                        .font(.title)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(locationViewModel.dailyForecast) { period in
                                Text("\(period.temperature)"+" "+period.temperatureUnit)
                                    .font(.title2)
                            }
                        }
                    }
                }
            } else {
                Text("Loading...")
            }
        }
        .task {
            if let locationViewModel = await dataManager.getLocationViewModel(location: location) {
                self.locationViewModel = locationViewModel
            }
        }
        .fullScreenCover(item: $locationSheet) { location in
            NavigationStack {
                LocationWeatherView(locationViewModel: location)
            }
        }
    }
}
