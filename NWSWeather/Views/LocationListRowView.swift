//
//  LocationListRowView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/18/23.
//

import SwiftUI

struct LocationListRowView: View {
    var location: Location
    var body: some View {
        VStack {
            Text(location.city)
                .font(.title)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(location.dailyForecast) { period in
                        Text("\(period.temperature)"+" "+period.temperatureUnit)
                            .font(.title2)
                    }
                }
            }
        }
    }
}
