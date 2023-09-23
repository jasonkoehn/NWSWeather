//
//  WeatherTileView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/22/23.
//

import SwiftUI

struct WeatherTileView: View {
    var period: Forecast
    @State var expand: Bool = false
    var body: some View {
        Button(action: {
            expand.toggle()
        }) {
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    VStack {
                        Text(period.name)
                            .font(.title2)
                        AsyncImage(url: URL(string: period.icon)) {image in image.resizable()} placeholder: {ShimmerEffectAnimationView()}
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Text("\(period.temperature)"+period.temperatureUnit)
                                .font(.title2)
                        }
                        Text(period.shortForecast)
                            .font(.system(size: 14))
                        Spacer()
                    }
                }
                if expand {
                    HStack(spacing: 15) {
                        Text("Dewpoint: "+"\(period.dewpointTemperature)"+period.dewpointUnit)
                    }
                }
            }
            .foregroundColor(.primary)
            .padding(10)
            .background(period.isDaytime ? .daytime : .nighttime)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

//var id: UUID
//var number: Int
//var name: String
//var startTime: String
//var endTime: String
//var isDaytime: Bool
//var temperature: Int
//var temperatureUnit: String
//var probabilityOfPrecipitation: Int
//var probabilityOfPrecipitationUnit: String
//var dewpointTemperature: Int
//var dewpointUnit: String
//var relativeHumidity: Int
//var relativeHumidityUnit: String
//var windSpeed: String
//var windDirection: String
//var icon: String
//var shortForecast: String
//var detailedForecast: String
