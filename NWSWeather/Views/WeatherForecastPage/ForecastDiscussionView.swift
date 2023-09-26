//
//  ForecastDiscussionView.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/22/23.
//

import SwiftUI

struct ForecastDiscussionView: View {
    @Environment(\.dismiss) private var dismiss
    var discussion: String
    var body: some View {
        ScrollView {
            Text(discussion)
                .font(.body)
                .padding(.horizontal, 10)
        }
        .navigationTitle("Area Forecast Discussion")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Done")
                })
            }
        }
    }
}
