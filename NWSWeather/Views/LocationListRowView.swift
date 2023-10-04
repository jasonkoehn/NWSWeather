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
    @Binding var reload: Bool
    @State private var locationViewModel: LocationViewModel?
    var body: some View {
        VStack {
            if let locationViewModel = locationViewModel {
                LocationListTileView(locationViewModel: locationViewModel, todaysForecast: locationViewModel.dailyForecast.first!, isUserLocation: isUserLocation)
            } else {
                Text("Loading...")
            }
        }
        .onChange(of: reload, initial: true) {
            Task {
                locationViewModel = await dataManager.getLocationViewModel(location: location)
            }
        }
    }
}
