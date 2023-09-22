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
    @State private var forecast: [Forecast]?
    var body: some View {
        ScrollView {
            VStack {
                Text(city)
                Text(state)
                if let forecast = forecast {
                    ForEach(forecast) { period in
                        Text("\(period.temperature)")
                    }
                }
            }
        }
        .task {
            if let location = await dataManager.locationUrlsRequest(latitude: latitude, longitude: longitude) {
                    locationInfo = Location(sortOrder: 0, city: city, state: state, officeId: location.gridId, dailyForecastUrl: location.forecast, hourlyForecastUrl: location.forecastHourly)
            }
            if let forecast = await dataManager.getForecast(url: locationInfo?.dailyForecastUrl ?? "") {
                self.forecast = forecast
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
                        let location = Location(sortOrder: newSortNumber, city: city, state: state, officeId: locationInfo.officeId, dailyForecastUrl: locationInfo.dailyForecastUrl, hourlyForecastUrl: locationInfo.hourlyForecastUrl)
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
