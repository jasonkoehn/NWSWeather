//
//  DataManager.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/15/23.
//

import Foundation

class DataManager: ObservableObject {
    
    // Get LocationViewModel
    func getLocationViewModel(location: Location) async -> LocationViewModel? {
        var locationViewModel: LocationViewModel = LocationViewModel(id: location.id, city: location.city, state: location.state, dailyForecast: [], hourlyForecast: [], forecastDiscussion: "")
        if let dailyForecast = await getForecast(url: location.dailyForecastUrl) {
            locationViewModel.dailyForecast = dailyForecast
        } else {
            return nil
        }
        if let hourlyForecastUrl = await getForecast(url: location.hourlyForecastUrl) {
            locationViewModel.hourlyForecast = hourlyForecastUrl
        } else {
            return nil
        }
        if let discussionUrlId = await propertiesUrlRequest(officeId: location.officeId) {
            if let discussion = await discussionUrlRequest(urlId: discussionUrlId) {
                locationViewModel.forecastDiscussion = discussion
            }
        } else {
            return nil
        }
        return locationViewModel
    }
    
    // Info for user location
    func getUserLocation(latitude: Double, longitude: Double) async -> Location? {
        let location: Location = Location(sortOrder: 0, city: "", state: "", officeId: "", dailyForecastUrl: "", hourlyForecastUrl: "")
        UserLocationManager().getUserAddress(latitude: latitude, longitude: longitude) { place, error in
            location.city = place?.locality ?? ""
            location.state = place?.administrativeArea ?? ""
        }
        if let locationUrls = await locationUrlsRequest(latitude: latitude, longitude: longitude) {
            location.officeId = locationUrls.gridId
            location.dailyForecastUrl = locationUrls.forecast
            location.hourlyForecastUrl = locationUrls.forecastHourly
        } else {
            return nil
        }
        return location
    }
    
    // Forecast modeling
    func getForecast(url: String) async -> [Forecast]? {
        var forecast: [Forecast] = []
        if let forecastRequest = await forecastUrlRequest(url: url) {
            for item in forecastRequest {
                forecast.append(Forecast(number: item.number, name: item.name, startTime: item.startTime, endTime: item.endTime, isDaytime: item.isDaytime, temperature: item.temperature, probabilityOfPrecipitation: Int(item.probabilityOfPrecipitation.value ?? 0), dewpointTemperature: celsiusToFahrenheit(celsius: item.dewpoint.value), relativeHumidity: Int(item.relativeHumidity.value), windSpeed: item.windSpeed, windDirection: item.windDirection, icon: item.icon, shortForecast: item.shortForecast, detailedForecast: item.detailedForecast))
            }
        } else {
            return nil
        }
        return forecast
    }
    
    // Url requests
    func locationUrlsRequest(latitude: Double, longitude: Double) async -> LocationUrlModel? {
        let url = "https://api.weather.gov/points/\(latitude),\(longitude)"
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try? JSONDecoder().decode(LocationUrlPropertiesModel.self, from: data).properties
        } catch {
            print("Invalid Data")
            return nil
        }
    }
    func forecastUrlRequest(url: String) async -> [ForecastItemsModel]? {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try? JSONDecoder().decode(ForecastFileModel.self, from: data).properties.periods
        } catch {
            print("Invalid Data")
            return nil
        }
    }
    func propertiesUrlRequest(officeId: String) async -> String? {
        let url = "https://api.weather.gov/products/types/AFD/locations/"+officeId
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try? JSONDecoder().decode(ProductsFileModel.self, from: data).graph.first?.id
        } catch {
            print("Invalid Data")
            return nil
        }
    }
    func discussionUrlRequest(urlId: String) async -> String? {
        let url = "https://api.weather.gov/products/"+urlId
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try? JSONDecoder().decode(DiscussionModel.self, from: data).productText
        } catch {
            print("Invalid Data")
            return nil
        }
    }
    
    // Celsius to Fahrenheit
    func celsiusToFahrenheit(celsius: Double) -> Int {
        let celsius = Measurement(value: celsius, unit: UnitTemperature.celsius)
        let fahrenheit = Int(celsius.converted(to: .fahrenheit).value)
        return fahrenheit
    }
}
