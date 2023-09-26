//
//  LocationListRowView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/18/23.
//

import SwiftUI

struct LocationListRowView: View {
    var locationId: UUID
    @Binding var locationViewModels: [LocationViewModel]
    @State private var locationModel: LocationViewModel?
    var body: some View {
        VStack {
            if let locationModel = locationModel {
                LocationListTileView(locationViewModel: locationModel, todaysForecast: locationModel.dailyForecast.first!, isUserLocation: false)
            } else {
                Text("Loading...")
            }
        }
        .onChange(of: locationViewModels, initial: false) { oldLocations, newLocations in
            for location in newLocations {
                if location.id == locationId {
                    locationModel = location
                }
            }
        }
    }
}
