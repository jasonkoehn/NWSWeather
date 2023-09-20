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
    var city: String
    var state: String
    @Transient var dailyForecast: [Forecast] = []
    
    // Url Storage
    var officeId: String
    var dailyForecastUrl: String
    var hourlyForecastUrl: String
    
    // Initializer
    init(city: String, state: String, dailyForecast: [Forecast], officeId: String, dailyForecastUrl: String, hourlyForecastUrl: String) {
        self.id = UUID()
        self.city = city
        self.state = state
        self.dailyForecast = dailyForecast
        self.officeId = officeId
        self.dailyForecastUrl = dailyForecastUrl
        self.hourlyForecastUrl = hourlyForecastUrl
    }
}

struct Forecast: Codable, Equatable, Identifiable {
    var id: UUID
    var number: Int
    var name: String
    var isDaytime: Bool
    var temperature: Int
    var temperatureUnit: String
    var windSpeed: String
    var windDirection: String
    var icon: String
    var shortForecast: String
    var detailedForecast: String
    // Initializer
    init(number: Int, name: String, isDaytime: Bool, temperature: Int, temperatureUnit: String, windSpeed: String, windDirection: String, icon: String, shortForecast: String, detailedForecast: String) {
        self.id = UUID()
        self.number = number
        self.name = name
        self.isDaytime = isDaytime
        self.temperature = temperature
        self.temperatureUnit = temperatureUnit
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.icon = icon
        self.shortForecast = shortForecast
        self.detailedForecast = detailedForecast
    }
}
