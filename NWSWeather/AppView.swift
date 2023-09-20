//
//  AppView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/15/23.
//

import SwiftUI
import SwiftData

struct AppView: View {
    @StateObject private var userLocationManager = UserLocationManager()
    @StateObject private var locationSearchManager = LocationSearchManager()
    @StateObject private var dataManager = DataManager()
    var body: some View {
        LocationsHomeView()
            .environmentObject(userLocationManager)
            .environmentObject(locationSearchManager)
            .environmentObject(dataManager)
            .modelContainer(for: Location.self)
    }
}

#Preview {
    AppView()
}
