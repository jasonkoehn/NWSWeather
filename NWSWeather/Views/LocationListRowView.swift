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
    var isUserLocation: Bool
    @State private var locationViewModel: LocationViewModel?
    var body: some View {
        VStack {
            if let locationViewModel = locationViewModel {
                LocationListTileView(locationViewModel: locationViewModel, todaysForecast: locationViewModel.dailyForecast.first!, isUserLocation: isUserLocation)
            } else {
                Text("Loading...")
            }
        }
        .task {
            locationViewModel = await dataManager.getLocationViewModel(location: location)
        }
    }
}
