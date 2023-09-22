//
//  ApiDataModels.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/15/23.
//

import Foundation

// LocationUrlModel
struct LocationUrlPropertiesModel: Codable {
    var properties: LocationUrlModel
}
struct LocationUrlModel: Codable {
    var gridId: String
    var forecast: String
    var forecastHourly: String
}

// ForecastApiModel
struct ForecastFileModel: Codable {
    var properties: ForecastPropertiesModel
}
struct ForecastPropertiesModel: Codable {
    var periods: [ForecastItemsModel]
}
struct ForecastItemsModel: Codable {
    var number: Int
    var name: String
    var startTime: String
    var endTime: String
    var isDaytime: Bool
    var temperature: Int
    var temperatureUnit: String
    var temperatureTrend: String?
    var probabilityOfPrecipitation: ProbabilityOfPrecipitation
    var dewpoint: Dewpoint
    var relativeHumidity: RelativeHumidity
    var windSpeed: String
    var windDirection: String
    var icon: String
    var shortForecast: String
    var detailedForecast: String
    
    struct ProbabilityOfPrecipitation: Codable {
        var unitCode: String
        var value: Double?
    }
    struct Dewpoint: Codable {
        var unitCode: String
        var value: Double
    }
    struct RelativeHumidity: Codable {
        var unitCode: String
        var value: Double
    }
}

//ProductsApiModel
struct ProductsFileModel: Codable {
    var graph: [GraphModel]
    enum CodingKeys: String, CodingKey {
        case graph = "@graph"
    }
}
struct GraphModel: Codable {
    var id: String
}

//DiscussionApiModel
struct DiscussionModel: Codable {
    var productText: String
}
