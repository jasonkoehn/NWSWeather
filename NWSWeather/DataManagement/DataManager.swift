//
//  DataManager.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/15/23.
//

import Foundation

class DataManager: ObservableObject {
    
    // Info for user location
    func userLocationForecast(latitude: Double, longitude: Double) async -> Location? {
        let location: Location = Location(city: "", state: "", dailyForecast: [], officeId: "", dailyForecastUrl: "", hourlyForecastUrl: "")
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
        if let dailyForecast = await getForecast(url: location.dailyForecastUrl) {
            location.dailyForecast = dailyForecast
        } else {
            return nil
        }
        return location
    }
    
    // Get Forecast for each location
    func locationsDailyForecasts(locations: [Location]) async -> [Location] {
        for location in locations {
            if var forecast = await getForecast(url: location.dailyForecastUrl) {
                forecast.sort {
                    $0.number < $1.number
                }
                location.dailyForecast = forecast
            }
        }
        return locations
    }
    
    // Forecast modeling
    func getForecast(url: String) async -> [Forecast]? {
        var forecast: [Forecast] = []
        if let forecastRequest = await forecastUrlRequest(url: url) {
            for item in forecastRequest {
                forecast.append(Forecast(number: item.number, name: item.name, isDaytime: item.isDaytime, temperature: item.temperature, temperatureUnit: item.temperatureUnit, windSpeed: item.windSpeed, windDirection: item.windDirection, icon: item.icon, shortForecast: item.shortForecast, detailedForecast: item.detailedForecast))
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
}
