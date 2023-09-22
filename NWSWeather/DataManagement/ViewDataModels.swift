//
//  ViewDataModels.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/15/23.
//

import Foundation
import SwiftData

// SwiftData Model and Dependents
@Model
class Location {
    var id: UUID
    var sortOrder: Int // For list reordering
    var city: String
    var state: String
    
    // Url Storage
    var officeId: String
    var dailyForecastUrl: String
    var hourlyForecastUrl: String
    
    // Initializer
    init(sortOrder: Int, city: String, state: String, officeId: String, dailyForecastUrl: String, hourlyForecastUrl: String) {
        self.id = UUID()
        self.sortOrder = sortOrder
        self.city = city
        self.state = state
        self.officeId = officeId
        self.dailyForecastUrl = dailyForecastUrl
        self.hourlyForecastUrl = hourlyForecastUrl
    }
}

struct Forecast: Equatable, Identifiable {
    var id: UUID
    var number: Int
    var name: String
    var startTime: String
    var endTime: String
    var isDaytime: Bool
    var temperature: Int
    var temperatureUnit: String
    var probabilityOfPrecipitation: Int
    var probabilityOfPrecipitationUnit: String
    var dewpointTemperature: Int
    var dewpointUnit: String
    var relativeHumidity: Int
    var relativeHumidityUnit: String
    var windSpeed: String
    var windDirection: String
    var icon: String
    var shortForecast: String
    var detailedForecast: String
    
    // Initializer
    init(number: Int, name: String, startTime: String, endTime: String, isDaytime: Bool, temperature: Int, probabilityOfPrecipitation: Int, dewpointTemperature: Int, relativeHumidity: Int, windSpeed: String, windDirection: String, icon: String, shortForecast: String, detailedForecast: String) {
        self.id = UUID()
        self.number = number
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.isDaytime = isDaytime
        self.temperature = temperature
        self.temperatureUnit = "°F"
        self.probabilityOfPrecipitation = probabilityOfPrecipitation
        self.probabilityOfPrecipitationUnit = "%"
        self.dewpointTemperature = dewpointTemperature
        self.dewpointUnit = "°F"
        self.relativeHumidity = relativeHumidity
        self.relativeHumidityUnit = "%"
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.icon = icon
        self.shortForecast = shortForecast
        self.detailedForecast = detailedForecast
    }
}

struct LocationViewModel: Identifiable {
    var id: UUID
    var city: String
    var state: String
    var dailyForecast: [Forecast]
    var hourlyForecast: [Forecast]
    var forecastDiscussion: String
    init(id: UUID, city: String, state: String, dailyForecast: [Forecast], hourlyForecast: [Forecast], forecastDiscussion: String) {
        self.id = id
        self.city = city
        self.state = state
        self.dailyForecast = dailyForecast
        self.hourlyForecast = hourlyForecast
        self.forecastDiscussion = forecastDiscussion
    }
}
