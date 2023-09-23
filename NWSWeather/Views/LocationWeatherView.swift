//
//  LocationWeatherView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/21/23.
//

import SwiftUI

struct LocationWeatherView: View {
    @Environment(\.dismiss) private var dismiss
    var locationViewModel: LocationViewModel
    @State var showAFD: Bool = false
    var body: some View {
        ScrollView {
            VStack {
                // Area Forcast Discussion
                Button(action: {
                    showAFD.toggle()
                }) {
                    HStack {
                        Text("Area Forecast Discussion")
                            .font(.title2)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 10))
                }
                
                // Weather Periods
                ForEach(locationViewModel.dailyForecast) { period in
                    WeatherTileView(period: period)
                }
            }
            .padding(.horizontal, 10)
        }
        .navigationTitle(locationViewModel.city+", "+locationViewModel.state)
        .sheet(isPresented: $showAFD) {
            NavigationStack {
                ForecastDiscussionView(discussion: locationViewModel.forecastDiscussion)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "list.bullet")
                    })
                }
            }
        }
    }
}
