//
//  NewLocationView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/19/23.
//

import SwiftUI
import SwiftData

struct NewLocationView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.modelContext) private var context
    @Environment var dismissSearch: DismissSearchAction
    @Environment(\.dismiss) var dismiss
    @Query private var locations: [Location]
    var city: String
    var state: String
    var latitude: Double
    var longitude: Double
    @State var locationInfo: Location? = nil
    var body: some View {
        ScrollView {
            VStack {
                Text(city)
                Text(state)
                if let forecast = locationInfo?.dailyForecast {
                    ForEach(forecast) { period in
                        Text("\(period.temperature)")
                    }
                }
            }
        }
        .task {
            if let location = await dataManager.locationUrlsRequest(latitude: latitude, longitude: longitude) {
                if let forecast = await dataManager.getForecast(url: location.forecast) {
                    locationInfo = Location(sortOrder: 0, city: city, state: state, dailyForecast: forecast, officeId: location.gridId, dailyForecastUrl: location.forecast, hourlyForecastUrl: location.forecastHourly)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                if let locationInfo = locationInfo {
                    Button(action: {
                        let newSortNumber = locations.count + 1
                        let location = Location(sortOrder: newSortNumber, city: city, state: state, dailyForecast: [], officeId: locationInfo.officeId, dailyForecastUrl: locationInfo.dailyForecastUrl, hourlyForecastUrl: locationInfo.hourlyForecastUrl)
                        context.insert(location)
                        dismissSearch()
                        dismiss()
                    }, label: {
                        Text("Add")
                    })
                } else {
                    Text("Add")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
