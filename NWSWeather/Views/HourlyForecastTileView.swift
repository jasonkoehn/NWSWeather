//
//  HourlyForecastTileView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/23/23.
//

import SwiftUI

struct HourlyForecastTileView: View {
    var period: HourlyForecast
    var body: some View {
        VStack(alignment: .leading, spacing: 1.4) {
            HStack {
                Spacer()
                Text("\(period.hourOfDay)")
                    .font(.system(size: 18))
                    .fontDesign(.serif)
                Spacer()
            }
            Divider()
                .frame(height: 0.5)
                .overlay(.dividerLines)
            HStack {
                Text("Temp:")
                    .font(.system(size: 15))
                    .fontDesign(.serif)
                Spacer()
                Text("\(period.temperature)"+period.temperatureUnit)
                    .font(.system(size: 16))
            }
            Divider()
                .frame(height: 0.5)
                .overlay(.dividerLines)
            HStack {
                Text("Rain:")
                    .font(.system(size: 15))
                    .fontDesign(.serif)
                Spacer()
                Text("\(period.probabilityOfPrecipitation)"+period.probabilityOfPrecipitationUnit)
                    .font(.system(size: 16))
            }
            Divider()
                .frame(height: 0.5)
                .overlay(.dividerLines)
            HStack(alignment: .center, spacing: 0) {
                if period.windDirection.count < 3 {
                    Text(period.windDirection+":")
                        .font(.system(size: 15))
                    Spacer(minLength: 0)
                    Text(period.windSpeed)
                        .font(.system(size: 16))
                } else {
                    Text(period.windDirection+":")
                        .font(.system(size: 14))
                    Spacer(minLength: 0)
                    Text(period.windSpeed)
                        .font(.system(size: 15))
                }
            }
        }
        .padding(4)
        .frame(width: 100, height: 100)
        .background(.hourlyTile)
        .clipShape(.rect(cornerRadius: 6))
    }
}
