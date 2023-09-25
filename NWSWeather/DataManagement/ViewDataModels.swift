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
    var startTime: Date
    var endTime: Date
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
    var hourlyForecast: [HourlyForecast]
    
    // Initializer
    init(number: Int, name: String, startTime: Date, endTime: Date, isDaytime: Bool, temperature: Int, probabilityOfPrecipitation: Int, dewpointTemperature: Int, relativeHumidity: Int, windSpeed: String, windDirection: String, icon: String, shortForecast: String, detailedForecast: String, hourlyForecast: [HourlyForecast]) {
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
        self.hourlyForecast = hourlyForecast
    }
}

struct HourlyForecast: Equatable, Identifiable {
    var id: UUID
    var number: Int
    var startTime: Date
    var endTime: Date
    var hourOfDay: String
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
    
    // Initializer
    init(number: Int, startTime: Date, endTime: Date, hourOfDay: String, isDaytime: Bool, temperature: Int, probabilityOfPrecipitation: Int, dewpointTemperature: Int, relativeHumidity: Int, windSpeed: String, windDirection: String, icon: String, shortForecast: String) {
        self.id = UUID()
        self.number = number
        self.startTime = startTime
        self.endTime = endTime
        self.hourOfDay = hourOfDay
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
    }
}


struct LocationViewModel: Identifiable {
    var id: UUID
    var city: String
    var state: String
    var dailyForecast: [Forecast]
    var forecastDiscussion: String
    init(id: UUID, city: String, state: String, dailyForecast: [Forecast], forecastDiscussion: String) {
        self.id = id
        self.city = city
        self.state = state
        self.dailyForecast = dailyForecast
        self.forecastDiscussion = forecastDiscussion
    }
}
