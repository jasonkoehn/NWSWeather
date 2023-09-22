//
//  WeatherTileView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/22/23.
//

import SwiftUI

struct WeatherTileView: View {
    var period: Forecast
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: period.icon)) {image in image.resizable()} placeholder: {ShimmerEffectAnimationView()}
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            VStack(alignment: .leading) {
                HStack {
                    Text(period.name)
                        .font(.title2)
                    Spacer()
                    Text("\(period.temperature)"+period.temperatureUnit)
                        .font(.title2)
                }
                Text(period.shortForecast)
                    .font(.system(size: 14))
                Spacer()
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 10))
    }
}
